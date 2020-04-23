const AWS = require('aws-sdk')
AWS.config.update({ region: 'ap-northeast-1' })

const dynamodb = new AWS.DynamoDB()

/* Retrieve table info */
// dynamodb.listTables().promise().then(data => {
//   const detailOps = data['TableNames'].map((tableName) => {
//     return dynamodb.describeTable({ TableName: tableName }).promise()
//   })
//   return Promise.all(detailOps)
// }).then(tableDetails => {
//   console.log('TableDetails: ', tableDetails)
// }).catch(error => {
//   console.error(error)
// })

const documentClient = new AWS.DynamoDB.DocumentClient()

/* Write item */
// documentClient.put({
//   TableName: 'user_posts',
//   Item: {
//     user_id: 'dajfkdyieua11',
//     timestamp: 1,
//     title: 'Sample',
//     content: 'Sample content'
//   }
// }).promise().then(data => {
//   console.log('Put: ', data)
// }).catch(error => {
//   console.error('Put error: ', error)
// })

/* Update item */
// documentClient.update({
//   TableName: 'user_posts',
//   Key: {
//     user_id: 'dajfkdyieua11',
//     timestamp: 1
//   },
//   UpdateExpression: 'set #t = :t',
//   ExpressionAttributeNames: {
//     '#t': 'title'
//   },
//   ExpressionAttributeValues: {
//     ':t': 'Updated title'
//   }
// }).promise().then(data => {
//   console.log('Update: ', data)
// }).catch(error => {
//   console.error('Update error: ', error)
// })

/* Batch write */
// documentClient
//   .batchWrite({
//     RequestItems: {
//       user_posts: [
//         {
//           PutRequest: {
//             Item: {
//               user_id: "foo1",
//               timestamp: 100,
//               title: "Foo title",
//               content: "Foo content",
//             },
//           },
//           PutRequest: {
//             Item: {
//               user_id: "bar",
//               timestamp: 101,
//               title: "Bar title",
//               content: "Bar content",
//             },
//           },
//         },
//       ],
//     },
//   })
//   .promise()
//   .then((data) => {
//     console.log("BatchUpdate: ", data);
//   })
//   .catch((error) => {
//     console.error("BatchUpdate error: ", error);
//   })

/* Conditional write */

// documentClient.put({
//   TableName: 'user_posts',
//   Item: {
//     user_id: 'baz1',
//     timestamp: 102,
//     title: 'Conditional write title',
//     content: 'Conditional write content'
//   },
//   ConditionExpression: '#t <> :t',
//   ExpressionAttributeNames: {
//     '#t': 'timestamp'
//   },
//   ExpressionAttributeValues: {
//     ':t': 102
//   }
// })
//   .promise()
//    .then((data) => {
//     console.log("Conditional write: ", data);
//   })
//   .catch((error) => {
//     console.error("Conditional write error: ", error);
//   })

// documentClient
//   .put({
//     TableName: "user_posts",
//     Item: {
//       user_id: "baz1",
//       timestamp: 102,
//       title: "Conditional write not write title",
//       content: "Conditional write not write content",
//     },
//     ConditionExpression: "#t <> :t",
//     ExpressionAttributeNames: {
//       "#t": "timestamp",
//     },
//     ExpressionAttributeValues: {
//       ":t": 102,
//     },
//   })
//   .promise()
//   .then((data) => {
//     console.log("Conditional write: ", data);
//   })
//   .catch((error) => {
//     // Conditional Writeに失敗する(すでに timestamp 102 のItemが存在するので)
//     // 失敗時には例外がThrowされる
//     console.error("Conditional write error: ", error);
//   });

// Read operations

documentClient.get({
  TableName: 'user_posts',
  Key: {
    user_id: 'foo1',
    timestamp: 100
  }
})
  .promise()
  .then(data => {
    console.log('get result: ', data)
    // Dataの構造
    // {
    //   Item: {
    //     content: 'Foo content',
    //     user_id: 'foo1',
    //     title: 'Foo title',
    //     timestamp: 100
    //   }
    // }
  })
  .catch(error => {
    console.error('get error: ', error)
  })

documentClient.query({
  TableName: 'user_posts',
  KeyConditionExpression: 'user_id = :uid',
  ExpressionAttributeValues: {
    ':uid': 'foo1'
  }
})
  .promise()
  .then(data => {
    console.log('query result: ', data)

    // Dataの構造 Items: [], Count: 件数, ScannedCount: RCUを使用した数？
    // {
    //   Items: [
    //   {
    //     content: 'Foo content',
    //     user_id: 'foo1',
    //     title: 'Foo title',
    //     timestamp: 100
    //   }
    // ],
    //   Count: 1,
    //   ScannedCount: 1
    // }
  })
  .catch(error => {
    console.error('query error: ', error)
  })
