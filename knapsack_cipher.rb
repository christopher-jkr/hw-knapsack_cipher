require 'prime'
require './modular_arithmetic.rb'

class SuperKnapsack
  attr_accessor :knapsack

  def self.array_sum(arr)
    arr.reduce (:+)
  end

  def initialize(arr)
    arr.each.with_index do |a, i|
      unless i==0
        if (a <= self.class.array_sum(arr[0..i-1])) then
          raise(ArgumentError, "not superincreasing at index #{i}")
        end
      end
      @knapsack = arr
    end
  end

  def primes?(m,n)
    return Prime.prime?(m) && Prime.prime?(n)
  end

  def to_general(m, n)
    argError = "arguments must both be prime" if (!primes?(m,n))
    argError = "#{n} is smaller than superincreasing knapsack" if n <= @knapsack.last
    raise(ArgumentError, argError) unless argError.nil?
    @knapsack.map {|a| (a*m)%n }
  end
end

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
  def self.encrypt(plaintext, generalknap=DEF_GENERAL)
    # TODO: implement this method
    ary_of_binary = plaintext.split('').map { |item| item.ord.to_s(2) }
    ary_of_binary.each do |x|
      while x.length < generalknap.length
        x.insert(0, '0')
      end
    end
    ary_of_binary.map do |x|
      x.split('').map.with_index { |y, idx| y.to_i * generalknap[idx] }.reduce(:+)
    end
  end

  def self.solve_superknap(num, knapsack_rev)
    result = ""
    knapsack_rev.each do |x|
      if num >= x
        num -= x
        result << '1'
      else
        result << '0'
      end
    end
    result.reverse.to_i(2).chr
  end

  # Decrypts encrypted Array
  # Params:
  # - cipherarray: Array of encrypted numbers
  # - superknap: SuperKnapsack object
  # - m: prime number
  # - n: prime number
  # Returns:
  # - String of plain text
  def self.decrypt(cipherarray, superknap=DEF_SUPER, m=M, n=N)
    raise(ArgumentError, "Argument should be a SuperKnapsack object"
      ) unless superknap.is_a? SuperKnapsack
    cipherarray.map! { |x| solve_superknap((x * ModularArithmetic.invert(m, n)) % n, superknap.knapsack.reverse) }.join('')
    # TODO: implement this method
  end
end
