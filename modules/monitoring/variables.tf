variable "database_name" {}
variable "environment" {}


variable "alarm_cpu_threshold" {
  default = "75"
}

variable "alarm_disk_queue_threshold" {
  default = "10"
}

variable "alarm_free_disk_threshold" {
  # 5GB
  default = "5000000000"
}

variable "alarm_free_memory_threshold" {
  # 128MB
  default = "128000000"
}

variable "alarm_cpu_credit_balance_threshold" {
  default = "30"
}

variable "alarm_actions" {
  type = "list"
  default = []
}

variable "ok_actions" {
  type = "list"
  default = []
}

variable "insufficient_data_actions" {
  type = "list"
  default = []
}

variable "instance_type" {
}

variable "database_identifier" {}

variable "postgresql_id" {}