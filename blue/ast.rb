module Blue
  module AST
    class Identifier
      attr_accessor :token, :value
    end

    class Number
      attr_accessor :token, :value
    end

    class String
      attr_accessor :token, :value
    end

    class Array
      attr_accessor :token, :expressions
    end

    class PrefixExpression
      attr_accessor :token, :operator, :right_expression
    end

    class InfixExpression
      attr_accessor :token, :left_expression, :operator, :right_expression
    end

    class Query
      attr_accessor :token, :expression
    end
  end
end
