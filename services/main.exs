defmodule Main do
  alias CheckTeam
  alias TeamRepository
  alias Team

  def main do
    equipo1=Team.createTeam("EquipoPrueba", ["juan", "pedro"])
    equipo2=Team.createTeam("EquipoPrueba", ["ana", "maria"])
    IO.inspect(equipo1)
    IO.inspect(equipo2)
  end
end
Main.main()
