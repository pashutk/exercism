if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("nth_prime.exs", __DIR__)
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule NthPrimeTest do
  use ExUnit.Case

  # @tag :pending
  test "first prime" do
    assert Prime.nth(1) == 2
  end

  test "is 1 prime" do
    assert Prime.prime?(1) == false
  end

  test "is 2 prime" do
    assert Prime.prime?(2)
  end

  test "is prime" do
    assert Prime.prime?(41)
  end

  test "is big prime" do
    assert Prime.prime?(13873)
  end

  test "next prime for 0" do
    assert Prime.next_prime(0) == 2
  end

  test "next prime for 2" do
    assert Prime.next_prime(2) == 3
  end

  test "next prime for 103" do
    assert Prime.next_prime(103) == 107
  end

  test "next prime 2" do
    assert Prime.next_prime(3559) == 3571
  end

  # @tag :pending
  test "second prime" do
    assert Prime.nth(2) == 3
  end

  # @tag :pending
  test "sixth prime" do
    assert Prime.nth(6) == 13
  end

  # @tag :pending
  test "100th prime" do
    assert Prime.nth(100) == 541
  end

  # @tag :pending
  test "weird case" do
    catch_error(Prime.nth(0))
  end
end
