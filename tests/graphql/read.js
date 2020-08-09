import { graphql_simple, resetdb } from '../common'
import should from 'should'
const graphql = graphql_simple

describe('read', function() {

  before(function(done){ resetdb(); done(); });
  after(function(done){ resetdb(); done(); });

  it('can get all drugs', function(done) {
    graphql()
      .withRole('webuser')
      .send({
        query: `{ drugs { id name } }`
      })
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect( r => {
        // console.log(r.body)
        r.body.data.drugs.length.should.equal(6);
      })

  });

  it.skip('can get drugs and subdrugs', function(done) {
    graphql()
      .withRole('webuser')
      .send({
        query: `
          {
            drugs{
              id
              name
            }
          }

        `
      })
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect( r => {
        r.body.data.drugs.length.should.equal(6);
        r.body.data.drugs[0].name.should.equal("drug_2_2_2_2_2_2_2_2_2_2_2_");
      })

  });

});
