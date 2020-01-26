const sql = require('mssql')
const config ={
  server: 'DESKTOP-PE24J4O',
  database: 'azDB',
  user: 'mra',
  password: '1377',
  port: 1433
}
sql.connect(config, err => {
  if (err) {
    console.log('error', err)
    return console.error(err.message)
  }
  let sqlRequest = new sql.Request()
  let sqlQuery = 'Select * From Employee e'
  console.log('sqlQuery ', sqlQuery)
  sqlRequest.query(sqlQuery, (err, data) => {
    if (err) {
      console.log('error', err)
      return console.error(err.message)
    }
    console.log(data)
    console.table(data.recordset)
    sql.close()
  })
})

// db.run('drop table note', (err, message) => {})
// db.run('CREATE TABLE note(wisId, userId, text, content)')

// db.close(err => {
//   if (err) {
//     return console.error(err.message)
//   }
//   console.log('Close the database connection.')
// })

// module.exports = {}
