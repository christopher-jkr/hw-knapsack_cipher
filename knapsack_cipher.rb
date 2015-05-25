require 'prime'
require './modular_arithmetic.rb'

# Knapsack Class
class SuperKnapsack
  attr_accessor :knapsack

  def self.array_sum(arr)
    arr.reduce(:+)
  end

  def initialize(arr)
    arr.each.with_index do |a, i|
      unless i == 0
        if (a <= self.class.array_sum(arr[0..i - 1]))
          fail(ArgumentError, "not superincreasing at index #{i}")
        end
      end
      @knapsack = arr
    end
  end

  def primes?(m, n)
    Prime.prime?(m) && Prime.prime?(n)
  end

  def to_general(m, n)
    arg_error = 'arguments must both be prime' unless primes?(m, n)
    if n <= @knapsack.last
      arg_error = "#{n} is smaller than superincreasing knapsack"
    end
    fail(ArgumentError, argError) unless arg_error.nil?
    @knapsack.map { |a| (a * m) % n }
  end
end

# Knapsack Cipher class
class KnapsackCipher
  # Default values of knapsacks, primes
  M = 41
  N = 491
  DEF_SUPER = SuperKnapsack.new([2, 3, 7, 14, 30, 57, 120, 251])
  DEF_GENERAL = DEF_SUPER.to_general(M, N)

  # Encrypts plaintext
  # Params:
  # - plaintext: String object to be encrypted
  # - generalknap: Array object containing general knapsack numbers
  # Returns:
  # - Array of encrypted numbers
  def self.encrypt(plaintext, generalknap = DEF_GENERAL)
    # TODO: implement this method
    # TODO: Make arguments required!
    bin_ary = split_text(plaintext)
    bin_ary = bin_ary.map { |e| e.split('').map(&:to_i) }
    zip_map(bin_ary, generalknap)
  end

  def self.split_text(plaintext)
    plaintext.chars.map do |c|
      a = c.ord.to_s(2)
      '0' * (8 - a.length) << a if a.length < 8
    end
  end

  def self.zip_map(ary, gen)
    ary.map do |e|
      e.zip(gen).map { |x, y| x * y }.inject(:+)
    end
  end

  # Decrypts encrypted Array
  # Params:
  # - cipherarray: Array of encrypted numbers
  # - superknap: SuperKnapsack object
  # - m: prime number
  # - n: prime number
  # Returns:
  # - String of plain text
  def self.decrypt(_cipherarray, superknap = DEF_SUPER, _m = M, _n = N)
    fail(ArgumentError, 'Argument should be a SuperKnapsack object'
      ) unless superknap.is_a? SuperKnapsack

    # TODO: implement this method
    # TODO: Make arguments required!
  end
end
