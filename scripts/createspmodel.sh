#!/bin/sh

if [ -z "$2" ]
then
  echo "Usage: $0 <input file> <token count> [number of lines to sample]"
  echo "Creates a sentence piece model from <input file> named 'sp' of size <token count>. Default number of lines to sample is <token count> * 200."
  echo "You can reuse the model for similar data (same language). hparams.json contains the model parameters for training,"
  echo "put it to the model directory together with sp.model and sp.vocab"
  exit 1
fi

if [ -z "$(which spm_train)" ]
then
  echo "Please download, build and install Sentence Piece from https://github.com/google/sentencepiece"
  exit 2
fi

INPUT=$(readlink -f "$1")
TOKENS=$2
LINES=$(( TOKENS * 200 ))
if [ -n "$3" ]
then
  LINES=$3
fi

echo "Creating model from $INPUT, vocabulary size is $TOKENS, sampling $LINES random lines"
spm_train --input "$INPUT" --model_prefix=sp --vocab_size=$TOKENS --model_type=bpe --user_defined_symbols '<|n|>,<|endoftext|>' --max_sentence_length=16384 --input_sentence_size=$LINES
echo '{
  "n_vocab": '$TOKENS',
  "n_ctx": 1024,
  "n_embd": 768,
  "n_head": 12,
  "n_layer": 12
}' > hparams.json
