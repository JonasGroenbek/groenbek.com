variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "domain_name" {
  default = "test-groenbek.com"
}

variable "website_docker_image_tag" {
  default = "latest"
}

variable "server_docker_image_tag" {
  default = "latest"
}
