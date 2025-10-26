defmodule TeamRepository do
  @archivo "teams.csv"

  def saveTeam(%{nombre: nombre, participantes: participantes, id: id}) do
    header= "id,nombre,participantes\n"
    miembros=Enum.join(participantes, ";")
    File.write(@archivo,header <> "#{id},#{nombre},#{miembros}\n", [:append])

  end

  def listarTeams() do
    File.read(@archivo)
    |> case do
      {:ok, contenido} ->
        String.split(contenido , "\n",  trim: true)
        |>Enum.map(fn fila ->[id, nombre , miembros]=String.split(fila,",")
          participantes=String.split(miembros,";")
          %Team{id: id, nombre: nombre, participantes: participantes}
        end)
      {:error, _reason} -> []
    end
  end
end
