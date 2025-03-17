# terascope helm chart repository

## Overview

This repository holds helm charts useful for running services for [teraslice](https://github.com/terascope/teraslice).

## Documentation

- <https://terascope.github.io/helm-charts/>

```bash
helm repo add terascope https://terascope.github.io/helm-charts/
helm repo update
```

## Development

This repo requires the following tools to perform pre-commit hooks:

- `pre-commit`
  - see the install guide here: <https://pre-commit.com/#install>
- `ct lint`
  - <https://github.com/helm/chart-testing>
  - install on mac with `brew install chart-testing`
- `helm-docs`
  - <https://github.com/norwoodj/helm-docs>
  - install on mac with `brew install norwoodj/tap/helm-docs`