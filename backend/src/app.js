// app
const koa = require('koa')
const app = new koa()

// router
const Router = require('koa-router')
const router = new Router()

// logger
const logger = require('koa-logger')
// app.use(logger())

// cors
const cors = require('@koa/cors')
app.use(cors({}))

// bodyParser
const bodyParser = require('koa-bodyparser')
app.use(bodyParser())

// db
// app.context.db = db()

app.use(async (ctx, next) => {
  try {
    await next()
  } catch (error) {
    ctx.status = error.status || 500
    ctx.body = error.message
    ctx.app.emit('error', error, ctx)
  }
})

require('./routes/basic')({ router })

app.use(router.routes())
app.use(router.allowedMethods())
const server = app.listen(4210)
module.exports = server
