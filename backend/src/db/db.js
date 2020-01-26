const sql = require('mssql')

sql.connect('mssql://javad:javad2256VHD@localhost/database', err => {
  if (err) {
    console.log('error', err)
    return console.error(err.message)
  }
  let sqlRequest = new sql.Request()
  let sqlQuery = 'Select EmpId From Employees'
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
