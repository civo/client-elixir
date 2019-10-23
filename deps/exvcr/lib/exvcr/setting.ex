defmodule ExVCR.Setting do
  @moduledoc """
  An module to store the configuration settings.
  """

  def get(key) do
    setup()
    :ets.lookup(table(), key)[key]
  end

  def set(key, value) do
    setup()
    :ets.insert(table(), {key, value})
  end

  def append(key, value) do
    set(key, [value | ExVCR.Setting.get(key)])
  end

  defp setup do
    if :ets.info(table()) == :undefined do
      :ets.new(table(), [:set, :public, :named_table])
      ExVCR.ConfigLoader.load_defaults
    end
  end

  defp table do
    if Application.get_env(:exvcr, :enable_global_settings) do
      :exvcr_setting
    else
      :"exvcr_setting#{inspect self()}"
    end
  end
end
