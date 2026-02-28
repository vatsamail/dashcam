#!/usr/bin/env python3
import argparse
import datetime
import pathlib
import re

REG_RE = re.compile(
    r"reg\s+(?P<name>[A-Za-z0-9_]+)\s*@\s*(?P<offset>0x[0-9a-fA-F]+)\s*\{(?P<body>.*?)\}\s*;",
    re.S,
)
SW_RE = re.compile(r"\bsw\s*=\s*(rw|ro|wo)\b")
RESET_RE = re.compile(r"\breset\s*=\s*(0x[0-9a-fA-F]+|\d+)\b")


def strip_comments(text: str) -> str:
    text = re.sub(r"//.*", "", text)
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    return text


def parse_rdl(path: pathlib.Path):
    text = strip_comments(path.read_text())
    regs = []
    for m in REG_RE.finditer(text):
        name = m.group("name")
        offset = int(m.group("offset"), 16)
        body = m.group("body")
        access = "rw"
        sw = SW_RE.search(body)
        if sw:
            access = sw.group(1)
        reset = 0
        rmatch = RESET_RE.search(body)
        if rmatch:
            rval = rmatch.group(1)
            reset = int(rval, 0)
        regs.append({"name": name, "offset": offset, "access": access, "reset": reset})
    if not regs:
        raise SystemExit("No registers parsed from SystemRDL")
    return regs


def write_offsets(regs, rtl_dir):
    lines = ["`ifndef DASHCAM_CSR_OFFSETS_VH", "`define DASHCAM_CSR_OFFSETS_VH"]
    for r in regs:
        lines.append(f"`define CSR_{r['name']} 8'h{r['offset']:02x}")
    lines.append("`endif")
    (rtl_dir / "dashcam_csr_offsets.vh").write_text("\n".join(lines) + "\n")


def write_header(regs, include_dir):
    lines = [
        "#ifndef DASHCAM_REGS_H",
        "#define DASHCAM_REGS_H",
        "#define DASHCAM_CSR_BASE 0x10000000u",
        "",
    ]
    for r in regs:
        lines.append(f"#define REG_{r['name']} (DASHCAM_CSR_BASE + 0x{r['offset']:02x}u)")
    lines.append("")
    lines.append("#endif")
    (include_dir / "dashcam_regs.h").write_text("\n".join(lines) + "\n")


def write_docs(regs, docs_dir):
    lines = ["# Dashcam CSR Map", "", "| Name | Offset | Access |", "|---|---:|---|"]
    for r in regs:
        lines.append(f"| `{r['name']}` | `0x{r['offset']:02x}` | `{r['access']}` |")
    lines.append("")
    lines.append(f"_Generated {datetime.datetime.utcnow().isoformat()}Z_")
    (docs_dir / "csr" / "dashcam_csr.md").write_text("\n".join(lines) + "\n")

    amap = docs_dir / "address_map" / "address_map.md"
    rows = ["| Name | Address | Access |", "|---|---:|---|"]
    for r in regs:
        rows.append(f"| {r['name']} | 0x10000000+0x{r['offset']:02x} | {r['access']} |")
    amap.write_text("# Generated Address Map\n\n" + "\n".join(rows) + "\n")

    imap = docs_dir / "interrupts" / "interrupt_map.md"
    imap.write_text(
        "# Generated Interrupt Map\n\n| IRQ | Source |\n|---:|---|\n| 0 | DMA done |\n"
    )


def write_ipxact(regs, ipx_dir):
    regs_xml = []
    for r in regs:
        access = "read-write" if r["access"] == "rw" else ("read-only" if r["access"] == "ro" else "write-only")
        regs_xml.append(
            f"""    <spirit:register>
      <spirit:name>{r['name']}</spirit:name>
      <spirit:addressOffset>0x{r['offset']:x}</spirit:addressOffset>
      <spirit:size>32</spirit:size>
      <spirit:access>{access}</spirit:access>
    </spirit:register>"""
        )
    xml = f"""<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<spirit:component xmlns:spirit=\"http://www.spiritconsortium.org/XMLSchema/SPIRIT/1685-2009\">
  <spirit:name>dashcam_csr_regs</spirit:name>
  <spirit:memoryMaps>
    <spirit:memoryMap>
      <spirit:name>csr_map</spirit:name>
      <spirit:addressBlock>
        <spirit:name>csr</spirit:name>
        <spirit:baseAddress>0x10000000</spirit:baseAddress>
        <spirit:range>0x1000</spirit:range>
        <spirit:width>32</spirit:width>
{chr(10).join(regs_xml)}
      </spirit:addressBlock>
    </spirit:memoryMap>
  </spirit:memoryMaps>
</spirit:component>
"""
    (ipx_dir / "dashcam_csr_regs.xml").write_text(xml)


