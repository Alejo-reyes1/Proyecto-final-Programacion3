defmodule GestionTeams do

  def createTeam(nombre, participantes,tema) do
    Team.createTeam(nombre, participantes,tema)
    |> case do
      {:ok, msg} -> msg
      {:error, msg} -> "Error al crear el equipo: #{msg}"
    end
  end

  def listarTeams() do
    Team.listarTeams()
  end

end
