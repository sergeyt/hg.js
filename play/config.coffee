hg = require './index'

print = (p) ->
	p.then (val) ->
		console.log val
	.fail (err) ->
		console.error err

print hg.config()
