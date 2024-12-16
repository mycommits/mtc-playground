resource "github_repository" "mtc_repo" {
  for_each    = var.repos
  name        = "mtc_repo_${each.key}"
  description = "${each.key} Code for MTC"
  visibility  = var.env == "dev" ? "private" : "public"
  auto_init   = true

  provisioner "local-exec" {
    command = "gh repo view ${self.name} --web"
  }

  provisioner "local-exec" {
    command = "rm -rf ${self.name}"
    when    = destroy
  }

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

resource "terraform_data" "local_repo_management" {
  for_each = var.repos

  provisioner "local-exec" {
    command = "gh repo clone ${github_repository.mtc_repo[each.key].name}"
  }

  depends_on = [github_repository_file.index_html, github_repository_file.read_me]
}

output "repo_url" {
  value       = { for k, v in github_repository.mtc_repo : v.name => v.http_clone_url }
  description = "Repository's URL"
}
