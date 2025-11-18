defmodule Usuario do
  defstruct [:nombre, :email, :contrasena, :id, :teams_id]

  def create_usuario(nombre, email, contrasena) do
    user_exist=ValidacionesUsuario.usuario_existente?(email)
    |> case do
      true -> {:error, "El usuario con email #{email} ya existe."}
      false -> id=generar_id()
      %Usuario{nombre: nombre, email: email, contrasena: contrasena, id: "#{id}US", teams_id: []}
      |> UsuarioRepository.saveUsuario()
      {:ok, "El usuario #{nombre} ha sido creado con ID #{id}"}
    end
  end

  def autenticar_usuario(email, contrasena) do
    ValidacionesUsuario.validar_usuario(email,contrasena)
    |> case do
      {:ok, usuario} -> {:ok, usuario}
      {:error, error_msg} -> {:error, error_msg}
    end
  end


  defp generar_id do
    UsuarioRepository.listarUsuarios()
    |>case  do
      [] -> 1
      usuarios -> Enum.reduce(usuarios, 0, fn usuario, acc ->
        String.replace(usuario.id,"US","") |>String.to_integer() |> max(acc)
      end)+1
    end
  end
end
