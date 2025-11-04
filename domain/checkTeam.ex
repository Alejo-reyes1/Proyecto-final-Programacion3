defmodule CheckTeam do
   @archivo "teams.csv"

  def checkTeamName(name) do
    nombresExistentes = leerArchivo(@archivo)
    if(name in nombresExistentes) do
      {:error, "El nombre del equipo ya existe"}
    else
      {:ok, "El nombre del equipo es válido"}
    end

  end

  defp leerArchivo(@archivo) do
    case File.read(@archivo) do
      {:ok, contenido} ->
        String.split(contenido, "\n", trim: true)
        |> Enum.map(fn linea -> [_,nombre,_,_,_]=String.split(linea, ",") ; nombre end)
        |> Enum.drop(1)
      {:error, _reason} -> []
    end
  end
end
