const multer = require("multer");
const {GridFsStorage} = require("multer-gridfs-storage");

const storage = new GridFsStorage({
    url: process.env.MONGO_URI,
    options: { useNewUrlParser: true, useUnifiedTopology: true },
    file: (req, file) => {

        if (file.originalname.slice(-3)=="wav") {
            return {
                bucketName: "wavs",
                contentType:"audio/wave",
                filename: `${Date.now()}-${file.originalname}`,
            };
        }
        else if (file.originalname.slice(-3)=="mid") {
            return {
                bucketName: "midis",
                contentType:"audio/midi",
                filename: `${Date.now()}-${file.originalname}`,
            };
        }
        else if (file.originalname.slice(-3)=="csv") {
                return {
                    bucketName: "csvs",
                    contentType:"text/csv",
                    filename: `${Date.now()}-${file.originalname}`,
                };
        }
        else if (file.originalname.slice(-4)=="jpeg") {
            return {
                bucketName: "images",
                contentType:"image/jpeg",
                filename: `${Date.now()}-${file.originalname}`,
            };
        }
        else{
            return {
                bucketName: "midis",
                contentType:"audio/midi",
                filename: `${Date.now()}-${file.originalname}`,
            };
        }
    },
});

module.exports = multer({ storage });