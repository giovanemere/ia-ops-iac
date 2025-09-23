variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "repositories" {
  description = "Lista de repositorios ECR a crear"
  type        = list(string)
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}
