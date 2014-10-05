parse = require 'parse-diff'
Q = require 'q'

# diff command plugin
module.exports = (hg) ->
	# todo could be a one command (detect revision and file)
	cmd = (revs, opts) ->
		# be smart, by default show changes
		if not revs || revs.length == 0
			return cmd.files([], opts)
		# using unified diff format
		rlist = revs.map (x) -> "-r #{x}"
		args = ['--unified=0', diff_opts(opts)..., rlist...]
		hg.run('diff', args).then(parse)
	# diff files
	cmd.files = (files, opts) ->
		# todo support more options
		files = [] if not files
		# using unified diff format
		args = ['--unified=0', diff_opts(opts)...]
		hg.run('diff', [args..., files...]).then(parse)
	cmd

diff_opts = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'include' then "--include=#{v}"
				when 'exclude' then "--exclude=#{v}"
				when 'subrepos' then "--subrepos"
				else ''
	.filter _.identity
