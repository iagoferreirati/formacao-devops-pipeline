provider "aws" {
  region = "us-east-1"  # Defina sua região
}

terraform {
  backend "s3" {
    bucket = "tfstate-formacao-devops"  # Nome do bucket para armazenar o tfstate
    key    = "terraform.tfstate"        # Caminho/Chave do arquivo tfstate no bucket
    region = "us-east-1"                # Região do bucket
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "formacao-devops-pipeline"  # Nome do bucket S3

  tags = {
    Name        = "formacao-devops-pipeline"
    Environment = "Development"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}
