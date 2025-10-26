defmodule ValidacionesUsuario do

  def usuario_existente?(email) do
    UsuarioRepository.listarUsuarios()
    |> Enum.any?(fn usuario -> usuario.email==email end)
    |>case do
      true -> true
      false -> false
    end
  end
end