def write_rtl(regs, rtl_dir):
    rw_regs = [r for r in regs if r["access"] == "rw"]
    ro_regs = [r for r in regs if r["access"] == "ro"]
    wo_regs = [r for r in regs if r["access"] == "wo"]

    lines = []
    lines.append("`include \"dashcam_csr_offsets.vh\"")
    lines.append("module dashcam_csr_regs (")
    lines.append("    input  wire        clk,")
    lines.append("    input  wire        rst_n,")
    lines.append("    input  wire [31:0] wb_adr_i,")
    lines.append("    input  wire [31:0] wb_dat_i,")
    lines.append("    output reg  [31:0] wb_dat_o,")
    lines.append("    input  wire        wb_we_i,")
    lines.append("    input  wire        wb_stb_i,")
    lines.append("    input  wire        wb_cyc_i,")
    lines.append("    output reg         wb_ack_o,")

    for r in rw_regs:
        name = r["name"].lower()
        lines.append(f"    output reg  [31:0] {name},")
        lines.append(f"    output reg         {name}_we,")
    for r in wo_regs:
        name = r["name"].lower()
        lines.append(f"    output reg         {name}_pulse,")
    for r in ro_regs:
        name = r["name"].lower()
        lines.append(f"    input  wire [31:0] {name}_in,")

    lines[-1] = lines[-1].rstrip(",")
    lines.append(");")
    lines.append("")
    lines.append("    wire sel = wb_stb_i & wb_cyc_i;")
    lines.append("")
    lines.append("    always @(posedge clk or negedge rst_n) begin")
    lines.append("        if (!rst_n) begin")
    for r in rw_regs:
        name = r["name"].lower()
        reset = r.get("reset", 0)
        lines.append(f"            {name} <= 32'h{reset:08x};")
        lines.append(f"            {name}_we <= 1'b0;")
    for r in wo_regs:
        name = r["name"].lower()
        lines.append(f"            {name}_pulse <= 1'b0;")
    lines.append("            wb_ack_o <= 1'b0;")
    lines.append("        end else begin")
    lines.append("            wb_ack_o <= 1'b0;")
    for r in rw_regs:
        name = r["name"].lower()
        lines.append(f"            {name}_we <= 1'b0;")
    for r in wo_regs:
        name = r["name"].lower()
        lines.append(f"            {name}_pulse <= 1'b0;")
    lines.append("            if (sel) begin")
    lines.append("                wb_ack_o <= 1'b1;")
    lines.append("                if (wb_we_i) begin")
    lines.append("                    case (wb_adr_i[7:0])")
    for r in rw_regs:
        name = r["name"].lower()
        lines.append(f"                        `CSR_{r['name']}: begin")
        lines.append(f"                            {name} <= wb_dat_i;")
        lines.append(f"                            {name}_we <= 1'b1;")
        lines.append("                        end")
    for r in wo_regs:
        name = r["name"].lower()
        lines.append(f"                        `CSR_{r['name']}: begin")
        lines.append(f"                            {name}_pulse <= wb_dat_i[0];")
        lines.append("                        end")
    lines.append("                        default: ;")
    lines.append("                    endcase")
    lines.append("                end")
    lines.append("            end")
    lines.append("        end")
    lines.append("    end")
    lines.append("")
    lines.append("    always @(*) begin")
    lines.append("        wb_dat_o = 32'h0;")
    lines.append("        case (wb_adr_i[7:0])")
    for r in rw_regs:
        name = r["name"].lower()
        lines.append(f"            `CSR_{r['name']}: wb_dat_o = {name};")
    for r in ro_regs:
        name = r["name"].lower()
        lines.append(f"            `CSR_{r['name']}: wb_dat_o = {name}_in;")
    for r in wo_regs:
        lines.append(f"            `CSR_{r['name']}: wb_dat_o = 32'h0;")
    lines.append("            default: wb_dat_o = 32'h0;")
    lines.append("        endcase")
    lines.append("    end")
    lines.append("endmodule")
    lines.append("")
    (rtl_dir / "dashcam_csr_regs.sv").write_text("\n".join(lines))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rdl", required=True)
    ap.add_argument("--outdir", default=".")
    args = ap.parse_args()

    root = pathlib.Path(args.outdir)
    rdl_path = pathlib.Path(args.rdl)
    regs = parse_rdl(rdl_path)

    rtl_dir = root / "ips" / "csr_regs" / "rtl"
    ipx_dir = root / "ips" / "csr_regs" / "ipxact"
    inc_dir = root / "sw" / "include"
    docs_dir = root / "docs" / "specs"

    rtl_dir.mkdir(parents=True, exist_ok=True)
    ipx_dir.mkdir(parents=True, exist_ok=True)
    inc_dir.mkdir(parents=True, exist_ok=True)
    (docs_dir / "csr").mkdir(parents=True, exist_ok=True)
    (docs_dir / "address_map").mkdir(parents=True, exist_ok=True)
    (docs_dir / "interrupts").mkdir(parents=True, exist_ok=True)

    write_offsets(regs, rtl_dir)
    write_header(regs, inc_dir)
    write_docs(regs, docs_dir)
    write_ipxact(regs, ipx_dir)
    write_rtl(regs, rtl_dir)

    print(f"Generated {len(regs)} registers from {rdl_path}")


if __name__ == "__main__":
    main()
