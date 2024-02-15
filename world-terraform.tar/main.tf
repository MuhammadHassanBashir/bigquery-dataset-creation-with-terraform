terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.15.0"
    }
  }
   backend "gcs" {
     bucket = var.bucket_name
     prefix = "ts-appengine-terraform/state"
   }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  name          = var.bucket_name
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}


resource "google_storage_bucket_object" "wb_frontend_zip" {
  name   = "wb-frontend.zip"
   bucket = google_storage_bucket.terraform_state.name
   source = "./wb-frontend.zip"
 }

resource "google_storage_bucket_object" "wb_citations_zip" {
  name   = "wb-citations.zip"
   bucket = google_storage_bucket.terraform_state.name
   source = "./wb-citations.zip"
 }

resource "google_storage_bucket_object" "wb_search_zip" {
  name   = "wb-search.zip"
   bucket = google_storage_bucket.terraform_state.name
   source = "./wb-search.zip"
 }


resource "google_storage_bucket_object" "wb_converse_zip" {
  name   = "wb-converse.zip"
   bucket = google_storage_bucket.terraform_state.name
   source = "./wb-converse.zip"
 }


resource "google_app_engine_standard_app_version" "wb_frontend" {
  version_id = var.wb_frontend_version
  service    = "wb-frontend"
  runtime    = "nodejs18"

  entrypoint {
    shell = "npm run start"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.terraform_state.name}/${google_storage_bucket_object.wb_frontend_zip.name}"
    }
  }

  env_variables = {
    port = var.wb_frontend_port
  }

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances = 1
    max_idle_instances = 3
    min_pending_latency = "1s"
    max_pending_latency = "5s"
    standard_scheduler_settings {
      target_cpu_utilization = 0.5
      target_throughput_utilization = 0.75
      min_instances = 2
      max_instances = 10
    }
  }

  delete_service_on_destroy = true
 }



resource "google_app_engine_standard_app_version" "wb_citations" {
  version_id = var.wb_citations_version
  service    = "wb-citations"
  runtime    = "python39"

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.terraform_state.name}/${google_storage_bucket_object.wb_citations_zip.name}"
    }
  }

  entrypoint {
    
      shell  = "gunicorn -w 2 -b 0.0.0.0:8080 main:app"
  }

  env_variables = {
    PORT = var.wb_citations_port
  }

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances = 1
    max_idle_instances = 3
    min_pending_latency = "1s"
    max_pending_latency = "5s"
    standard_scheduler_settings {
      target_cpu_utilization = 0.5
      target_throughput_utilization = 0.75
      min_instances = var.automatic_scaling_min_instances
      max_instances = var.automatic_scaling_max_instances
    }
  }

  delete_service_on_destroy = true
}


resource "google_app_engine_standard_app_version" "wb_search" {
  version_id = var.wb_search_version
  service    = "wb-search"
  runtime    = "python39"

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.terraform_state.name}/${google_storage_bucket_object.wb_search_zip.name}"
    }
  }

  entrypoint {
    
      shell  = "gunicorn -w 2 -b 0.0.0.0:5000 main:app"
  }

  env_variables = {
    PORT = var.wb_search_port
  }

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances = 1
    max_idle_instances = 3
    min_pending_latency = "1s"
    max_pending_latency = "5s"
    standard_scheduler_settings {
      target_cpu_utilization = 0.5
      target_throughput_utilization = 0.75
      min_instances = var.automatic_scaling_min_instances
      max_instances = var.automatic_scaling_max_instances
    }
  }

  delete_service_on_destroy = true
}


resource "google_app_engine_standard_app_version" "wb_converse" {
  version_id = var.wb_converse_version
  service    = "wb-converse"
  runtime    = "python39"

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.terraform_state.name}/${google_storage_bucket_object.wb_converse_zip.name}"
    }
  }

  entrypoint {
    
      shell  = "gunicorn -w 2 -b 0.0.0.0:5000 main:app"
  }

  env_variables = {
    PORT = var.wb_converse_port
  }

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances = 1
    max_idle_instances = 3
    min_pending_latency = "1s"
    max_pending_latency = "5s"
    standard_scheduler_settings {
      target_cpu_utilization = 0.5
      target_throughput_utilization = 0.75
      min_instances = var.automatic_scaling_min_instances
      max_instances = var.automatic_scaling_max_instances
    }
  }

  delete_service_on_destroy = true
}