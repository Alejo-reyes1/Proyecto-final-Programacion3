defmodule UsuarioRepository do
  @archivo "usuarios.csv"

  def saveUsuario(%{nombre: nombre, email: email, contrasena: contrasena, id: id}) do
    File.write(@archivo, "#{nombre},#{email},#{contrasena},#{id}\n", [:append])
  end

  def listarUsuarios() do
    File.read(@archivo)
    |> case do
      {:ok, contenido} ->
        String.split(contenido , "\n",  trim: true)
        |>Enum.map(fn fila ->[nombre , email, contrasena,id]=String.split(fila,",")
          %Usuario{nombre: nombre, email: email, contrasena: contrasena, id: id}
        end)
      {:error, _reason} -> []
    end
  end
end
