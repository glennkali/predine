# predine
Elixir umbrella application for soccer results prediction. 
It contains separate applications for:

- `data_preprocessor` (data ingestion and data pre processing)
This application is in charge of importing soccer games results (including odds) for the last 10 seasons of all major european leagues
from [footbal-data](https://www.football-data.co.uk/data.php).

```
seasons = [
  "2013-2014",
  "2014-2015",
  "2015-2016",
  "2016-2017",
  "2017-2018",
  "2018-2019",
  "2019-2020",
  "2020-2021",
  "2021-2022",
  "2022-2023",
  "2023-2024"
]
leagues = %{
  "england" => ["E0", "E1", "E2", "E3", "EC"],
  "scotland" => ["SC0", "SC1", "SC2", "SC3"],
  "germany" => ["D1", "D2"],
  "italy" => ["I1", "I2"],
  "spain" => ["SP1", "SP2"],
  "france" => ["F1", "F2"],
  "netherlands" => ["N1"],
  "belgium" => ["B1"],
  "portugal" => ["P1"],
  "turkey" => ["T1"],
  "greece" => ["G1"]
}
```

Once ingested in the database, this application then proceeds to a season based ranking.
The ranking is done following the [rateform](http://www.betfairprotrader.co.uk/2012/02/rateform.html#:~:text=Rateform%20works%20in%20the%20following,not%20so%20good%20lose%20points.) strategy.

- `fine_tuner` (build and train model)
Using the data ingested by the `data_preprocessor` this application perfoms 3 types of classification strategy :

#### Linear regression
#### Logistic regression
#### Neural network
```
model =
  Axon.input("input")
  |> Axon.dense(256)
  |> Axon.relu()
  |> Axon.dense(256)
  |> Axon.relu()
  |> Axon.dropout(rate: 0.3)
  |> Axon.dense(3, activation: :softmax)
```
![Screenshot 2024-04-26 at 9 23 52 AM](https://github.com/glennkali/predine/assets/147419777/16630d11-4424-4279-bc57-da62583d3f1c)

Once the models are built (the NN model is the most accurate one) the application waits for API calls to make predictions

## Getting Started

To get started with development, follow these steps:

1. Clone this repository.
2. Install Elixir if you haven't already. Refer to the [official Elixir installation guide](https://elixir-lang.org/install.html) for instructions.
3. Install dependencies by running: ```mix deps.get```
4. configure your postgresql connection in the `config.exs` file
5. Start `data_preprocessor` by running `iex -S mix` within `apps/data_preprocessor`
6. In a separate terminal window connect to the server started previously via `telnet 127.0.0.1 4040`
7. Import all data from csv into the database by running: `INITIALIZE`
8. To rank teams execute all the instructions in the `ranking.txt` file
9. `cd` into `apps/fine_tuner` and start that application with `iex -S mix` to have the model created and trained

That's it you should now have a trained model that can make predictions and that's waiting for prediction requests.
