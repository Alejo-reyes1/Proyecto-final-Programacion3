defmodule NodoCliente do
  @cookie :team_cookie
  @nombre_proceso :servicio_chat

  def iniciar_chat(id_team, usuario) do
    IO.puts("Se inicia el cliente para el chat del equipo #{id_team}")
    iniciar_nodo(usuario)
    nodo_servidor =String.to_atom("#{id_team}@#{obtener_ip()}")
    if Node.connect(nodo_servidor) do #Nodo servidor
      IO.puts("Conectado al servidor del chat.")
      spawn(fn ->
        send({@nombre_proceso, nodo_servidor}, {:nuevo_cliente, self()})
        :timer.sleep(500) # Esperar a que el servidor registre al cliente
        esperar_mensajes()
      end)
      IO.puts("Puedes empezar a enviar mensajes. Escribe '/exit' para salir del chat.")
      escribir_mensajes(id_team, usuario.nombre)
    else
      IO.puts("No se pudo conectar con el servidor.")
    end
  end

  defp iniciar_nodo(usuario) do
    nombre_nodo = String.to_atom("#{usuario.id}@#{obtener_ip()}")
    Node.start(nombre_nodo)
    Node.set_cookie(@cookie)
  end

  defp esperar_mensajes() do
    receive do
      {:mensaje, emisor, mensaje} ->
        IO.puts("[#{emisor}]: #{mensaje}")
        esperar_mensajes()

      :fin ->
        IO.puts("El servidor finalizó la conexión.")

      otro ->
        IO.puts("Mensaje desconocido: #{inspect(otro)}")
        esperar_mensajes()
    end
  end

  defp escribir_mensajes(id_team, usuario_nombre) do
    mensaje = IO.gets(">>") |> String.trim()
    if mensaje != "/exit" do
      enviar_mensaje(id_team, usuario_nombre, mensaje)
      escribir_mensajes(id_team, usuario_nombre)
    else
      nodo_servidor=String.to_atom("#{id_team}@#{obtener_ip()}")
      send({@nombre_proceso, nodo_servidor}, {:salir, self()})
      IO.puts("Has salido del chat.")
    end
  end

  defp enviar_mensaje(id_team, usuario_nombre, mensaje) do
    nodo_servidor =String.to_atom("#{id_team}@#{obtener_ip()}")
    send({@nombre_proceso, nodo_servidor}, {:mensaje, usuario_nombre, mensaje})
  end


  defp obtener_ip do
    {:ok, interfaces} = :inet.getif()
    # Tomar la primera interfaz no loopback
    {ip, _, _} = Enum.find(interfaces, fn {ip, _, _} -> ip != {127,0,0,1} end)
    ip |> Tuple.to_list() |> Enum.join(".")
  end

end
