resource "random_id" "random" {
  byte_length = 2
}

resource "github_repository" "mtc_repo" {
  name        = "mtc_repo_${random_id.random.dec}"
  description = "Code for MTC"
  visibility  = "private"
  auto_init   = true
}

resource "github_repository_file" "read_me" {
  repository          = github_repository.mtc_repo.name
  branch              = "master"
  file                = "README.md"
  content             = "# Infrastructure Developer Repository"
  overwrite_on_create = true
}

resource "github_repository_file" "index_html" {
  repository          = github_repository.mtc_repo.name
  branch              = "master"
  file                = "index.html"
  content             = "Hello Terraform!"
  overwrite_on_create = true
}