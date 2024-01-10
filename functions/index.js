const functions = require("firebase-functions");
const admin = require("firebase-admin"); //admin으로 토큰 발급 가능
const auth = require("firebase-auth");

var serviceAccount = require("./bukkunglist-firebase-adminsdk-kamny-7edcc4b1f7.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//

exports.createCustomToken = functions.https.onRequest(
  async (request, response) => {
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
  }
);

//24시간마다 추천리스트 만드는 함수
const firestore = admin.firestore();

exports.generateDailyRecommendation = functions.pubsub
  .schedule("every 24 hours")
  .timeZone("Asia/Seoul")
  .onRun(async (context) => {
    try {
      const bukkungListsRef = firestore.collection("bukkungLists");
      const snapshot = await bukkungListsRef.get();
      const allLists = snapshot.docs.map((doc) => doc.data());

      // 여기에서 적절한 로직으로 추천 리스트 생성
      const dailyRecommendation = generateRecommendation(allLists);

      // 생성된 추천 리스트를 Firestore에 저장
      await firestore
        .collection("recommendations")
        .doc("daily")
        .set(dailyRecommendation);

      console.log(
        "Daily recommendation generated successfully:",
        dailyRecommendation
      );
      return null;
    } catch (error) {
      console.error("Error generating daily recommendation:", error);
      return null;
    }
  });

function generateRecommendation(allLists) {
  // 여기에서 적절한 로직으로 추천 리스트를 생성하는 코드 작성
  // 예를 들어, 랜덤하게 몇 개의 리스트를 선택하는 등의 로직을 포함할 수 있습니다.
  const randomLists = getRandomItems(allLists, 5);

  return {
    recommendation: randomLists,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  };
}

function getRandomItems(array, count) {
  // 배열에서 랜덤하게 count 개의 아이템을 선택하는 함수
  const shuffled = array.sort(() => 0.5 - Math.random());
  return shuffled.slice(0, count);
}
