# atom.workspaceView.getActiveView().getEditor().setSelectedBufferRanges([[[0,9], [0,13]], [[3,16], [3,21]]])

{Emitter, Disposable, CompositeDisposable} = require 'atom'

module.exports =
class BlockSelectionModeView
  editor: null
  blockStart = null
  blockEnd   = null

  constructor: (@editorElement) ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable
    @editor = @editorElement.getModel()

    @subscriptions.add atom.commands.add @editorElement, "block-selection-mode:toggle", (event) => @toggle()
    @subscriptions.add atom.commands.add @editorElement, "block-selection-mode:next-line", (event) => @nextLine()
    @subscriptions.add atom.commands.add @editorElement, "block-selection-mode:previous-line", (event) => @previousLine()
    @subscriptions.add atom.commands.add @editorElement, "block-selection-mode:forward-char", (event) => @forwardChar()
    @subscriptions.add atom.commands.add @editorElement, "block-selection-mode:backward-char", (event) => @backwardChar()
    @subscriptions.add atom.commands.add @editorElement, "core:cancel", (event) => @deactivate()

  nextLine: ->
    if @isActivated
      @blockEnd.row += 1
      @selectBlock()

  previousLine: ->
    if @isActivated
      @blockEnd.row -= 1
      @selectBlock()

  forwardChar: ->
    if @isActivated
      @blockEnd.column += 1
      @selectBlock()

  backwardChar: ->
    if @isActivated
      if @blockEnd.column > 0
        @blockEnd.column -= 1
        @selectBlock()

  # Do the actual selecting
  selectBlock: ->
    allRanges = []
    rangesWithLength = []
    for row in [@blockStart.row..@blockEnd.row]
      # Define a range for this row from the blockStart column number to
      # the blockEnd column number
      range = @editor.bufferRangeForScreenRange [[row, @blockStart.column], [row, @blockEnd.column]]

      allRanges.push range
      if @editor.getTextInBufferRange(range).length > 0
        rangesWithLength.push range

    # If there are ranges with text in them then only select those
    # Otherwise select all the 0 length ranges
    if rangesWithLength.length
      @editor.setSelectedBufferRanges rangesWithLength
    else
      @editor.setSelectedBufferRanges allRanges

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    @subscriptions.dispose()
    @editorElement.classList.remove("block-selection-mode")

  getElement: ->
    @element

  toggle: ->
    if @isActivated
      @deactivate()
    else
      @activate()

  activate: ->
    @isActivated = true
    @editorElement.classList.add("block-selection-mode")
    pos = this.editor.getCursorScreenPosition()
    @blockStart = {row: pos.row, column: pos.column}
    @blockEnd   = {row: pos.row, column: pos.column}

  deactivate: ->
    @isActivated = false
    @editorElement.classList.remove("block-selection-mode")
    @blockStart = null
    @blockEnd   = null
    @editor.clearSelections()
