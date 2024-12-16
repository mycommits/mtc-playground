variable "env" {
  type        = string
  description = "The name of environment."

  validation {
    # condition     = var.env == "dev" || var.env == "prod"
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Environment should be 'dev' or 'prod'"
  }

}

variable "repos" {
  type        = map(map(string))
  description = "List of the repositories"

  validation {
    condition     = length(var.repos) < 5
    error_message = "The maximum repository count could be 5."
  }

}
