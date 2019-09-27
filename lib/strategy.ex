defmodule Strategy do
  @card_names %{
    11 => "Jack",
    12 => "Queen",
    13 => "King",
    14 => "Ace"
  }

  @strategies_rank %{
    "Straight Flush" => 8,
    "Four of a Kind" => 7,
    "Full House" => 6,
    "Flush" => 5,
    "Straight" => 4,
    "Three of a Kind" => 3,
    "Two Pairs" => 2,
    "Pair" => 1,
    "High Card" => 0
  }

  def determine_winning_hand(hands) do
    hands
    |> Enum.map(&determine_strategy/1)
    |> determine_winner
    |> generate_result
  end

  defp determine_strategy({name, cards}) do
    strategy =
      cards
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> determine_poker_strategy

    {name, {strategy, cards}}
  end

  defp determine_winner(strategies) do
    strategies
    |> Enum.group_by(fn {_name, {strategy, _cards}} ->
      @strategies_rank[strategy]
    end)
    |> Enum.sort_by(fn {rank, _hand} -> rank end, &>=/2)
    |> Enum.map(fn {_rank, hand} -> hand end)
    |> List.first()
    |> case do
      [{name, {strategy, _cards}}] -> {name, strategy}
      hands_with_same_strategy -> determine_by_highest_card(hands_with_same_strategy)
    end
  end

  defp generate_result(:tie), do: "Tie"

  defp generate_result({winner, winning_strategy}) do
    "#{winner} wins - #{winning_strategy}"
  end

  defp determine_by_highest_card(hands) do
    hands
    |> Enum.map(fn {name, {strategy, cards}} ->
      sorted_cards =
        cards
        |> Enum.sort_by(&elem(&1, 0), &>/2)
        |> Enum.chunk_by(&elem(&1, 0))
        |> Enum.sort_by(&length(&1), &>/2)
        |> Enum.chunk_by(&length(&1))
        |> Enum.map(fn list ->
          list
          |> List.flatten()
          |> Enum.sort_by(&elem(&1, 0), &>/2)
        end)
        |> List.flatten()

      {name, {strategy, sorted_cards}}
    end)
    |> compare_hands
  end

  defp compare_hands(hands), do: compare_hands(hands, nil)
  defp compare_hands([_], :tie), do: :tie
  defp compare_hands([_], winner), do: winner

  defp compare_hands([first, second | hands], _) do
    winner = compare_cards(first, second)
    compare_hands([first | hands], winner)
  end

  defp compare_cards({_, {_, []}}, {_, {_, []}}), do: :tie

  defp compare_cards(
         {player_1, {strategy, [{card_1, _suite_1} | remaining_cards_1]}},
         {player_2, {strategy, [{card_2, _suite_2} | remaining_cards_2]}}
       ) do
    cond do
      card_1 == card_2 ->
        compare_cards(
          {player_1, {strategy, remaining_cards_1}},
          {player_2, {strategy, remaining_cards_2}}
        )

      card_1 > card_2 ->
        {player_1, format_strategy(strategy, card_1)}

      card_1 < card_2 ->
        {player_2, format_strategy(strategy, card_2)}
    end
  end

  defp format_strategy("High Card", high_card),
    do: "high card: #{@card_names[high_card] || high_card}"

  defp format_strategy(strategy, _), do: strategy

  defp determine_poker_strategy(cards) do
    suites = Map.values(cards) |> Enum.sort(&(length(&1) <= length(&2)))
    straight? = is_straight(cards)

    case suites do
      [[x], [x], [x], [x], [x]] when straight? -> "Straight Flush"
      [[_], [_], [_], [_], [_]] when straight? -> "Straight"
      [[x], [x], [x], [x], [x]] -> "Flush"
      [[_], [_], [_], [_], [_]] -> "High Card"
      [[_], [_], [_], [_, _]] -> "Pair"
      [[_], [_, _], [_, _]] -> "Two Pairs"
      [[_], [_], [_, _, _]] -> "Three of a Kind"
      [[_, _], [_, _, _]] -> "Full House"
      [[_], [_, _, _, _]] -> "Four of a Kind"
    end
  end

  defp is_straight(cards) do
    values = Enum.map(cards, &elem(&1, 0))
    sum = Enum.sum(values)
    max = Enum.max(values)
    min = Enum.min(values)
    sum == (max * (max + 1) - min * (min - 1)) / 2
  end
end
