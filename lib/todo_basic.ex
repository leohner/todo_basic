defmodule TodoBasic do
  alias TodoBasic.Main

  @doc """
  Main access point for the application
  """
  def run() do
    Main.run(:new)
  end
end
