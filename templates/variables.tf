variable "repo_count" {
  type        = number
  description = "Number of repositories."
  default     = 1

  validation {
    condition     = var.repo_count < 5
    error_message = "The maximum repository count could be 4."
  }
}

variable "env" {
  type        = string
  description = "The name of environment."

  validation {
    # condition     = var.env == "dev" || var.env == "prod"
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Environment should be 'dev' or 'prod'"
  }

}