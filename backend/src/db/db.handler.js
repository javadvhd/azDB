const { db } = require('./db')

const saveNote = async ({ wisId, userId }) =>
  await db.run(
    `INSERT INTO note(wisId, userId) VALUES('${wisId}', '${userId}')`,
    function(err) {
      if (err) {
        return console.log(err.message)
      }
      // console.log(`A row has been inserted with rowid ${this.lastID}`)
    },
  )

const fetchNote = ({ wisId }) => {
  return new Promise(resolve => {
    db.get(
      `select title title, content content from note where wisId = '${wisId}'`,
      (err, row) => {
        if (err) {
          console.error(err.message)
        }
        resolve(row)
      },
    )
  })
}

const updateNote = async ({ wisId, title, content }) => {
  return await db.run(
    `UPDATE note SET title = '${title}' , content = '${content}' WHERE wisId = '${wisId}'`,
    err => {
      if (err) console.error(err)
    },
  )
}

const getPatientlist = async ({}) => {
  ;['1', '11']
}

module.exports = {
  saveNote,
  fetchNote,
  updateNote,
  getPatientlist,
}
