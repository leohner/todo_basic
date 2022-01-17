defmodule TodoBasic.Add do
  @file_path "lib/todo_basic/todo.json"

  alias TodoBasic.Main
  alias TodoBasic.ParseInput, as: Parse

  @doc """
  Initial access point for the add module
  """
  def add() do
    add_step_1()
  end

  # Prompt user for todo item text
  defp add_step_1() do
    IO.puts "\n\nAdd Todo Item"
    item = IO.gets "Item Name: "
    item = String.trim(item, "\n")
    add_step_2(item)
  end

  # Print status list and get status from user
  defp add_step_2(item) do
    get_status_list()
      |> print_status_menu()

    status = IO.gets "\nStatus Number: "
    status = Parse.parse_add_input(status)
    add_entry(item, status)
    IO.puts "\n\n*** Todo Item Added ***\n\n"
    Main.run()
  end

  # Add the item to the list, convert to json, and write to the file
  defp add_entry(item, status) do
    json = File.read!(@file_path)
    todo = Poison.decode!(json)
    id = get_next_id(todo)

    new_todo = Enum.concat([%{"id" => id, "item" => item, "status" => status}], Enum.reverse(todo))
    Enum.reverse(new_todo)
    new_json = new_todo |> Enum.reverse |> Poison.encode!()

    File.write!(@file_path, new_json)
  end

  # Gets the list of statuses
  defp get_status_list() do
    [
      "\nChoose Item Status",
      "1. Not Started",
      "2. In Progress",
      "3. Completed"
    ]
  end

  @doc """
  Prints the status menu; accessed by non-add module
  """
  def print_status_menu() do
    get_status_list()
      |> print_status_menu
  end

  # Take the status list and print out each option
  defp print_status_menu([head | tail]) do
    IO.puts head
    print_status_menu(tail)
  end

  # Final condition
  defp print_status_menu(_) do
    ""
  end


  # Returns the next id to be used in the todo item sequence
  defp get_next_id(todo_list) when todo_list != [] do
    [head | _] = Enum.reverse(todo_list)
    head["id"] + 1
  end

  # If no todo list exists yet, the next id has to be 1
  defp get_next_id(_) do
    1
  end
end
