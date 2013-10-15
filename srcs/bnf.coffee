
module.exports = '''

main :: eol* [line_entities | eol]+ eof ;

extra_entity :: false ;
extra_formated :: false ;

line_entities ::  title | rule | section | list | code | quote
                | linkref | paragraph | extra_entity ;

title ::  title:raw eol
          '='+ eol+;

rule :: rule#[dash_rule | star_rule] space* eol+;
dash_rule :: dash_rulesub dash_rulesub dash_rulesub+ ;
dash_rulesub :: space* '-' ;
star_rule :: star_rulesub star_rulesub star_rulesub+ ;
star_rulesub :: space* '*' ;

section :: section#_section eol+;
_section :: .level:section_hash space+ formated ;
section_hash :: '######' | '#####' | '####' | '###' | '##' | '#' ;

list :: list#list_lines eol+ ;
list_lines :: [item#list_line]+ ;
list_line :: list_start [[formated ^ list_start] eol]+ ;
list_start :: .level:[space*] list_bullet space+ ;
list_bullet :: '-' | '*' | '+' | ordered ;
ordered :: .ordered:int '.' ;

code :: code#code_lines eol* ;
code_lines :: [code_line eol]+ ;
code_line :: space space space space line:raw ;

quote :: '>' space* quote#quote_lines eol+ ;
quote_lines :: [formated eol]+ ;

linkref :: link_ref#_linkref ;
_linkref :: '['
              .name:[ any ^ ']' ^ eol ]+
            ']' ':' space
            .url:raw eol* ;

paragraph :: paragraph#_paragraph ;
_paragraph :: [formated eol]+ eol ;

raw :: [any ^ eol]+ ;

formated :: [   raw:formated_raw
              | escaped
              | bold_and_underlined#bold_and_underlined
              | bold#bold
              | underlined#underlined
              | inline_code
              | link#full_link
              | link#address_link
              | link#link_from_ref
              | image#image
              | extra_formated
              | format_error:error_prone_chars ]+;

formated_raw :: [   any ^ '*' ^ '_' ^ '[' ^ '`'
                  ^ '(' ^ '!' ^ ' * ' ^ ' _ ' ^ ' ` ' ^ ' ( ' ^ ' [ '
                  ^ line_break ^ eol]+ ;

nostar_raw :: [ any ^ '*' ^ eol ]+ ;
nodash_raw :: [ any ^ '_' ^ eol ]+ ;

escaped ::  [' '? escaped:'*' ' ']
          | [' '? escaped:'_' ' ']
          | [' '? escaped:'[' ' ']
          | [' '? escaped:'(' ' ']
          | [' '? escaped:'`' ' ']
          | [' '? escaped:'!' ' ']
          | ['  ' escaped:eol] ;

bold_and_underlined :: bold_and_underlined_star | bold_and_underlined_dash ; 
bold_and_underlined_star :: '***' raw:nostar_raw '***' ;
bold_and_underlined_dash :: '___' raw:nodash_raw '___' ;

bold :: bold_star | bold_dash ; 
bold_star :: '**' raw:nostar_raw '**' ;
bold_dash :: '__' raw:nodash_raw '__' ;

underlined :: underlined_star | underlined_dash ; 
underlined_star :: '*' raw:nostar_raw '*' ;
underlined_dash :: '_' raw:nodash_raw '_' ;

line_break :: space space eol ;

inline_code :: '`' inline_code:inline_code_raw '`' ;
inline_code_raw :: [any ^ '`' ^ eol]+ ;

full_link :: '['
                .name:[ any ^ ']' ^ eol ]+
              ']'
              '('
                .url:[ any ^ ')' ^ eol ]+
              ')' ;

address_link :: '('
                  .url:[ any ^ ')' ^ eol ]+
                ')' ;

link_from_ref ::  '['
                    .name:[ any ^ ']' ^ eol ]+
                  ']'
                  '['
                    .ref:[ any ^ ']' ^ eol ]+
                  ']' ;

image :: '!' [full_link | address_link | link_from_ref];

error_prone_chars :: '*' | '_' | '[' | '`' | '(' | '!' ;

'''

