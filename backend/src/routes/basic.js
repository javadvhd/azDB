const { getPatientlist } = require('../db/db.handler')

module.exports = ({ router }) => {
  router.get('/patientList', ctx => {
    // getPatientlist()
    //   .then(data => {
    //     console.log('data ', data)
    //     ctx.body = 'success!'
    //   })
    //   .catch(console.log)
  })

  router.post('/updateNote', ctx => {
    // updateNote(ctx.request.body)
    //   .then(() => (ctx.body = 'success!'))
    //   .catch(console.log)
  })

  router.get('/fetchNote', ctx => {
    // fetchNote(ctx.query)
    //   .then(res => {
    //     ctx.body = res
    //   })
    //   .catch(console.log),
  })
}
