module Blue
  class Lexer
    def initialize(input)
      @input = input
      @current_position = 0
      @next_position = 0
      @current_character = 0

      read_character
    end

    def next_token
      skip_whitespaces

      token = Token.new
      case @current_character
      when "("
        token.literal = @current_character
        token.type = Token::LPAREN
      when ")"
        token.literal = @current_character
        token.type = Token::RPAREN
      when "-"
        token.literal = @current_character
        token.type = Token::MINUS
      when "="
        token.literal = @current_character
        token.type = Token::EQUALS
      when "!"
        if next_character == "="
          b = @current_character
          read_character
          token.literal = b + @current_character
          token.type = Token::NOT_EQUALS
        else
          token.literal = @current_character
          token.type = Token::BANG
        end
      when "<"
        token.literal = @current_character
        token.type = Token::LT
      when ">"
        token.literal = @current_character
        token.type = Token::GT
      when "["
        token.literal = @current_character
        token.type = Token::LBRACKET
      when "]"
        token.literal = @current_character
        token.type = Token::RBRACKET
      when ","
        token.literal = @current_character
        token.type = Token::COMMA
      when "\""
        token.literal = read_string
        token.type = Token::STRING
        return token
      when "\0"
        token.literal = "EOF"
        token.type = Token::EOF
        return token
      else
        if digit?(@current_character)
          token.literal = read_number
          token.type = Token::NUMBER
          return token
        elsif letter?(@current_character)
          literal = read_identifier
          token.literal = literal
          token.type = Token.lookup_identifier(literal)
          return token
        else
          token.literal = @current_character
          token.type = Token::ILLEGAL
        end
      end

      read_character

      token
    end

    def read_character
      if @next_position >= @input.size
        @current_character = "\0"
      else
        @current_character = @input[@next_position]
      end

      @current_position = @next_position
      @next_position += 1
    end

    def next_character
      if @next_position >= @input.size
        "\0"
      else
        @input[@next_position]
      end
    end

    def read_number
      start_pos = @current_position
      while(digit?(@current_character))
        read_character
      end
      @input[start_pos...@current_position]
    end

    def read_identifier
      start_pos = @current_position
      while(letter?(@current_character))
        read_character
      end
      @input[start_pos...@current_position]
    end

    def read_string
      read_character
      start_pos = @current_position
      while(@current_character != "\"" && @current_character != "\0")
        read_character
      end
      str = @input[start_pos...@current_position]
      read_character
      str
    end

    def skip_whitespaces
      while(whitespace?(@current_character))
        read_character
      end
    end

    def whitespace?(character)
      character == " " || character == "\t" || character == "\n" || character == "\r"
    end

    def letter?(character)
      character == "_" || (character >= "a" && character <= "z") || (character >= "A" && character <= "Z")
    end

    def digit?(character)
      character >= "0" && character <= "9"
    end
  end
end
