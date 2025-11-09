defmodule ValidacionesUsuario do

  def usuario_existente?(email) do
    UsuarioRepository.listarUsuarios()
    |> Enum.any?(fn usuario -> usuario.email==email end)
    |>case do
      true -> true
      false -> false
    end
  end

  def usuario_en_team(usuario, nombre_team) do
    teams = TeamRepository.listarTeams()
    team = Enum.find(teams, fn t -> String.trim(t.nombre) == String.trim(nombre_team) end)
    if team do
      if usuario.id in team.participantes do
        {:ok, "El usuario pertenece al equipo #{nombre_team}."}
      else
        {:error, "El usuario no pertenece al equipo #{nombre_team}."}
      end
    else
      {:error, "El equipo #{nombre_team} no existe."}
    end
  end

  def validar_usuario(email, contrasena) do
    UsuarioRepository.listarUsuarios()
    |> Enum.find( fn usuario ->
      String.trim(usuario.email) == String.trim(email) and
      String.trim(usuario.contrasena) == String.trim(contrasena)
    end)
    |> case do
      nil -> {:error, "Credenciales invalidas"}
      usuario -> {:ok, usuario}
    end
  end
end
