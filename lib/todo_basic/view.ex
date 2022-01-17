defmodule TodoBasic.View do
  alias TodoBasic.Main
  @file_path "lib/todo_basic/todo.json"

  @doc """
  Print out the current todo list
  """
  def view() do
    IO.puts "\n\nTodo List"
    IO.puts "---------"

    # Get todo list file contents and decode
    json = File.read!(@file_path)
    todo = Poison.decode!(json)

    print_todo(todo)
    IO.gets "\n\nPress Enter to Return to Main Menu"
    Main.run()
  end

  @doc """
  List view accessed by non-view module
  """
  def view_list() do
    IO.puts "\n\nTodo List"
    IO.puts "---------"
    json = File.read!(@file_path)
    todo = Poison.decode!(json)
    print_todo(todo)
  end

  # Prints out each item in the todo list
  defp print_todo([head | tail]) do
    IO.puts ~s(#{head["id"]}: [#{head["status"]}] | #{head["item"]})
    print_todo(tail)
  end

  # Final condition
  defp print_todo([]), do: ""


  @doc """
  Gets the max id number from the todo list
  """
  def get_highest_id() do
    json = File.read!(@file_path)
    todo = Poison.decode!(json)

    case todo do
      [_ | _] -> [head | _] =  Enum.reverse(todo); head["id"]
      [] -> 0
    end
  end
end
