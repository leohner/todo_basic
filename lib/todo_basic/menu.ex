defmodule TodoBasic.Menu do
  def list_main_menu() do
    get_menu_list()
      |> print_menu
  end

  def get_menu_list() do
    [
      "1. View List",
      "2. Add Item",
      "3. Update Item",
      "4. Delete Item",
      "5. Delete Todo List",
      "6. Exit Todo"
    ]
  end

  def print_menu([head | tail]) do
    IO.puts head
    print_menu(tail)
  end

  def print_menu(_) do
    ""
  end
end
