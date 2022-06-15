/* eslint-disable promise/always-return */
/* eslint-disable promise/no-nesting */
/* eslint-disable promise/catch-or-return */
const admin = require("firebase-admin");
const functions = require('firebase-functions');

const {XMLParser} = require('fast-xml-parser');
const TurndownService = require('turndown')

const turndownService = new TurndownService()

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0

const AUTHOR_DISPLAY_NAME = 'LSAC Bucharest';
const SOURCE_CATEGORY = 'organizations';
const CATEGORY_ROLE = 'organizations-LSAC';
const POST_RELEVANCE = [];

const lsacBucharestFeedUrl = "https://lsacbucuresti.ro/feed/";
const feedPagedArg = "/?paged=";

const fetch = require('isomorphic-unfetch')

exports.lsacBucharestScraper = functions
  .region("europe-west3")
  .https
  .onRequest((req, res) => {
    fetch(lsacBucharestFeedUrl)
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
              userId: '',
              body: markdown,
              authorDisplayName: AUTHOR_DISPLAY_NAME,
              externalLink: item.link,
              relevance: POST_RELEVANCE,
              category: SOURCE_CATEGORY,
              categoryRole: CATEGORY_ROLE,
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
