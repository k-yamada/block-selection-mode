BlockSelectionModeView = require './block-selection-mode-view'
{Disposable, CompositeDisposable} = require 'atom'

module.exports = BlockSelectionMode =
  blockSelectionModeView: null
  modalPanel: null
  subscriptions: null
  modeViews: []

  activate: (state) ->
    console.log("activate")
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @disposables = new CompositeDisposable

    blockModes = new WeakMap
    # Register command that toggles this view
    # @subscriptions.add atom.commands.add 'atom-workspace', 'block-selection-mode:toggle': => @toggle()
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      return if editor.mini
      element = atom.views.getView(editor)

      if not blockModes.get(editor)
        blockSelectionModeView = new BlockSelectionModeView(element)
        blockModes.set(editor, blockSelectionModeView)

        @disposables.add new Disposable =>
          blockSelectionModeView.destroy()

    # @subscriptions.add atom.commands.add 'atom-workspace', 'block-selection-mode:toggle': => @toggle()

  deactivate: ->
    console.log("diactivate")
    @subscriptions.dispose()
    @blockSelectionModeView.destroy()
    @modeViews = []

  serialize: ->
    blockSelectionModeViewState: @blockSelectionModeView.serialize()
