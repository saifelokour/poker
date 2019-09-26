defmodule PokerTest do
  use ExUnit.Case
  doctest Poker

  test "hands must have 5 cards" do
    assert Poker.play(black: "2H 3D 5S 9C", white: "2C 3H 4S 8C") == "invalid hand(s)"
    assert Poker.play(black: "2H 3D 5S 9C", white: "2C 3H 4S 8C AH") == "invalid hand(s)"
    assert Poker.play(black: "2H 3D 5S 9C KH QH", white: "2C 3H 4S 8C AH") == "invalid hand(s)"
    assert Poker.play(black: "2H 3D 5S 9C KH QH", white: "2C 3H 4S 8C AH 4C") == "invalid hand(s)"
  end

  test "hands must have valid cards" do
    # invalid value
    assert Poker.play(black: "2H 3D 5S 9C XH", white: "2C 3H 4S 8C AH") == "invalid hand(s)"
    # invalid suite
    assert Poker.play(black: "2H 3D 5S 9C KX", white: "2C 3H 4S 8C AH") == "invalid hand(s)"
  end

  test "hands must Tie" do
    # High card Tie
    assert Poker.play(black: "3H 4D 6S 9C AH", white: "3C 4H 6H 9S AD") == "Tie"
    # Pair Tie
    assert Poker.play(black: "3H 4D 6S AC AH", white: "3C 4H 6C AS AD") == "Tie"
    # Two Pair Tie
    assert Poker.play(black: "3H 4D 6C AS AD", white: "3C 4H 6S AC AH") == "Tie"
    # Straight Tie
    assert Poker.play(black: "3H 4D 5S 6C 7H", white: "3C 4H 6S 5C 7D") == "Tie"
    # Flush Tie
    assert Poker.play(black: "3H 4H 6H 8H AH", white: "3C 4C 6C 8C AC") == "Tie"
    # Straight Flush Tie
    assert Poker.play(black: "KS QS AS TS JS", white: "KD QD AD TD JD") == "Tie"
  end

  test "hand must win with High Card strategy" do
    assert Poker.play(black: "2H 3D 6S 8C KH", white: "3C 4H 7S 9C AH") ==
             "white wins - high card: Ace"

    assert Poker.play(black: "2H 3D 6S 8C AC", white: "3C 4H 7S 9C AH") ==
             "white wins - high card: 9"

    assert Poker.play(black: "2H 3D 6S 9S AC", white: "3C 4H 7S 9C AH") ==
             "white wins - high card: 7"

    assert Poker.play(black: "2H 3D 7D 9S AC", white: "3C 4H 7S 9C AH") ==
             "white wins - high card: 4"

    assert Poker.play(black: "2H 4D 7D 9S AC", white: "3C 4H 7S 9C AH") ==
             "white wins - high card: 3"
  end

  test "hand must win with Pair strategy" do
    # against High card
    assert Poker.play(black: "2H 3D 6S 8C AH", white: "2C 3H 8S AC AD") == "white wins - Pair"
    # against other Pair
    assert Poker.play(black: "2H 2D 6S 8C KH", white: "2C 3H 8S AC AH") == "white wins - Pair"
    # against same Pair with high card
    assert Poker.play(black: "2C 3H 4S AC AH", white: "2S 3D 8S AS AD") == "white wins - Pair"
  end

  test "hand must win with Two Pair strategy" do
    # against High card
    assert Poker.play(black: "2H 3D 6S 8C AH", white: "3C 4H 4S AC AD") ==
             "white wins - Two Pairs"

    # against Pair
    assert Poker.play(black: "2H 4D 6S AS AH", white: "3C 4H 4S AC AD") ==
             "white wins - Two Pairs"

    # against Two Pairs
    assert Poker.play(black: "2H 2D 6S AC AH", white: "3C 4H 4S AS AD") ==
             "white wins - Two Pairs"

    # against same Two Pairs with high card
    assert Poker.play(black: "2H 4D 4C AD AS", white: "3C 4H 4S AC AH") ==
             "white wins - Two Pairs"
  end

  test "hand must win with Three of a kind strategy" do
    # against High card
    assert Poker.play(black: "2H 3D 6S 8C AH", white: "2C 4H 4S 4C QH") ==
             "white wins - Three of a Kind"

    # against Pair
    assert Poker.play(black: "2H 4D 6S AC AH", white: "2C 4H 4S 4C QH") ==
             "white wins - Three of a Kind"

    # against Two Pairs
    assert Poker.play(black: "2H 2D 6S AC AH", white: "2C 4H 4S 4C QH") ==
             "white wins - Three of a Kind"

    # against Three of a kind
    assert Poker.play(black: "2H 2D 2S 4C QH", white: "2C 4H 4S 4D AH") ==
             "white wins - Three of a Kind"
  end

  test "hand must win with Straight strategy" do
    # against High card
    assert Poker.play(black: "2H 3D 6S 8C AH", white: "3C 4H 5S 6C 7H") == "white wins - Straight"
    # against Pair
    assert Poker.play(black: "2H 4D 6S AC AH", white: "3C 4H 5S 6C 7H") == "white wins - Straight"
    # against Two Pairs
    assert Poker.play(black: "2H 2D 6S AC AH", white: "3C 4H 5S 6C 7H") == "white wins - Straight"
    # against Three of a kind
    assert Poker.play(black: "2H 2D 2S 4C AH", white: "3C 4H 5S 6C 7H") == "white wins - Straight"
    # against other Straight
    assert Poker.play(black: "2H 3D 4S 5C 6H", white: "3C 4H 5S 6C 7H") == "white wins - Straight"
  end

  test "hand must win with Flush strategy" do
    # against High card
    assert Poker.play(black: "2H 3D 6S 8C QH", white: "3H 4H 6H 9H AH") == "white wins - Flush"
    # against Pair
    assert Poker.play(black: "2H 4D 6S AC QH", white: "3H 4H 6H 9H AH") == "white wins - Flush"
    # against Two Pairs
    assert Poker.play(black: "2H 2D 6S AC QH", white: "3H 4H 6H 9H AH") == "white wins - Flush"
    # against Three of a kind
    assert Poker.play(black: "2H 2D 2S 4C QH", white: "3H 4H 6H 9H AH") == "white wins - Flush"
    # against Straight
    assert Poker.play(black: "2H 3D 4S 5C 6D", white: "3H 4H 6H 9H AH") == "white wins - Flush"
    # against other Flush
    assert Poker.play(black: "3D 4D 6D 9D JD", white: "3H 4H 6H 9H AH") == "white wins - Flush"
  end

  test "hand must win with Full House strategy" do
    # against High card
    assert Poker.play(black: "2H 3D 6S 8C QH", white: "4C 4H AS AC AH") ==
             "white wins - Full House"

    # against Pair
    assert Poker.play(black: "2H 4D 6S JC QH", white: "4C 4H AS AC AH") ==
             "white wins - Full House"

    # against Two Pairs
    assert Poker.play(black: "2H 2D 6S JC QH", white: "4C 4H AS AC AH") ==
             "white wins - Full House"

    # against Three of a kind
    assert Poker.play(black: "2H 2D 2S 7C QH", white: "4C 4H AS AC AH") ==
             "white wins - Full House"

    # against Straight
    assert Poker.play(black: "2H 3D 4S 5C 6H", white: "4C 4H AS AC AH") ==
             "white wins - Full House"

    # against Flush
    assert Poker.play(black: "3H 2H 6H 9H JH", white: "4C 4H AS AC AH") ==
             "white wins - Full House"

    # against other Full House
    assert Poker.play(black: "3C 3H QS QC QH", white: "4C 4H AS AC AH") ==
             "white wins - Full House"
  end

  test "hand must win with Four of a kind strategy" do
    # against High card
    assert Poker.play(black: "2H 3D 6S 8C QD", white: "4C AH AS AC AD") ==
             "white wins - Four of a Kind"

    # against Pair
    assert Poker.play(black: "2H 4D 6S KC QD", white: "4C AH AS AC AD") ==
             "white wins - Four of a Kind"

    # against Two Pairs
    assert Poker.play(black: "2H 2D 6S KC QD", white: "4C AH AS AC AD") ==
             "white wins - Four of a Kind"

    # against Three of a kind
    assert Poker.play(black: "2H 2D 2S 4C QD", white: "4H AH AS AC AD") ==
             "white wins - Four of a Kind"

    # against Straight
    assert Poker.play(black: "2H 3D 4S 5C 6H", white: "4C AH AS AC AD") ==
             "white wins - Four of a Kind"

    # against Flush
    assert Poker.play(black: "3H 4H 6H 9H JH", white: "4C AH AS AC AD") ==
             "white wins - Four of a Kind"

    # against Full House
    assert Poker.play(black: "4C 4H QS QC QH", white: "4D AH AS AC AD") ==
             "white wins - Four of a Kind"

    # against other Four of a kind
    assert Poker.play(black: "2C TH TS TC TD", white: "4C AH AS AC AD") ==
             "white wins - Four of a Kind"
  end

  test "hand must win with Straight Flush strategy" do
    # against High card
    assert Poker.play(black: "2H 3D 6S 8C AH", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"

    # against Pair
    assert Poker.play(black: "2H 4D 6S AC AH", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"

    # against Two Pairs
    assert Poker.play(black: "2H 2D 6S AC AH", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"

    # against Three of a kind
    assert Poker.play(black: "2H 2D 2S 4C AH", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"

    # against Straight
    assert Poker.play(black: "2H 3D 4S 5C 6H", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"

    # against Flush
    assert Poker.play(black: "3H 4H 6H 9H JH", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"

    # against Full House
    assert Poker.play(black: "4C 4H QD QC QH", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"

    # against Four of a kind
    assert Poker.play(black: "2C 9D 9S 9C 9H", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"

    # against other Straight flush
    assert Poker.play(black: "9C TH JH QH KH", white: "KS QS AS TS JS") ==
             "white wins - Straight Flush"
  end
end
