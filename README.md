# k8s-digital-ocean-env
Use this project to launch a Cloud Native Kubernetes environment on Digital Ocean with Terraform.

## Prerequisites

Firstly create a DigitalOcean account. Following [this link](https://m.do.co/c/264f85e9e580) will grant $100 on a new account (and also $25 for me, thank you!).

[Download](https://www.terraform.io/downloads.html) and [install](https://learn.hashicorp.com/tutorials/terraform/install-cli) the Terraform CLI, the latest and greatest version is OK.

Be ready to use a terminal on your local development environment.

Clone this repository and switch your terminal to the cloned directory:

```bash
git clone https://github.com/thomasriley/k8s-digital-ocean-env.git

cd k8s-digital-ocean-env/
```

Navigate to Digital Ocean API token generation page here: [https://cloud.digitalocean.com/account/api/tokens](https://cloud.digitalocean.com/account/api/tokens)

Create a new `Personal access token` called `terraform` and then export it as an environment variable in your terminal:

```bash
export DIGITALOCEAN_TOKEN=<do-personal-access-token>
```

Then generate a new `Spaces access key` and set the key ID and key secret in the environment variables as shown below:

```bash
export SPACES_ACCESS_KEY_ID=<do-spaces-key-id>
export SPACES_SECRET_ACCESS_KEY=<do-spaces-secret-access-key>

export AWS_ACCESS_KEY_ID=<do-spaces-key-id>
export AWS_SECRET_ACCESS_KEY=<do-spaces-secret-access-key>
```

Make note of these secret tokens so that they can be reused again in future when setting up a terminal for use again. You may wish to permanently add these to the terminals session configuration. Digital Ocean will only reveal the key secrets once therefore if these keys are lost you will need to regenerate them again.

## Getting Started

Firstly ensure the terminals working directory is set to the root of a clone copy of this GitHub project.

Open the `backend.tf` file in an editor of your choice and comment out the backend configuration block, for example:

```terraform
# Terraform Backend Bucket
resource "digitalocean_spaces_bucket" "terraform_backend" {
  name   = "${var.prefix}-${var.environment}-${var.region}-k8s-terraform-backend"
  region = var.region
}

// terraform {
//   backend "s3" {
//     endpoint                    = "region.digitaloceanspaces.com"
//     key = "terraform.tfstate"
//     bucket                      = "bucket-name"
//     region                      = "us-west-1"
//     skip_requesting_account_id  = true
//     skip_credentials_validation = true
//     skip_get_ec2_platforms      = true
//     skip_metadata_api_check     = true
//   }
// }
```

Then in your terminal initialize Terraform using `terraform init`:

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "digitalocean" (terraform-providers/digitalocean) 2.3.0...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.digitalocean: version = "~> 2.3"


Warning: registry.terraform.io: For users on Terraform 0.13 or greater, this provider has moved to digitalocean/digitalocean. Please update your source in required_providers.


Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

When initializing Terraform downloads any plugins it needs based on the Terraform projects configured Terraform providers.

Now generate a Terraform Plan using the `terraform plan` command:

```bash
$ terraform plan -out terraform.plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # digitalocean_kubernetes_cluster.this will be created
  + resource "digitalocean_kubernetes_cluster" "this" {
      + auto_upgrade   = false
      + cluster_subnet = (known after apply)
      + created_at     = (known after apply)
      + endpoint       = (known after apply)
      + id             = (known after apply)
      + ipv4_address   = (known after apply)
      + kube_config    = (sensitive value)
      + name           = "do-sandbox-ams3-k8s-cluster"
      + region         = "ams3"
      + service_subnet = (known after apply)
      + status         = (known after apply)
      + updated_at     = (known after apply)
      + version        = "1.19.3-do.2"
      + vpc_uuid       = (known after apply)

      + node_pool {
          + actual_node_count = (known after apply)
          + auto_scale        = true
          + id                = (known after apply)
          + max_nodes         = 4
          + min_nodes         = 2
          + name              = "worker-pool"
          + nodes             = (known after apply)
          + size              = "s-2vcpu-2gb"
        }
    }

  # digitalocean_spaces_bucket.terraform_backend will be created
  + resource "digitalocean_spaces_bucket" "terraform_backend" {
      + acl                = "private"
      + bucket_domain_name = (known after apply)
      + force_destroy      = false
      + id                 = (known after apply)
      + name               = "do-sandbox-ams3-k8s-terraform-backend"
      + region             = "ams3"
      + urn                = (known after apply)
    }

  # digitalocean_vpc.this will be created
  + resource "digitalocean_vpc" "this" {
      + created_at = (known after apply)
      + default    = (known after apply)
      + id         = (known after apply)
      + ip_range   = (known after apply)
      + name       = "do-sandbox-ams3-k8s-vpc"
      + region     = "ams3"
      + urn        = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

This plan was saved to: terraform.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "terraform.plan"
```

This command generated a visual plan of resources that it would add, change or destroy in Digital Ocean if applied. The command shown above uses the `-out` flag so a copy of this plan is saved in a binary format that Terraform can then re-use.

Apply the plan that you have just generated using `terraform apply`:

```bash
$ terraform apply terraform.plan

digitalocean_vpc.this: Creating...
digitalocean_spaces_bucket.terraform_backend: Creating...
digitalocean_vpc.this: Creation complete after 1s [id=538e523c-c579-40b6-a173-055217788ffd]
digitalocean_kubernetes_cluster.this: Creating...
digitalocean_spaces_bucket.terraform_backend: Still creating... [10s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [10s elapsed]
digitalocean_spaces_bucket.terraform_backend: Still creating... [20s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [20s elapsed]
digitalocean_spaces_bucket.terraform_backend: Still creating... [30s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [30s elapsed]
digitalocean_spaces_bucket.terraform_backend: Still creating... [40s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [40s elapsed]
digitalocean_spaces_bucket.terraform_backend: Still creating... [50s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [50s elapsed]
digitalocean_spaces_bucket.terraform_backend: Creation complete after 59s [id=do-sandbox-ams3-k8s-terraform-backend]
digitalocean_kubernetes_cluster.this: Still creating... [1m0s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [1m10s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [1m20s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [1m30s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [1m40s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [1m50s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [2m0s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [2m10s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [2m20s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [2m30s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [2m40s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [2m50s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [3m0s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [3m10s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [3m20s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [3m30s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [3m40s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [3m50s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [4m0s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [4m10s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [4m20s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [4m30s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [4m40s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [4m50s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [5m0s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [5m10s elapsed]
digitalocean_kubernetes_cluster.this: Still creating... [5m20s elapsed]
digitalocean_kubernetes_cluster.this: Creation complete after 5m22s [id=ecf8161f-0392-4f2c-82dd-664ea8a1c1be]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```

If you now login to the Digital Ocean portal you will see these resources have been created.

Back in the terminal you will notice a few files have been created by Terraform when executing the CLI commands:

```bash
$ ls -lrtha

total 96
drwxr-xr-x   3 thomas.riley  staff    96B 12 Dec 12:57 ..
-rw-r--r--   1 thomas.riley  staff   716B 12 Dec 12:57 .gitignore
-rw-r--r--   1 thomas.riley  staff   1.0K 12 Dec 12:57 LICENSE
-rw-r--r--   1 thomas.riley  staff   101B 12 Dec 12:57 README.md
drwxr-xr-x  13 thomas.riley  staff   416B 12 Dec 12:58 .git
-rw-r--r--   1 thomas.riley  staff    27B 12 Dec 13:12 provider.tf
-rw-r--r--   1 thomas.riley  staff   193B 12 Dec 13:57 backend.tf
-rw-r--r--   1 thomas.riley  staff   136B 12 Dec 13:57 networking.tf
-rw-r--r--   1 thomas.riley  staff   1.8K 12 Dec 14:12 variables.tf
-rw-r--r--   1 thomas.riley  staff   576B 12 Dec 14:12 kubernetes.tf
drwxr-xr-x   3 thomas.riley  staff    96B 12 Dec 14:13 .terraform
-rw-r--r--   1 thomas.riley  staff   3.4K 12 Dec 14:14 terraform.plan
-rw-r--r--   1 thomas.riley  staff   8.1K 12 Dec 14:19 terraform.tfstate
drwxr-xr-x  14 thomas.riley  staff   448B 12 Dec 14:19 .
```

The `.terraform` directory contains the Terraform Provider Plugins downloaded by the `terraform init` command.

The `terraform.tfstate` file is very important and contains the state of resources that Terraform has just created in Digital Ocean. Without the file, Terraform will be unable to continue managing the resources it has just created. Terraform would attempt to create the new resources again if created a new Terraform plan without this file, as it is unaware of the state of the already created resources.

As manage this Terraform State file locally or from within the Git repo, Terraform has a concept of [backends](https://www.terraform.io/docs/backends/index.html) for storing state in a remote datastore.

When running the Terraform Apply on this project, a Digital Ocean Space (bucket) was created for this very purpose. Digital Ocean's Spaces product exposes same Swift protocol used by AWS S3, therefore we can use the `s3` backend type to store the Terraform state in a Digital Ocean Spaces bucket. This is why previously in this README one of the steps was to export the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` with the Digital Ocean Spaces API keys set.

Before proceeding firstly open the `backends.tf` file in your editor again and remove the comments that were previously used to disable the backend configuration.

Now revert back to the terminal and re-initialize the Terraform project. This time specify the URL of the Spaces API that suits the Digital Ocean Region that is in use (see the `region` Terraform variable in the file `variables.tf`). Also specify the name of the Spaces bucket that has been created. After executing the `terraform init` command show below, Terraform will note that it can see the state file is on the local filesystem and it will ask if it should be moved to the remote backend. Proceed with this by entering 'yes':

```bash
$ terraform init \
-backend-config="endpoint=ams3.digitaloceanspaces.com" \
-backend-config="bucket=do-sandbox-ams3-k8s-terraform-backend"

Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes


Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.digitalocean: version = "~> 2.3"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

The state has now been moved to the Digital Ocean Spaces bucket. Any `terraform.*` files on the local system can now be removed and are no longer required.

```bash
$ rm -vfr terraform.*

terraform.plan
terraform.tfstate
terraform.tfstate.backup
```

When interacting with this Terraform project again be sure to export all of the required environment variables and also ensure the required `backend-config` flags are set when using `terraform init`.

To validate that Terraform is managing these resources in Digital Ocean, generate a new Terraform Plan. You will see that Terraform notes there are no changes to be made:

```bash
$ terraform plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

digitalocean_vpc.this: Refreshing state... [id=c1163b08-237b-4091-98b2-bc1a5de9e20a]
digitalocean_spaces_bucket.terraform_backend: Refreshing state... [id=do-sandbox-ams3-k8s-terraform-backend]
digitalocean_kubernetes_cluster.this: Refreshing state... [id=24ab41b7-4bb4-4edf-821f-76c521df3f30]

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```
