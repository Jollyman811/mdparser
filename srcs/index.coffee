
YParser = require "yparser"
bnf = require './bnf'
grammar = require './grammar'

class MarkdownParser extends YParser.AstParser
  constructor: ->
    super()
    @grammars = grammar

  generateGrammar: ->
    gram = new YParser.GrammarParser
    gram.loadString bnf
    parser = gram.loadGrammar()
    @grammars = parser.grammars

  printGrammar: ->
    console.log "module.exports = #{JSON.stringify @grammars}"

  extendGrammar: (bnf) ->
    gram = new YParser.GrammarParser
    gram.loadString bnf
    grams = gram.loadGrammar().grammars
    for id, gram of grams
      @grammars[id] = gram

  parseMarkdown: (cb) ->
    if (@execGrammar "main") is false
      return cb.call this, @ast, false
    @processLists()
    return cb.call this, @ast, true

  processLists: ->
    for node, id in @ast.nodes
      if node.type isnt 'list'
        continue
      @ast.nodes[id] = (@processList node)[0]

  processList: (list, id = 0) ->
    newList = @createList()
    lastLevel = list.nodes[id].level
    while list.nodes[id]?
      node = list.nodes[id]
      if node.level.length < lastLevel.length
        return [newList, id]
      if node.level.length > lastLevel.length
        ret = @processList list, id
        newList.nodes[-1..][0].nodes.push ret[0]
        id = ret[1]
        continue
      newList.nodes.push node
      id++
    return [newList, id]

  createList: ->
    return {
      type: "list"
      nodes: new Array
    }

  createListItem: (nodes) ->
    return {
      type: "item"
      nodes: nodes
    }

MarkdownParser.YParser = YParser
module.exports = MarkdownParser

