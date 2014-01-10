# init command plugin
module.exports = (hg) ->
	return (opts) ->
		args = ['--quiet', transform(opts)...]
		hg.run('init', args)

transform = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'ssh' then "--ssh=#{v}"
				when 'insecure' then "--insecure"
				else ''
	.filter _.identity
