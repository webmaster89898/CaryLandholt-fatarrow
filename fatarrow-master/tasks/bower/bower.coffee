fs = require 'fs'
q = require 'q'
path = require 'path'
{BOWER_DIRECTORY, BOWER_FILE} = require '../constants'
{BOWER_COMPONENTS} = require '../../config/bower'
pkg = require '../../package.json'

module.exports = (gulp, plugins) -> ->
	{onError} = require('../events') plugins
	# we only want the bower task to run ones
	unless require('../options').firstRun
		deferred = q.defer()
		deferred.resolve()
		return deferred

	components = []

	urlExpression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
	urlRegEx = new RegExp urlExpression

	do ->
		bowerJson =
			_comment: 'THIS FILE IS AUTOMATICALLY GENERATED.  DO NOT EDIT.'
			name: pkg.name
			version: pkg.version
			devDependencies: {}

		compo = {}

		for component, value of BOWER_COMPONENTS
			for version, componentTypes of value
				bowerJson.devDependencies[component] = version

				for componentType, files of componentTypes
					isArray         = Array.isArray files
					filesToAdd      = if isArray then files else [files]
					filesToAdd      = filesToAdd.map (file) -> path.join component, file
					key             = path.join component, componentType
					compo[key] = [] if not compo[key]
					compo[key] = compo[key].concat filesToAdd

		fs.writeFile BOWER_FILE, JSON.stringify bowerJson, {}, '\t'
