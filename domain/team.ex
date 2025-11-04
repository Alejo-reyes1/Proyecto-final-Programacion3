defmodule Team do
  defstruct [:nombre, :participantes,:tema,:id, :estado]

  def createTeam(nombre,participantes,tema) do
    validacion=CheckTeam.checkTeamName(nombre)
    case validacion do
      {:ok, _msg} ->
        id=generar_id()
        %Team{nombre: nombre, participantes: participantes,tema: tema, id: "#{id}TM", estado: "activo"}
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
    Enum.map(teams,fn infoTeam -> "ID: #{infoTeam.id}, Nombre: #{infoTeam.nombre},Tema: #{infoTeam.tema} ,Participantes: #{Enum.join(infoTeam.participantes, ", ")}, Estado: #{infoTeam.estado}"end)
  end
end

  defp generar_id do
    TeamRepository.listarTeams()
    |>case do
      [] -> 1
      teams -> Enum.reduce(teams, 0, fn team, acc ->
        String.replace(team.id,"TM","") |>String.to_integer() |> max(acc)
      end)+1
    end
  end
end
