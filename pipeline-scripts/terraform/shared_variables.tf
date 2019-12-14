variable "service" {
  type = string
  description = "Name of the service. The name is derived from folder name and reached in from deployment script."
}

variable "stage" {
  type = string
  description = "Name of the stage like 'prod', 'live', 'test' or 'dev'. The name is reached in from deployment script."
}