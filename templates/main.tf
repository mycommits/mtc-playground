resource "github_repository" "mtc_repo" {
  for_each    = var.repos
  name        = "mtc_repo_${each.key}"
  description = "${each.value} Code for MTC"
  visibility  = var.env == "dev" ? "private" : "public"
  auto_init   = true
}

resource "github_repository_file" "read_me" {
  for_each            = var.repos
  repository          = github_repository.mtc_repo[each.key].name
  branch              = "master"
  file                = "README.md"
  content             = "# Infrastructure ${var.env} Repository"
  overwrite_on_create = true
}

resource "github_repository_file" "index_html" {
  for_each            = var.repos
  repository          = github_repository.mtc_repo[each.key].name
  branch              = "master"
  file                = "index.html"
  content             = "Hello Terraform!"
  overwrite_on_create = true
}

output "repo_url" {
  value       = { for k, v in github_repository.mtc_repo : v.name => v.http_clone_url }
  description = "Repository's URL"
}
