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


  defp generar_id do
    :erlang.unique_integer([:positive, :monotonic])
    |> Integer.to_string()
  end
end
