

const mongoose = require('mongoose');
const Grid = require("gridfs-stream");
const conn = mongoose.connection;
conn.once("open", function () {
    gfs = Grid(conn.db, mongoose.mongo);
    gfs.collection("wavs");
    gfs_midi = Grid(conn.db, mongoose.mongo);
    gfs_midi.collection("midis");
    gfs_csv = Grid(conn.db, mongoose.mongo);
    gfs_csv.collection("csvs");
    gfs_img= Grid(conn.db, mongoose.mongo);
    gfs_img.collection("images");
});


exports.getFileWav = async (req,res) => {
    try {
        const file = await gfs.files.findOne({ filename: req.params.filename });
        const readStream = gfs.createReadStream(file.filename);
        readStream.pipe(res);
    } catch (error) {
        res.send(error);
    }
}

exports.getFileMidi = async (req,res) => {
    try {
        const file = await gfs_midi.files.findOne({ filename: req.params.filename });
        const readStream = gfs_midi.createReadStream(file.filename);
        readStream.pipe(res);
    } catch (error) {
        res.send(error);
    }
}

exports.getFileCsv = async (req,res) => {
    try {
        const file = await gfs_csv.files.findOne({ filename: req.params.filename });
        const readStream = gfs_csv.createReadStream(file.filename);
        readStream.pipe(res);
    } catch (error) {
        res.send(error);
    }
}

exports.getFileImg = async (req,res) => {
    try {
        const file = await gfs_img.files.findOne({ filename: req.params.filename });
        const readStream = gfs_img.createReadStream(file.filename);
        readStream.pipe(res);
    } catch (error) {
        res.send(error);
    }
}

exports.deleteFile = async (req,res) => {
    try {
        await a.gfs.files.deleteOne({ filename: req.params.filename });
        res.send("success");
    } catch (error) {
        console.log(error);
        res.send("An error occured.");
    }
}