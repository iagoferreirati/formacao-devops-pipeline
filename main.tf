provider "aws" {
  region = "us-east-1"  # Defina sua região ou use 'sa-east-1' para São Paulo
}

# Configuração do backend para armazenar o estado no S3
terraform {
  backend "s3" {
    bucket = "tfstate-formacao-devops"  # Nome do bucket para armazenar o tfstate
    key    = "terraform.tfstate"        # Caminho/Chave do arquivo tfstate no bucket
    region = "us-east-1"                # Região do bucket
  }
}

# Bucket S3 que servirá como website
resource "aws_s3_bucket" "website_bucket" {
  bucket = "formacao-devops-pipeline"  # Nome único do bucket S3

  website {
    index_document = "index.html"        # Define o arquivo de índice principal
  }

  tags = {
    Name        = "formacao-devops-pipeline"
    Environment = "Development"
  }
}

# Arquivo HTML que será hospedado no bucket
resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket  # Refere-se ao bucket criado
  key    = "index.html"
  source = "index.html"                         # Fonte local do arquivo HTML
  content_type = "text/html"                    # Define o tipo de conteúdo como HTML
  acl    = "public-read"                        # Garante que o arquivo HTML seja acessível publicamente
}

# Configura a ACL do bucket para ser publicamente acessível
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

# Output da URL do bucket website
output "bucket_website_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint  # URL do bucket para acessar o site
}
