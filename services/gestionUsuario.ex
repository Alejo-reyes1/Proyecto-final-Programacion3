defmodule GestionUsuario do

  def crear_usuario(nombre, email,contrasena) do
    Usuario.create_usuario(nombre, email,contrasena)
    |> case do
      {:ok, mensaje } -> {:ok, mensaje }
      {:error, error_msg} -> {:error, error_msg}
    end
  end

  def iniciar_sesion(email, contrasena) do

  end

end
