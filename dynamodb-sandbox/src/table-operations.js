const AWS = require('aws-sdk')
AWS.config.update({ region: 'ap-northeast-1' })

const dynamodb = new AWS.DynamoDB()

dynamodb.listTables().promise().then(data => {
  console.log(data)
}).catch(error => {
  console.error(error)
})
