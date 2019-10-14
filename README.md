**Status:** Archive (code is provided as-is, no updates expected)

# gpt-2
Code ["Language Models are Unsupervised Multitask Learners"](https://d4mucfpksywv.cloudfront.net/better-language-models/language-models.pdf). | [README](https://github.com/openai/gpt-2/blob/master/README.md). | [Development](https://github.com/openai/gpt-2/blob/master/DEVELOPERS.md) | [Contributors](https://github.com/openai/gpt-2/blob/master/CONTRIBUTORS.md) | License [MIT](./LICENSE)
_________________________________________________________________________________________________________________
### Fine tuning on custom datasets

To retrain GPT-2 117M model on a custom text dataset:

```
PYTHONPATH=src ./train.py --dataset <file|directory|glob>
```

If you want to precompute the dataset's encoding for multiple runs, you can instead use:

```
PYTHONPATH=src ./encode.py <file|directory|glob> /path/to/encoded.npz
PYTHONPATH=src ./train.py --dataset /path/to/encoded.npz
```

To do distributed on multiple GPUs or machines using Horovod: 

```
mpirun -np 4 \
    -H localhost:4 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -x PYTHONPATH=src \
    -mca pml ob1 -mca btl ^openib \
    /home/jovyan/gpt-2/train-horovod.py --dataset encoded.npz
```

## GPT-2 samples

| WARNING: Samples are unfiltered and may contain offensive content. |
| --- |

While we have not yet released GPT-2 itself, you can see some samples from it in the `gpt-2-samples` folder.
We show unconditional samples with default settings (temperature 1 and no truncation), with temperature 0.7, and with truncation with top_k 40.
We show conditional samples, with contexts drawn from `WebText`'s test set, with default settings (temperature 1 and no truncation), with temperature 0.7, and with truncation with top_k 40.

## Citation

Please use the following bibtex entry:
```
@article{radford2019language,
  title={Language Models are Unsupervised Multitask Learners},
  author={Radford, Alec and Wu, Jeff and Child, Rewon and Luan, David and Amodei, Dario and Sutskever, Ilya},
  year={2019}
}
```

FB2_2_txt.xsl conversion file is forked from https://github.com/kmrov/fb2_2_rtf
