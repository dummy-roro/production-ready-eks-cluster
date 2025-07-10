variable "cluster_name" {}
variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}
