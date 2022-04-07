variable "resource_prefix" {
  description = "The prefix for all the created objects, e.g. '<YOURINITIALS>'"

  validation {
    condition     = length(var.resource_prefix) > 0 && length(var.resource_prefix) < 13
    error_message = "The resource prefix must not be empty and must be less than 13 characters."
  }
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
}

variable "resource_email" {
  description = "your F5 email address"
}