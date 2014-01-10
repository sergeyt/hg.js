_ = require 'underscore'
_.str = require 'underscore.string'

# status command plugin
module.exports = (hg) ->
	return (opts) ->
		args = transform(opts)
		hg.run('status', args).then(parse)

transform = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'all' then "--all"
				when 'modified' then "--modified"
				when 'added' then "--added"
				when 'removed' then "--removed"
				when 'deleted' then "--deleted"
				when 'clean' then "--clean"
				when 'unknown' then "--unknown"
				when 'ignored' then "--ignored"
				when 'rev' then "--rev=#{v}"
				when 'include' then "--include=#{v}"
				when 'exclude' then "--exclude=#{v}"
				else ''
	.filter _.identity

parse = (out) ->
	return [] if not out
	lines = _.str.lines(out)
	# todo parse lines
	lines.map (line) ->
		status = line.substr(0, 1)
		path = line.substr(1).trim()
		{path: path, status: fullStatus(status)}

fullStatus = (s) ->
	switch s.trim()
		when 'M' then 'modified'
		when 'A' then 'added'
		when 'R' then 'removed'
		when 'C' then 'clean'
		when 'I' then 'ignored'
		when '!' then 'missing'
		when '?' then 'untracked'
		else ''
