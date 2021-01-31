.PHONY: plan apply destroy validate fmt output destroy-cache

plan:
	@terragrunt plan-all

apply:
	@terragrunt apply-all

destroy:
	@terragrunt destroy-all

validate:
	@terragrunt validate-all

fmt:
	@terragrunt hclfmt

output:
	@terragrunt output-all

destroy-cache:
	@find . -name ".terragrunt-cache" -type d -exec rm -rf {} \;
