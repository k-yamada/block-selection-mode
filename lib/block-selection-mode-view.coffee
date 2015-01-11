{Emitter, Disposable, CompositeDisposable} = require 'atom'

module.exports =
class BlockSelectionModeView
  editor: null
  constructor: (@editorElement) ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable
    @editor = @editorElement.getModel()
    @editorElement.classList.add("block-selection-mode")

    for cursor in @editor.getCursors()
      @subscriptions.add cursor.onDidChangePosition (event) => @onDidChangePosition(event)

    @subscriptions.add atom.commands.add @editorElement, "block-selection-mode:toggle", (event) => @toggle()
    @subscriptions.add atom.commands.add @editorElement, "core:cancel", (event) => @deactivate()

  onDidChangePosition: (event) ->
    if @isActivated
      console.log(event)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    @subscriptions.dispose()
    @deactivateInsertMode()
    #@editorElement.component.setInputEnabled(true)
    @editorElement.classList.remove("block-selection-mode")

  getElement: ->
    @element

  toggle: ->
    if @isActivated
      @deactivate()
    else
      @activate()

  activate: ->
    console.log("activate")
    @isActivated = true

  deactivate: ->
    console.log("deactivate")
    @isActivated = false
