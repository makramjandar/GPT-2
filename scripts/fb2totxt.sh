#!/bin/sh

if [ -z "$2" ]
then
  echo "Usage: $0 <input dir> <output dir>"
  echo "Converts fb2 files in <input dir> to plain utf-8 encoded text and puts them to <output dir>."
  exit 1
fi

if [ -z "$(which unoconv)" ]
then
  echo "Please install unoconv and OpenOffice/LibreOffice"
  exit 2
fi

INPUT=$(readlink -f "$1")
OUTPUT=$(readlink -f "$2")
mkdir -p "$OUTPUT"
unoconv -l&
UNOPID=$!
sleep 1
for i in "$INPUT/"*.fb2
do
  TXT=$OUTPUT/$(basename "$i" .fb2).txt
  if [ ! -f "$TXT" ]
  then
    unoconv -c "socket,host=localhost,port=2002;urp;StarOffice.ComponentContext" -f txt -o "$TXT" "$i"
    sed -i '1s/^\xEF\xBB\xBF//' "$TXT" # remove BOM
  fi
done
kill $UNOPID
