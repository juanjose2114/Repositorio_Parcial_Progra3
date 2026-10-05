defmodule Programa do
  @moduledoc """
  Orquestador del programa funcional.
  """

  def main do
    Util.mostrar_mensaje("=========================================================")
    Util.mostrar_mensaje("=== TALLER DE CONFECCIONES - LIQUIDACIÓN DE PRODUCCIÓN ===")
    Util.mostrar_mensaje("=========================================================\n")

    confeccionistas_list = Datos.confeccionistas()
    lineas_list = Datos.lineas()
    lotes_iniciales = Datos.lotes()

    confeccionistas_map = Enum.into(confeccionistas_list, %{}, fn c -> {c.codigo, c} end)
    lineas_map = Enum.into(lineas_list, %{}, fn l -> {l.id, l} end)

    # Captura de lote adicional (B.5)
    lote_adicional_resultado = capturar_lote_adicional_consola()

    lotes_totales =
      case lote_adicional_resultado do
        {:ok, lote_nuevo} ->
          Util.mostrar_mensaje(" [INFO] Lote adicional capturado correctamente.")
          lotes_iniciales ++ [lote_nuevo]

        {:error, :formato_invalido} ->
          Util.mostrar_mensaje(" [INFO] Formato de lote adicional inválido. Se omitió la adición.")
          lotes_iniciales

        :omitido ->
          Util.mostrar_mensaje(" [INFO] Se omitió el ingreso de lote adicional.")
          lotes_iniciales
      end

    # Validaciones y separación
    {lotes_validos, lotes_rechazados} = procesar_validaciones(lotes_totales, confeccionistas_map, lineas_map)

    # Liquidación
    liquidaciones = Liquidacion.liquidar_todos(confeccionistas_list, lotes_validos)

    # Impresión de los 8 Reportes (B.4)
    Util.mostrar_mensaje("\n" <> Reportes.generar_r1(lotes_rechazados))
    Util.mostrar_mensaje(Reportes.generar_r2(lineas_list, lotes_validos))
    Util.mostrar_mensaje(Reportes.generar_r3(lotes_validos))
    Util.mostrar_mensaje(Reportes.generar_r4(liquidaciones))
    Util.mostrar_mensaje(Reportes.generar_r5(confeccionistas_list, lotes_validos))
    Util.mostrar_mensaje(Reportes.generar_r6(confeccionistas_list, lotes_validos))
    Util.mostrar_mensaje(Reportes.generar_r7(liquidaciones, lotes_validos))
    Util.mostrar_mensaje(Reportes.generar_r8(confeccionistas_list, lineas_list, lotes_validos))

    # Investigación C.1
    demostrar_c1(liquidaciones)

    # Investigación C.2
    demostrar_c2(lotes_validos)

    # Comprobante Individual (B.5)
    generar_comprobante_individual_consola(liquidaciones, confeccionistas_list)

    Util.mostrar_mensaje("\n=== PROCESAMIENTO FINALIZADO EXITOSAMENTE ===")
  end

  defp capturar_lote_adicional_consola do
    entrada = Util.ingresar_texto("Ingrese un lote adicional (confeccionista;linea;dia;prendas;defectos) o Enter para omitir: ")

    if entrada == "" do
      :omitido
    else
      partes = String.split(entrada, ";")

      if Enum.count(partes) == 5 do
        [conf, lin, str_dia, str_prendas, str_defectos] = partes

        with {dia, ""} <- Integer.parse(str_dia),
             {prendas, ""} <- Integer.parse(str_prendas),
             {defectos, ""} <- parse_flotante(str_defectos) do
          {:ok, %{confeccionista: String.trim(conf), linea: String.trim(lin), dia: dia, prendas: prendas, defectos: defectos}}
        else
          _ -> {:error, :formato_invalido}
        end
      else
        {:error, :formato_invalido}
      end
    end
  end

  defp parse_flotante(str) do
    str = String.trim(str)
    case Float.parse(str) do
      {num, ""} -> {:ok, num}
      _ ->
        case Integer.parse(str) do
          {num, ""} -> {:ok, num * 1.0}
          _ -> :error
        end
    end
  end

  defp procesar_validaciones(lotes, confeccionistas_map, lineas_map) do
    Enum.reduce(lotes, {[], []}, fn lote, {validos, rechazados} ->
      case Validacion.validar_lote(lote, confeccionistas_map, lineas_map) do
        {:ok, lote_valido} ->
          {validos ++ [lote_valido], rechazados}

        {:error, motivo} ->
          {validos, rechazados ++ [{lote, motivo}]}
      end
    end)
  end

  defp demostrar_c1(liquidaciones) do
    Util.mostrar_mensaje("===============================================================")
    Util.mostrar_mensaje("C.1 PRUEBAS DE RANKING CON KEYWORD LISTS")
    Util.mostrar_mensaje("===============================================================")

    r1 = Reportes.ranking(liquidaciones, [])
    Util.mostrar_mensaje("1. Reportes.ranking(liquidaciones, []): #{Enum.count(r1)} elementos (por defecto :neto :desc)")

    r2 = Reportes.ranking(liquidaciones, campo: :prendas, limite: 3)
    top3_prendas = Enum.map(r2, &"#{&1.codigo}: #{&1.prendas} prendas")
    Util.mostrar_mensaje("2. Reportes.ranking(liquidaciones, campo: :prendas, limite: 3): #{Enum.join(top3_prendas, ", ")}")

    r3 = Reportes.ranking(liquidaciones, orden: :asc, campo: :bruto)
    bottom_bruto = Enum.map(r3, &"#{&1.codigo}: $#{Util.formatear_moneda(&1.valor_bruto)}") |> Enum.take(3)
    Util.mostrar_mensaje("3. Reportes.ranking(liquidaciones, orden: :asc, campo: :bruto) [Top 3 menor bruto]: #{Enum.join(bottom_bruto, ", ")}\n")
  end

  defp demostrar_c2(lotes_validos) do
    Util.mostrar_mensaje("===============================================================")
    Util.mostrar_mensaje("C.2 COMBINACIÓN DE PRODUCCIÓN CON TALLER ALIADO (Map.merge/3)")
    Util.mostrar_mensaje("===============================================================")

    prod_propia =
      for dia <- 1..6, into: %{} do
        prendas = lotes_validos |> Enum.filter(&(&1.dia == dia)) |> Enum.map(& &1.prendas) |> Enum.sum()
        {dia, prendas}
      end

    taller_aliado = %{1 => 550, 2 => 620, 3 => 480, 5 => 710, 7 => 200}

    combinado = Map.merge(prod_propia, taller_aliado, fn _dia, prendas_propias, prendas_aliado ->
      prendas_propias + prendas_aliado
    end)

    Util.mostrar_mensaje("Producción Propia : #{inspect(prod_propia)}")
    Util.mostrar_mensaje("Taller Aliado     : #{inspect(taller_aliado)}")
    Util.mostrar_mensaje("Combinado         : #{inspect(combinado)}\n")
  end

  defp generar_comprobante_individual_consola(liquidaciones, confeccionistas_list) do
    Util.mostrar_mensaje("===============================================================")
    Util.mostrar_mensaje("B.5 COMPROBANTE INDIVIDUAL DE LIQUIDACIÓN")
    Util.mostrar_mensaje("===============================================================")

    codigo = Util.ingresar_texto("Ingrese el código del confeccionista para generar comprobante (ej: C01): ")

    case Enum.find(liquidaciones, &(&1.codigo == codigo)) do
      nil ->
        Util.mostrar_mensaje(" [ERROR] El confeccionista con código '#{codigo}' no existe.")

      c ->
        conf_info = Enum.find(confeccionistas_list, &(&1.codigo == c.codigo))

        dias_validos =
          c.lotes
          |> Enum.map(& &1.dia)
          |> Enum.uniq()
          |> Enum.sort()

        detalles_dias =
          for dia <- dias_validos do
            lotes_dia = Enum.filter(c.lotes, &(&1.dia == dia))
            prendas_dia = Enum.sum(for l <- lotes_dia, do: l.prendas)
            valor_lotes_dia = Enum.sum(for l <- lotes_dia, do: Liquidacion.calcular_valor_lote(l))
            bono_dia = if prendas_dia >= 120, do: 18000, else: 0

            "   * Día #{dia}: #{prendas_dia} prendas | Valor Lotes: $#{Util.formatear_moneda(valor_lotes_dia)} | Bono Día: $#{Util.formatear_moneda(bono_dia)}"
          end

        Util.mostrar_mensaje("""

        ---------------------------------------------------------------
        COMPROBANTE DE PAGO INDIVIDUAL - TALLER DE CONFECCIONES
        ---------------------------------------------------------------
        Confeccionista : #{c.nombre} (#{c.codigo})
        Usa Máquina    : #{if conf_info.alquiler, do: "SÍ ($15.000/día)", else: "NO"}
        Días Trabajados: #{c.dias_trabajados} día(s)

        DETALLE POR DÍA TRABAJADO:
        #{if Enum.empty?(detalles_dias), do: "   (Sin días trabajados con lotes válidos)", else: Enum.join(detalles_dias, "\n")}

        RESUMEN FINANCIERO:
        (+) Suma Valor de Lotes   : $#{Util.formatear_moneda(c.valor_bruto)}
        (+) Bonificaciones Totales: $#{Util.formatear_moneda(c.bonificaciones)}
        (-) Descuento Alquiler    : $#{Util.formatear_moneda(c.alquiler_descuento)}
        ---------------------------------------------------------------
        (=) PAGO NETO LIQUIDADO   : $#{Util.formatear_moneda(c.pago_neto)}
        ---------------------------------------------------------------
        """)
    end
  end
end

Programa.main()
