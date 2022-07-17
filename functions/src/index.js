const admin = require("firebase-admin");
const backupFirestore = require('./firestore-backup');
const backupStorage = require('./storage-backup');
const acsFacultyScraper = require('./acs-pub-feed-scraper');
const lsacBucharestScraper = require('./lsac-bucharest-feed-scraper');
const upbScraper = require('./upb-pub-feed-scraper');
const createdNewsEvent = require('./created-news-event');
const serviceAccount = require("../serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://acs-upb-mobile-dev.firebaseio.com"
});

exports.backupFirestore = backupFirestore.backupFirestore;
exports.backupStorage = backupStorage.backupStorage;
exports.createdNewsEvent = createdNewsEvent.createdNewsEvent;
exports.acsFacultyScraper = acsFacultyScraper.acsFacultyScraper;
exports.upbScraper = upbScraper.upbScraper;
exports.lsacBucharestScraper = lsacBucharestScraper.lsacBucharestScraper;
exports.createNewsEvent = acsFacultyScraper.createNewsEvent;