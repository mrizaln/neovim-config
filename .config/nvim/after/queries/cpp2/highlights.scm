; based on treesitter by tsoj: https://github.com/tsoj/tree-sitter-cpp2
; commit                     : 51af102d553e84d79c7efe3c9935b9502e65f8be

[
  ; unary
  "-" "!" "~" "++" "--" "*" "&"
  ; binary
  "+" "-" "*" "/" "%" "&&" "||" "^" "==" "!=" "<=" ">=" "<" ">" "<<" ">>" "<=>"
  ; assignment
  "=" "+=" "-=" "*=" "/=" "%="">>=" "<<=" "&=" "|=" "^="
  ; range
  "..<" "..="
] @operator

[ "template <" "> template" "(" ")" "[" "]" "{" "}" ]
@punctuation.bracket

[ "." ";" ":" "::" "->" "..." ]
@punctuation.delimiter

[ "@" "$" ]
@punctuation.special

[ "is" "as" ]
@keyword.operator

[ "if" "else" ]
@keyword.conditional

[ "while" "for" "do" (cpp2_next) ]
@keyword.repeat

[ "public" "private" "virtual" "override" "final" "implicit" (cpp2_passing_style) ]
@keyword.modifier

"return" @keyword.return

(comment) @comment

(true) @boolean
(false) @boolean

(string_literal) @string
(cpp2_number_literal) @number

((this) @variable.builtin (#set! "priority" 110)) 

(cpp2_primitive_type) @type.builtin

(cpp2_namespace_type) @keyword.type
(cpp2_type_type) @keyword.type

(cpp2_throws) @keyword.exception

(macro_comment) @keyword.directive
(preproc_include) @keyword.directive

(cpp2_inspect) @keyword

((cpp2_operator_keyword) @keyword.operator (#set! "priority" 110))

; namespace specifier
namespaces: (cpp2_non_template_identifier) @module

; function return type
return: (cpp2_expression
  (cpp2_any_identifier
    last: (cpp2_non_template_identifier) @type))


; include preprocessor
(preproc_include
  path: (system_lib_string) @string)

; function parameter
; --------------------
(cpp2_function_declaration_argument
  (cpp2_any_identifier
  last: (cpp2_non_template_identifier) @variable.parameter))

(cpp2_function_declaration_argument
  (_ name: (cpp2_non_template_identifier) @variable.parameter))
; --------------------

; expression type
(_ type: (cpp2_expression
  (cpp2_any_identifier
    last: (cpp2_non_template_identifier) @type)))

; function call
(cpp2_function_call
  function: (cpp2_expression
    (cpp2_any_identifier
      last: (cpp2_non_template_identifier) @function.call)))

; member access
(cpp2_dot_access
  field: (cpp2_any_identifier
    last: (cpp2_non_template_identifier) @property))

; member variable declaration
(cpp2_block_definition
  (cpp2_left_side_of_definition
    type: (cpp2_type_type))
      (cpp2_block
        (cpp2_statement
          (_ name: (cpp2_non_template_identifier) @variable.member))))

; namespace declaration
(cpp2_block_declaration
  name: (cpp2_non_template_identifier) @module
  (cpp2_block_definition
    (cpp2_left_side_of_definition
      type: (cpp2_namespace_type))))

; type declaration
(cpp2_block_declaration
  name: (cpp2_non_template_identifier) @type.definition
  (cpp2_block_definition
    (cpp2_left_side_of_definition
      type: (cpp2_type_type))))

; function declaration
; --------------------
(cpp2_block_declaration
  name: (cpp2_non_template_identifier) @function
  (cpp2_block_definition
    (cpp2_left_side_of_definition
      type: (cpp2_expression))))

(cpp2_expression_declaration
  name: (cpp2_non_template_identifier) @function
  (cpp2_expression_definition
    (cpp2_left_side_of_definition
      type: (cpp2_expression
        (cpp2_type
          (cpp2_function_type))))))
; --------------------

; type metafunction
(cpp2_metafunction_arguments
  (cpp2_any_identifier
    last: (cpp2_non_template_identifier)) @function.macro)

; template parameter
; ------------------
(cpp2_template_declaration_arguments
  (cpp2_comma_seperated_declarations
    (cpp2_function_declaration_argument
      (cpp2_any_identifier
        last: (cpp2_non_template_identifier) @type))))

; - type parameter
(cpp2_template_declaration_arguments
  (cpp2_comma_seperated_declarations
    (cpp2_function_declaration_argument
      (cpp2_no_definition_declaration
        name: (cpp2_non_template_identifier) @type
        type: (cpp2_type_type)))))

; - non-type parameter
(cpp2_template_declaration_arguments
  (cpp2_comma_seperated_declarations
    (cpp2_function_declaration_argument
      (cpp2_no_definition_declaration
        name: (cpp2_non_template_identifier) @constant
        type: (cpp2_expression)))))
; ------------------

; template argument
; -----------------
(cpp2_template_call_arguments
  (cpp2_comma_expressions
    (cpp2_expression
      (cpp2_any_identifier
        last: (cpp2_non_template_identifier) @type))))
; -----------------

; (cpp2_block_declaration
;   name: (cpp2_non_template_identifier) @emphasis.strong)

; (cpp2_expression_declaration
;   name: (cpp2_non_template_identifier) @emphasis.strong)

; (cpp2_no_definition_declaration
;   name: (cpp2_non_template_identifier)  @emphasis.strong)

; (cpp2_function_declaration_argument
;   (cpp2_any_identifier
;   last: (cpp2_non_template_identifier) @emphasis))

; (cpp2_function_declaration_argument
;   (cpp2_expression_declaration
;     name: (cpp2_non_template_identifier) @emphasis))

; (cpp2_function_declaration_argument
;   (cpp2_block_declaration
;     name: (cpp2_non_template_identifier) @emphasis))

; (cpp2_function_declaration_argument
;   (cpp2_no_definition_declaration
;     name: (cpp2_non_template_identifier) @emphasis))
