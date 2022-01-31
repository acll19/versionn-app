variable "region" {
  description = "AWS region"
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = "default"
}

variable "app_prefix" {
  description = "Application prefix for the AWS services that are built"
  default     = "versionn-app"
}

variable "app_cpu_limit" {
    description = "AWS ECS CPU limit for the versionn-app task definition"
    default = 256
}

variable "app_memory_limit" {
    description = "AWS ECS Memory limit for the versionn-app task definition"
    default = 512
}

variable "app_image_name" {
    description = "Docker image name"
}

variable "container_port" {
  description = "The port value to expose the app in docker"
  default     = 8080
}

variable "load_balancer_port" {
  description = "The port value to expose the app via the load balancer"
  default     = 80
}

variable "route53_hosted_zone_name" {
  default = "armandocollazo.com"
}

variable "app_subdomain" {
  description = "Subdomain to register in a hosted zone record"
  default     = "myapp"
}