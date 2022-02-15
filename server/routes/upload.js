const upload = require("../models/upload");
const express = require("express");
const router = express.Router();
const {PythonShell} = require('python-shell');
const axios = require('axios');
var fs = require('fs');

async function download(url,dest){ 
    var file = fs.createWriteStream(dest);
    try {
        const response = await axios({
            url,
            method: 'GET',
            responseType: 'stream'
          })
       response.data.pipe(file)
       return new Promise((resolve, reject) => {
           file.on('finish', resolve)
           file.on('error', reject)
       })
    } catch (error) {
        console.log(error.response.body);
    }
}

const { 
    getFileWav,
    getFileMidi,
    getFileCsv,
    getFileImg,
    deleteFile
} = require("../controllers/upload");


router.post("/transcribe", upload.single("file"), async (req, res) => {
    res.setTimeout(0);
    if (req.file === undefined) return res.send("you must select a file.");
    const url = `http://${req.headers.host}/wav/${req.file.filename}`;
    await download(url,"./temp.wav");
    var options = {
        //pythonPath: '/app/.heroku/python/bin/python3', //localde sil
        args:
        [
          "/temp.wav",
          req.headers.host
        ]
      }
    PythonShell.run('./python/amt_algo.py', options, function (err, data) {
        if (err) throw err;
        // results is an array consisting of messages collected during execution
        console.log('results: %j', data);
        return res.respond({
            url:url,
            midi:data.slice(-3)[0],
            csv:data.slice(-3)[1],
            sheetMusic:data.slice(-3)[2],
        });
    });
});


router.post("/wav/upload", upload.single("file"), async (req, res) => {
    if (req.file === undefined) return res.send("you must select a file.");
    const url = `http://${req.headers.host}/wav/${req.file.filename}`;
    return res.send(url);
});


router.post("/midi/upload", upload.single("file"), async (req, res) => {
    if (req.file === undefined) return res.send("you must select a file.");
    const url = `http://${req.headers.host}/midi/${req.file.filename}`;
    return res.send(url);
});


router.post("/csv/upload", upload.single("file"), async (req, res) => {
    if (req.file === undefined) return res.send("you must select a file.");
    const url = `http://${req.headers.host}/csv/${req.file.filename}`;
    return res.send(url);
});

router.post("/image/upload", upload.single("file"), async (req, res) => {
    if (req.file === undefined) return res.send("you must select a file.");
    const url = `http://${req.headers.host}/img/${req.file.filename}`;
    return res.send(url);
});

router.get("/midi/:filename", getFileMidi);
router.get("/wav/:filename", getFileWav);
router.get("/csv/:filename", getFileCsv);
router.get("/img/:filename", getFileImg);
router.delete("/:filename", deleteFile);

module.exports = router;