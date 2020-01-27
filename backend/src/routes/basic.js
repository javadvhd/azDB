const { getPatientlist, getPrescriptionList, getEmpleyeeList,
   getHospitalizationList, getReleaseList} = require('../db/db.handler')

const { illnessNeedLabsProcedure, calcOnCallDoctorPaymentProcedure, 
  patointHistoryByAgeProcedure,labsCauseHospitalizationProcedure,
  clerkAddmiterProcedure,dhwlPrescriptionProcedure,
  longestHospitalizationProcedure,roomPatientCountProcedure,
  worstIllnessProcedure, patientCaseProcedure
 } = require('./../store/stored.procedures') 

 const { getDoctorRelations, getPharmacyIncome } = require('./../functions/functions')

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
    await calcOnCallDoctorPaymentProcedure(ctx.query.doctorId, ctx.query.initialDate).then(( data ) =>  (ctx.body = data))
  })
  
  router.get('/patointHistoryByAge',async ctx => {
    await patointHistoryByAgeProcedure(ctx.query.initialAge).then(( data ) =>  (ctx.body = data))
  })

  router.get('/labsCauseHospitalization',async ctx => {
    await labsCauseHospitalizationProcedure(ctx.query.minimumNumber).then(( data ) =>  (ctx.body = data))
  })

  router.get('/clerkAddmiter',async ctx => {
    await clerkAddmiterProcedure(ctx.query.basement).then(( data ) =>  (ctx.body = data))
  })

  router.get('/dhwlPrescription',async ctx => {
    await dhwlPrescriptionProcedure(ctx.query.baseNumber).then(( data ) =>  (ctx.body = data))
  })

  router.get('/longestHospitalization',async ctx => {
    await longestHospitalizationProcedure().then(( data ) =>  (ctx.body = data))
  })

  router.get('/roomPatientCount',async ctx => {
    await roomPatientCountProcedure(ctx.query.countStartTime).then(( data ) =>  (ctx.body = data))
  })

  router.get('/worstIllness',async ctx => {
    await worstIllnessProcedure(ctx.query.illnessStartTime).then(( data ) =>  (ctx.body = data))
  })

  router.get('/patientCase',async ctx => {
    await patientCaseProcedure(ctx.query.nationalId).then(( data ) =>  (ctx.body = data))
  })

  router.get('/releaseList',async ctx => {
    await getReleaseList().then(( data ) =>  (ctx.body = data))
  })

  router.get('/doctorRelations',async ctx => {
    await getDoctorRelations(ctx.query.doctorId).then(( data ) =>  (ctx.body = data))
  })

  router.get('/pharmacyIncome',async ctx => {
    await getPharmacyIncome(ctx.query.pharmacyId).then(( data ) =>  (ctx.body = data))
  })

  

  
  
}