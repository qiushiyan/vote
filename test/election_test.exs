defmodule ElectionTest do
  use ExUnit.Case
  doctest Election

  setup_all do
    %{election: %Election{}}
  end

  test "updating election name", ctx do
    command = "name presendential election"
    election = ctx.election |> State.update(command)
    assert election.name === "presendential election"
  end

  test "adding candidates", ctx do
    command = "add qiushi"
    election = ctx.election |> State.update(command)

    names =
      for candidate <- election.candidates do
        candidate.name
      end

    assert "qiushi" in names
  end

  test "voting for candidate" do
    command = "v1"

    election =
      %Election{
        candidates: [
          %Candidate{id: 1, name: "qiushi", votes: 0},
          %Candidate{id: 2, name: "tom", votes: 0}
        ],
        next_id: 3
      }
      |> State.update(command)

    for candidate <- election.candidates do
      if candidate.name === "qiushi" do
        assert candidate.votes === 1
      else
        assert candidate.votes === 0
      end
    end
  end
end
