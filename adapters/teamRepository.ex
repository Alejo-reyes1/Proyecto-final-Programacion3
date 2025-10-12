defmodule TeamRepository do
  @archivo "teams.csv"

  def saveTeam(%{nombre: nombre, participantes: participantes, id: id}) do
    miembros=Enum.join(participantes, ";")
    File.write(@archivo, "#{id},#{nombre},#{miembros}\n", [:append])
  end
end
