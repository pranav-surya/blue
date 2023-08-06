module Blue
  class Parser
    LOWEST = 1
    OR = 2
    AND = 3
    EQUALS = 4
    LESSGREATER = 5
    SUM = 6
    PRODUCT = 7
    PREFIX = 8

    PRECEDENCE_TABLE = {
      Token::EQUALS => EQUALS,
      Token::NOT_EQUALS => EQUALS,
      Token::LT => LESSGREATER,
      Token::GT => LESSGREATER,
      Token::AND => AND,
      Token::OR => OR
    }

    attr_accessor :current_token, :next_token, :lexer, :errors

    def initialize(lexer)
      @lexer = lexer
      @current_token = lexer.next_token
      @next_token = lexer.next_token
      @errors = []

      @prefix_parse_methods = {
        Token::IDENTIFIER => :parse_identifier,
        Token::NUMBER => :parse_number,
        Token::STRING => :parser_string,
        Token::LPAREN => :parse_grouped_expression,
        Token::LBRACKET => :parse_array,
        Token::MINUS => :parse_prefix_expression
      }

      @infix_parse_methods = {
        Token::AND => :parse_infix_expression,
        Token::OR => :parse_infix_expression,
        Token::EQUALS => :parse_infix_expression,
        Token::NOT_EQUALS => :parse_infix_expression,
        Token::LT => :parse_infix_expression,
        Token::GT => :parse_infix_expression
      }
    end

    def parse
      q = AST::Query.new
      q.expression = parse_expression(LOWEST)

      q
    end

    def parse_expression(precedence)
      prefix_parse_function = @prefix_parse_methods[@current_token.type]
      if prefix_parse_function.nil?
        @errors.push("no prefix parse function for #{@current_token.literal}")
        return
      end
      left_expression = send(prefix_parse_function)
      while(@next_token.type != Token::EOF && precedence < next_precedence)
        infix_parse_function = @infix_parse_methods[@next_token.type]
        if infix_parse_function.nil?
          return left_expression
        end
        next_token
        left_expression = send(infix_parse_function, left_expression)
      end
      left_expression
    end

    def next_token
      @current_token = @next_token
      @next_token = @lexer.next_token
    end

    def next_precedence
      PRECEDENCE_TABLE.fetch(@next_token.type, LOWEST)
    end

    def current_precedence
      PRECEDENCE_TABLE.fetch(@current_token.type, LOWEST)
    end

    def parse_identifier
      i = AST::Identifier.new
      i.token = @current_token
      i.value = @current_token.literal

      i
    end

    def parse_number
      i = AST::Number.new
      i.token = @current_token
      i.value = @current_token.literal.to_i

      i
    end

    def parser_string
      i = AST::Number.new
      i.token = @current_token
      i.value = @current_token.literal

      i
    end

    def parse_grouped_expression
      next_token
      expression = parse_expression(LOWEST)
      if @next_token.type == Token::RPAREN
        next_token
      else
        @errors.push("unexpected `#{@next_token.literal}`")
        return
      end
      expression
    end

    def parse_array
      array = AST::Array.new
      array.token = Token::ARRAY
      array.expressions = []

      if @next_token.type == Token::RBRACKET
        next_token
        return array
      end

      next_token
      array.expressions.push(parse_expression(LOWEST))

      while(@next_token.type == Token::COMMA)
        next_token
        next_token
        array.expressions.push(parse_expression(LOWEST))
      end

      if @next_token.type != Token::RBRACKET
        @errors.push("unexpected `#{@next_token.literal}`")
        return
      end

      next_token
      array
    end

    def parse_prefix_expression
      pe = AST::PrefixExpression.new
      pe.token = @current_token
      pe.operator = @current_token.literal

      next_token
      pe.right_expression = parse_expression(PREFIX)

      pe
    end

    def parse_infix_expression(left_expression)
      ie = AST::InfixExpression.new
      ie.token = @current_token
      ie.left_expression = left_expression
      ie.operator = @current_token.literal

      precedence = current_precedence
      next_token
      ie.right_expression = parse_expression(precedence)

      ie
    end
  end
end
