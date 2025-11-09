defmodule HistorialMensajes do
    def guardar_mensaje_csv(id_team, emisor, mensaje) do
    File.mkdir_p!("data/chats")
    ruta = "data/chats/#{id_team}_chat.csv"
    linea = "#{emisor},\"#{mensaje}\"\n"
    if File.exists?(ruta) do
      File.write!(ruta, linea, [:append])
    else
      header = "emisor,mensaje\n"
      File.write!(ruta, header <> linea)
    end
  end

  def mostrar_historial(id_team) do
    ruta = "data/chats/#{id_team}_chat.csv"

    if File.exists?(ruta) do
      IO.puts("\nÚltimos 10 mensajes del chat #{id_team}:")

      File.stream!(ruta)
      |> Stream.drop(1) # Saltar encabezado
      |> Enum.to_list()
      |> Enum.each(fn linea ->
        [emisor, mensaje] =
          String.split(linea, ~r/,(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)/)
        IO.puts("[#{emisor}]: #{String.replace(mensaje, "\"", "")}")
      end)

      IO.puts("──────────────────────────────")
    else
      IO.puts("No hay historial disponible para este equipo.")
    end
  end
end
