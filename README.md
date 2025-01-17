# Scraping Google Workspace Groups with a Cloud Run Job

### Introduction

This repository contains code and infrastructure as code to retrieve Google Workspace groups and their members, then store this information in Firestore. The solution leverages a Cloud Run Job scheduled via Cloud Scheduler to perform daily scrapes of group memberships across a Google Cloud Organization. This automated approach aids administrators in auditing and managing group access effectively.

### Prerequisites

- Google Cloud Platform account with necessary permissions.
- Google Workspace administrator access to configure domain-wide delegation.
- APIs enabled in your project:
  - Admin SDK Directory API
  - Google Cloud Firestore API
  - Secret Manager API
  - Cloud Run API
  - Cloud Scheduler API
- Python installed on your local machine.
- `gcloud` CLI configured for your GCP account.
- OpenTofu installed (for deploying infrastructure).

### Getting Started

Clone the repository and navigate to the project directory:

```bash
git clone https://github.com/TheCloudStead/gcp-cloud-run-google-groups.git
cd gcp-cloud-run-google-groups/build
```

### Setting Up Environment

1. **Python Dependencies:**  
   Install the required Python packages:

   ```bash
   pip install -r requirements.txt
   ```

2. **Google Cloud Authentication:**  
   Ensure you are authenticated to your GCP account:

   ```bash
   gcloud config set project <project_id>
   gcloud config set account <email>
   gcloud auth login
   gcloud auth application-default login
   ```

3. **Configure Domain-wide Delegation:**  
   Follow the instructions in this repository or accompanying article to set up a service account with domain-wide delegation in Google Workspace. This step is essential for the service account to impersonate an admin and access group data.

### Building and Deploying the Application

#### Dockerize the Python Application

Build the Docker image and push it to Google Container Registry (GCR):

```bash
docker build -t gcr.io/<project_id>/get-google-groups:1.0 .
docker push gcr.io/<project_id>/get-google-groups:1.0
```

#### Deploy Infrastructure with OpenTofu

1. Update variables in your OpenTofu configuration files as necessary (project ID, region, etc.).
2. Initialize and apply the configuration to set up Firestore, service accounts, Cloud Run Job, Cloud Scheduler, and other resources:

   ```bash
   cd ../opentofu
   tofu init
   tofu apply
   ```

### How It Works

1. **Service Account & Domain-Wide Delegation:**  
   The service account, configured with domain-wide delegation, impersonates a Workspace admin to read group memberships.

2. **Python Script (main.py):**  
   - Fetches a service account key from Secret Manager.
   - Uses the Google Admin SDK Directory API to iterate through Workspace groups.
   - Retrieves group members and their roles.
   - Stores group membership data in Firestore for future reference.

3. **Cloud Run Job and Scheduler:**  
   - The containerized Python application runs as a Cloud Run Job.
   - Cloud Scheduler triggers the job once a day based on the specified cron schedule.
   - The job updates Firestore with the latest group membership information, preserving historical data for deleted groups.

### Updating and Maintaining

- **Adjusting Schedule:**  
  Modify the Cloud Scheduler configuration in the OpenTofu files to change how frequently the job runs.

- **Updating Environment Variables:**  
  If you need to modify environment variables (like domain or collection names), update them in the OpenTofu configuration for the Cloud Run Job resource.

- **Managing Secrets:**  
  The service account key is stored in Secret Manager and referenced in the Python application. To rotate keys or update secrets, follow standard procedures in GCP and update the Secret Manager accordingly.

### License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

### Acknowledgments

Thank you to the readers of my Medium articles!