defmodule NodoServidor do
  @cookie :team_cookie
  @nombre_proceso :servicio_chat

  def iniciar_servidor_chat(id_team) do
    iniciar_nodo(id_team)
    Process.register(self(), @nombre_proceso)
    loop([])
  end

  defp iniciar_nodo(id_team) do
    nodo_servidor=String.to_atom("#{id_team}@#{obtener_ip()}")
    Node.start(nodo_servidor)
    Node.set_cookie(@cookie)
  end

  defp loop(clientes) do
    receive do
      # Cuando un nuevo cliente se conecta
      {:nuevo_cliente, pid_cliente} ->
        # Agregarlo a la lista (si no estaba ya)
        nuevos_clientes = Enum.uniq([pid_cliente | clientes])
        loop(nuevos_clientes)

      # Cuando un cliente envía un mensaje
      {:mensaje, emisor, mensaje} ->
        Enum.each(clientes, fn pid ->
          send(pid, {:mensaje, emisor, mensaje})
        end)
        loop(clientes)

      # Cuando un cliente se desconecta
      {:salir, pid_cliente} ->
        nuevos_clientes = clientes -- [pid_cliente]
        loop(nuevos_clientes)

      # Finalizar
      :fin ->
        :ok

      _ ->
        loop(clientes)
    end
  end

  def obtener_ip do
  {:ok, interfaces} = :inet.getif()
  # Tomar la primera interfaz no loopback
  {ip, _, _} = Enum.find(interfaces, fn {ip, _, _} -> ip != {127,0,0,1} end)
  ip |> Tuple.to_list() |> Enum.join(".")
end
end
