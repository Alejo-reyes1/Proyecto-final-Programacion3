defmodule Main do
  alias CheckTeam
  alias TeamRepository
  alias Team
  alias Chat

  def run do
    limpiar_consola()
    IO.puts("Bienvenido al sistema de la hackaton.")
    IO.puts("1. Iniciar sesion")
    IO.puts("2. Crear usuario")
    IO.puts("3. Salir")
    opcion= IO.gets("Ingrese una opcion: ") |> String.trim()
    case opcion do
      "1" -> iniciar_sesion()
      "2" -> crear_usuario()
      "3" -> IO.puts("Saliendo del sistema. ¡Hasta luego!")
      _-> IO.puts("Opcion invalida")
      run()
    end
  end
  defp crear_usuario() do
    limpiar_consola()
    nombre= IO.gets("Ingrese su nombre: ") |> String.trim() |> String.downcase()
    email= IO.gets("Ingrese su email: ") |> String.trim() |> String.downcase()
    contrasena= IO.gets("Ingrese su contrasena: ") |> String.trim() |> String.downcase()
    GestionUsuario.crear_usuario(nombre, email, contrasena)
    |> case do
      {:ok, mensaje} ->
        IO.puts("Usuario creado exitosamente: #{mensaje}")
        :timer.sleep(2000)
        iniciar_sesion()
      {:error, error_msg} ->
        IO.puts("Error al crear el usuario: #{error_msg}")
        :timer.sleep(2000)
        run()
    end
  end

  defp iniciar_sesion() do
    limpiar_consola()
    IO.puts("Bienvenido, por favor inicie sesion.")
    email= IO.gets ("Ingrese su email:") |> String.trim() |> String.downcase()
    contrasena= IO.gets ("Ingrese su contrasena:") |> String.trim() |> String.downcase()
    GestionUsuario.iniciar_sesion(email,contrasena)
    |> case do
      {:ok, usuario} ->
        IO.puts("Bienvenido, #{usuario.nombre}!")
        :timer.sleep(2000)
        limpiar_consola()
        mostrar_menu(usuario)
      {:error, error_msg} ->
        IO.puts("Error al iniciar sesion: #{error_msg}")
        :timer.sleep(2000)
        limpiar_consola()
        run()
    end
  end

  defp mostrar_menu(usuario) do
    limpiar_consola()
    IO.puts("Comandos disponibles:")
    IO.puts("/teams - Listar todos los equipos")
    IO.puts("/join team - Unirse a un equipo")
    IO.puts("/chat - Acceder al chat de un equipo")
    IO.puts("/create team - Crear un nuevo equipo\n/exit - Salir del sistema")
    comando = IO.gets("Ingrese el comando: ") |> String.trim() |> String.downcase()
    ejecutar_comando(comando, usuario)
  end

  defp ejecutar_comando("/create team", usuario) do
    limpiar_consola()
    nombre= IO.gets("Ingrese el nombre del equipo: ") |> String.trim() |> String.downcase()
    tema=IO.gets("Ingrese el tema del equipo: ") |> String.trim() |> String.downcase()
    participantes=usuario
    GestionTeams.createTeam(nombre,participantes,tema)
    |> case do
      {:ok, mensaje} ->
        IO.puts("Equipo creado exitosamente: #{mensaje}")
      {:error, error_msg} ->
        IO.puts("Error al crear el equipo: #{error_msg}")
    end
    if String.downcase(IO.gets("Digite ok para salir:")|> String.trim())=="ok" do
      :timer.sleep(2000)
      limpiar_consola()
      mostrar_menu(usuario)
    end
  end

  defp ejecutar_comando("/exit", _usuario) do
    IO.puts("Saliendo del sistema. ¡Hasta luego!")
    run()
  end

  defp ejecutar_comando("/teams", usuario) do
    limpiar_consola()
    GestionTeams.listarTeams()
    |> Enum.each(fn team_info ->
      :timer.sleep(500)
      IO.puts(team_info) end)
    if String.downcase(IO.gets("Digite ok para salir:")|> String.trim())=="ok" do
      mostrar_menu(usuario)
    end
  end

  defp ejecutar_comando("/join team", usuario ) do
    limpiar_consola()
    nombre_team=IO.gets("Ingrese el nombre del equipo al que desea unirse: ") |> String.trim() |> String.downcase()
    GestionTeams.asociar_usuario_team(nombre_team, usuario)
    GestionTeams.asociar_team_usuario(nombre_team,usuario)
    |> case do
      {:ok, mensaje} ->
        IO.puts("Exito: #{mensaje}")
      {:error, error_msg} ->
        IO.puts("Error al unirse al equipo: #{error_msg}")
    end
    :timer.sleep(2000)
    mostrar_menu(usuario)
  end

  defp ejecutar_comando("/chat", usuario) do
    limpiar_consola()
    nombre_team=IO.gets("Ingrese el nombre del equipo: ") |> String.trim() |> String.downcase()
    case GestionUsuario.usuario_en_equipo(usuario, nombre_team) do
      {:ok, _msg} ->
        id_team=TeamRepository.obtener_id_por_nombre(nombre_team)
        spawn(fn -> NodoServidor.iniciar_servidor_chat(id_team) end)
        :timer.sleep(1000) # Esperar a que el servidor inicie
        IO.puts("Acceso concedido al chat del equipo #{nombre_team}.")
        NodoCliente.iniciar_chat(id_team, usuario)
        mostrar_menu(usuario)
      {:error, msg} ->
        IO.puts("Acceso denegado: #{msg}")
        mostrar_menu(usuario)
    end
  end

  defp ejecutar_comando(_, usuario) do
    limpiar_consola()
    IO.puts("Comando no reconocido. Por favor, intente de nuevo.")
    mostrar_menu(usuario)
  end

  defp limpiar_consola do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())
  end

  def datos_prueba() do
     equipo1=GestionTeams.createTeam("EquipoPrueba", ["juan", "pedro"],"TemaPrueba")
    equipo2=GestionTeams.createTeam("EquipoPrueba", ["ana", "maria"],"OtroTema")
    IO.inspect(equipo1)
    IO.inspect(equipo2)
  end
end
Main.run()
