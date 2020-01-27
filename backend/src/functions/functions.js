const { sql } = require('../db/db')
const getDoctorRelations =  (doctorId) => {
    return new Promise(resolve => {
      let sqlRequest = new sql.Request()
      sqlRequest.query( `select * from FindDoctorRelationsss (${doctorId})` ,(err, data) => {
        if (err) {
          console.log('error', err)
          return console.error(err.message)
        }
        resolve(data.recordsets)
      })
    })
}

const getPharmacyIncome =  (pharmacyId) => {
    return new Promise(resolve => {
      let sqlRequest = new sql.Request()
      sqlRequest.query( `select dbo.all_income (${pharmacyId})` ,(err, data) => {
        if (err) {
          console.log('error', err)
          return console.error(err.message)
        }
        resolve(data.recordsets)
      })
    })
}


  

module.exports = {
    getDoctorRelations,
    getPharmacyIncome
}