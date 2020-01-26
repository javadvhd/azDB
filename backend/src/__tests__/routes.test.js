// routes.test.js
const request = require('supertest')
const server = require('../app')
// import {} from 'jest'
beforeAll(async () => {
  console.log('jest starting')
})

afterAll(async () => {
  server.close()
  console.log('server closed')
})

describe('basic route tests', () => {
  test('get home route GET / ', async () => {
    const response = await request(server).get('/')
    expect(response.status).toEqual(200)
    expect(response.text).toContain('HELLO WORLD')
  })
})
