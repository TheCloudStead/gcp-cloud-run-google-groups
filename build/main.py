import json, os

from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
import google.cloud.secretmanager as secretmanager
from google.oauth2 import service_account
from google.cloud import firestore

PROJECT_ID = os.environ["PROJECT_ID"]
SECRET_ID = os.environ["SECRET_ID"]
DOMAIN = os.environ["DOMAIN"]
DELEGATED_ADMIN = os.environ["DELEGATED_ADMIN"]
COLLECTION = os.environ["COLLECTION"]
SCOPES = os.environ["SCOPES"].split(",")

def get_secret(secret_id, project_id):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{project_id}/secrets/{secret_id}/versions/latest"
    response = client.access_secret_version(request={"name": name})
    return response.payload.data.decode("UTF-8")

def main():

    sa_key = get_secret(SECRET_ID, PROJECT_ID)

    credentials = service_account.Credentials.from_service_account_info(
        json.loads(sa_key),
        scopes=SCOPES
    )
    
    delegated_credentials = credentials.with_subject(DELEGATED_ADMIN)
    service = build('admin', 'directory_v1', credentials=delegated_credentials)

    db = firestore.Client()
    group_tracker = {}
    group_page_token = None

    while True:

        group_result = service.groups().list(domain=DOMAIN, pageToken=group_page_token).execute()
        for group in group_result.get('groups', []):
            group_email = group['email'] 
            group_id = group['id'] 

            group_tracker.setdefault(group_email, {})

            member_page_token = None
            while True:

                member_result = service.members().list(groupKey=group_id, pageToken=member_page_token).execute()
                for member in member_result.get('members', []):
                    role = member['role']
                    email = member['email']

                    group_tracker[group_email].setdefault(role, [])
                    group_tracker[group_email][role].append(email)

                member_page_token = member_result.get('nextPageToken')
                if not member_page_token:
                    break

            db.collection(COLLECTION).document(group_email).set(group_tracker[group_email])

        group_page_token = group_result.get('nextPageToken')
        if not group_page_token:
            break

if __name__ == "__main__":
    
    main()