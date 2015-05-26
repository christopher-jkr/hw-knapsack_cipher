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
    fail(ArgumentError, arg_error) unless arg_error.nil?
    @knapsack.map { |a| (a * m) % n }
  end
end

# Knapsack Cipher class
class KnapsackCipher
  extend ModularArithmetic
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
    bin_ary = split_text(plaintext, generalknap.length)
    bin_ary = bin_ary.map { |e| e.split('').map(&:to_i) }
    bin_ary.map { |ary| ary.zip(generalknap).map { |x, y| x * y }.inject(:+) }
  end

  def self.split_text(plaintext, b = gen_length)
    plaintext.chars.map do |c|
      a = c.ord.to_s(2)
      a.length < b ? '0' * (b - a.length) << a : a
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
  def self.decrypt(cipherarray, superknap = DEF_SUPER, m = M, n = N)
    fail(ArgumentError, 'Argument should be a SuperKnapsack object'
      ) unless superknap.is_a? SuperKnapsack

    # TODO: implement this method
    mod_i = invert(m, n)
    superknap = superknap.knapsack.reverse
    cipherarray = cipherarray.map { |e| e * mod_i % n }
    plain_bin_ary = cipherarray.map { |e| div_by_super(e, superknap) }
    convert_join(plain_bin_ary)
  end

  def self.div_by_super(v, ary, res = [])
    ary.each do |e|
      res.unshift(v / e)
      v %= e
    end
    res
  end

  def self.convert_join(plain_bin)
    plain_bin.map { |e| e.join.to_i(2).chr }.join
  end
end
