/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  service_account_cloud_services = "${local.project.number}@cloudservices.gserviceaccount.com"
  service_accounts_default = {
    compute = "${local.project.number}-compute@developer.gserviceaccount.com"
    gae     = "${local.project.project_id}@appspot.gserviceaccount.com"
  }
  service_accounts_robot_services = {
    bq                = "bigquery-encryption"
    cloudasset        = "gcp-sa-cloudasset"
    cloudbuild        = "gcp-sa-cloudbuild"
    compute           = "compute-system"
    container-engine  = "container-engine-robot"
    containerregistry = "containerregistry"
    dataflow          = "dataflow-service-producer-prod"
    dataproc          = "dataproc-accounts"
    gae-flex          = "gae-api-prod"
    gcf               = "gcf-admin-robot"
    pubsub            = "gcp-sa-pubsub"
    storage           = "gs-project-accounts"
  }
  service_accounts_robots = {
    for service, name in local.service_accounts_robot_services :
    service => "${service == "bq" ? "bq" : "service"}-${local.project.number}@${name}.iam.gserviceaccount.com"
  }
}

data "google_storage_project_service_account" "gcs_account" {
  count   = try(var.services["storage.googleapis.com"], false) ? 1 : 0
  project = local.project.project_id
}

data "google_bigquery_default_service_account" "bq_sa" {
  count   = try(var.services["bigquery.googleapis.com"], false) ? 1 : 0
  project = local.project.project_id
}
