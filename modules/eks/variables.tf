variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs de las subnets privadas"
  type        = list(string)
}

variable "node_instance_type" {
  description = "Tipo de instancia para nodos"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Número deseado de nodos"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Número máximo de nodos"
  type        = number
  default     = 4
}

variable "node_min_size" {
  description = "Número mínimo de nodos"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}
