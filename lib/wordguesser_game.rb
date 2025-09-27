class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError unless not letter.nil? and letter.match?(/[A-Za-z]/)

    letter = letter.downcase

    if self.guesses.include?(letter) || self.wrong_guesses.include?(letter)
      return false
    end

    if self.word.include?(letter)
      self.guesses += letter
    else
      self.wrong_guesses += letter
    end
  end

  def word_with_guesses
    self.word.chars.map do |char|
      if self.guesses.include?(char)
        char
      else
        "-"
      end
    end.join
  end

  def check_win_or_lose
    state = :win

    self.word.each_char do |char|
      if not self.guesses.include?(char)
        state = :play
      end
    end
    
    if self.wrong_guesses.length >= 7
      state = :lose
    end

    state
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
