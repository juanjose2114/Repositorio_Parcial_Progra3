defmodule Validacion do
  def validar_lotes(map_lotes, map_confeccionistas, map_lineas) do
    confeccionistas = map_confeccionistas
    lineas = map_lineas
    lotes = map_lotes

    Enum.reduce(lotes, {[], []}, fn lote, {lista_validos, lista_invalidos} ->
      resultado =
        with {:ok, lote} <- validar_confeccionista(lote, confeccionistas),
             {:ok, lote} <- validar_linea(lote, lineas),
             {:ok, lote} <- validar_dia(lote),
             {:ok, lote} <- validar_prendas_rango(lote),
             {:ok, lote} <- validar_porcentaje(lote) do
          {:ok, lote}
        end

      case resultado do
        {:ok, lote} ->
          {[{:ok, lote} | lista_validos], lista_invalidos}
        {:error, motivo, lote} ->
          {lista_validos, [{:error, motivo, lote} | lista_invalidos]}
      end
    end)
  end

  def validar_confeccionista(lote, confeccionistas) do
    if Enum.any?(confeccionistas, fn x -> x.codigo == lote.confeccionista end) do
      {:ok, lote}
    else
      {:error, :confeccionista_desconocido, lote}
    end
  end

  def validar_linea(lote, lineas) do
    if Enum.any?(lineas, fn x -> x.id == lote.linea end) do
      {:ok, lote}
    else
      {:error, :linea_desconocida, lote}
    end
  end

  def validar_dia(lote) do
    if is_integer(lote.dia) do
      if lote.dia >= 1 and lote.dia <= 6 do
        {:ok, lote}
      else
        {:error, :dia_invalido, lote}
      end
    else
      {:error, :dia_invalido, lote}
    end
  end

  def validar_prendas_rango(lote) do
    if is_integer(lote.prendas) do
      if lote.prendas >= 1 and lote.prendas <= 180 do
        {:ok, lote}
      else
        {:error, :prendas_fuera_de_rango, lote}
      end
    else
      {:error, :prendas_fuera_de_rango, lote}
    end
  end

  def validar_porcentaje(lote) do
    if is_float(lote.defectos) do
      if lote.defectos >= 0 and lote.prendas <= 100 do
        {:ok, lote}
      else
        {:error, :porcentaje_invalido, lote}
      end
    else
      {:error, :porcentaje_invalido, lote}
    end
  end
end
