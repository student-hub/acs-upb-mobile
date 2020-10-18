// https://medium.com/@bastihumann/how-to-backup-firestore-the-firebase-way-874da6d75082

import * as functions from 'firebase-functions';
import * as key from "../service-account.json"; // your service file here

import { google } from "googleapis";


const authClient = new google.auth.JWT({
  email: key.client_email,
  key: key.private_key,
  scopes: ["https://www.googleapis.com/auth/datastore", "https://www.googleapis.com/auth/cloud-platform"]
});

const firestoreClient = google.firestore({
  version: "v1beta2",
  auth: authClient
});

exports.backupFirestore = functions.region("europe-west3").pubsub.schedule('every day 00:00').timeZone('Europe/Bucharest').onRun(async (_) => {
  const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT

  const timestamp = new Date().toISOString()

  console.log(`Start to backup project ${projectId}`)

  await authClient.authorize();
  return firestoreClient.projects.databases.exportDocuments({
    name: `projects/${projectId}/databases/(default)`,
    requestBody: {
      outputUriPrefix: `gs://${projectId}-firestore-backups/backups/${timestamp}`
    }
  })
});
