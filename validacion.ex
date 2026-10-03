defmodule Validacion do

  def validar_lotes(lotes, confeccionistas, lineas) do
    resultados = Enum.map(lotes, fn lote -> {lote, validar_lote(lote, confeccionistas, lineas)} end)
    validos = for {lote, {:ok, _}} <- resultados, do: {:ok, lote}
    rechazados = for {lote, {:error, razon}} <- resultados, do: {:error, lote, razon}
    {validos, rechazados}
  end

  def lote_adicional(texto) when is_binary(texto) do
    campos = texto |> String.split(";") |> Enum.map(&String.trim/1)

    case campos do
      [confeccionista, linea, dia, prendas, defectos] ->
        with {dia, ""} <- Integer.parse(dia),
             {prendas, ""} <- Integer.parse(prendas),
             {defectos, ""} <- Float.parse(defectos) do
          {:ok, %{
            confeccionista: confeccionista,
            linea: linea,
            dia: dia,
            prendas: prendas,
            defectos: defectos
          }}
        else
          _ -> {:error, :formato_invalido}
        end

      _ -> {:error, :formato_invalido}
    end
  end

  def lote_adicional(_), do: {:error, :formato_invalido}

  # Guarda defensiva: si no es mapa, rechazar
  def validar_lote(lote, _confeccionistas, _lineas) when not is_map(lote) do
    {:error, :lote_invalido}
  end

  def validar_lote(lote, confeccionistas, lineas) do
    with :ok <- validar_confeccionista(lote, confeccionistas),
         :ok <- validar_linea(lote, lineas),
         :ok <- validar_dia(Map.get(lote, :dia)),
         :ok <- validar_prendas(Map.get(lote, :prendas)),
         :ok <- validar_porcentaje(Map.get(lote, :defectos)) do
      {:ok, lote}
    end
  end

  def validar_confeccionista(lote, confeccionistas) do
    if Enum.any?(confeccionistas, fn conf -> Map.get(conf, :codigo) == Map.get(lote, :confeccionista) end) do
      :ok
    else
      {:error, :confeccionista_desconocido}
    end
  end

  def validar_linea(lote, lineas) do
    if Enum.any?(lineas, fn lin -> Map.get(lin, :id) == Map.get(lote, :linea) end) do
      :ok
    else
      {:error, :linea_desconocida}
    end
  end

  def validar_dia(dia) do
    if is_integer(dia) and dia in 1..7 do
      :ok
    else
      {:error, :dia_invalido}
    end
  end

  def validar_prendas(prendas) do
    if is_integer(prendas) and prendas in 1..180 do
      :ok
    else
      {:error, :prendas_fuera_de_rango}
    end
  end

  def validar_porcentaje(defectos) when is_number(defectos) do
    if defectos >= 0 and defectos <= 100 do
      :ok
    else
      {:error, :porcentaje_invalido}
    end
  end

  def validar_porcentaje(_), do: {:error, :porcentaje_invalido}
end
