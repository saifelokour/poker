defmodule Poker do
  @moduledoc """
  Documentation for Poker.
  """

  @doc """
  Play Poker.

  ## Examples

      iex> Poker.play(black: "2H 3D 5S 9C KD", white: "2C 3H 4S 8C AH")
      "white wins - high card: Ace"

  """
  def play(hands) do
    case Parser.parse_hands(hands) do
      {:ok, parsed_hands} ->
        Strategy.determine_winning_hand(parsed_hands)

      {:error, message} ->
        message
    end
  end
end
