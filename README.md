# Kubernetes Cluster On GCP With Terraform 

* Terraform v0.11.14
* edit variables.tf
* $terraform init
* $terraform plan
* $terraform apply

## Fully automated infrastructure according to [Kubernetes the hard way](https://github.com/kelseyhightower/kubernetes-the-hard-way) 
you may need to read [this](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform) for setup gcp credentials.

![infra-design](https://github.com/DTherHtun/kube-cluster-gcp-terraform/blob/master/kubernetes-cluster.png)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| google | ~> 1.20 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 1.20 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kube\_api\_port | n/a | `string` | `"6443"` | no |
| machines | n/a | `map` | <pre>{<br>  "disk-size": 200,<br>  "image": "ubuntu-1604-xenial-v20180814",<br>  "img_project": "ubuntu-os-cloud",<br>  "instance-type": "n1-standard-1"<br>}</pre> | no |
| network | n/a | `map` | <pre>{<br>  "iprange": "10.240.0.0/24",<br>  "name": "kubernetes",<br>  "prefix": "10.240.0"<br>}</pre> | no |
| number\_of\_controller | n/a | `number` | `3` | no |
| number\_of\_worker | n/a | `number` | `3` | no |
| project | n/a | `string` | `"k8sops"` | no |
| region | n/a | `string` | `"us-central1"` | no |
| zones | n/a | `list` | <pre>[<br>  "a",<br>  "b",<br>  "c"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| addresses | n/a |
| master\_ip\_list | Master ip list |
| worker\_ip\_list | worker ip list |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
