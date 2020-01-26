// modules
import { create } from 'axios'

const server = 'http://localhost:4210'

export const { get, post } = create({
  baseURL: server
})
