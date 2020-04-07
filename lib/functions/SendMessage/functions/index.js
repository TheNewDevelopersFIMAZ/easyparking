const functions = require('firebase-functions');
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
    .document('alerta_de_robo/{message}')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)

        //const idLocation = doc.idLocation
        const idUsuario = doc.idUsuario
        const contentMessage = `El vehículo con el numero de Placas "${doc.placas}" fue reportado como robado...`

        const registrationTokens = [
            'f-opgFP51dQ:APA91bEkrlR8dN7Dgf2wYq_3M_CSyrL4-TmuqDScvaGOkHs9DcoJgQEViahhniO5yLmFqZvYUpJYMt8Et_JrIY03SjThqdO3FLV9ANTFyRUO9QlFDT9k57_c2ADxgRGzNZvUeVpK0ffz',
            'fwHvVWBO3JM:APA91bF8zT9v1GQG36B9uWRrncXa3JHbrUZFa0Y2V5Dxt6LG8I-Px9wYJAueGRVFI56ONCAM8QCLCEdP8eIoLelCdPo7KzWv_CZ8v6S7SEgY33BcUgSDwlaXdvuUGsuE-NHjWyXpTqCu',
            'e3ejfb5fd2w:APA91bG49Mx27sjJOT8WHBmQulV7HlLaMrplWaLqHBpwBfOPhztlWl6lNUgTqRrw-j-W3fcsPlsOhpgnwrD3lCKJrZ_ciORW_Lxco2hP58EsfBYZS9OsSMhr07oHYQcFFbfzXFq6Qvnj',
            'fbKkL2BXZwo:APA91bFGEaw_EpfMlIy1bjU8nuIFnIqR8irLf2Q18m569GNPaIMdlh4dgXfCBDBNn9NcGyrVgX5jEgKQuE-Epv0PTw8vxqdGZ62--5kKIft812KSmXoFWCOXQKGMZJniOO2HvP-tbcby',
            'dPw7YYWYOIc:APA91bHY0wYctBqQfDLzmzFkzFqEsNeAuhDi-azkScrveFwYgpOCzbaELtRQoWu5h28EiltyQO2I285eI2-Gxa04aSAZyXBSCSZ7sjcyjgtmcBqER0AfqntPzqCbq-hsFs65msRYOgfo',
            'fSQIJToKJBk:APA91bGdLqW2IUTJuOOW6zn1G99KWHZEKdDX21cPZnNKulvzWoPMIcmfK-qibTQFPQt0ya1a9IYIEB60ucIqcevzr1aLkTCU93O1blVrxXzDVxbe8LuDgKqPwlTXuRm4G56fbfMqqLbW',
            'fxo_O1iy0bQ:APA91bEcXxHOQSKxqn8jj9u1jRZvATbi3FtH0PMfXUZo0GfiqmOKKXgg-JEHsEppZV8sOZEucXT6pD0afSenv_TpYYf3K7MHq0PTVehYCMVJfwsqOUKVytFg1MLwRxJdk69HMydR2bVW',
            'eI3RFdU44q8:APA91bHUSe4vf7fa4QMfkIVhXnsvNDg7qYLx8VjHPIofdunf-85K9WewcFQ-wNYlw6GGtSMw4HK4wI1v5ldW1lY48thrbdqogMbmjX6gdoEQFwInIHdFU2nm7OTDmbG3CfCI2qbkrZug',
            'ceWqgJ5YJEYhuHzt2lK7Vp:APA91bHltpzDJCZLxt0jJmnvbqoM_q8qG7SAUPU9kBlYD_0EWZWZkR0HbVKSJhkpRYK7ANTtJzTxoxT7FwtYfgNwkvvnv8gOc7GLcCon0Sx1J4Fo8JKqO23RjiilvyjcWslbEAlBhpcm'
        ];
        // Get push token user to (receive)
        admin
            .firestore()
            .collection('usuarios')
            .where('id', '==', idUsuario)
            .get()
            .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {
                    console.log(`Found user from: ${userFrom.data().nombre}`)
                    const payload = {
                        notification: {
                            title: `Ayuda a "${userFrom.data().nombre}" a recuperar su vehículo`,
                            body: contentMessage,
                        },
                        data: {
                            click_action: "FLUTTER_NOTIFICATION_CLICK",
                            info: `{"nombre": "${userFrom.data().nombre}","tipovehiculo": "${doc.tipovehiculo}", "color": "${doc.color}", "placas": "${doc.placas}", "correo": "${doc.correo}"}`

                        },
                        tokens: registrationTokens,
                    }
                    // Let push to the target device
                    admin
                        .messaging()
                        .sendMulticast(payload)
                        .then(response => {
                            console.log('Successfully sent message:', response)
                        })
                        .catch(error => {
                            console.log('Error sending message:', error)
                        })
                })
            })

        return null
    })
