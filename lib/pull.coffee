# pull command plugin
module.exports = (hg) ->
	return (opts) ->
		args = ['--quiet', transform(opts)...]
		hg.run('pull', args)

transform = (opts) ->
	return [] if not opts
	# todo support more options
	_.keys(opts)
	.map (k) ->
			v = opts[k]
			switch k
				when 'update' then "--update"
				when 'force' then "--force"
				when 'bookmark' then "--bookmark=#{v}"
				when 'branch' then "--branch=#{v}"
				when 'insecure' then "--insecure"
				when 'ssh' then "--ssh=#{v}"
				else ''
	.filter _.identity
