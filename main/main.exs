defmodule Main do
  alias CheckTeam
  alias TeamRepository
  alias Team

  def main do
    IO.puts("Comandos del sistema: \n/teams - Listar todos los equipos\n")
    comando= IO.gets("Ingrese un comando: ") |>String.trim()
    |>ejecutar_comando()
  end

  defp ejecutar_comando("/teams") do
    GestionTeams.listarTeams()
    |> Enum.each(fn team_info -> IO.puts(team_info) end)
  end

  defp ejecutar_comando("/join team") do
  end

  defp datos_prueba() do
     equipo1=GestionTeams.createTeam("EquipoPrueba", ["juan", "pedro"])
    equipo2=GestionTeams.createTeam("EquipoPrueba", ["ana", "maria"])
    IO.inspect(equipo1)
    IO.inspect(equipo2)
  end
end
Main.main()
