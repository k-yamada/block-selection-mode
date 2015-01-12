{Workspace} = require 'atom'

BlockSelectionMode = require '../lib/block-selection-mode'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "BlockSelectionMode", ->
  [editor, editorElement, workspaceElement, activationPromise] = []

  beforeEach ->
    atom.workspace = new Workspace
    activationPromise = atom.packages.activatePackage('block-selection-mode')
    workspaceElement = atom.views.getView(atom.workspace)

    # This is an activation event, triggering it will cause the package to be
    # activated.
    atom.commands.dispatch workspaceElement, 'block-selection-mode:toggle'

    waitsForPromise ->
      atom.workspace.open()

    waitsForPromise ->
      atom.packages.activatePackage('block-selection-mode')
      #atom.commands.dispatch workspaceElement, 'block-selection-mode:toggle'
      #activationPromise

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)

  #describe ".activate", ->
  #  it "adds the block-selection-mode class to the editor", ->
  #    atom.commands.dispatch workspaceElement, 'block-selection-mode:toggle'
  #    expect(editorElement.classList.contains('block-selection-mode')).toBe(true)

  describe ".deactivate", ->
    it "removes the block-selection-mode class from the editor", ->
      atom.packages.deactivatePackage('block-selection-mode')
      expect(editorElement.classList.contains('block-selection-mode')).toBe(false)
