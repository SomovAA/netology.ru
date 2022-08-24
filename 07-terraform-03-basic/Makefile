include .env

ENVS = TF_VAR_yc_token=${TF_VAR_yc_token} TF_VAR_yc_cloud_id=${TF_VAR_yc_cloud_id} TF_VAR_yc_folder_id=${TF_VAR_yc_folder_id} TF_VAR_s3_access_key=${TF_VAR_s3_access_key} TF_VAR_s3_secret_key=${TF_VAR_s3_secret_key}
TERRAFORM = $(ENVS) terraform

all: init plan apply

init:
	cd ./terraform && $(TERRAFORM) init -backend-config="access_key=${TF_VAR_s3_access_key}" -backend-config="secret_key=${TF_VAR_s3_secret_key}"

workspace-new:
	cd ./terraform && terraform workspace new ${TF_WORKSPACE}

workspace-select:
	cd ./terraform && terraform workspace select ${TF_WORKSPACE}

workspace-list:
	cd ./terraform && terraform workspace list

validate: init workspace-select
	cd ./terraform && $(TERRAFORM) validate

plan: workspace-select
	cd ./terraform && $(TERRAFORM) plan

apply: workspace-select
	cd ./terraform && $(TERRAFORM) apply -auto-approve

destroy: workspace-select
	cd ./terraform && $(TERRAFORM) destroy -auto-approve

clean:
	cd ./terraform && rm -f terraform.tfplan
	cd ./terraform && rm -f .terraform.lock.hcl
	cd ./terraform && rm -fr terraform.tfstate*
	cd ./terraform && rm -fr .terraform/

envs:
	echo ${ENVS}

copy-env-file:
	cp .env.example .env