defmodule Update do
  @file_path "lib/todo_basic/todo.json"

  alias TodoBasic.Main
  alias TodoBasic.Add
  alias TodoBasic.View
  alias TodoBasic.ParseInput, as: Parse

  @doc """
  Initial access point for update functions
  """
  def update() do
    run_update_step_1()
  end

  # Checks for items to update and proceeds accordingly
  defp run_update_step_1() do
    View.view_list()
    highest_id = View.get_highest_id()


    case highest_id do
      # If the highest id is 0...
      0 ->
        IO.puts "\n*** No Todo Items to Update ***"
        Main.run()

      # If the highest id is anything but 0...
      _ ->
        # Prompt the user to select an item and proceed
        input = IO.gets "\nSelect an item to update: "
        item_number = Parse.parse_update_input(input, highest_id)

        choice = IO.gets "\nEnter 1 to update item. Enter 2 to update status: "
        choice = String.trim(choice)

        case choice do
          "1" -> update_item_text(item_number)
          "2" -> update_item_status(item_number)
          _ -> update()
        end
    end
  end

  # Update text for a specified item id
  defp update_item_text(item_id) do
    json = File.read!(@file_path)
    todo = Poison.decode!(json)

    update_text = IO.gets "\nNew Item Text: "
    update_text = String.trim(update_text)

    item = Enum.find(todo, fn x -> x["id"] == item_id end )
    item = %{ item | "item" => update_text }

    new_todo = replace_item(todo, item)
    json = Poison.encode!(new_todo)
    File.write!(@file_path, json)

    IO.puts "\n*** Item Text Updated ***\n"
    Main.run()
  end

  # Update status for a specified item id
  defp update_item_status(item_number) do
    json = File.read!(@file_path)
    todo = Poison.decode!(json)

    Add.print_status_menu()

    new_status = IO.gets "\nNew Item Status: "
    new_status = String.trim(new_status)

    case new_status do
      n when n in ["1", "2", "3"] ->
        # We know Integer.parse will work, so need to check output; get corresponding status text
        {stat_num, _} = Integer.parse(new_status)
        status_text = Parse.convert_to_status(stat_num)

        # Retrieve the item associated with the provided id and create a new item with the updated status
        item = Enum.find(todo, fn x -> x["id"] == item_number end)
        item = %{ item | "status" => status_text }

        # Replace the item in the todo list and update the file
        new_todo = replace_item(todo, item)
        json = Poison.encode!(new_todo)
        File.write!(@file_path, json)
        IO.puts "\n*** Item Status Updated ***\n"
        Main.run()

      # If invalid option selected, re-run the update sequence
      _ -> update()
    end

    #IO.inspect new_status
    #new_text = String.trim(new_status)
  end

  # Function header for replace item
  defp replace_item(todo_list, item, new_todo_list \\ [])

  # Loop through items and replace where item id matches the in the item
  defp replace_item([head | tail], item, new_todo_list) do
    id = item["id"]

    case head["id"] do
      ^id -> replace_item(tail, item, [item | new_todo_list])
      _ -> replace_item(tail, item, [head | new_todo_list])
    end
  end

  # Reverse the new todo list and return it
  defp replace_item([], _, new_todo_list) do
    Enum.reverse(new_todo_list)
  end
end
