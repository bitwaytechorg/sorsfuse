"use strict";
const FBAnalyseGroupPage = require("./Facebook/AnalyseGroupPage");
const AnalyseCSV = require("./Custom/AnalyseCSV");

// Note do below initialization tasks in index.js and
// NOT in child functions:
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const database = admin.firestore();

// Pass database to child functions so they have access to it
exports.FBAnalyseGroupPage = functions.https.onRequest((req, res) => {
  FBAnalyseGroupPage.handler(req, res, database);
});
exports.AnalyseCSV = functions.https.onRequest((req, res) => {
  AnalyseCSV.handler(req, res, database);
});
