## Example AWS infrastructure layout in Terragrunt

Based on the following references:
* https://github.com/gruntwork-io/terragrunt-infrastructure-live-example
* https://github.com/antonbabenko/terragrunt-reference-architecture
* https://github.com/silazare/terraform-aws-example

Prerequisites:
* terraform >= 0.13
* terragrunt >= 0.27

Pre-commit installation:
```shell
git secrets --install
pre-commit install -f
pre-commit run -a
```

## Create Multi-region Staging Infrastructure:

1) Create and use `.envrc` file with Staging AWS account id from example

```shell
cd staging
cp .envrc.example .envrc
source .envrc
```

2) Create Infra

```shell
make apply
```

3) Destroy Infra

```shell
make destroy
```

## Create Multi-region Production Infrastructure:

1) Create and use `.envrc` file with Production AWS account id from example

```shell
cd production
cp .envrc.example .envrc
source .envrc
```

2) Create Infra

```shell
make apply
```

3) Destroy Infra

```shell
make destroy
```
