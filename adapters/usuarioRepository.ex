defmodule UsuarioRepository do
  @archivo "data/repositoryusuarios.csv"

    def saveUsuario(%{nombre: nombre, email: email, contrasena: contrasena, id: id, teams_id: []}) do
      header= "nombre,email,contrasena,id,teams_id\n"
      equipos=Enum.join([], ";")
      case File.exists?(@archivo) do
        true -> File.write(@archivo,"#{nombre},#{email},#{contrasena},#{id},#{equipos}\n", [:append])
        false -> File.write(@archivo,header <> "#{nombre},#{email},#{contrasena},#{id},#{equipos}\n", [:append])
      end
    end

  def actualizar_usuario(usuario_actualizado) do
    usuarios = listarUsuarios()
    nuevos_usuarios =
      Enum.map(usuarios, fn usuario ->
        if usuario.id == usuario_actualizado.id, do: usuario_actualizado, else: usuario
      end)
    header = "nombre,email,contrasena,id,teams_id\n"
    contenido =
      nuevos_usuarios
      |> Enum.map(fn u ->
        equipos = Enum.join(u.teams_id || [], ";")
        "#{u.nombre},#{u.email},#{u.contrasena},#{u.id},#{equipos}"
      end)
      |> Enum.join("\n")
    File.write(@archivo, header <> contenido <> "\n")
  end


  def listarUsuarios() do
    File.read(@archivo)
    |> case do
      {:ok, contenido} ->
        String.split(contenido , "\n",  trim: true)
        |>Enum.map(fn fila ->[nombre,email,contrasena,id,teams_id]=String.split(fila,",")
          %Usuario{nombre: nombre, email: email, contrasena: contrasena, id: id, teams_id: String.split(teams_id,";")}
        end)
        |> Enum.drop(1)
      {:error, _reason} -> []
    end
  end

  def obtener_usuario_id(id_buscar) do
    listarUsuarios()
    |> Enum.find(fn usuario -> usuario.id == id_buscar end)
  end
end
