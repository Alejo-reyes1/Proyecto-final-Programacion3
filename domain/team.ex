defmodule Team do
  defstruct [:nombre, :participantes,:id]

  def createTeam(nombre,participantes) do
    validacion=CheckTeam.checkTeamName(nombre)
    case validacion do
      {:ok, _msg} ->
        id=generar_id()
        %Team{nombre: nombre, participantes: participantes, id: "#{id}TM"}
        |> TeamRepository.saveTeam()
        {:ok, "El equipo #{nombre} ha sido creado con ID #{id}" }
      {:error, msg} -> {:error, msg}
      end
  end

  def listarTeams() do
    teams=TeamRepository.listarTeams()
    if teams== [] do
      "No hay equipos registrados."
    else
    Enum.map(teams,fn infoTeam -> "ID: #{infoTeam.id}, Nombre: #{infoTeam.nombre}, Participantes: #{Enum.join(infoTeam.participantes, ", ")}"end)
  end
end

  defp generar_id do
    TeamRepository.listarTeams()
    |> case do
      [] -> 1
      teams -> Enum.max(teams)+1
    end
  end
end
