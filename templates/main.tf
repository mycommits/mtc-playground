resource "github_repository" "mtc_repo" {
  name        = "mtc-repo"
  description = "Code for MTC"
  visibility  = "private"
  auto_init   = true
}