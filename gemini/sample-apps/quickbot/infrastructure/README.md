# QuickBot Infrastructure

This folder will contain the infra for Quickbot. Pipelines and supporting resources.

# Initial Setup

1. Create the Service Account for running Terraform (manual)

# Replace 'tf-admin-sa' with your desired service account name
```shell
gcloud iam service-accounts create tf-deployer-sa --display-name="Terraform Deployer Service Account"
```

# Grant the roles needed to manage the resources (IAM, Cloud Build, Cloud Run, etc.)

```shell
# Grant least-privilege roles to the service account
gcloud projects add-iam-policy-binding quickbot-dev \
  --member="serviceAccount:tf-deployer-sa@quickbot-dev.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountAdmin"

gcloud projects add-iam-policy-binding quickbot-dev \
  --member="serviceAccount:tf-deployer-sa@quickbot-dev.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectIamAdmin"

gcloud projects add-iam-policy-binding quickbot-dev \
  --member="serviceAccount:tf-deployer-sa@quickbot-dev.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.admin"

gcloud projects add-iam-policy-binding quickbot-dev \
  --member="serviceAccount:tf-deployer-sa@quickbot-dev.iam.gserviceaccount.com" \
  --role="roles/cloudbuild.builds.editor"
```

# Grant your user account the ability to generate tokens for the deployer SA
```shell
gcloud iam service-accounts add-iam-policy-binding \
  tf-deployer-sa@quickbot-dev.iam.gserviceaccount.com \
  --member="user:sansrinivasan@google.com" \
  --role="roles/iam.serviceAccountTokenCreator"
```

2. Github Connection (Manual)

Enable CloudBuild, Cloud Resource Manager and Secret Manager APIs.

Then connect the repository in Cloud Build interface.

3. Run Terraform

Impersonate

 gcloud config set auth/impersonate_service_account tf-deployer-sa@quickbot-dev.iam.gserviceaccount.com

Terraform Apply

A manual step to connect repo might be needed. TF err would shot the URL to do this.


 