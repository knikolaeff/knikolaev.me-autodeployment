provider "aws" {
  region     = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_amplify_app" "blog" {
  name       = "knikolaev.me"
  repository = "https://github.com/knikolaeff/knikolaev.me"

  enable_auto_branch_creation = true
  enable_branch_auto_deletion = true
  enable_branch_auto_build    = true

  auto_branch_creation_config {
    enable_auto_build           = true
    enable_pull_request_preview = true
    stage                       = "DEVELOPMENT"
  }
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.blog.id
  branch_name = "main"
  framework   = "Hugo"

  stage = "PRODUCTION"

}

resource "aws_amplify_branch" "feature" {
  app_id      = aws_amplify_app.blog.id
  branch_name = "feature"
  framework   = "Hugo"

  stage = "DEVELOPMENT"

}

resource "aws_amplify_domain_association" "blog" {
  app_id      = aws_amplify_app.blog.id
  domain_name = "knikolaev.me"

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.feature.branch_name
    prefix      = "feature"
  }
}



resource "aws_route53_zone" "main" {
  name = "knikolaev.me"
}

variable "access_key" {
  description = "AWS Access Key"
}

variable "secret_key" {
  description = "AWS Secret Key"
}
