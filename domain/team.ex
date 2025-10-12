defmodule Team do
  defstruct [:nombre, :participantes,:id]

  def createTeam(nombre,participantes) do
    validacion=CheckTeam.checkTeamName(nombre)
    case validacion do
      {:ok, _msg} ->
        id=generar_id()
        %Team{nombre: nombre, participantes: participantes, id: id}
        |> TeamRepository.saveTeam()
      {:error, msg} -> {:error, msg}
  end
end

  defp generar_id do
    :erlang.unique_integer([:positive, :monotonic])
  end
end
