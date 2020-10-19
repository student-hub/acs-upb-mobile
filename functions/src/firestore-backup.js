const functions = require('firebase-functions');
const firestore = require('@google-cloud/firestore');
const client = new firestore.v1.FirestoreAdminClient();

exports.backupFirestore = functions.region("europe-west3")
  .pubsub
  .schedule('every day 00:00')
  .timeZone('Europe/Bucharest')
  .onRun((context) => {

    const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
    const databaseName =
      client.databasePath(projectId, '(default)');
    const timestamp = new Date().toISOString();
    const bucket = `gs://${projectId}-firestore-backups/${timestamp}`;

    return client.exportDocuments({
        name: databaseName,
        outputUriPrefix: bucket,
        collectionIds: []
      })
      .then(responses => {
        const response = responses[0];
        console.log(`Operation Name: ${response['name']}`);
        return null;
      })
      .catch(err => {
        console.error(err);
        throw new Error('Export operation failed');
      });
  });
