defmodule TeamRepository do
  @archivo "teams.csv"

  def saveTeam(%{nombre: nombre, participantes: participantes,tema: tema, id: id, estado: estado}) do
    header= "id,nombre,participantes,tema,estado\n"
    miembros=Enum.join(participantes, ";")
    case File.exists?(@archivo) do
      true -> File.write(@archivo,"#{id},#{nombre},#{miembros},#{tema},#{estado}\n", [:append])
      false -> File.write(@archivo,header <> "#{id},#{nombre},#{miembros},#{tema},#{estado}\n", [:append])
    end
  end

  def actualizar_team(team_actualizado) do
    teams = listarTeams()
    nuevos_teams =
      Enum.map(teams, fn team ->
        if team.id == team_actualizado.id, do: team_actualizado, else: team
      end)
    header = "id,nombre,participantes,tema,estado\n"
    contenido =
      nuevos_teams
      |> Enum.map(fn t ->
        miembros = Enum.join(t.participantes || [], ";")
        "#{t.id},#{t.nombre},#{miembros},#{t.tema},#{t.estado}"
      end)
      |> Enum.join("\n")
    File.write(@archivo, header <> contenido <> "\n")
  end

  def listarTeams() do
    File.read(@archivo)
    |> case do
      {:ok, contenido} ->
        String.split(contenido , "\n",  trim: true)
        |>Enum.map(fn fila ->[id,nombre,miembros,tema,estado]=String.split(fila,",")
          participantes=String.split(miembros,";")
          %Team{id: id, nombre: nombre, participantes: participantes,tema: tema, estado: estado}
        end)
        |> Enum.drop(1)
      {:error, _reason} -> []
    end
  end
end
