defmodule GestionUsuario do

  def crear_usuario(nombre, email,contrasena) do
    if String.contains?(email,"@") and String.contains?(email,".") do
      Usuario.create_usuario(nombre, email,contrasena)
      |> case do
        {:ok, mensaje } -> {:ok, mensaje }
        {:error, error_msg} -> {:error, error_msg}
    end
    else
      {:error, "El email proporcionado no es valido."}
    end
  end

  def iniciar_sesion(email, contrasena) do
    Usuario.autenticar_usuario(email, contrasena)
    |> case do
      {:ok, usuario} -> {:ok, usuario}
      {:error, error_msg} -> {:error, error_msg}
    end
  end

  def usuario_en_equipo(usuario,nombre_team) do
    ValidacionesUsuario.usuario_en_team(usuario,nombre_team)
    |> case do
      {:ok, msg} -> {:ok, msg}
      {:error, msg} -> {:error, msg}
    end
  end

end
