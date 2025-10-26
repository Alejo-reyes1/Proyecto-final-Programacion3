defmodule ValidacionesUsuario do

  def usuario_existente?(email) do
    UsuarioRepository.listarUsuarios()
    |> Enum.any?(fn usuario -> usuario.email==email end)
    |>case do
      true -> true
      false -> false
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
