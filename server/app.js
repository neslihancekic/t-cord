const express = require('express');
const mongoose = require('mongoose');
const morgan = require('morgan');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const expressValidator = require('express-validator');
const cors = require('cors');
const responseHelper = require('express-response-helper').helper();
const axios = require('axios');
const {admin} = require("./firebase-config");


//app
const app = express();

//import routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');
const trackRoutes = require('./routes/track');
const compositonRoutes = require('./routes/composition');
const notificationRoutes = require('./routes/notification');
const commentRoutes = require('./routes/comment');
const upload = require("./routes/upload");

//db connection
mongoose.connect(
	process.env.MONGO_URI,
	{
		useNewUrlParser: true,
		useUnifiedTopology: true,
		useCreateIndex: true,
		useFindAndModify: false
	}
).then(() => console.log('DB Connected'));

mongoose.connection.on('error', err =>{
	console.log('DB connection error: ${err.message}')
});


//middlewares
if (!process.env.CLOSE_MORGAN)
	app.use(morgan('dev'));
app.use(bodyParser.json());
app.use(cookieParser());
app.use(expressValidator());
app.use(cors());
app.use(responseHelper);

//routes middleware
app.use("/api",authRoutes);
app.use("/api",userRoutes);
app.use("/api",trackRoutes);
app.use("/api",compositonRoutes);
app.use("/api",notificationRoutes);
app.use("/api",commentRoutes);
app.use("/", upload);


const notification_options = {
    priority: "high",
    timeToLive: 60 * 60 * 24
};
app.post('/firebase/notification', (req, res)=>{
    const  registrationToken = req.body.registrationToken
    const message = req.body.message
    const data = req.body.data
    const options =  notification_options
    axios
    .post(`http://${req.headers.host}/api/notification`, data)
    .then(response => {
        console.log(`statusCode: ${response.status}`)
        console.log(response)
        message["data"] = {id:response.data._id}
        console.log(message)
        admin.messaging().sendToDevice(registrationToken, message, options)
        .then( r => {
        
            res.status(200).send("Notification sent successfully")
        
        })
        .catch( error => {
            console.log(error);
        });
    })
    .catch(error => {
        console.error(error)
    })
    

})

module.exports = app