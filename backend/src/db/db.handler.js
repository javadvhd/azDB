const {sql} = require('./db')

const getPrescriptionList = () => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    let sqlQuery = 'Select * From Prescription '
    sqlRequest.query(sqlQuery,  (err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordset)
    })
  })
}

const getPatientlist =  () => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    let sqlQuery = 'Select * From Pationt p'
    sqlRequest.query(sqlQuery,  (err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordset)
    })
  })
}


const getEmpleyeeList =  () => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    let sqlQuery = 'Select * From Employee e'
    sqlRequest.query(sqlQuery,  (err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordset)
    })
  })
}
const getHospitalizationList =  () => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    let sqlQuery = 'Select * From Hospitalization h'
    sqlRequest.query(sqlQuery,  (err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordset)
    })
  })
}






module.exports = {
  getPatientlist,
  getPrescriptionList,
  getEmpleyeeList,
  getHospitalizationList
}
