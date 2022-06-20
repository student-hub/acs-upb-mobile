/* eslint-disable promise/always-return */
/* eslint-disable promise/no-nesting */
/* eslint-disable promise/catch-or-return */
const admin = require("firebase-admin");
const functions = require('firebase-functions');

const {XMLParser} = require('fast-xml-parser');
const TurndownService = require('turndown');
const fetch = require('isomorphic-unfetch');

const turndownService = new TurndownService()

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0

const AUTHOR_DISPLAY_NAME = 'LSAC Bucharest';
const AUTHOR_AVATAR_URL = 'https://firebasestorage.googleapis.com/v0/b/acs-upb-mobile-dev.appspot.com/o/websites%2Flsac%2Ficon.png?alt=media&token=1534aa39-5a6c-4319-9277-95beb7a871bf';
const SOURCE_CATEGORY = 'organizations';
const CATEGORY_ROLE = 'organizations-LSAC';
const POST_RELEVANCE = [];

const lsacBucharestFeedUrl = "https://lsacbucuresti.ro/feed/";
const feedPagedArg = "/?paged=";

exports.lsacBucharestScraper = functions
  .region("europe-west3")
  .pubsub
  .schedule('every minute')
  .timeZone('Europe/Bucharest')
  .onRun(async (_) => {
    const response = await fetch(lsacBucharestFeedUrl);
    const xmlData = await response.text();
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
        authorAvatarUrl: AUTHOR_AVATAR_URL,
        externalLink: item.link,
        relevance: POST_RELEVANCE,
        category: SOURCE_CATEGORY,
        categoryRole: CATEGORY_ROLE,
        createdAt: publishedDate
      };
    });

    const db = admin.firestore();
    const existingNewsQuery = await db.collection('news').get();
    const existingNewsTimestamps = existingNewsQuery.docs.map((doc) => doc.data().createdAt.toDate().getTime());

    const onlyRecentNews = news.filter((item) => {
      const checkDate = item.createdAt.getTime();
      const exists = existingNewsTimestamps.includes(checkDate);
      return !exists;
    });

    if (onlyRecentNews === null || onlyRecentNews.length < 1) {
      return;
    }     

    const batch = db.batch();
    onlyRecentNews.forEach((doc) => {
      const docRef = db.collection('news').doc();
      batch.set(docRef, doc);
    });

    batch.commit();
  });