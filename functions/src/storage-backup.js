const functions = require('firebase-functions');
const admin = require('firebase-admin');
const serviceAccount = require("../serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.backupStorage = functions.region("europe-west3")
  .pubsub
  .schedule('every day 00:00')
  .timeZone('Europe/Bucharest')
  .onRun(async (_) => {

    const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
    const sourceBucket = admin.storage().bucket(`${projectId}.appspot.com`);
    const destBucket = admin.storage().bucket(`${projectId}-storage-backups`);

    console.log("Starting storage backup...")
    const timestamp = new Date().toISOString();

    const [sourceFiles] = await sourceBucket.getFiles();
    const sourceFileNames = sourceFiles.map((file) => file.name);
    console.log(timestamp, "# Total", sourceFileNames.length);

    let promises = [];
    for (let fileName of sourceFileNames) {
      const copyFilePromise = sourceBucket.file(fileName).copy(destBucket.file(`${timestamp}/${fileName}`));
      promises.push(copyFilePromise);
    }
    await Promise.all(promises);

    console.log("Storage backup completed.")
    return "DONE";
  });
