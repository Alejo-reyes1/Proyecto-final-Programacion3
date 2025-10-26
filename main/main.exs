defmodule Main do
  alias CheckTeam
  alias TeamRepository
  alias Team
  Path.wildcard("**/*.ex")
|> Enum.each(&Code.compile_file/1)


  def main do
    IO.puts("Bienvenido al sistema de la hackaton ingrese sesion.\n")
    IO.puts("1. Iniciar sesion")
    IO.puts("2. Crear usuario")
    opcion= IO.gets("Ingrese una opcion: ") |> String.trim()
    case opcion do
      "1" -> iniciar_sesion()
      "2" -> crear_usuario()
      _ -> IO.puts("Opcion invalida")
    end
  end
  defp crear_usuario() do
    nombre= IO.gets("Ingrese su nombre: ") |> String.trim()
    email= IO.gets("Ingrese su email: ") |> String.trim()
    contrasena= IO.gets("Ingrese su contrasena: ") |> String.trim()
    GestionUsuario.crear_usuario(nombre, email, contrasena)
    |> case do
      {:ok, mensaje} ->
        IO.puts("Usuario creado exitosamente: #{mensaje}")
        mostrar_menu()
      {:error, error_msg} ->
        IO.puts("Error al crear el usuario: #{error_msg}")
    end
  end

  defp iniciar_sesion() do
    email= IO.gets ("Ingrese su email: ") |> String.trim()
    contrasena= IO.gets ("Ingrese su contrasena: ") |> String.trim()
  end

  defp mostrar_menu() do
    IO.puts("Comandos disponibles:")
    IO.puts("/teams - Listar todos los equipos")
    IO.puts("/join team - Unirse a un equipo")
    comando = IO.gets("Ingrese el comando: ") |> String.trim()
    ejecutar_comando(comando)
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
