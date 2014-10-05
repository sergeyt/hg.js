_ = require 'underscore'
_.str = require 'underscore.string'

# config command plugin
module.exports = (hg) ->
  return (opts) ->
    hg.run('config', []).then (out) ->
      lines = _.str.lines(out)
      props = lines
        .map (line) ->
          p = line.split '='
          return null if p.length < 2
          key = _.str.trim(p[0])
          val = _.str.trim(p[1])
          obj = {}
          obj[key] = val
          obj
        .filter (p) -> p != null
      _.extend.apply _, props
