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
  console.log(tableDetails)
}).catch(error => {
  console.error(error)
})

const documentClient = new AWS.DynamoDB.DocumentClient()

/* Write item */
documentClient.put({
  TableName: 'user_posts',
  Item: {
    user_id: 'dajfkdyieua11',
    timestamp: 1,
    title: 'Sample',
    content: 'Sample content'
  }
}).promise().then(data => {
  console.log(data)
}).catch(error => {
  console.error(error)
})
