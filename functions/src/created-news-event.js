const admin = require("firebase-admin");
const functions = require('firebase-functions');

exports.createdNewsEvent = functions
  .region("europe-west3")
  .firestore
  .document('news/{newsId}')
  .onCreate((snap, _) => {
    const newValue = snap.data();
    const category = newValue.category;
    if (category === null || category === '')
      return Promise.resolve(false);

    if (category === 'official') {
      return Promise.resolve(sendNewsNotification(
        'New official post!', 'official'
      ));
    } else if (category === 'organizations') {
      return Promise.resolve(sendNewsNotification(
        'New organization post!', 'organizations'
      ));
    } else {
      return Promise.resolve(sendNewsNotification(
        'New post from students!', 'students'
      ));
    }
  });

const sendNewsNotification = async (title, body) => {
  const query = await admin.firestore()
    .collection('fcmTokens')
    .get();

  const fcmTokens = query.docs.map((doc) => doc.data().token);
  console.log(fcmTokens);
  if (fcmTokens.length > 0) {
    const payload = {
      notification: {
        title: title,
        body: body
      }
    };
    const response = await admin.messaging().sendToDevice(fcmTokens, payload);
    await cleanupTokens(response, fcmTokens);
  }
  return true;
}
const cleanupTokens = (response, tokens) => {
  const tokensDelete = [];
  response.results.forEach((result, index) => {
    const error = result.error;
    if (error) {
        console.error('Failure sending notification to', tokens[index], error);
        // Cleanup the tokens who are not registered anymore.
        if (error.code === 'messaging/invalid-registration-token' ||
            error.code === 'messaging/registration-token-not-registered') {
            const deleteTask = admin.firestore().collection('fcmTokens').doc(tokens[index]).delete();
            tokensDelete.push(deleteTask);
        }
    }
  });
  return Promise.all(tokensDelete);
}