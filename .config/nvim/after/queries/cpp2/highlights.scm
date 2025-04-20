[
  "-"
  "+"
  "!"
  "++"
  "--"
  "*"
  "&"
  "&&"
  "~"
  "$"
  "..."
  "*"
  "/"
  "%"
  "+"
  "-"
  "<<"
  ">>"
  "<=>"
  "<"
  ">"
  "<="
  ">="
  "=="
  "!="
  "&"
  "^"
  "|"
  "&&"
  "||"

; range operator
  "..<"
  "..="

; assignment operator
  "="
  "*="
  "/="
  "%="
  "+="
  "-="
  ">>="
  "<<="
  "&="
  "^="
  "|="

  "::"
  "->"
] @operator

[
  "<"
  ">"
  "("
  ")"
  "["
  "]"
  "{"
  "}"

  "template <"                      ; what is this?
  "> template"                      ; what is this?
] @punctuation.bracket

[
  "."
  ";"
  ":"
] @punctuation.delimiter

"@" @punctuation.special

"is" @keyword.operator
"as" @keyword.operator

"if" @keyword.conditional
"else" @keyword.conditional

"while" @keyword.repeat
"for" @keyword.repeat
"do" @keyword.repeat

[
"public"
"private"
"virtual"
"override"
"final"
"implicit"
] @keyword.modifier

"return" @keyword.return

(comment) @comment

(true) @boolean
(false) @boolean

(string_literal) @string
(cpp2_number_literal) @number

(this) @variable.builtin

(cpp2_primitive_type) @type.builtin
(macro_comment) @property

(cpp2_next) @keyword.repeat

(cpp2_namespace_type) @keyword.type
(cpp2_type_type) @keyword.type

(cpp2_passing_style) @keyword.modifier

(cpp2_throws) @keyword.exception
(cpp2_inspect) @keyword

(preproc_include) @keyword.directive
(cpp2_operator_keyword) @constructor

(preproc_include
  path: (system_lib_string) @string)

(cpp2_any_identifier
  namespaces: (cpp2_non_template_identifier) @module)

(cpp2_block_declaration
  name: (cpp2_non_template_identifier) @emphasis.strong )

(cpp2_expression_declaration
  name: (cpp2_non_template_identifier) @emphasis.strong )

(cpp2_no_definition_declaration
  name: (cpp2_non_template_identifier)  @emphasis.strong)

(cpp2_function_declaration_argument
  (cpp2_any_identifier
  last: (cpp2_non_template_identifier) @emphasis))

(cpp2_function_declaration_argument
  (cpp2_expression_declaration
    name: (cpp2_non_template_identifier) @emphasis))

(cpp2_function_declaration_argument
  (cpp2_block_declaration
    name: (cpp2_non_template_identifier) @emphasis))

(cpp2_function_declaration_argument
  (cpp2_no_definition_declaration
    name: (cpp2_non_template_identifier) @emphasis))

(cpp2_no_definition_declaration
  type: (cpp2_expression
    (cpp2_any_identifier
      last: (cpp2_non_template_identifier) @type)))

(cpp2_left_side_of_definition
  type: (cpp2_expression
    (cpp2_any_identifier
      last: (cpp2_non_template_identifier) @type)))

(cpp2_function_type
  return: (cpp2_expression
    (cpp2_any_identifier
      last: (cpp2_non_template_identifier) @type)))

(cpp2_function_call
  function: (cpp2_expression
    (cpp2_any_identifier
      last: (cpp2_non_template_identifier) @function)))

(cpp2_dot_access
  field: (cpp2_any_identifier
    last: (cpp2_non_template_identifier) @property))

(cpp2_block_declaration
  name: (cpp2_non_template_identifier
    (cpp2_ordinary_identifier) @module)
  (cpp2_block_definition
    (cpp2_left_side_of_definition
      type: (cpp2_namespace_type))))

(cpp2_block_declaration
  name: (cpp2_non_template_identifier
    (cpp2_ordinary_identifier) @type.definition)
  (cpp2_block_definition
    (cpp2_left_side_of_definition
      type: (cpp2_type_type))))

(cpp2_block_declaration
  name: (cpp2_non_template_identifier
    (cpp2_ordinary_identifier) @function)
  (cpp2_block_definition
    (cpp2_left_side_of_definition
      type: (cpp2_expression))))

(cpp2_metafunction_arguments
  (cpp2_any_identifier
    last: (cpp2_non_template_identifier)) @function.macro)

(cpp2_template_declaration_arguments
  (cpp2_comma_seperated_declarations
    (cpp2_function_declaration_argument
      (cpp2_any_identifier
        last: (cpp2_non_template_identifier) @type))))

(cpp2_template_call_arguments
  (cpp2_comma_expressions
    (cpp2_expression
      (cpp2_any_identifier
        last: (cpp2_non_template_identifier
          (cpp2_ordinary_identifier
            (identifier) @type))))))
