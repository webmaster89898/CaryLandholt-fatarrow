es                    = require 'event-stream'
{COMPONENTS_DIRECTORY,
	TEMP_DIRECTORY,
	SRC_DIRECTORY}    = require '../constants'
templateOptions       = require '../templateOptions'
path                  = require 'path'

module.exports = (gulp, plugins) -> ->
	{onError} = require('../events') plugins
	options =
		less:
			paths: [
				path.resolve TEMP_DIRECTORY
			]
			sourceMap: true
			sourceMapBasepath: path.resolve TEMP_DIRECTORY

	sources = '**/*.less'
	srcs    = []

	srcs.push src =
		gulp
			.src sources, {cwd: TEMP_DIRECTORY, nodir: true}
			.on 'error', onError

	srcs.push src =
		gulp
			.src sources, {cwd: COMPONENTS_DIRECTORY, nodir: true}
			.on 'error', onError

	es
		.merge.apply @, srcs
		.on 'error', onError

		.pipe plugins.less options.less
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError
