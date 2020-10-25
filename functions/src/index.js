const backupFirestore = require('./firestore-backup');
const backupStorage = require('./storage-backup');

exports.backupFirestore = backupFirestore.backupFirestore;
exports.backupStorage = backupStorage.backupStorage;
