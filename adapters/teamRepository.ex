defmodule TeamRepository do
  @archivo "teams.csv"

  def saveTeam(%{nombre: nombre, participantes: participantes,tema: tema, id: id, estado: estado}) do
    header= "id,nombre,participantes,tema,estado\n"
    miembros=Enum.join(participantes, ";")
    File.write(@archivo,header <> "#{id},#{nombre},#{miembros},#{tema},#{estado}\n", [:append])

  end

  def listarTeams() do
    File.read(@archivo)
    |> case do
      {:ok, contenido} ->
        String.split(contenido , "\n",  trim: true)
        |>Enum.map(fn fila ->[id,nombre,tema,miembros,estado]=String.split(fila,",")
          participantes=String.split(miembros,";")
          %Team{id: id, nombre: nombre, participantes: participantes,tema: tema, estado: estado}
        end)
        |> Enum.drop(1)
      {:error, _reason} -> []
    end
  end
end
