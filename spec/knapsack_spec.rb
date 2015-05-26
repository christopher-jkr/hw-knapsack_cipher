require 'minitest/autorun'
require_relative '../knapsack_cipher'

describe 'Check if knapsack cipher works' do
  it 'should create a general knapsack from a superknapsack' do
    sup_ks = SuperKnapsack.new([2, 3, 7, 14, 30, 57, 120, 251])
    gen_a = sup_ks.to_general(41, 491)
    gen_a.length.must_be :==, sup_ks.knapsack.length
  end

  it 'should encrypt a string to an array' do
    plaintext = "Hello World!"
    sup_ks = SuperKnapsack.new([2, 3, 7, 14, 30, 57, 120, 251])
    gen_a = sup_ks.to_general(41, 491)
    array_enc = KnapsackCipher.encrypt(plaintext, gen_a)
    array_enc.length.must_be :==, plaintext.length
  end

  it 'should be able to decrypt what it encrypted with default values' do
    plaintext = "Hello World!"
    sup_ks = SuperKnapsack.new([2, 3, 7, 14, 30, 57, 120, 251])
    gen_a = sup_ks.to_general(41, 491)
    array_enc = KnapsackCipher.encrypt(plaintext, gen_a)
    text = KnapsackCipher.decrypt(array_enc)
    text.must_be :==, plaintext
  end

  it 'should be able to decrypt what it encrypted with specified values' do
    plaintext = "Hello World!"
    sup_ks = SuperKnapsack.new([2, 3, 7, 14, 30, 57, 120, 251])
    gen_a = sup_ks.to_general(53, 503)
    array_enc = KnapsackCipher.encrypt(plaintext, gen_a)
    text = KnapsackCipher.decrypt(array_enc, sup_ks, 53, 503)
    text.must_be :==, plaintext
  end
end
