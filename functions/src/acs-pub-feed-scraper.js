const axios = require('axios');
const cheerio = require('cheerio');
const {XMLParser} = require('fast-xml-parser');
const TurndownService = require('turndown')

const turndownService = new TurndownService()

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0

const facultyFeedUrl = "https://acs.pub.ro/feed";
const universityFeedUrl = "https://upb.ro/feed/";

const feedPagedArg = "/?paged=";

const fetch = require('isomorphic-unfetch')

// eslint-disable-next-line promise/catch-or-return
fetch(universityFeedUrl)
  .then((response) => response.text())
  // eslint-disable-next-line promise/always-return
  .then((xmlData) => {
    const parser = new XMLParser();
    let jsonObj = parser.parse(xmlData);
    
    // const builder = new XMLBuilder();
    // let samleXmlData = builder.build(jsonObj);

    const items = jsonObj.rss.channel.item;
    const news = items.map(item => {
        let markdown = turndownService.turndown(item['content:encoded'])
        if (markdown === null || markdown === '') {
            markdown = `Post content could not be loaded. Please check [original link](${item.link})`;
        }
        return {
            title: item.title,
            authorId: '',
            body: markdown,
            externalSource: 'acs.upb.ro',
            externalSourceLink: item.link,
            relevance: [],
            category: 'official',
            createdAt: Date.now()
        }
    });

    console.log(news);

  });
