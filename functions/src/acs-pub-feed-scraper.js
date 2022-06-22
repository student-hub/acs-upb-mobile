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

const AUTHOR_DISPLAY_NAME = 'acs.pub.ro';
const AUTHOR_AVATAR_URL = 'https://firebasestorage.googleapis.com/v0/b/acs-upb-mobile-dev.appspot.com/o/websites%2Facspubro%2Ficon.png?alt=media&token=049a6c7b-0198-4b5c-b68c-c92e151b0f0d';
const SOURCE_CATEGORY = 'official';
const CATEGORY_ROLE = 'official';
const POST_RELEVANCE = [];

const facultyFeedUrl = "https://acs.pub.ro/feed";
const universityFeedUrl = "https://upb.ro/feed/";
const feedPagedArg = "/?paged=";

exports.acsFacultyScraper = functions
  .region("europe-west3")
  .pubsub
  .schedule('every day 00:00')
  .timeZone('Europe/Bucharest')
  .onRun(async (_) => {
    const response = await fetch(facultyFeedUrl);
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


