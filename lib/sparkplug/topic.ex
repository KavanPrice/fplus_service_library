defmodule Sparkplug.Topic do
  defmodule TopicType do
    @type t ::
            :Any
            | :NBIRTH
            | :NCMD
            | :NDATA
            | :NDEATH
            | :DBIRTH
            | :DCMD
            | :DDATA
            | :DDEATH

    @spec to_string(t()) :: String.t()
    def to_string(topic_type) do
      case topic_type do
        :Any -> "+"
        :NBIRTH -> "NBIRTH"
        :NCMD -> "NCMD"
        :NDATA -> "NDATA"
        :NDEATH -> "NDEATH"
        :DBIRTH -> "DBIRTH"
        :DCMD -> "DCMD"
        :DDATA -> "DDATA"
        :DDEATH -> "DDEATH"
      end
    end

    @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
    def from_string(topic_type_string) do
      case topic_type_string do
        "+" -> {:ok, :Any}
        "NBIRTH" -> {:ok, :NBIRTH}
        "NCMD" -> {:ok, :NCMD}
        "NDATA" -> {:ok, :NDATA}
        "NDEATH" -> {:ok, :NDEATH}
        "DBIRTH" -> {:ok, :DBIRTH}
        "DCMD" -> {:ok, :DCMD}
        "DDATA" -> {:ok, :DDATA}
        "DDEATH" -> {:ok, :DDEATH}
        _ -> {:error, "Couldn't parse topic type."}
      end
    end
  end

  @type t :: %__MODULE__{
          prefix: String.t(),
          address: Sparkplug.Address.t(),
          topic_type: Sparkplug.Topic.TopicType.t()
        }
  defstruct [:prefix, :address, :topic_type]

  @spec to_string(t()) :: String.t()
  def to_string(topic) do
    device_path =
      case topic.address.address_type do
        {:device, device_name} -> "/" <> device_name
        :node -> ""
      end

    topic_type_string = __MODULE__.TopicType.to_string(topic.topic_type)

    topic.prefix <>
      "/" <>
      topic.address.group <>
      "/" <>
      topic_type_string <>
      "/" <>
      topic.address.node <>
      device_path
  end

  @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_string(topic_string) do
    topic_parts = String.split(topic_string, "/")

    target_sp_prefix = Sparkplug.Address.sp_prefix()

    case topic_parts do
      [sp_prefix, group_string, topic_type_string, node_string, device_string]
      when sp_prefix == target_sp_prefix ->
        address = %Sparkplug.Address{
          group: group_string,
          node: node_string,
          address_type: {:device, device_string}
        }

        case __MODULE__.TopicType.from_string(topic_type_string) do
          {:ok, topic_type} ->
            %__MODULE__{
              prefix: sp_prefix,
              address: address,
              topic_type: topic_type
            }

          {:error, message} ->
            {:error, "Error parsing string to topic: #{message}"}
        end

      [sp_prefix, group_string, topic_type_string, node_string]
      when sp_prefix == target_sp_prefix ->
        address = %Sparkplug.Address{
          group: group_string,
          node: node_string,
          address_type: :node
        }

        case __MODULE__.TopicType.from_string(topic_type_string) do
          {:ok, topic_type} ->
            %__MODULE__{
              prefix: sp_prefix,
              address: address,
              topic_type: topic_type
            }

          {:error, message} ->
            {:error, "Error parsing string to topic: #{message}"}
        end

      _ ->
        {:error, "Error parsing string to topic."}
    end
  end
end
