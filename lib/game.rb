module Codebreaker
  class Game
    ATTEMPTS_NUMBER = 7
    HINTS_NUMBER = 1

    attr_reader :attempts, :hints

    def initialize
      @secret_code = generate_secret_code
      @attempts =  ATTEMPTS_NUMBER
      @hints = HINTS_NUMBER
    end

    def check_guess(guess)
      return "You don't have any attempts" unless any_attempts?
      @attempts -= 1
      return '++++' if guess == @secret_code

      mark(@secret_code.chars, guess.chars)
    end

    def hint
      return "You don't have any hints" if @hints == 0
      @hints -= 1
      @secret_code[rand(4)]
    end

    def any_attempts?
      @attempts != 0
    end

    def to_h
      {
        :secret_code => @secret_code,
        :attempts_used => ATTEMPTS_NUMBER - @attempts,
        :hints_used => HINTS_NUMBER - @hints,
        :attempts_number => ATTEMPTS_NUMBER,
        :hints_number => HINTS_NUMBER
      }
    end

    def to_s
      "Secret code: #{@secret_code}, " +
      "attempts left: #{@attempts}, hints left: #{@hints}"
    end

    private

    def generate_secret_code
      Array.new(4).map { rand(1..6) }.join
    end

    def mark(code, guess)
      answer = ''

      guess.each_with_index do |number, index|
        next unless code[index] == number
        answer << '+'
        code[index], guess[index] = nil
      end

      [code,guess].each(&:compact!)

      guess.each do |number|
        next unless code.include?(number)
        answer << '-'
        code[code.find_index(number)] = nil
      end
      
      answer
    end
  end
end