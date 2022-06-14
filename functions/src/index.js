const admin = require("firebase-admin");
const backupFirestore = require('./firestore-backup');
const backupStorage = require('./storage-backup');
const acsFacultyScraper = require('./acs-pub-feed-scraper');
const serviceAccount = require("../serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://acs-upb-mobile-dev.firebaseio.com"
});

exports.backupFirestore = backupFirestore.backupFirestore;
exports.backupStorage = backupStorage.backupStorage;
exports.acsFacultyScraper = acsFacultyScraper.acsFacultyScraper;
exports.createNewsEvent = acsFacultyScraper.createNewsEvent;