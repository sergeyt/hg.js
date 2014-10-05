fs = require 'fs'
path = require 'path'
exeq = require 'exequte'
_ = require "underscore"

# load command plugins
plugins = fs.readdirSync(path.join(__dirname, 'commands'))
	.filter (file) ->
		name = path.basename(file, '.coffee')
		switch name
			when 'hg' then false
			else true
	.map (file) ->
		name = path.basename(file, '.coffee')
		factory = require "./commands/#{name}"
		factory.cmdname = name
		return factory

# executes given hg command
exec = (cwd, cmd, args, opts) ->
	args = [] if not args
	argv = [cmd, args...]
	exeq 'hg', argv, {cwd: cwd, verbose: opts.verbose}

# creates hg command runner
hg = (dir, opts) ->
	unless arguments.length
		dir = process.cwd()
		opts = {}

	if _.isObject dir
		opts = dir
		dir = opts.dir

	dir = process.cwd() unless dir
	opts = {} unless opts

	# todo support bundles and remote sessions
	if not fs.existsSync dir
		throw new Error "#{dir} does not exist"

	# runs given command
	run = (cmd, args) ->
		exec dir, cmd, args, opts

	api = {run: run}

	# inject commands
	plugins.forEach (factory) ->
		cmdfn = factory api
		api[factory.cmdname] = cmdfn
		(cmdfn.aliases || []).forEach (name) ->
			api[name] = cmdfn

	return api

module.exports = hg
