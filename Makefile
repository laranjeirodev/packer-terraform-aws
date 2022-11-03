apply:
	cd .\packer && packer init -upgrade .\aws-linux.pkr.hcl
	cd .\packer && packer build -var-file=packer.pkvars.hcl .\aws-linux.pkr.hcl
	terraform -chdir=".\terraform" init
	terraform -chdir=".\terraform" apply -auto-approve 
	terraform -chdir=".\terraform" output -raw SSH_key_content

destroy:
	terraform -chdir=".\terraform" destroy -auto-approve