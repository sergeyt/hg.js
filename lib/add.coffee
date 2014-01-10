# add command plugin
module.exports = (hg) ->
	return (files, opts) ->
		args = [transform(opts)..., files...]
		hg.run('add', args)

transform = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'include' then "--include=#{v}"
				when 'exclude' then "--exclude=#{v}"
				when 'dryrun' then "--dry-run"
				else ''
	.filter _.identity
