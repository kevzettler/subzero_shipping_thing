var {graphql_simple, graphql_relay, jwt, resetdb} = require('../common.js');
var graphql = graphql_simple

describe('write', function() {

  before(function(done){ resetdb(); done(); });
  after(function(done){ resetdb(); done(); });

  it('can insert one drug', function(done) {
    graphql()
      .withRole('webuser')
      .send({
        query: `
          mutation {
            insert{
              drug(input: {name: "new name"}){
                id
                name
              }
            }
          }
        `
      })
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect( r => {
        //r.body.data.drugs.length.should.equal(10);
        r.body.data.insert.drug.name.should.equal('new name');
        r.body.data.insert.drug.id.should.be.type('number');
      })

  });

  it('can insert multiple', function(done) {
    graphql()
      .withRole('webuser')
      .send({
        //query: `{ drugs { id name } }`
        query: `
          mutation {
            insert{
              drugs(input: [{name: "item 1"}, {name: "item 2"}]){
                id
                name
              }
            }
          }
        `
      })
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect( r => {
        r.body.data.insert.drugs.length.should.equal(2);
        r.body.data.insert.drugs[0].name.should.equal('item 1');
        r.body.data.insert.drugs[0].id.should.be.type('number');
        r.body.data.insert.drugs[1].name.should.equal('item 2');
        r.body.data.insert.drugs[1].id.should.be.type('number');
      })

  });

  // DRUG!!!!!!!!!  bad fail 500 if the id is not found
  it('can update one drug', function(done) {
    graphql()
      .withRole('webuser')
      .send({
        //query: `{ drugs { id name } }`
        query: `
          mutation {
            update{
              drug(id: 1, input: {name: "new name 1"}){
                id
                name
              }
            }
          }
        `
      })
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect( r => {
        //r.body.data.items.length.should.equal(10);
        r.body.data.update.drug.name.should.equal('new name 1');
        r.body.data.update.drug.id.should.be.type('number');
        r.body.data.update.drug.id.should.equal(1)
      })

  });

});
