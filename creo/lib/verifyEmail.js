const admin = require('firebase-admin');

const serviceAccount = require('../creo-7b668-firebase-adminsdk-jp80q-117be605a6.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const uid = 'ybzkJ5EUJPdThTfmx4fLjgVwTGe2';

admin.auth().updateUser(uid, {
  emailVerified: true
})
.then((userRecord) => {
  console.log('Successfully updated user', userRecord.toJSON());
})
.catch((error) => {
  console.log('Error updating user:', error);
});
