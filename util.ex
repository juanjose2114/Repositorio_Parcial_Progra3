defmodule Util do
  @moduledoc """
  Módulo de funciones de entrada y salida (impuro).
  """

  def mostrar_mensaje(mensaje) do
    IO.puts(mensaje)
  end

  def ingresar_texto(mensaje) do
    mensaje
    |> IO.gets()
    |> to_string()
    |> String.trim()
  end

  def formatear_moneda(numero) do
    val = (numero || 0) * 1.0
    :erlang.float_to_binary(val, [decimals: 2])
  end
end
