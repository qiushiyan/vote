defmodule State do
  @moduledoc """
  change election struct state
  """
  @commands ["n", "a", "v"]

  def update(_election, "q" <> _), do: :quit

  def update(election, cmd) when is_binary(cmd) do
    update(election, String.split(cmd, " ", trim: true))
  end

  # in case user enter without space, e.g., "v1" "cqiushi"
  # transform it into "v 2" "a qiushi"
  def update(election, [<<c::binary-size(1)>> <> rest] = cmd)
      when c in @commands and length(cmd) == 1 do
    cmd = String.split(c <> " " <> rest, " ")
    update(election, cmd)
  end

  def update(election, ["n" <> _ | election_name]) do
    name = Enum.join(election_name, " ") |> String.trim()
    %Election{election | name: name}
  end

  def update(election, ["a" <> _ | candidate_name]) do
    # candidate name is ["qiushi\n"]
    name = Enum.join(candidate_name, " ") |> String.trim()
    new_candidate = Candidate.new(election.next_id, name)

    %Election{
      election
      | next_id: election.next_id + 1,
        candidates: [new_candidate | election.candidates]
    }
  end

  # note the bracket betwen id
  # in ["v" <> _ | id] = ["vote", "1"] id will matched as ["1"]
  def update(election, ["v" <> _ | [id]]) do
    vote(election, Integer.parse(id))
  end

  defp vote(election, {id, _}) do
    candidates = Enum.map(election.candidates, &maybe_inc_vote(&1, id))
    %Election{election | candidates: candidates}
  end

  defp vote(election, :error) do
    election
  end

  defp maybe_inc_vote(candidate, id) when is_integer(id) do
    maybe_inc_vote(candidate, id === candidate.id)
  end

  defp maybe_inc_vote(candidate, true) do
    %Candidate{candidate | votes: candidate.votes + 1}
  end

  defp maybe_inc_vote(candidate, false) do
    candidate
  end
end
