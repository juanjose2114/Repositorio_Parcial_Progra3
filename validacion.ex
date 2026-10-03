
defmodule Validacion do

  #validar lotes/3 recorre la lista de lotes y los clasifica dentro de una tupla con una etiqueta definida  por validar_lote/3, luego descarta lotes invalidos y retorna una lista de lotes validos
  def validar_lotes(lotes, confeccionistas, lineal) do
    lotes = Enum.map(lotes, fn lote -> validar_lote(lote, confeccionistas, lineal) end)
    validos = for {_lote, {:ok,:lote}} <- lotes, do: {:ok, lote}
    rechazados = for {lote, {:error, razon}} <- lotes, do: {:error, lote, razon}     #lote es requerido para Reporte_1
    {validos, rechazados}
  end

  # creacion de lote adicional a partir de un comando en texto valido como parametro
  # C03;L2;3;75;1.5 -> {:ok, lote}
  def lote_adicional(texto) when is_binary(texto) do
    campos = texto |> String.split(";") |> Enum.map(&String.trim/1)     #separa y depura espacios

    case campos do
      [confeccionista, linea, dia, prendas, defectos] ->
        with {dia, ""} <- Integer.parse(dia),
             {prendas, ""} <- Integer.parse(prendas),
             {defectos, ""} <- Float.parse(defectos) do
          lote = %{
            confeccionista: confeccionista,
            linea: linea,
            dia: dia,
            prendas: prendas,
            defectos: defectos
          }
          {:ok, lote}
        else
          _ -> {:error, :formato_invalido}
        end

      _ -> {:error, :formato_invalido}
    end
  end

  #guarda
  def lote_adicional(_), do: {:error, :formato_invalido}

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
    if Enum.any?(confeccionistas, fn conf -> conf.codigo == Map.get(lote, :confeccionista) end) do
      :ok
    else
      {:error, :confeccionista_desconocido}
    end
  end

  def validar_linea(lote, lineas) do
    if Enum.any?(lineas, fn lin -> lin.id == Map.get(lote, :linea) end) do
      :ok
    else
      {:error, :linea_desconocida}
    end
  end

  def validar_dia(dia) do
    if dia in 1..7 do
      :ok
    else
      {:error, :dia_invalido}
    end
  end

  def validar_prendas(prendas) do
    if prendas in 1..180 do
      :ok
    else
      {:error, :prendas_fuera_de_rango}
    end
  end

  def validar_porcentaje(defectos) do
    if defectos in 0..100 do
      :ok
    else
      {:error, :porcentaje_invalido}
    end
  end

end
