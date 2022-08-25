include .env

ENVS = TF_VAR_yc_token=${TF_VAR_yc_token} TF_VAR_yc_cloud_id=${TF_VAR_yc_cloud_id} TF_VAR_yc_folder_id=${TF_VAR_yc_folder_id}
TERRAFORM = $(ENVS) terraform

all: init plan apply

init:
	cd ./terraform && $(TERRAFORM) init

validate: init
	cd ./terraform && $(TERRAFORM) validate

plan:
	cd ./terraform && $(TERRAFORM) plan

apply:
	cd ./terraform && $(TERRAFORM) apply -auto-approve

destroy:
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