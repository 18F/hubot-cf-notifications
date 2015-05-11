assert = require('assert')
checker = require('../src/event_checker')
fixtures = require('./support/fixtures')

describe 'event_checker', ->
  describe '.isDeploy()', ->
    it "returns true for STARTED events", ->
      event = fixtures.getStartedEvent()
      # sanity check
      assert.equal(event.entity.metadata.request.state, 'STARTED')
      assert(checker.isDeploy(event))

    it "returns false for STOPPED events", ->
      event = fixtures.getStoppedEvent()
      # sanity check
      assert.equal(event.entity.metadata.request.state, 'STOPPED')
      assert(!checker.isDeploy(event))

  describe '.getRequestOpts()', ->
    it "formats the timestamp properly", ->
      since = new Date(2014, 2, 1)
      opts = checker.getRequestOpts(since)
      assert.deepEqual(opts,
        path: '/v2/events'
        qs:
          q: [
            'timestamp>2014-03-01T06:00:00.000Z'
            'type:audit.app.update'
          ]
      )
