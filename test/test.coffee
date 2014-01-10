require 'should'
fs = require 'fs'
path = require 'path'
tmp = path.join __dirname, 'tmp'

create = ->
	fs.mkdirSync tmp if not fs.existsSync tmp
	require('../index')(tmp)

clean = ->
	fs.rmdirSync tmp

hg = null

describe 'hg object', ->
	describe 'created for temp dir', ->

		beforeEach ->
			hg = create()

		afterEach ->
			clean()

		it 'should expose the following commands', ->
			[
				'add', 'remove', 'commit',
				'diff', 'init', 'log',
				'pull', 'push',
				'status'
			].forEach (cmd) ->
				hg.should.have.property(cmd)
				hg[cmd].should.be.instanceof(Function)
				(typeof hg[cmd]).should.be.eql 'function'
