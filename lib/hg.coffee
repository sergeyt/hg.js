fs = require 'fs'
path = require 'path'
{spawn} = require 'child_process'
Q = require 'q'

verbose = false

# load command plugins
plugins = fs.readdirSync(__dirname)
	.filter (file) ->
		name = path.basename(file, '.coffee')
		switch name
			when 'hg' then false
			else true
	.map (file) ->
		name = path.basename(file, '.coffee')
		factory = require "./#{name}"
		factory.cmdname = name
		return factory

# todo move a separate micro module (e.g. qrun)
# executes given hg command
exec = (cwd, cmd, args) ->
	args = [] if not args

	# todo allow to configure exec options
	opts =
		encoding: 'utf8'
		timeout: 1000 * 60
		killSignal: 'SIGKILL'
		maxBuffer: 1024 * 1024
		cwd: cwd
		env: process.env

	# inherit process identity
	opts.uid = process.getuid() if process.getuid
	opts.gid = process.getgid() if process.getgid

	def = Q.defer()

	argv = [cmd, args...]
	if verbose
		console.log "hg #{argv.join(' ')}"
	hg = spawn "hg", argv, opts

	hg.stdout.on 'data', (data) ->
		msg = data?.toString().trim()
		def.resolve msg

	hg.stderr.on 'data', (data) ->
		msg = data?.toString().trim()
		console.error data
		def.reject msg

	hg.on 'error', (err) ->
		msg = err?.toString().trim()
		console.error msg
		def.reject msg

	hg.on 'close', ->
		def.resolve '' if def.promise.isPending()

	return def.promise

# creates hg command runner
hg = (dir) ->
	# todo support bundles and remote sessions
	if not fs.existsSync dir
		throw new Error "#{dir} does not exist"

	# runs given command
	run = (cmd, args) ->
		exec dir, cmd, args

	api = {run: run}

	# inject commands
	plugins.forEach (factory) ->
		cmdfn = factory api
		api[factory.cmdname] = cmdfn
		(cmdfn.aliases || []).forEach (name) ->
			api[name] = cmdfn

	return api

module.exports = hg
