defmodule FplusServiceLibraryTest do
  use ExUnit.Case
  doctest FplusServiceLibrary

  test "services to uuids" do
    assert FplusServiceLibrary.ServiceType.to_uuid(:auth) ==
             "cab2642a-f7d9-42e5-8845-8f35affe1fd4"

    assert FplusServiceLibrary.ServiceType.to_uuid(:commands) ==
             "78ea7071-24ac-4916-8351-aa3e549d8ccd"

    assert FplusServiceLibrary.ServiceType.to_uuid(:configdb) ==
             "af15f175-78a0-4e05-97c0-2a0bb82b9f3b"

    assert FplusServiceLibrary.ServiceType.to_uuid(:directory) ==
             "af4a1d66-e6f7-43c4-8a67-0fa3be2b1cf9"

    assert FplusServiceLibrary.ServiceType.to_uuid(:mqtt) ==
             "feb27ba3-bd2c-4916-9269-79a61ebc4a47"
  end

  test "successful services from uuids" do
    assert FplusServiceLibrary.ServiceType.from_uuid("cab2642a-f7d9-42e5-8845-8f35affe1fd4") ==
             {:ok, :auth}

    assert FplusServiceLibrary.ServiceType.from_uuid("78ea7071-24ac-4916-8351-aa3e549d8ccd") ==
             {:ok, :commands}

    assert FplusServiceLibrary.ServiceType.from_uuid("af15f175-78a0-4e05-97c0-2a0bb82b9f3b") ==
             {:ok, :configdb}

    assert FplusServiceLibrary.ServiceType.from_uuid("af4a1d66-e6f7-43c4-8a67-0fa3be2b1cf9") ==
             {:ok, :directory}

    assert FplusServiceLibrary.ServiceType.from_uuid("feb27ba3-bd2c-4916-9269-79a61ebc4a47") ==
             {:ok, :mqtt}
  end

  test "unsuccessful service from uuid" do
    assert match?({:error, _}, FplusServiceLibrary.ServiceType.from_uuid("not a uuid"))
  end
end
