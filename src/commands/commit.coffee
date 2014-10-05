_ = require 'underscore'
_.str = require 'underscore.string'

# commit command plugin
module.exports = (hg) ->
	return (opts) ->
		files = opts.files || []
		args = ['--quite', transform(opts)..., files...]
		# todo parse output
		hg.run('commit', args)

transform = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'amend' then "--amend"
				when 'closebranch' then "--close-branch"
				when 'close-branch' then "--close-branch"
				when 'secret' then "--secret=#{v}"
				when 'include' then "--include=#{v}"
				when 'exclude' then "--exclude=#{v}"
				when 'message' then "--message=#{_.str.quote(v)}"
				when 'subrepos' then "--subrepos"
				else ''
	.filter _.identity
