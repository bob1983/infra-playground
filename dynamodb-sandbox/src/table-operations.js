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
