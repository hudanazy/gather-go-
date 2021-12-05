const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.myFunction = functions.firestore
    .document("events/{docId}")
    .onUpdate((change, context) => {
      const userId = change.after.data().uid.toString();
      let message = "";
      if ( change.after.data().adminCheck && !change.before.data().adminCheck) {
        const isApproved = change.after.data().approved;
        if (isApproved) {
          message = "Your event "+
          change.after.data().name+" is approved, don't forget about it.";
          return admin.messaging().sendToTopic(
              "event_"+userId, {
                notification: {
                  title: "Upcoming event",
                  body: message,
                  clickAction: "FLUTTER_NOTIFICATION_CLICK",
                }});
        } else {
          message = "Sorry, your event "+
          change.after.data().name+" is disapproved.";
          return admin.messaging().sendToTopic(
              "event_"+userId, {
                notification: {
                  title: "Event disapproved",
                  body: message}});
        }
      }
    }
    );
