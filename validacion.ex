defmodule Validacion do
  @moduledoc """
  Módulo de validación pura de lotes (Regla 1).
  """

  def validar_lote(lote, confeccionistas_map, lineas_map) do
    with :ok <- verificar_confeccionista(lote[:confeccionista], confeccionistas_map),
         :ok <- verificar_linea(lote[:linea], lineas_map),
         :ok <- verificar_dia(lote[:dia]),
         :ok <- verificar_prendas(lote[:prendas]),
         :ok <- verificar_defectos(lote[:defectos]) do
      {:ok, lote}
    else
      {:error, motivo} -> {:error, motivo}
    end
  end

  defp verificar_confeccionista(codigo, confeccionistas_map) do
    if is_binary(codigo) and Map.has_key?(confeccionistas_map, codigo) do
      :ok
    else
      {:error, :confeccionista_desconocido}
    end
  end

  defp verificar_linea(linea_id, lineas_map) do
    if is_binary(linea_id) and Map.has_key?(lineas_map, linea_id) do
      :ok
    else
      {:error, :linea_desconocida}
    end
  end

  defp verificar_dia(dia) do
    if is_integer(dia) and dia >= 1 and dia <= 6 do
      :ok
    else
      {:error, :dia_invalido}
    end
  end

  defp verificar_prendas(prendas) do
    if is_integer(prendas) and prendas >= 1 and prendas <= 180 do
      :ok
    else
      {:error, :prendas_fuera_de_rango}
    end
  end

  defp verificar_defectos(defectos) do
    if is_number(defectos) and defectos >= 0 and defectos <= 100 do
      :ok
    else
      {:error, :porcentaje_invalido}
    end
  end
end
