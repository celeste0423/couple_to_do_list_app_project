const functions = require("firebase-functions");
const admin = require("firebase-admin"); //admin으로 토큰 발급 가능
const auth = require("firebase-auth");

var serviceAccount = require("./bukkunglist-firebase-adminsdk-kamny-7edcc4b1f7.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//

exports.createCustomToken = functions.https.onRequest(async (request, response) => {
  //서버에 넣을 때 request.body로 넣어줌
  const user = request.body;

  const uid = `kakao:${user.uid}`;
  const updatedParams = {
    email: user.email,
  };

  try {
    //uid를 가진 유저의 값을 updatedParams로 업데이트 함
    await admin.auth().updateUser(uid, updatedParams);
  } catch (e) {
    //만약 등록된 유저가 없을 경우 => 새로 만듦
    updatedParams["uid"] = uid;
    await admin.auth().createUser(updatedParams);
  }
  //파이어베이스에 유저 추가
  const token = await admin.auth().createCustomToken(uid);
  //token은 response에 실어서 보내줌
  response.send(token);
});
