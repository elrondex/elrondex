defmodule Elrondex.Test do
  def pad(value) when rem(byte_size(value), 2) == 0 do
    value
  end

  def pad(value) do
    "0" <> value
  end
end
