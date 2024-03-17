variable "dockerhub_credentials" {
  type = object({
    username    = string
    accessToken = string
  })
  description = "Dockerhub credentials"
  sensitive   = true
}
