const { sql } = require('./../db/db')

const calcOnCallDoctorPaymentProcedure =  (doctorId, initialDate) => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('doctorId', doctorId).input('startTime', initialDate).execute('calcOnCallDoctorPayment' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
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
        resolve(data.recordsets)
      })
    })
  }

  
const patointHistoryByAgeProcedure =  (initialAge) => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('age', initialAge).execute('returnHistory' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordsets)
    })
  })
}


const labsCauseHospitalizationProcedure = (minimumNumber) => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('minimumNumber', minimumNumber).execute('LabCauseHospi' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordsets)
    })
  })
}

const clerkAddmiterProcedure = (basement) => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('basePayment', basement).execute('clerkAddmiter' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordsets)
    })
  })
}

const dhwlPrescriptionProcedure = (baseNumber) => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('baseNumber', baseNumber).execute('DHWLPrescription' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordsets)
    })
  })
}

const longestHospitalizationProcedure = () => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.execute('LongestHospitalization' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordsets)
    })
  })
}


const roomPatientCountProcedure = (countStartTime) => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('startTime', countStartTime).execute('RoomPationtNumber' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordsets)
    })
  })
}

const worstIllnessProcedure = (illnessStartTime) => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('startTime', illnessStartTime).execute('worstIllness' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordsets)
    })
  })
}

const patientCaseProcedure = (natoinalId) => {
  return new Promise(resolve => {
    let sqlRequest = new sql.Request()
    sqlRequest.input('national_id', natoinalId).execute('pationPrescriptionHistory' ,(err, data) => {
      if (err) {
        console.log('error', err)
        return console.error(err.message)
      }
      resolve(data.recordsets)
    })
  })
}










module.exports = {
    calcOnCallDoctorPaymentProcedure,
    illnessNeedLabsProcedure,
    patointHistoryByAgeProcedure,
    labsCauseHospitalizationProcedure,
    clerkAddmiterProcedure,
    dhwlPrescriptionProcedure,
    longestHospitalizationProcedure,
    roomPatientCountProcedure,
    worstIllnessProcedure,
    patientCaseProcedure

}
