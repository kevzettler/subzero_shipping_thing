import { rest_service, resetdb } from '../common'
import should from 'should'

describe('read', function () {
  before(function (done) { resetdb(); done() })
  after(function (done) { resetdb(); done() })

  it('basic', function (done) {
    rest_service()
      .get('/drugs?select=id,name')
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect(r => {
        r.body.length.should.equal(6)
        r.body[0].id.should.equal(1)
      })
  })

  it('by primary key', function (done) {
    rest_service()
      .get('/drugs/1&select=id,name')
      .expect(200, done)
      .expect(r => {
        r.body.id.should.equal(1)
        r.body.name.should.equal('drug_1_1_1_1_1_1_1_1_1_1_1_1_1_')
      })
  })
})
