const { sql } = require('./../db/db')

const calcOnCallDoctorPaymentProcedure =  () => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('doctorId', 102).input('startTime', '2019-05-05').execute('calcOnCallDoctorPayment' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      console.log(data)
      resolve(data.recordsets)
    })
  })
}

const illnessNeedLabsProcedure =  () => {
    return new Promise(resolve => {
      let sqlRequest = new sql.Request()
      sqlRequest.execute('illnessNeedLab' ,(err, data) => {
        if (err) {
          console.log('error', err)
          return console.error(err.message)
        }
        console.log(data)
        resolve(data.recordsets)
      })
    })
  }





module.exports = {
    calcOnCallDoctorPaymentProcedure,
    illnessNeedLabsProcedure
}
