defmodule Chucky.Server do
  use GenServer

  def init(_args \\ []) do
    :random.seed(:os.timestamp())
    facts =
      "facts.txt" |> File.read!() |> String.split("\n")
    {:ok, facts}
  end
  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], [name: {:global, __MODULE__}])
  end

  def fact(), do: GenServer.call({:global, __MODULE__}, :fact)

  def handle_call(:fact, _from, facts) do
    random_fact =
      facts
      |> Enum.shuffle()
      |> List.first()

    {:reply, "#{random_fact} - #{self()}", facts}
  end
end
