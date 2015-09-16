deepExtend = require('deep-extend')
request = require('request-promise')
credentials = require('../src/credentials')


module.exports = {
  apiOrigin: ->
    process.env.HUBOT_CF_API_ORIGIN || throw new Error("Please set HUBOT_CF_API_ORIGIN.")

  resolveUrl: (path) ->
    @apiOrigin() + path

  generalRequestOpts: (accessToken) ->
    {
      json: true
      headers:
        Authorization: "Bearer #{accessToken}"
      useQuerystring: true
    }

  request: (opts) ->
    credentials.fetchTokenObj().then (token) =>
      allOpts = @generalRequestOpts(token.access_token)
      deepExtend(allOpts, opts)

      if allOpts.path
        allOpts.url = @resolveUrl(opts.path)
        delete allOpts.path

      request(allOpts)
}
