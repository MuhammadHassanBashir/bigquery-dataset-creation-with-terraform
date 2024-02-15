# variables.tf

variable "project_id" {
  description = "Google Cloud Project ID."
  type        = string
  default     = "world-learning-400909"
}

variable "region" {
  description = "The region where resources will be deployed."
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket."
  type        = string
  default     = "test-az-test"
}


variable "service_name" {
  description = "The name of the App Engine service."
  type        = string
  default     = "my-test-service"  #we can also use "default" service here... when you say default it will create new version in default service. when you give name other then default it will create a new service in app engine... with that name and add version there... you can delete the default version with gcloud command " gcloud app versions delete v2 --service=default"(V2 is default version here)  but you cannot delete default once you create default service.. other service can be deleted...
}


variable "wb_frontend_port" {
  description = "The port to be used in the environment variables."
  type        = string
  default     = "8080"
}

variable "wb_converse_port" {
  description = "The port to be used in the environment variables."
  type        = string
  default     = "5000"
}

variable "wb_citations_port" {
  description = "The port to be used in the environment variables."
  type        = string
  default     = "8080"
}

variable "wb_search_port" {
  description = "The port to be used in the environment variables."
  type        = string
  default     = "5000"
}

variable "automatic_scaling_min_instances" {
  description = "The minimum number of instances for automatic scaling."
  type        = number
  default     = 1
}

variable "automatic_scaling_max_instances" {
  description = "The maximum number of instances for automatic scaling."
  type        = number
  default     = 10
}


variable "wb_frontend_version" {
  description = "The Version to be used in the environment variables."
  type        = string
  default     = "v1"
}

variable "wb_search_version" {
  description = "The Version to be used in the environment variables."
  type        = string
  default     = "v1"
}

variable "wb_citations_version" {
  description = "The Version to be used in the environment variables."
  type        = string
  default     = "v1"
}

variable "wb_converse_version" {
  description = "The Version to be used in the environment variables."
  type        = string
  default     = "v1"
}

variable "datasets" {
  type    = map(list(map(string)))
  default = {}
}


