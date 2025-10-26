defmodule Usuario do
  defstruct [:nombre, :email, :contrasena, :id]

  def create_usuario(nombre, email, contrasena) do
    user_exist=ValidacionesUsuario.usuario_existente?(email)
    |> case do
      true -> {:error, "El usuario con email #{email} ya existe."}
      false -> id=generar_id()
      %Usuario{nombre: nombre, email: email, contrasena: contrasena, id: "#{id}US"}
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
    |> case do
      [] -> 1
      usuarios -> Enum.max(usuarios)+1
    end
  end
end
