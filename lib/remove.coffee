_ = require 'underscore'

# remove command plugin
module.exports = (hg) ->
	cmd = (files, opts) ->
		args = ['--quite', transform(opts)..., files...]
		hg.run('remove', args)
	cmd

transform = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'force' then "--force"
				when 'include' then "--include=#{v}"
				when 'exclude' then "--exclude=#{v}"
				else ''
	.filter _.identity
