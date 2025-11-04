defmodule GestionTeams do

  def createTeam(nombre, usuario,tema) do
    Team.createTeam(nombre, [usuario.id],tema)
    |> case do
      {:ok, msg} -> asociar_team_usuario(nombre, usuario)
                    {:ok, msg}
      {:error, msg} -> {:error, msg}
    end
  end

  def asociar_team_usuario(nombre_team, participante) do
    teams=TeamRepository.listarTeams()
    team=Enum.find(teams, fn t ->String.trim(t.nombre)==String.trim(nombre_team)end)
    usuario_modificado = %{participante | teams_id: participante.teams_id ++ [team.id]}
    UsuarioRepository.actualizar_usuario(usuario_modificado)
  end

  def listarTeams() do
    Team.listarTeams()
  end

end
