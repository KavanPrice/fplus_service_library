defmodule FplusServiceLibrary do
  @moduledoc """
  Documentation for `FplusServiceLibrary`.
  """

  defmodule ServiceType do
    @moduledoc """
    Defines the Factory+ service types and handles conversion between Factory+
    services and UUIDs.
    """
    @type t ::
            :auth
            | :commands
            | :configdb
            | :directory
            | :mqtt

    @doc """
    Converts a service to its corresponding UUId.
    """
    @spec to_uuid(t()) :: String.t()
    def to_uuid(service_type) do
      case service_type do
        :auth -> FactoryPlus.Uuids.Service.auth()
        :commands -> FactoryPlus.Uuids.Service.commands()
        :configdb -> FactoryPlus.Uuids.Service.config_db()
        :directory -> FactoryPlus.Uuids.Service.directory()
        :mqtt -> FactoryPlus.Uuids.Service.mqtt()
      end
    end

    @doc """
    Attempts to convert a UUID to its corresponding service.
    """
    @spec from_uuid(String.t()) :: {:ok, t()} | {:error, String.t()}
    def from_uuid(uuid) do
      cond do
        uuid == FactoryPlus.Uuids.Service.auth() -> {:ok, :auth}
        uuid == FactoryPlus.Uuids.Service.commands() -> {:ok, :commands}
        uuid == FactoryPlus.Uuids.Service.config_db() -> {:ok, :configdb}
        uuid == FactoryPlus.Uuids.Service.directory() -> {:ok, :directory}
        uuid == FactoryPlus.Uuids.Service.mqtt() -> {:ok, :mqtt}
        true -> {:error, "No service type corresponding to the given uuid: " <> uuid <> "."}
      end
    end
  end
end
