defmodule Election do
  defstruct(
    name: "Mayor",
    candidates: [],
    next_id: 1
  )

  def run do
    %Election{} |> run
  end

  @doc """
  Update the Election construct, based on the provided command

  ## Paramters

  - (n)ame command update table header
    - example: "n president"
  - (a)dd command add a candidate
    - example: "a john"
  - (v)ote command vote for a candidate
    - example: "v john"
  - (q) quit the app

  ## Examples

      iex> %Election{} |> State.update("n president")
      %Election{name: "president"}
  """

  def run(election = %Election{}) do
    [IO.ANSI.clear(), IO.ANSI.cursor(0, 0)] |> IO.write()

    IO.inspect(election)

    election
    |> view()
    |> IO.write()

    command = IO.gets("> ")

    election
    |> State.update(command)
    |> run()
  end

  def run(:quit), do: :quit

  def view_header(%Election{name: name}) do
    [
      "\nElection for #{name}\n"
    ]
  end

  def view_body(%Election{candidates: candidates}) do
    candidates
    |> Enum.sort(&(&1.votes >= &2.votes))
    |> Enum.map(fn %{id: id, name: name, votes: votes} ->
      "#{id}\t#{votes}\t#{name}\n"
    end)
    |> insert_header()
  end

  def view_footer() do
    [
      "\n",
      "commands: (n)ame <election>, (a)dd <candidate>, <v>ote <id>, (q)uit",
      "\n"
    ]
  end

  def view(election) do
    [view_header(election), view_body(election), view_footer()]
  end

  defp insert_header(candidates) do
    [
      "ID\tVotes\tName\n",
      "==================================\n"
      | candidates
    ]
  end
end
