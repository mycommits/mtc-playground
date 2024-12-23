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
  content             = "# Infrastructure ${var.env} ${each.key} Repository"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [content]
  }
}

resource "github_repository_file" "main_file" {
  for_each            = var.repos
  repository          = github_repository.mtc_repo[each.key].name
  branch              = "master"
  file                = each.value.filename
  content             = "Hello Terraform!"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [content]
  }
}

resource "terraform_data" "local_repo_management" {
  for_each = var.repos

  provisioner "local-exec" {
    command = "gh repo clone ${github_repository.mtc_repo[each.key].name}"
  }

  depends_on = [github_repository_file.main_file, github_repository_file.read_me]
}

output "repo_url" {
  value       = { for k, v in github_repository.mtc_repo : v.name => [v.http_clone_url, v.ssh_clone_url] }
  description = "Repository's URL"
}
