module "vpc" {
  source         = "./vpc"
  vpcblock       = "10.9.0.0/16"
  subnetwebblock = "10.9.1.0/24"
  subnetdbblock  = "10.9.2.0/24"
  az             = "us-east-1a"
}

output "subnet_out" {
  value = module.vpc.sg_out
}

output "sg_out" {
  value = module.vpc.subnet_out
}

variable "ec2size" {
  description = "instance size:"
  default = "t2.micro" 
}

module "ec2" {
  source     = "./ec2"
  ec2_type   = var.ec2size
  ec2_sg     = module.vpc.sg_out
  ec2_subnet = module.vpc.subnet_out
}

output "ec2name" {
  value = module.ec2.ec2name
}

output "ec2private" {
  value = module.ec2.ec2private
}

output "ec2public" {
  value = module.ec2.ec2public
}

variable "s3_name_list" {
  type        = list(string)
  description = "List of names of buckets"

  validation {
    condition = alltrue([
      for item in var.s3_name_list : (startswith(item, "appdev-"))
    ])
    error_message = "All names have to start with appdev-."
  }
}

module "s3" {
  source  = "./s3"
  s3_name = var.s3_name_list
}


resource "local_file" "foo" {
  filename = "./${module.ec2.ec2name}.txt"
  content  = <<-EOT
    EC2 name: ${module.ec2.ec2name}
    public ip: ${module.ec2.ec2public}
    private ip: ${module.ec2.ec2private}
  EOT
}
