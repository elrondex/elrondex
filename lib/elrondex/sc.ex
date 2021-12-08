defmodule Elrondex.Sc do
  alias Elrondex.{Account}

  @doc """
  Prepare map structure for pure SC function call
  Optional :caller and :value as options
  """
  def view_map_call(sc_address, func_name, args \\ [], opts \\ [])
      when is_binary(sc_address) and is_binary(func_name) do
    %{
      "scAddress" => sc_address,
      "funcName" => func_name,
      "args" => Enum.map(args, &hex_encode/1)
    }
    |> view_map_call_optional("caller", Keyword.get(opts, :caller))
    |> view_map_call_optional("value", Keyword.get(opts, :value))
  end

  defp view_map_call_optional(map, opt_param, nil) do
    map
  end

  defp view_map_call_optional(map, opt_param, opt_value) do
    Map.put(map, opt_param, opt_value)
  end

  def data_call(call, []) do
    call
  end

  def data_call(call, args) when is_list(args) do
    [call | Enum.map(args, &hex_encode/1)]
    |> Enum.join("@")
  end

  def hex_encode(value) when is_binary(value) do
    Base.encode16(value, case: :lower)
  end

  def hex_encode(value) when is_integer(value) do
    Integer.to_string(value, 16) |> String.downcase() |> hex_pad()
  end

  defp hex_pad(value) when is_binary(value) and value |> byte_size |> rem(2) == 0,
    do: value

  defp hex_pad(value) when is_binary(value),
    do: "0" <> value

  def parse_view_sc_response(%{"returnCode" => "ok", "returnData" => return_data} = response) do
    IO.inspect(response)
    {:ok, return_data}
  end

  def parse_view_sc_response(%{"returnCode" => return_code, "returnMessage" => return_message}) do
    # TODO map vs binary/string
    {:error, %{return_code: return_code, return_message: return_message}}
  end

  def parse_view_sc_response(response) do
    IO.inspect(response)
    {:error, response}
  end
end
