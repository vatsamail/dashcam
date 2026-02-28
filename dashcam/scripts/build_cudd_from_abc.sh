#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ABC_SRC="${ROOT_DIR}/tools/OpenROAD-src/third-party/abc/src"
OUT_DIR="${ROOT_DIR}/tools/cudd"
BUILD_DIR="${OUT_DIR}/build"
LIB_DIR="${OUT_DIR}/lib"
INC_DIR="${OUT_DIR}/include"

if [ ! -d "${ABC_SRC}" ]; then
  echo "ABC source not found at ${ABC_SRC}" >&2
  exit 2
fi

mkdir -p "${BUILD_DIR}" "${LIB_DIR}" "${INC_DIR}"

CC=${CC:-cc}
CFLAGS="-O2 -fPIC -DDD_STATS -DABC_USE_STDINT_H"

compile_dir() {
  local out_lib="$1"
  local extra_inc="$2"
  shift 2
  local objs=()
  for c in "$@"; do
    [ -f "$c" ] || continue
    local obj="${BUILD_DIR}/$(basename "$c" .c).o"
    ${CC} ${CFLAGS} -I"${ABC_SRC}" -I"${ABC_SRC}/bdd/cudd" ${extra_inc} -c "$c" -o "$obj"
    objs+=("$obj")
  done
  if [ ${#objs[@]} -eq 0 ]; then
    echo "No sources in ${src_dir}" >&2
    exit 2
  fi
  /usr/bin/ar rcs "${LIB_DIR}/${out_lib}" "${objs[@]}"
}

# Build dependencies
compile_dir "libst.a" "" "${ABC_SRC}/misc/st"/*.c
compile_dir "libutil.a" "" "${ABC_SRC}/misc/util"/*.c "${ABC_SRC}/misc/extra/extraUtilUtil.c"
compile_dir "libmtr.a" "" "${ABC_SRC}/bdd/mtr"/*.c
compile_dir "libepd.a" "" "${ABC_SRC}/bdd/epd"/*.c

# Build CUDD itself (skip test sources)
CUDD_SRCS=()
for c in "${ABC_SRC}/bdd/cudd"/*.c; do
  base=$(basename "$c")
  case "$base" in
    test*.c) continue ;;
  esac
  CUDD_SRCS+=("$c")
done
compile_dir "libcudd.a" "" "${CUDD_SRCS[@]}"

# Install headers
mkdir -p "${INC_DIR}/bdd" "${INC_DIR}/misc"
cp -R "${ABC_SRC}/bdd/cudd" "${INC_DIR}/bdd/"
cp -R "${ABC_SRC}/bdd/mtr" "${INC_DIR}/bdd/"
cp -R "${ABC_SRC}/bdd/epd" "${INC_DIR}/bdd/"
cp -R "${ABC_SRC}/misc/st" "${INC_DIR}/misc/"
cp -R "${ABC_SRC}/misc/util" "${INC_DIR}/misc/"

# Provide top-level cudd.h for FindCUDD.cmake
cp "${ABC_SRC}/bdd/cudd/cudd.h" "${INC_DIR}/cudd.h"

echo "CUDD built at ${OUT_DIR}"
