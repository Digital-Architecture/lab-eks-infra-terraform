#!/bin/bash

### INSTALL PROGRANS BASTION HOST ###

### Variables ###
PYTHONIOENCODING="UTF-8"
TERRAFORM_VERSION="0.14.10"
KUBECTL_VERSION="1.18.0"
AWS_IAM_AUTHENTICATOR_VERSION="1.15.10"
HELM_VERSION="3.2.0"
HELM_SSM_PLUGIN="2.0.3"


### Update S.O ###
apt update && apt upgrade -y -qq

### Others Package ###
apt-get install -y -qq curl unzip make wget vim watch packer ansible python

### Create Diretory Apps ###
mkdir apps
cd apps

### kubectl ###
curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.15/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

### Terraform ###
curl --silent https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip
unzip terraform.zip 
mv terraform /usr/local/bin/
rm terraform.zip

### Helm ###
curl --silent https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz --output helm-linux-amd64.tar.gz
tar xvf helm-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm
rm helm-linux-amd64.tar.gz
rm -rf linux-amd64

### Helm Plugin ###
helm plugin install https://github.com/codacy/helm-ssm/releases/download/$HELM_SSM_PLUGIN/helm-ssm-linux.tgz


### AWS CLI ###
# https://docs.aws.amazon.com/pt_br/eks/latest/userguide/install-aws-iam-authenticator.html
curl --silent https://amazon-eks.s3.us-west-2.amazonaws.com/$AWS_IAM_AUTHENTICATOR_VERSION/2020-02-22/bin/linux/amd64/aws-iam-authenticator --output /usr/local/bin/aws-iam-authenticator && chmod +x /usr/local/bin/aws-iam-authenticator
curl --silent https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip --output awscliv2.zip
unzip awscliv2.zip  > /dev/null
/bin/bash aws/install
rm awscliv2.zip

### EKSCTL ###
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
/tmp/eksctl /usr/local/bin
chmod +x /usr/local/bin/eksctl
