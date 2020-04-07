const functions = require('firebase-functions');
const admin = require('firebase-admin')
admin.initializeApp()
exports.sendNotification = functions.firestore
    .document('alerta_de_robo/{message}')
    .onCreate((snap, context) => {
        // These registration tokens come from the client FCM SDKs.
        var registrationTokens = [
            'f-opgFP51dQ:APA91bEkrlR8dN7Dgf2wYq_3M_CSyrL4-TmuqDScvaGOkHs9DcoJgQEViahhniO5yLmFqZvYUpJYMt8Et_JrIY03SjThqdO3FLV9ANTFyRUO9QlFDT9k57_c2ADxgRGzNZvUeVpK0ffz',
            // ...
            //'YOUR_REGISTRATION_TOKEN_n'
        ];

        // Subscribe the devices corresponding to the registration tokens to the
        var topic = "usuarios";
        admin.messaging().subscribeToTopic(registrationTokens, topic)
            .then(function (response) {
                // See the MessagingTopicManagementResponse reference documentation
                // for the contents of response.
                console.log('Successfully subscribed to topic:', response);
            })
            .catch(function (error) {
                console.log('Error subscribing to topic:', error);
            });
    })
