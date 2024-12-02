resource "random_id" "random" {
  count       = var.repo_count
  byte_length = 2
}

resource "github_repository" "mtc_repo" {
  count       = var.repo_count
  name        = "mtc_repo_${random_id.random[count.index].dec}"
  description = "Code for MTC"
  visibility  = "private"
  auto_init   = true
}

resource "github_repository_file" "read_me" {
  count               = var.repo_count
  repository          = github_repository.mtc_repo[count.index].name
  branch              = "master"
  file                = "README.md"
  content             = "# Infrastructure Developer Repository"
  overwrite_on_create = true
}

resource "github_repository_file" "index_html" {
  count               = var.repo_count
  repository          = github_repository.mtc_repo[count.index].name
  branch              = "master"
  file                = "index.html"
  content             = "Hello Terraform!"
  overwrite_on_create = true
}

output "repo_url" {
  value       = { for repo in github_repository.mtc_repo[*] : repo.name => repo.html_url }
  description = "Repository's URL"
}

output "varsource" {
  value       = var.varsource
  description = "Source being used to source variable definition."
}