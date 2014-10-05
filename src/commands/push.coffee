_ = require 'underscore'
_.str = require 'underscore.string'

# push command plugin
module.exports = (hg) ->
	return (opts) ->
		args = ['--quite', transform(opts)...]
		# todo parse output
		hg.run('push', args)

transform = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'force' then "--force"
				when 'rev' then "--rev=#{v}"
				when 'bookmark' then "--bookmark=#{v}"
				when 'branch' then "--branch=#{v}"
				when 'newbranch' then "--new-branch"
				when 'ssh' then "--ssh=#{v}"
				when 'insecure' then "--insecure=#{v}"
				else ''
	.filter _.identity
