variable "repo_count" {
  type        = number
  description = "Number of repositories."
}

variable "varsource" {
  type        = string
  description = "Source used to define variables."
  # default     = "variables.tf"
}