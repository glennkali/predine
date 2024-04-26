defmodule MlModelCreator.Data do
  import Nx.Defn
  alias Explorer.{DataFrame, Series}

  def split_train_test(df, portion) do
    num_examples = DataFrame.n_rows(df)
    num_train = ceil(portion * num_examples)
    num_test = num_examples - num_train

    train = DataFrame.slice(df, 0, num_train)
    test = DataFrame.slice(df, num_train, num_test)
    {train, test}
  end

  def split_features_targets(df) do
    features =
      DataFrame.select(df, [
        "home_old_rating",
        "away_old_rating",
        "odds_home_bet365",
        "odds_draw_bet365",
        "odds_away_bet365"
      ])

    targets = DataFrame.select(df, "full_time_result")
    {features, targets}
  end

  def df_to_tensor(df) do
    df
    |> DataFrame.names()
    |> Enum.map(&Series.to_tensor(df[&1]))
    |> Nx.stack(axis: 1)
  end

  def convert_to_tensor(df_targets) do
    result_map = %{
      "H" => [1, 0, 0],
      "D" => [0, 1, 0],
      "A" => [0, 0, 1]
    }

    Explorer.Series.transform(df_targets["full_time_result"], fn x ->
      Map.fetch!(result_map, x)
    end)
    |> Explorer.Series.to_list()
    |> Nx.tensor()
  end

  defn normalize_features(tensor) do
    max =
      tensor
      |> Nx.abs()
      |> Nx.reduce_max(axes: [0], keep_axes: true)

    tensor / max
  end
end
