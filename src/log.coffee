_ = require 'underscore'
_.str = require 'underscore.string'
Q = require 'q'
async = require 'async'

# log command plugin
module.exports = (hg) ->
	return (opts) ->
		format = '--template={rev};{node};{author};{date};{desc}'
		args = [format, '--date=iso', transform(opts)...]
		hg.run('log', args).then(parse).then(extend(hg))

transform = (opts) ->
	return [] if not opts
	# todo support more options like since, after, etc
	_.keys(opts)
	.map (k) ->
		v = opts[k]
		switch k
			when 'include' then "--include=#{{v}}"
			when 'exclude' then "--exclude=#{{v}}"
			when 'rev' then "--rev=#{{v}}"
			when 'limit' then "--limit=#{{v}}"
			when 'removed' then "--removed"
			when 'keyword' then "--keyword=#{v}"
			when 'nomerges' then "--nomerges"
			else ''
	.filter _.identity

parse = (out) ->
	return [] if not out
	lines = _.str.lines(out)
	lines.map (l) ->
		p = l.split ';'
		id: p[0]
		hash: p[1]
		author:
			name: p[2]
		date: new Date(p[3])
		message: p[4]

extend = (git) ->
	(commits) ->
		list = commits.map (c) ->
			c.diff = -> diff(git, c)
			return c
		list.diffs = -> diffs(git, commits)
		list

# fetch diff for given commit
diff = (git, commit) ->
	git.diff([commit.id])

# fetch diffs for given commits
diffs = (git, commits) ->
	def = Q.defer()
	funcs = commits.map (c) -> diffAsyncFn(git, c)
	async.parallel funcs, (err, res) ->
		def.reject(err) if err
		def.resolve(res)
	def.promise

diffAsyncFn = (git, commit) ->
	(cb) ->
		diff(git, commit)
		.then (res) ->
			cb null, res
		.fail (err) ->
			cb err, null
