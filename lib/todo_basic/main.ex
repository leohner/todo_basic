defmodule TodoBasic.Main do
  alias TodoBasic.ParseInput, as: Parse
  alias TodoBasic.Menu

  @doc """
  Displays the Main Menu and gets user input
  """
  def run(option \\ :repeat) do
    case option do
      :new -> IO.puts "\nWelcome to the Todo List!"
      _ -> IO.puts "\n\nMain Menu\n---------"
    end

    Menu.list_main_menu()
    get_user_option()
      # Sends the user input to be parsed
      |> Parse.parse_main_menu_input()
  end

  @doc """
  Gets user input for the main menu
  """
  def get_user_option() do
    IO.gets "\nChoose an option: "
  end
end
