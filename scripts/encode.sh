#!/bin/sh

if [ -z "$3" ]
then
  echo "Usage: $0 <input file> <model dir> <output file>"
  echo "Creates an .npz file from text <input file> using sp.model found inside models/<model dir> and stores the result as models/<model dir>/<output file>"
  echo "Provide just the model name like 117M_Books, not thet full path!"
echo "If you use tensorflow_gpu you might want to provide CUDA libs path in LD_LIBRARY_PATH for this script to run. If there are no import errors about libcublas, you're fine."
  exit 1
fi

INPUT=$(readlink -f "$1")
MODEL="$2"
OUTPUT="$3"

cd "$(dirname "$0")/.."
OUTDIR=$(mktemp -d outXXXXX)
trap "rm -rf $OUTDIR" INT TERM EXIT
spm_encode --model="models/$MODEL/sp.model" --output_format=id < "$INPUT" | split --lines=100000 --additional-suffix=.ids - "$OUTDIR"/part
PYTHONPATH=src ./encode.py --model_name="$MODEL" "$OUTDIR" "models/$MODEL/$OUTPUT"
