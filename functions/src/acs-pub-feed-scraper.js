/* eslint-disable promise/always-return */
/* eslint-disable promise/no-nesting */
/* eslint-disable promise/catch-or-return */
const admin = require("firebase-admin");
const functions = require('firebase-functions');

const {XMLParser} = require('fast-xml-parser');
const TurndownService = require('turndown')

const turndownService = new TurndownService()

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0

const EXTERNAL_SOURCE = 'acs.pub.ro';
const SOURCE_CATEGORY = 'official';
const POST_RELEVANCE = [];

const facultyFeedUrl = "https://acs.pub.ro/feed";
const universityFeedUrl = "https://upb.ro/feed/";
const feedPagedArg = "/?paged=";

const fetch = require('isomorphic-unfetch')

exports.acsFacultyScraper = functions
  .region("europe-west3")
  .https
  .onRequest((req, res) => {
    fetch(facultyFeedUrl)
      .then((response) => response.text())
      .then((xmlData) => {
        const parser = new XMLParser();
        const jsonObj = parser.parse(xmlData);
        const items = jsonObj.rss.channel.item;
        const news = items.map(item => {
            const publishedDate = new Date(item.pubDate);
            let markdown = turndownService.turndown(item['content:encoded'])
            if (markdown === null || markdown === '') {
                markdown = `Post content could not be loaded. Please check [original link](${item.link})`;
            }
            return { 
              title: item.title,
              authorId: '',
              body: markdown,
              externalSource: EXTERNAL_SOURCE,
              externalSourceLink: item.link,
              relevance: POST_RELEVANCE,
              category: SOURCE_CATEGORY,
              createdAt: publishedDate
            };
        });

        const db = admin.firestore();
        const batch = db.batch();
        news.forEach((doc) => {
          const docRef = db.collection('news').doc();
          batch.set(docRef, doc);
        });

        batch.commit().then(result => {
          res.status(200).send(result);
        }).catch(val => {
          res.status(500).send(val);
        })
      }).catch(val => {
        res.status(500).send(val);
      });
});

exports.createNewsEvent = functions
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
    .where('agreeToReceive', '==', true)
    .get();

  const fcmTokens = query.docs.map((doc) => doc.data().token);
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
