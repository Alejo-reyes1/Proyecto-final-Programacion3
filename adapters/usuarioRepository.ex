defmodule UsuarioRepository do
  @archivo "usuarios.csv"

    def saveUsuario(%{nombre: nombre, email: email, contrasena: contrasena, id: id}) do
      header= "nombre,email,contrasena,id\n"
      case File.exists?(@archivo) do
        true -> File.write(@archivo,"#{nombre},#{email},#{contrasena},#{id}\n", [:append])
        false -> File.write(@archivo,header <> "#{nombre},#{email},#{contrasena},#{id}\n", [:append])
      end
    end

  def listarUsuarios() do
    File.read(@archivo)
    |> case do
      {:ok, contenido} ->
        String.split(contenido , "\n",  trim: true)
        |>Enum.map(fn fila ->[nombre,email,contrasena,id]=String.split(fila,",")
          %Usuario{nombre: nombre, email: email, contrasena: contrasena, id: id}
        end)
        |> Enum.drop(1)
      {:error, _reason} -> []
    end
  end
end
