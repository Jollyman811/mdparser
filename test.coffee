
MDParser = require "./lib/index"

parser = new MDParser

extending_md = """

rule :: rule#[dash_rule | star_rule | eq_rule] space* eol+;

eq_rule :: eq_rulesub eq_rulesub eq_rulesub+ ;
eq_rulesub :: space* '=' ;

"""

parser.loadFile "test.md", ->
  # adding '=' rule
  @extendGrammar extending_md

  ret = @parseMarkdown (md, success) ->
    if not success
      throw Error "error parsing markdown"
    console.log JSON.stringify md, null, 2

