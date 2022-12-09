variable "region" {
  default = "us-east-2"
}

variable "int_type" {
  description = "Tipo de Instancia EC2 web"
  type        = string
  default     = "t2.micro"
}

variable "disable_api_termination" {
  description = "Protege a instancia contra delete acidental"
  type        = bool
  default     = true
}

variable "int_names" {
  description = "Lista de nomes para instancias"
  type        = list(string)
  default     = ["TestServer"]
}

variable "amis" {
  description = "Amis para determinar regioes"
  type        = map(any)
  default = {
    "us-east-1" = "ami-05fa00d4c63e32376"
    "us-east-2" = "ami-0568773882d492fc8"
  }
}

variable "ipv4_cidr_blocks" {
  default = "177.155.206.82/32"
}

variable "key_name" {
  default = "ChaveServidor"
}

variable "vpc_id" {
  default = "vpc-038a96a45cc7e0a92"
}
