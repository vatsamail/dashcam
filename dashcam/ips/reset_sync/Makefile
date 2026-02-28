###############################################################################
# Name of this IP block
BLOCK = reset_sync
###############################################################################

LINT_SRCS = $(BLOCK).v
SIM_SRCS  = $(BLOCK).v $(BLOCK)_tb.sv

LINT_TOOL  = verilator
LINT_FLAGS = --lint-only

SIM_TOOL   = iverilog
SIM_OUT    = run_files/sim/$(BLOCK).simv

LINT_LOG        = reports/$(BLOCK)_lint.log
SIM_COMPILE_LOG = reports/$(BLOCK)_sim_compile.log
SIM_RUN_LOG     = reports/$(BLOCK)_sim_run.log
REPORT_JSON     = reports/report.json

.PHONY: all lint sim clean setup-dirs

all: lint sim

lint: | setup-dirs
	@echo "[$(BLOCK)] Linting with $(LINT_SRCS)..."
	$(LINT_TOOL) $(LINT_FLAGS) $(LINT_SRCS) 2>&1 | tee $(LINT_LOG)
	@if grep -qi "error" $(LINT_LOG); then \
	  echo '{ "$(BLOCK)": { "lint": "FAIL" } },' >> $(REPORT_JSON); \
	else \
	  echo '{ "$(BLOCK)": { "lint": "PASS" } },' >> $(REPORT_JSON); \
	fi

sim: | setup-dirs
	@echo "[$(BLOCK)] Compiling & Running SIM with $(SIM_SRCS)..."
	$(SIM_TOOL) -o $(SIM_OUT) $(SIM_SRCS) 2>&1 | tee $(SIM_COMPILE_LOG)
	@echo "=== $(BLOCK) simulation run ===" > $(SIM_RUN_LOG)
	vvp $(SIM_OUT) 2>&1 | tee -a $(SIM_RUN_LOG)
	@if grep -qi "error" $(SIM_RUN_LOG); then \
	  echo '{ "$(BLOCK)": { "sim": "FAIL" } },' >> $(REPORT_JSON); \
	else \
	  echo '{ "$(BLOCK)": { "sim": "PASS" } },' >> $(REPORT_JSON); \
	fi

setup-dirs:
	mkdir -p reports
	mkdir -p run_files/sim

clean:
	rm -rf run_files/ reports/*.log $(SIM_OUT) $(REPORT_JSON) reports/
