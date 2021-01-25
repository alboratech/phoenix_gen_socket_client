defmodule Phoenix.Channels.GenSocketClient.Serializer do
  @moduledoc """
  Describes the serializer interface used in `Phoenix.Channels.GenSocketClient`
  to encode/decode messages.
  """

  @doc "Invoked to decode the raw message."
  @callback decode_message(Phoenix.Channels.GenSocketClient.encoded_message(), Keyword.t()) ::
              Phoenix.Channels.GenSocketClient.message()

  @doc "Invoked to encode a socket message."
  @callback encode_message(Phoenix.Channels.GenSocketClient.message()) ::
              {:ok, Phoenix.Channels.GenSocketClient.Transport.frame()} | {:error, reason :: any}
end

defmodule Phoenix.Channels.GenSocketClient.Serializer.Json do
  @moduledoc "Json serializer for the socket client."
  @behaviour Phoenix.Channels.GenSocketClient.Serializer

  # -------------------------------------------------------------------
  # Phoenix.Channels.GenSocketClient.Serializer callbacks
  # -------------------------------------------------------------------

  @doc false
  def decode_message(encoded_message, _opts), do: Jason.decode!(encoded_message)

  @doc false
  def encode_message(message) do
    case Jason.encode(message) do
      {:ok, encoded} -> {:ok, {:text, encoded}}
      error -> error
    end
  end
end

defmodule Phoenix.Channels.GenSocketClient.Serializer.GzipJson do
  @moduledoc "Gzip+Json serializer for the socket client."
  @behaviour Phoenix.Channels.GenSocketClient.Serializer

  # -------------------------------------------------------------------
  # Phoenix.Channels.GenSocketClient.Serializer callbacks
  # -------------------------------------------------------------------

  @doc false
  def decode_message(encoded_message, _opts) do
    encoded_message
    |> :zlib.gunzip()
    |> Jason.decode!()
  end

  @doc false
  def encode_message(message) do
    case Jason.encode_to_iodata(message) do
      {:ok, encoded} -> {:ok, {:binary, :zlib.gzip(encoded)}}
      error -> error
    end
  end
end
