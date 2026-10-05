defmodule Validacion do
  def validar_lotes(lotes, confeccionistas, lineas) do
     {lista_validos, lista_invalidos} =
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

    texto = IO.gets("Ingrese un lote adicional (confeccionista;linea;dia;prendas;defectos)
            o Enter para omitir:")

    lote_adicion =
      case String.trim(texto) do
        "" -> IO.puts("Se omitio el lote adicional...")
        :omitido
        texto -> lote_adicional(texto, confeccionistas, lineas)
      end

    case lote_adicion do

      :omitido -> {lista_validos, lista_invalidos}

      {:error, :formato_invalido} -> {lista_validos, lista_invalidos}

      {:ok, lote_adicion} ->
        IO.puts("Lote validado y agregado correctamente...")
        {[{:ok, lote_adicion} | lista_validos], lista_invalidos}

      {:error, motivo, lote_adicion} ->
        IO.puts("Lote invalido, moviendo a rechazados...")
        {lista_validos, [{:error, motivo, lote_adicion} | lista_invalidos]}
    end
  end

  def lote_adicional(texto, confeccionistas, lineas) when is_binary(texto) do
    campos = texto |> String.split(";") |> Enum.map(&String.trim/1)

    adicional =
      case campos do
        [confeccionista, linea, dia, prendas, defectos] ->
          with {dia, ""} <- Integer.parse(dia),
               {prendas, ""} <- Integer.parse(prendas),
               {defectos, ""} <- Float.parse(defectos) do
            %{
              confeccionista: confeccionista,
              linea: linea,
              dia: dia,
              prendas: prendas,
              defectos: defectos
            }
          else
            _ -> {:error, :formato_invalido}
          end

        _ ->
          {:error, :formato_invalido}
      end

    case adicional do
      {:error, :formato_invalido} ->
        IO.puts("Formato invalido, intente nuevamente...")
        {:error, :formato_invalido}

      adicional ->
        validar_lote(adicional, confeccionistas, lineas)
    end
  end

  def validar_lote(lote, confeccionistas, lineas) do
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
        {:ok, lote}

      {:error, motivo, lote} ->
        {:error, motivo, lote}
    end
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
