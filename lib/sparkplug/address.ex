defmodule Sparkplug.Address do
  @moduledoc """
  Contains structs and functions for handling Sparkplug addresses.
  """

  @sp_prefix "spBv1.0"
  def sp_prefix, do: @sp_prefix

  defmodule AddressType do
    @type t :: :node | {:device, String.t()}

    @spec to_string(t()) :: String.t()
    def to_string(address) do
      case address do
        :node -> "N"
        {:device, _} -> "D"
      end
    end
  end

  @type t :: %__MODULE__{
          group: String.t(),
          node: String.t(),
          address_type: __MODULE__.AddressType.t()
        }
  defstruct [:group, :node, :address_type]

  @spec matches(t(), t()) :: boolean()
  def matches(address, other) do
    wild = fn p, a -> p == a || p == "+" end

    wild_address_type = fn p, a ->
      p == a || (p == {:device, "+"} && a != :node)
    end

    wild.(address.group, other.group) && wild.(address.node, other.node) &&
      wild_address_type.(address.address_type, other.address_type)
  end

  @spec is_device(t()) :: boolean()
  def is_device(address) do
    case address.type do
      {:device, _} -> true
      :node -> false
    end
  end

  @spec topic_kind(t()) :: String.t()
  def topic_kind(address) do
    __MODULE__.AddressType.to_string(address.address_type)
  end

  @spec to_topic(t(), Sparkplug.Topic.TopicType.t()) :: Sparkplug.Topic.t()
  def to_topic(address, topic_type) do
    %Sparkplug.Topic{
      prefix: @sp_prefix,
      address: address,
      topic_type: topic_type
    }
  end

  @spec to_string(t()) :: String.t()
  def to_string(address) do
    device_path =
      case address.address_type do
        {:device, device_name} -> "/" <> device_name
        :node -> ""
      end

    address.group <> "/" <> address.node <> device_path
  end

  @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_string(address_string) do
    case String.split(address_string, "/") do
      [group_string, node_string, device_string] ->
        {:ok,
         %__MODULE__{
           group: group_string,
           node: node_string,
           address_type: {:device, device_string}
         }}

      [group_string, node_string] ->
        {:ok, %__MODULE__{group: group_string, node: node_string, address_type: :node}}

      _ ->
        {:error, "Couldn't parse address string."}
    end
  end
end
