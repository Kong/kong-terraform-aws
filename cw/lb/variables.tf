variable "load_balancer" {
  description = "Load balancer ARN suffix"
  type        = string
}

variable "target_group" {
  description = "Target group ARN"
  type        = string
}

variable "cloudwatch_actions" {
  description = "List of cloudwatch actions for Alert/Ok"
  type        = list(string)
}

variable "enable" {
  description = "Boolean to enable cloudwatch metrics"
  type        = bool

  default = true
}

# Metric threshholds
variable "http_4xx_count" {
  description = "HTTP Code 4xx count threshhold"
  type        = string
}

variable "http_5xx_count" {
  description = "HTTP Code 5xx count threshhold"
  type        = string
}
