defmodule Parser do
  @value_map %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  @suites ~w(H D C S)

  def parse_hands(hands) do
    with hands_cards <- split_into_cards(hands),
         true <- validate_deck(hands_cards),
         parsed_hands <- parse_cards(hands_cards),
         true <- validate_hands(parsed_hands) do
      {:ok, parse_cards(hands_cards)}
    else
      false -> {:error, "invalid hand(s)"}
    end
  end

  defp split_into_cards(hands) do
    hands
    |> Enum.map(fn {name, hand} -> {name, String.split(hand)} end)
  end

  defp validate_deck(cards) do
    all_cards = Enum.flat_map(cards, fn {_, hand} -> hand end)
    length(all_cards) == length(Enum.uniq(all_cards))
  end

  defp validate_hands(hands) do
    Enum.all?(hands, fn {_, hand} -> length(hand) == 5 end)
  end

  defp parse_cards(hands_cards) do
    hands_cards
    |> Enum.map(fn {name, hand} -> {name, parse_hand(hand)} end)
  end

  defp parse_hand(hand) do
    hand
    |> Enum.map(fn card ->
      [value, suite] = String.codepoints(card)
      {@value_map[value], suite}
    end)
    |> Enum.filter(fn {val, suite} -> val && suite in @suites end)
  end
end
