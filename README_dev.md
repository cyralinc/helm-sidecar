# Development

This document contains information about the development process for this
repository.

## README Generation

The [README](README.md) contains some auto-generated content related to Helm
values. Specifically, content related to any specific Helm value should be added
as comments to [`values.yaml`](values.yaml), and they will be added to the
README via a [pre-commit](https://pre-commit.com/) job.

To generate the README, run the following command:

```shell
pre-commit run --all-files
```
