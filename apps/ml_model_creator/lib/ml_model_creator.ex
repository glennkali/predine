defmodule MlModelCreator do
  alias Explorer.{DataFrame}
  require Logger

  def create() do
    Logger.info("Starting the model creation process")

    Logger.info("Loading the data from the database")
    {:ok, df} = load_data()

    Logger.info("Preprocessing the data and splitting the training and testing sets")

    {:ok, [normalized_train_inputs, normalized_test_inputs, train_targets, test_targets]} =
      preprocess_data(df)

    Logger.info("Instantiating the model")

    model =
      Axon.input("input")
      |> Axon.dense(256)
      |> Axon.relu()
      |> Axon.dense(256)
      |> Axon.relu()
      |> Axon.dropout(rate: 0.3)
      |> Axon.dense(3, activation: :softmax)

    Logger.info("Model training start")
    params = train_model(model, normalized_train_inputs, train_targets)
    Logger.info("Model training completed")

    Logger.info("Model evaluation")
    evaluate_model(model, params, normalized_test_inputs, test_targets)

    Logger.info("Model exporting to ONNX")
    export_model(model, params)

    {:ok, model}
  end

  def load_data() do
    Adbc.download_driver!(:postgresql,
      uri: "postgresql://postgres:toorroot@localhost:5432/sports"
    )

    {:ok, db} =
      Kino.start_child(
        {Adbc.Database,
         driver: :postgresql, uri: "postgresql://postgres:toorroot@localhost:5432/sports"}
      )

    {:ok, conn} = Kino.start_child({Adbc.Connection, database: db})

    # query to load data
    query =
      "SELECT tseh.old_rating as home_old_rating, tsea.old_rating as away_old_rating, f.full_time_result, f.odds_home_bet365, f.odds_draw_bet365, f.odds_away_bet365
    FROM public.fixtures as f
    JOIN public.team_statistics as tsh
    ON f.home_team_id = tsh.team_id
    JOIN public.team_statistics as tsa
    ON f.away_team_id = tsa.team_id
    JOIN public.team_statistic_events as tseh
    ON f.id = tseh.fixture_id AND tsh.id = tseh.team_statistic_id
    JOIN public.team_statistic_events as tsea
    ON f.id = tsea.fixture_id AND tsa.id = tsea.team_statistic_id
    WHERE f.odds_home_bet365 IS NOT NULL
    AND f.odds_draw_bet365 IS NOT NULL
    AND f.odds_away_bet365 IS NOT NULL
    ORDER BY f.id"

    # When using the conn PID directly
    DataFrame.from_query(conn, query, [])
  end

  def preprocess_data(df) do
    {train_df, test_df} = MlModelCreator.Data.split_train_test(df, 0.8)
    {train_features, train_targets} = MlModelCreator.Data.split_features_targets(train_df)
    {test_features, test_targets} = MlModelCreator.Data.split_features_targets(test_df)

    normalized_train_inputs =
      train_features
      |> MlModelCreator.Data.df_to_tensor()
      |> MlModelCreator.Data.normalize_features()

    normalized_test_inputs =
      test_features
      |> MlModelCreator.Data.df_to_tensor()
      |> MlModelCreator.Data.normalize_features()

    train_targets = MlModelCreator.Data.convert_to_tensor(train_targets)
    test_targets = MlModelCreator.Data.convert_to_tensor(test_targets)

    {:ok, [normalized_train_inputs, normalized_test_inputs, train_targets, test_targets]}
  end

  def train_model(model, normalized_train_inputs, train_targets) do
    batched_train_inputs = Nx.to_batched(normalized_train_inputs, 2048)
    batched_train_targets = Nx.to_batched(train_targets, 2048)
    batched_train = Stream.zip(batched_train_inputs, batched_train_targets)

    model
    |> Axon.Loop.trainer(
      :categorical_cross_entropy,
      Polaris.Optimizers.adam(learning_rate: 1.0e-4),
      log: 1
    )
    |> Axon.Loop.run(batched_train, %{}, epochs: 30, compiler: EXLA)
  end

  def evaluate_model(model, params, normalized_test_inputs, test_targets) do
    batched_test_inputs = Nx.to_batched(normalized_test_inputs, 2048)
    batched_test_targets = Nx.to_batched(test_targets, 2048)
    batched_test = Stream.zip(batched_test_inputs, batched_test_targets)

    model
    |> Axon.Loop.evaluator()
    |> Axon.Loop.metric(:accuracy, "acc")
    |> Axon.Loop.metric(:precision, "pre")
    |> Axon.Loop.metric(:true_positives, "tp", :running_sum)
    |> Axon.Loop.metric(:true_negatives, "tn", :running_sum)
    |> Axon.Loop.metric(:false_positives, "fp", :running_sum)
    |> Axon.Loop.metric(:false_negatives, "fn", :running_sum)
    |> Axon.Loop.run(batched_test, params, compiler: EXLA)
    |> inspect()
    |> IO.puts()
  end

  def export_model(model, params) do
    _template = Nx.to_template({2048, 5})
    # AxonOnnx.export(model, template, params)
  end
end
