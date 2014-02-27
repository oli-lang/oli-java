grammar Oli;

// *******	
// 	PARSER
// *******

// Statements - Blocks

statement
  : mainStatement
  ;

 mainStatement
  : COMMENT
  | blockStatement
  ;

blockStatement
	: Identifier ASSIGN blockElementStatement END
	;

blockElementStatement
	: (statement ElementSeparator statement)*
	;

// Expressions

literal
	: BooleanLiteral
	| IntegerLiteral
	| FloatingPointLiteral
	| StringLiteral
	| NilLiteral
	;


// *******	
// 	LEXER
// *******

// Keywords

END
	: 'end'
	;	
						
NIL
	: 'nil'
	;

// Integer literals
	
IntegerLiteral
	: DecimalIntegerLiteral
	| HexIntegerLiteral
	| SignedInteger
	;

fragment
DecimalIntegerLiteral
    : DecimalNumeral
    ;	
    
fragment
HexIntegerLiteral
    : HexNumeral
    ;
    
fragment
DecimalNumeral
    : '0'
    | NonZeroDigit Digits?
    ;

fragment
Digits
    : Digit+
    ;

fragment
Digit
    : '0'
    | NonZeroDigit
    ;

fragment
NonZeroDigit
    : [1-9]
    ;
    
fragment
HexNumeral
    : '0' [xX] HexDigits
    ;
    
fragment
HexDigits
    : HexDigit+
    ;
    
fragment
HexDigit
    : [0-9a-fA-F]
    ;
    
// Floating point literals

FloatingPointLiteral
	: DecimalFloatingPointLiteral
	;

fragment	
DecimalFloatingPointLiteral
    : Digits '.' Digits? ExponentPart?
    | '.' Digits ExponentPart?
    | Digits ExponentPart
    ;
	
fragment
ExponentPart
    : ExponentIndicator SignedInteger
    ;
    
fragment
ExponentIndicator
    : [eE]
    ;

fragment
SignedInteger
    : Sign? Digits
    ;

fragment
Sign
    : [+-]
    ;

// Boolean literals

BooleanLiteral
	: TRUE
	| FALSE
	;

TRUE
	: 'true'
	| 'yes'
	;
						
FALSE
	: 'false'
	| 'no'
	;  
	
// String literals

fragment
StringCharacter
    : ~[\'"\\]
    | EscapeSequence
    ;
    
fragment
StringCharacters
    : StringCharacter+
    ;

StringLiteral
    : '"' StringCharacters? '"'
    | '\'' StringCharacters? '\''
    ;

// Escape sequences for string literals

fragment
EscapeSequence
    : SingleCharacterEscape
    | UnicodeEscape
    | HexEscape
    ;
    
fragment
SingleCharacterEscape
	: '\\' ['"\\bfnrtv]
	;

fragment
UnicodeEscape
    : '\\' 'u' HexDigit HexDigit HexDigit HexDigit
    ;
    
fragment
HexEscape
	: '\\' HexNumeral
	;
	
LineContinuation
	: '\\' LineTerminatorSequence
	;

// Nil literal

NilLiteral
    :   NIL
    ;


// Separators

COMMA				: ',' ;

// Operators

ASSIGN				  : ':' ;
VAR_ASSIGN			: '=' ;
ASSIGN_RAW			: ':>' ;
ASSIGN_NOT			: ':!' ;
ASSIGN_UNFOLD		: ':=' ;
ASSIGN_FOLD			: ':-' ;
PIPE				    : '|' ;
PIPE_NOT			  : '|!' ;
DASH				    : '-' ;
DOUBLE_DASH			: '--' ;
RELATIONAL			: '>' ;
RELATIONAL_NOT	: '!>' ;
REFERENCE			  : '*' ;
ANCHOR				  : '&' ;
LOGICAL_NOT			: '!' ;
EXTEND				  : '>>' ;
MERGE 				  : '>>>' ;

// Identifiers

Identifier
	: Letter+
	;

fragment    
Letter					
	: [a-zA-Z0-9]
	| [\\\"\.\$\@\?\%\+\;]
	| [-/_^ºç¡¿€]
	;

// Line terminator

LineTerminator
	: [\n\r\u2028\u2029]
	;
				
LineTerminatorSequence
	: '\n'
	| '\r'
	| '\u2028' // line separator
	| '\u2029' // paragraph separator  						
  ;  						

EOSNoLineTerminator
	: ~[\n\r\u2028\u2029]
	;

ElementSeparator
	: EOSNoLineTerminator
 	| COMMA 
 	;

// Whitespace and comments

WS
	:  [\t\v\f\u00A0\uFEFF]+ -> skip
  ;

COMMENT
	: ('#' ~[\r\n]*) -> channel(HIDDEN)
	;
	
LINE_COMMENT
	: ('##' .*? '##') -> channel(HIDDEN)
	;