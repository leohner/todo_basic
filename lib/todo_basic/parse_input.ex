defmodule TodoBasic.ParseInput do
  alias TodoBasic.Main
  alias TodoBasic.View
  alias TodoBasic.Add
  alias TodoBasic.Delete


  ## Parse Main Menu Options

  @doc """
  Take user input and direct to the next step
  """
  def parse_main_menu_input(option) do
      option
        |> Integer.parse()
        # menu has options 1 through 6; anything else in invalid
        |> parse_option(1, 6)
        |> menu_next_step()
  end

  @doc """
  Map user input to todo functions
  """
  def menu_next_step({status, number}) when status == :ok do
    case number do
      1 -> View.view()
      2 -> Add.add()
      3 -> Update.update()
      4 -> Delete.delete()
      5 -> Delete.delete_all()
      6 -> IO.puts "\n*** Thank you for using Todo List! ***\n"; Exit
    end
  end

  def menu_next_step(_) do
    # repeat
    Main.run()
  end



  ## Parse Add Option

  def parse_add_input(option) do
    {status, number} =
        option
          |> Integer.parse()
          |> parse_option(1, 3)

    case status do
      :error ->
        Add.print_status_menu();
        status = IO.gets "\nStatus Number: ";
        parse_add_input(status)
      :ok -> process_status(number)
    end
  end

  def process_status(number) do
    number
      |> convert_to_status()
  end

  def convert_to_status(number) do
    case number do
      1 -> "Not Started"
      2 -> "In Progress"
      3 -> "Completed"
      _ -> "Invalid"
    end
  end


  ## Parse Delete Option
  def parse_delete_input(option, max) do
    {status, number} =
      option
        |> Integer.parse()
        |> parse_option(1, max)

    case status do
      :ok -> number
      :error -> Delete.delete()
    end
  end


  ## Parse Update Option

  def parse_update_input(option, max) do
    {status, number} =
      option
        |> Integer.parse()
        |> parse_option(1, max)

    case status do
      :ok -> number
      :error -> Update.update()
    end
  end


  def parse_update_option(option) do
    option = String.trim(option)

    case option do
      "1" -> :ok
      "2" -> :ok
      _ ->
        IO.puts "\n*** Invalid Option ***\n"
        Update.update()
    end
  end


  ## General Parse Option Functions

  @doc """
  Take the data from Integer.parse and compare it with the supplied min and max
  """
  def parse_option({number, _}, min, max)
        when number >= min
        and number <= max do
    {:ok, number}
  end

  # A non-number entered
  def parse_option(:error, _, _) do
    IO.puts "\n*** Please enter a number ***\n"
    {:error, nil}
  end

  # An invalid number entered
  def parse_option(_, _, _) do
    IO.puts "\n*** Invalid option ***\n"
    {:error, nil}
  end

end
