module Blue
  class Token
    LPAREN = "("
    RPAREN = ")"
    LBRACKET = "["
    RBRACKET = "]"
    COMMA = ","
    AND = "AND"
    OR = "OR"
    EQUALS = "="
    NOT_EQUALS = "!="
    MINUS = "-"
    LT = "<"
    GT = ">"
    BANG = "!"
    IDENTIFIER = "IDENTIFIER"
    NUMBER = "NUMBER"
    STRING = "STRING"
    ARRAY = "ARRAY"
    EOF     = "EOF"
    ILLEGAL = "ILLEGAL"

    KEYWORDS = {
      "AND" => AND,
      "and" => AND,
      "OR" => OR,
      "or" => OR
    }

    attr_accessor :literal, :type

    def self.lookup_identifier(identifier)
      KEYWORDS.fetch(identifier, IDENTIFIER)
    end
  end
end
