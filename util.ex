defmodule Util do
  @moduledoc """
  Módulo de utilidades para operaciones de entrada/salida (E/S) por consola
  y formateo numérico.
  """

  @doc """
  Imprime un mensaje en la salida estándar (consola).
  """
  def mostrar_mensaje(mensaje) do
    IO.puts(mensaje)
  end

  @doc """
  Solicita una entrada al usuario mostrando un mensaje y limpia los espacios en blanco.
  """
  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end

  @doc """
  Captura texto desde la consola, asegurando la conversión a `String` y eliminando saltos de línea.
  """
  def ingresar_texto(mensaje) do
    mensaje
    |> IO.gets()
    |> to_string()
    |> String.trim()
  end

  @doc """
  Convierte un número a formato de representación decimal flotante con 2 decimales.
  Maneja valores `nil` asignando 0.0 por defecto.
  """
  def formatear_moneda(numero) do
    val = (numero || 0) * 1.0
    :erlang.float_to_binary(val, [decimals: 2])
  end
end
