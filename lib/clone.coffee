# clone command plugin
module.exports = (hg) ->
	return (url, directory, opts) ->
		args = ['--quiet', transform(opts)..., url]
		args.push directory if directory
		hg.run('clone', args)

transform = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'noupdate' then "--noupdate"
				when 'pull' then "--pull"
				when 'uncompressed' then "--uncompressed"
				when 'insecure' then "--insecure"
				when 'ssh' then "--ssh=#{v}"
				else ''
	.filter _.identity
