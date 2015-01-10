BlockSelectionModeView = require './block-selection-mode-view'
{Disposable, CompositeDisposable} = require 'atom'

module.exports = BlockSelectionMode =
  blockSelectionModeView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @disposables = new CompositeDisposable

    # Register command that toggles this view
    # @subscriptions.add atom.commands.add 'atom-workspace', 'block-selection-mode:toggle': => @toggle()
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      return if editor.mini
      element = atom.views.getView(editor)
      blockSelectionModeView = new BlockSelectionModeView(element)

      @disposables.add new Disposable =>
        blockSelectionModeView.destroy()

  deactivate: ->
    @subscriptions.dispose()
    @blockSelectionModeView.destroy()

  serialize: ->
    blockSelectionModeViewState: @blockSelectionModeView.serialize()

  toggle: ->
    console.log 'BlockSelectionMode was toggled!'
