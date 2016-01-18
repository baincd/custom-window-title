_updateWindowTitle = null

module.exports =
	configDefaults:
		template: '<%= fileName %><% if (projectPath) { %> - <%= projectPath %><% } %>'

	config:
		template:
			type: 'string'
			default: '<%= fileName %><% if (projectPath) { %> - <%= projectPath %><% } %>'

	subscriptions: null
	configSub: null

	activate: (state) ->
		_ = require 'underscore'
		{ allowUnsafeNewFunction } = require 'loophole'
		path = require 'path'
		{CompositeDisposable} = require 'event-kit'

		@subscriptions = new CompositeDisposable

		template = null

		@configSub = atom.config.observe 'custom-title.template', ->
			templateString = atom.config.get('custom-title.template')

			if templateString
				try
					template = allowUnsafeNewFunction -> _.template templateString
				catch e
					template = null
			else
				template = null

			atom.workspace.updateWindowTitle()

		_updateWindowTitle = atom.workspace.updateWindowTitle

		atom.workspace.updateWindowTitle = ->
			if template
				item = atom.workspace.getActivePaneItem()

				fileName = item?.getTitle?() ? 'untitled'
				filePath = item?.getPath?()
				fileInProject = false

				projectIdx = 0
				for i in [0..atom.project.getPaths().length - 1]
					if item?.getPath?().startsWith(atom.project.getPaths()[i])
						projectIdx = i
						break

				projectPath = atom.project.getPaths()[projectIdx]
				projectName = if projectPath then path.basename(projectPath) else null

				repo = atom.project.getRepositories()[projectIdx]
				gitHead = repo?.getShortHead()

				gitAdded = null
				gitDeleted = null
				relativeFilePath = null

				devMode = atom.inDevMode()
				safeMode = atom.inSafeMode?()

				if filePath and repo
					status = repo.getCachedPathStatus(filePath)
					if repo.isStatusModified(status)
						stats = repo.getDiffStats(filePath)
						gitAdded = stats.added
						gitDeleted = stats.deleted
					else if repo.isStatusNew(status)
						gitAdded = item.getBuffer?().getLineCount()
						gitDeleted = 0
					else
						gitAdded = gitDeleted = 0

				if filePath and projectPath
					relativeFilePath = path.relative(projectPath, filePath)
					if filePath.startsWith(projectPath)
						fileInProject = true

				try

					title = template {
						projectPath, projectName, fileInProject,
						filePath, relativeFilePath, fileName,
						gitHead, gitAdded, gitDeleted
						devMode, safeMode
					}

					if filePath or projectPath
						atom.setRepresentedFilename(filePath ? projectPath)
					document.title = title
				catch e
					_updateWindowTitle.call(this)
			else
				_updateWindowTitle.call(this)

		atom.workspace.updateWindowTitle()

		@subscriptions.add atom.workspace.observeTextEditors (editor) =>
			editorSubscriptions = new CompositeDisposable
			editorSubscriptions.add editor.onDidSave -> atom.workspace.updateWindowTitle()
			editorSubscriptions.add editor.onDidDestroy -> editorSubscriptions.dispose()

			@subscriptions.add editorSubscriptions


	deactivate: ->
		@subscriptions?.dispose()
		@configSub?.dispose()
		atom.workspace.updateWindowTitle = _updateWindowTitle

	serialize: ->
