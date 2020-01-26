const { getPatientlist, getPrescriptionList, getEmpleyeeList, getHospitalizationList} = require('../db/db.handler')
const { illnessNeedLabsProcedure, calcOnCallDoctorPaymentProcedure } = require('./../store/stored.procedures') 
module.exports =  ({ router }) => {
  router.get('/patientList', async  ctx => {
   await getPatientlist().then(( data ) =>  (ctx.body = data))
  })

  router.get('/prescriptionList',async ctx => {
    await getPrescriptionList().then(( data ) =>  (ctx.body = data))
  })

  router.get('/empleyeeList',async ctx => {
    await getEmpleyeeList().then(( data ) =>  (ctx.body = data))
  })
  router.get('/hospitalizationList',async ctx => {
    await getHospitalizationList().then(( data ) =>  (ctx.body = data))
  })

  router.get('/illnessNeedsLabs',async ctx => {
    await illnessNeedLabsProcedure().then(( data ) =>  (ctx.body = data))
  })
  
  router.get('/calcOnCallDoctorPayment',async ctx => {
    await calcOnCallDoctorPaymentProcedure(ctx).then(( data ) =>  (ctx.body = data))
  })
  
}