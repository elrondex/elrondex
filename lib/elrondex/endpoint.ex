defmodule Elrondex.Endpoint do
  @moduledoc """
  Endpoint abstraction to connect on Elrond Network.
  """
  # TODO Node type (proxy vs node, validator)  
  defstruct type: :proxy,
            url: nil,
            client: nil

  def new(type, url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON
    ]

    %__MODULE__{type: type, url: url, client: Tesla.client(middleware)}
  end
end
