variable "s3_name" {
  
}

resource "aws_s3_bucket" "example" {
   bucket = element(var.s3_name, count.index)
   count = length(var.s3_name)
   
  tags = {
    Name        = element(var.s3_name, count.index)
  }
}

