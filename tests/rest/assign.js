import { rest_service, resetdb } from '../common'
import { should } from 'should'

describe('assign', function(){
  beforeEach(function (done) { resetdb(); done() })
  afterEach(function (done) { resetdb(); done() })

  describe('with order id', function(){
    it('writes', function(done){
      rest_service()
        .post('/rpc/assign')
        .set('Accept', 'application/vnd.pgrst.object+json')
        .send({"order_id": "5"})
        .expect('Content-Type', /json/)
        .expect(r => {
          r.body.length.should.equal(2);
        }, done)
        .expect(200, done)
    })

    it('reads', function(done){
      rest_service()
        .get('/assignments')
        .expect('Content-Type', /json/)
        .expect(200, done)
        .expect(r => {
          r.body.length.should.equal(1);
          r.body[0].items.length.should.equal(2);
        })
    })


    describe.only('with order json blob', function(){
      it('writes', function(done){
        rest_service()
          .post('/rpc/assign')
          .set('Accept', 'application/vnd.pgrst.object+json')
          .send({
            'destination': 'WI',
            'items': [],
          })
          .expect('Content-Type', /json/)
          .expect(r => {
            console.log('r.body', r.body);
            r.body.length.should.equal(1);
          }, done)
          .expect(200, done)
      });
    });
  });
});
