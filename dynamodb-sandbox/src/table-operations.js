const AWS = require('aws-sdk')
AWS.config.update({ region: 'ap-northeast-1' })

const dynamodb = new AWS.DynamoDB()

/* Retrieve table info */
dynamodb.listTables().promise().then(data => {
  const detailOps = data['TableNames'].map((tableName) => {
    return dynamodb.describeTable({ TableName: tableName }).promise()
  })
  return Promise.all(detailOps)
}).then(tableDetails => {
  console.log('TableDetails: ', tableDetails)
}).catch(error => {
  console.error(error)
})

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
documentClient.update({
  TableName: 'user_posts',
  Key: {
    user_id: 'dajfkdyieua11',
    timestamp: 1
  },
  UpdateExpression: 'set #t = :t',
  ExpressionAttributeNames: {
    '#t': 'title'
  },
  ExpressionAttributeValues: {
    ':t': 'Updated title'
  }
}).promise().then(data => {
  console.log('Update: ', data)
}).catch(error => {
  console.error('Update error: ', error)
})

/* Batch operation */

documentClient
  .batchWrite({
    RequestItems: {
      user_posts: [
        {
          PutRequest: {
            Item: {
              user_id: "foo1",
              timestamp: 100,
              title: "Foo title",
              content: "Foo content",
            },
          },
          PutRequest: {
            Item: {
              user_id: "bar",
              timestamp: 101,
              title: "Bar title",
              content: "Bar content",
            },
          },
        },
      ],
    },
  })
  .promise()
  .then((data) => {
    console.log("BatchUpdate: ", data);
  })
  .catch((error) => {
    console.error("BatchUpdate error: ", error);
  });

