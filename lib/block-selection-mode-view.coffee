{Emitter, Disposable, CompositeDisposable} = require 'atom'

module.exports =
class BlockSelectionModeView
  editor: null
  constructor: (@editorElement) ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable

    @editor = @editorElement.getModel()

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('block-selection-mode')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The BlockSelectionMode package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

    @editorElement.classList.add("block-selection-mode")

    for cursor in @editor.getCursors()
      @subscriptions.add cursor.onDidChangePosition (event) ->
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
