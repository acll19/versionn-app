# versionn-app
Versionn App (yes with double n) is a sample application that (you guessed it!) displays its version every time you make a request to the `/version` endpoint. It is built with ExpressJS and deployed to AWS Elasic Container Registry (ECS).


## Setup
To set up your local environment you need to insall the following tools:
* NodeJS v14.17.1
* Docker v20.10.6
* Terraform v1.1.4
* AWS CLI v2.2.27

### Run the app locally
Run `npm start` in the root directory of the project. Then open a browser and type `localhost:8080/version` in the URL bar and hit enter.

### Build Docker image
Open a terminal in the root dirctory of the project and run `docker build -t <IMAGE_NAME> .` where `IMAGE_NAME` is the name you want to give to the image being built.

### Run a Terraform plan
#### Terraform backend
This project uses a remote backend to manage the Terraform state. This is useful when there are multiple people working on the sasme codebase. Before running any terraform command make sure you create an S3 bucket named `terraform-backend-versionn-app`. See [backend.tf](infra/backend.tf) for more details.

#### Terraform AWS user
In order for Terraform to be able to manage your infrastructure, you need to create an IAM User with enough privilages so that Terraform can perform the necesasary tasks. You can use built-in AWS policies or you can create a custom one. [Here](docs/terraform-iam-policy.json) is an example so you have an idea what the permissions needed are. You will need a similar user so that terraform can run in the pipeline (Github Actions).<br/>
[Here](https://github.com/acll19/terraform-eks-example#11-create-a-new-iam-policy) are some instructions on how to create the user, the policy and the the access key and token. Keep in mind that the permissions there are for different resources than the ones needed for this project.

#### Terraform init
cd into the infra folder and run `terraform init`. This command will initialize terraform in your project downloading provider's plugins, etc. You have to run this command before you can run any other terraform command.

#### The plan
After you have made changes to the infra description you can run `terraform plan` inside the infra folder, to see what opperations Terraform will attempt to do.

## Install instructions
This repository containes 2 Github Actions workflows [ci](.github/workflows/pipeline.yml) and [cleanup](.github/workflows/clean-up.yml). 
The ci workflow has 2 jobs. The first one called `BuildAndPublish` builds the [Docker](https://www.docker.com/) image and then publishes it to [Docker Hub](https://hub.docker.com/) public rergistry. The second job is called `ApplyInfraAndRelease`, it runs `Terraform apply` which updates the infra and runs a new ECS task. This last part will always happen because this workflow will always create and push a new Docker image with every build.<br/>
The cleanup workflow runs a `terraform desroy` which deletes all resources that are managed by terraform. Please, beware that if you need to do any changes to the infra, it is strongly recommended that you do so via Terraform, otherwise, things might get messy. Find here a guide on [how to run the cleanup workflow](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow).


## What would be required to take this to production?
In order to run this application in production, in addition to creating an IAM User for Terraform as described above, you also need the following:

* A Docker registry to store the application's Docker images and that is available from Github Acions.
* Create 2 secrets in the repository setting. One named `DOCKER_HUB_USERNAME` and the other `DOCKER_HUB_ACCESS_TOKEN` which will hold the credentials to access the Docker rergistry.
* Two additional secrets for the Github Actions workflows to authenticate to AWS: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY_ID`. Those credentials will be used in the Terraform steps so they need to be linked to the Terraform user.
Additionally if you want the team to be able to review the Terraform plan before applying the changes, you can configure [hashicorp/setup-terraform@v1](https://github.com/hashicorp/setup-terraform#usage) Github Action to create a Pull Request as outputs.

## External References
* Terraform AWS VPC example: https://hiveit.co.uk/techshop/terraform-aws-vpc-example/04-create-the-application-load-balancer/
* Provision AWS infrastructure using Terraform https://aws.amazon.com/es/blogs/developer/provision-aws-infrastructure-using-terraform-by-hashicorp-an-example-of-running-amazon-ecs-tasks-on-aws-fargate/
