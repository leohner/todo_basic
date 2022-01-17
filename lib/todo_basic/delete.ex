defmodule TodoBasic.Delete do
  @file_path "lib/todo_basic/todo.json"

  alias TodoBasic.Main
  alias TodoBasic.View
  alias TodoBasic.ParseInput, as: Parse

  @doc """
  Initial access point for delete function
  """
  def delete() do
    delete_step_1()
  end

  # Display list of todos, get the max id from the list, and proceed as necessary
  defp delete_step_1() do
    View.view_list()
    highest_id = View.get_highest_id()

    case highest_id do
      0 ->
        # No items in list; return to main menu
        IO.puts "\n*** No Todo Items to Delete ***"
        Main.run()
      _ ->
        # Prompt user for item number in list and parse it
        selected_number = IO.gets "\nSelect a Number to Delete: "
        item_number = Parse.parse_delete_input(selected_number, highest_id)

        # Delete item with specified id and convert to json
        new_todo = delete_item(item_number)
        new_json = Poison.encode!(new_todo)

        # Write new json todo list to file and return to main menu
        File.write!(@file_path, new_json)
        IO.puts "\n*** Item Deleted ***\n"
        Main.run()
    end
  end

  # Deletes item from list based on id
  defp delete_item(number) do
    # Get list
    json = File.read!(@file_path)
    todo = Poison.decode!(json)

    # Create a new todo with the specified item id removed (rejected)
    new_todo = Enum.reject(todo, fn item -> item["id"] == number end)

    # Update the numbering for the list to account for the deletion
    renumber(new_todo, 1, [])
  end


  # Reset the number, create new lsit, and loop until all entries are renumbered
  defp renumber([head | tail], next_value, new_list) do
    new_item = %{ head | "id" => next_value }
    new_list = Enum.concat([new_item], new_list)
    renumber(tail, next_value + 1, new_list)
  end

  # Exit renumber function; return reversed renumbered todo list (to order in ascending order)
  defp renumber([], _new_value, new_list) do
    Enum.reverse(new_list)
  end


  ## Delete All

  @doc """
  Initial access point for deleting all records in the todo list
  """
  def delete_all() do
    delete_all_step_1()
  end

  # Prompt user for confirmation
  defp delete_all_step_1() do
    input = IO.gets "Type 'yes' to delete all todo items. Type anything else to return to main menu: "
    input = String.trim(input)

    case input do
      # if user typed yes...
      "yes" -> run_delete_all()
      # return to menu for any other input
      _ -> Main.run()
    end
  end

  # Writes an empty list to the json file and returns to the main menu
  defp run_delete_all() do
    File.write!(@file_path, "[]")
    IO.puts "\n\n*** All Todo Items Deleted **\n"
    Main.run()
  end
end
