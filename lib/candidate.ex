defmodule Candidate do
  defstruct [:id, :name, votes: 0]

  def new(id, name) do
    %Candidate{id: id, name: name, votes: 0}
  end
end
