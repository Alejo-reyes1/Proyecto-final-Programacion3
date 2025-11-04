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
    CheckTeam.checkTeamName(nombre_team)
    |> case do
      {:ok, _msg} -> {:error, "El equipo #{nombre_team} no existe."}
      {:error, _msg} -> teams=TeamRepository.listarTeams()
      team=Enum.find(teams, fn t ->String.trim(t.nombre)==String.trim(nombre_team)end)
      if team.id in participante.teams_id do
        {:error, "El usuario ya pertenece al equipo #{nombre_team}."}
      else
        usuario_modificado = %{participante | teams_id: participante.teams_id ++ [team.id]}
        UsuarioRepository.actualizar_usuario(usuario_modificado)
        {:ok, "El usuario se ha unido al equipo #{nombre_team} exitosamente."}
      end
    end
  end

  def listarTeams() do
    Team.listarTeams()
  end

end
