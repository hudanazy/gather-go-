var admin = require("firebase-admin");

var serviceAccount = require("gather_go/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://gather-go-default-rtdb.firebaseio.com"
});

var regestarationToken = "ftDIWvFGSx-aiEs8ETZhst:APA91bE7PygDDU4JYlq1d54SXdBMIYiafJ4S_q4bAyJ9ma5sFP1hYc0dpgNcszUkZ9rEpH7ybVyI1WbvLbsDG88yrBqSIWI3eRR9MNn-WulKbvzMpu9Tq54-s3sbNttcc99EHj7mJY0D";
var message = {
    data: {
        title: "",
        body: ""
    },
    token: regestarationToken
};

admin.messaging().send(message)
.then ((response) => {
    console.log(response);
}).catch((e) => {
    console.log(e);
})