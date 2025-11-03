defmodule TeamRepository do
  @archivo "teams.csv"

  def saveTeam(%{nombre: nombre, participantes: participantes, id: id, estado: estado}) do
    header= "id,nombre,participantes,estado\n"
    miembros=Enum.join(participantes, ";")
    File.write(@archivo,header <> "#{id},#{nombre},#{miembros},#{estado}\n", [:append])

  end

  def listarTeams() do
    File.read(@archivo)
    |> case do
      {:ok, contenido} ->
        String.split(contenido , "\n",  trim: true)
        |>Enum.map(fn fila ->[id,nombre ,miembros,estado]=String.split(fila,",")
          participantes=String.split(miembros,";")
          %Team{id: id, nombre: nombre, participantes: participantes, estado: estado}
        end)
        |> Enum.drop(1)
      {:error, _reason} -> []
    end
  end
end
