defmodule Reportes do
  @moduledoc """
  Generación textual de Reportes R1 a R8 y función de ranking C.1.
  """

  def generar_r1(lotes_rechazados) do
    conteo_motivos =
      Enum.reduce(lotes_rechazados, %{}, fn {_lote, motivo}, acc ->
        Map.update(acc, motivo, 1, &(&1 + 1))
      end)

    resumen_motivos =
      for {motivo, cantidad} <- conteo_motivos do
        "   * #{motivo}: #{cantidad} lote(s) rechazado(s)"
      end

    detalle_lotes =
      for {lote, motivo} <- lotes_rechazados do
        "   - Lote Conf: #{lote[:confeccionista]} | Línea: #{lote[:linea]} | Día: #{lote[:dia]} | Motivo: #{motivo}"
      end

    """
    ===============================================================
    R1. REPORTE DE LOTES RECHAZADOS (TOTAL: #{Enum.count(lotes_rechazados)})
    ===============================================================
    RESUMEN POR MOTIVO:
    #{Enum.join(resumen_motivos, "\n")}

    DETALLE DE LOTES RECHAZADOS:
    #{Enum.join(detalle_lotes, "\n")}
    """
  end

  def generar_r2(lineas_list, lotes_validos) do
    resumen =
      for linea <- lineas_list do
        lotes_linea = Enum.filter(lotes_validos, &(&1.linea == linea.id))
        total_prendas = Enum.sum(for l <- lotes_linea, do: l.prendas)
        productividad = Float.round(total_prendas / linea.puestos, 2)

        %{
          id: linea.id,
          nombre: linea.nombre,
          puestos: linea.puestos,
          prendas: total_prendas,
          productividad: productividad
        }
      end

    ordenados = Enum.sort_by(resumen, & &1.productividad, :desc)

    filas =
      for l <- ordenados do
        " - [#{l.id}] #{String.pad_trailing(l.nombre, 18)} | Puestos: #{l.puestos} | Prendas: #{String.pad_leading(Integer.to_string(l.prendas), 4)} | Prod/Puesto: #{Util.formatear_moneda(l.productividad)}"
      end

    """
    ===============================================================
    R2. PRODUCTIVIDAD POR LÍNEA DE PRODUCCIÓN (ORDENADO DE MAYOR A MENOR)
    ===============================================================
    #{Enum.join(filas, "\n")}
    """
  end

  def generar_r3(lotes_validos) do
    meta_diaria = 600

    prod_por_dia =
      for dia <- 1..6 do
        prendas =
          lotes_validos
          |> Enum.filter(&(&1.dia == dia))
          |> Enum.map(& &1.prendas)
          |> Enum.sum()

        {dia, prendas, prendas >= meta_diaria}
      end

    filas =
      for {dia, prendas, alcanzo} <- prod_por_dia do
        estado = if alcanzo, do: "CUMPLIÓ META", else: "NO CUMPLIÓ META"
        " - Día #{dia}: #{String.pad_leading(Integer.to_string(prendas), 4)} prendas -> #{estado}"
      end

    alcanzo_todos = Enum.all?(prod_por_dia, fn {_d, _p, a} -> a end)
    alcanzo_al_menos_uno = Enum.any?(prod_por_dia, fn {_d, _p, a} -> a end)

    """
    ===============================================================
    R3. PRODUCCIÓN DIARIA DEL TALLER (META DIARIA: #{meta_diaria} PRENDAS)
    ===============================================================
    #{Enum.join(filas, "\n")}
    ---------------------------------------------------------------
     * ¿Se alcanzó la meta TODOS los días?: #{if alcanzo_todos, do: "SÍ", else: "NO"}
     * ¿Se alcanzó la meta AL MENOS UN día?: #{if alcanzo_al_menos_uno, do: "SÍ", else: "NO"}
    """
  end

  def generar_r4(liquidaciones) do
    ranking = Enum.sort_by(liquidaciones, & &1.pago_neto, :desc)

    filas =
      for {c, idx} <- Enum.with_index(ranking, 1) do
        num = String.pad_leading(Integer.to_string(idx), 2, " ")
        "#{num}. [#{c.codigo}] #{String.pad_trailing(c.nombre, 18)} | Prendas: #{String.pad_leading(Integer.to_string(c.prendas), 4)} | Valor Lotes: $#{Util.formatear_moneda(c.valor_bruto)} | Bono: $#{Util.formatear_moneda(c.bonificaciones)} | Alq: -$#{Util.formatear_moneda(c.alquiler_descuento)} | NETO: $#{Util.formatear_moneda(c.pago_neto)}"
      end

    """
    ===============================================================
    R4. LIQUIDACIÓN GENERAL (ORDENADA POR PAGO NETO DE MAYOR A MENOR)
    ===============================================================
    #{Enum.join(filas, "\n")}
    """
  end

  def generar_r5(confeccionistas_list, lotes_validos) do
    ganadores_por_dia =
      for dia <- 1..6 do
        lotes_dia = Enum.filter(lotes_validos, &(&1.dia == dia))

        if Enum.empty?(lotes_dia) do
          {dia, [], 0}
        else
          agrupado =
            Enum.reduce(lotes_dia, %{}, fn l, acc ->
              Map.update(acc, l.confeccionista, l.prendas, &(&1 + l.prendas))
            end)

          max_prendas = agrupado |> Map.values() |> Enum.max()

          ganadores =
            agrupado
            |> Enum.filter(fn {_conf, cant} -> cant == max_prendas end)
            |> Enum.map(fn {conf, _cant} -> conf end)

          {dia, ganadores, max_prendas}
        end
      end

    filas =
      for {dia, ganadores, cant} <- ganadores_por_dia do
        if Enum.empty?(ganadores) do
          " - Día #{dia}: Sin lotes válidos registrados."
        else
          nombres =
            Enum.map(ganadores, fn cod ->
              conf = Enum.find(confeccionistas_list, &(&1.codigo == cod))
              "#{conf.nombre} (#{cod})"
            end)

          " - Día #{dia}: #{Enum.join(nombres, ", ")} con #{cant} prendas"
        end
      end

    conteo_primeros =
      ganadores_por_dia
      |> Enum.flat_map(fn {_d, ganadores, _c} -> ganadores end)
      |> Enum.reduce(%{}, fn conf, acc -> Map.update(acc, conf, 1, &(&1 + 1)) end)

    resumen_lideres =
      if Enum.empty?(conteo_primeros) do
        "Sin líderes registrados."
      else
        max_dias = conteo_primeros |> Map.values() |> Enum.max()

        lideres =
          conteo_primeros
          |> Enum.filter(fn {_conf, dias} -> dias == max_dias end)
          |> Enum.map(fn {cod, _dias} ->
            conf = Enum.find(confeccionistas_list, &(&1.codigo == cod))
            "#{conf.nombre} (#{cod})"
          end)

        "#{Enum.join(lideres, ", ")} ocupó(aron) el primer lugar #{max_dias} día(s)."
      end

    """
    ===============================================================
    R5. MAYOR PRODUCTOR DIARIO Y LÍDER SEMANAL
    ===============================================================
    #{Enum.join(filas, "\n")}
    ---------------------------------------------------------------
     * Líder semanal: #{resumen_lideres}
    """
  end

  def generar_r6(confeccionistas_list, lotes_validos) do
    calificados =
      for conf <- confeccionistas_list do
        lotes_conf = Enum.filter(lotes_validos, &(&1.confeccionista == conf.codigo))
        num_lotes = Enum.count(lotes_conf)

        if num_lotes >= 3 do
          suma_ponderada = Enum.sum(for l <- lotes_conf, do: l.defectos * l.prendas)
          total_prendas = Enum.sum(for l <- lotes_conf, do: l.prendas)
          pct_ponderado = Float.round(suma_ponderada / total_prendas, 2)

          %{
            codigo: conf.codigo,
            nombre: conf.nombre,
            lotes: num_lotes,
            prendas: total_prendas,
            pct_ponderado: pct_ponderado
          }
        else
          nil
        end
      end
      |> Enum.reject(&is_nil/1)

    if Enum.empty?(calificados) do
      """
      ===============================================================
      R6. MEJOR CALIDAD (DEFECTOS PONDERADOS)
      ===============================================================
      Ningún confeccionista cumple el mínimo de 3 lotes válidos.
      """
    else
      ganador = Enum.min_by(calificados, & &1.pct_ponderado)

      """
      ===============================================================
      R6. MEJOR CALIDAD (MENOR PORCENTAJE DE DEFECTOS PONDERADO)
      ===============================================================
       * Ganador: [#{ganador.codigo}] #{ganador.nombre}
       * Porcentaje ponderado de defectos: #{Util.formatear_moneda(ganador.pct_ponderado)}%
       * Lotes válidos evaluados: #{ganador.lotes}
       * Total prendas evaluadas: #{ganador.prendas}
      """
    end
  end

  def generar_r7(liquidaciones, lotes_validos) do
    total_pagado = Enum.sum(for c <- liquidaciones, do: c.pago_neto)
    total_prendas_validas = Enum.sum(for l <- lotes_validos, do: l.prendas)

    promedio_str =
      if total_prendas_validas > 0 do
        prom = total_pagado / total_prendas_validas
        "$#{Util.formatear_moneda(prom)} por prenda"
      else
        "El promedio no puede calcularse (0 prendas válidas)."
      end

    """
    ===============================================================
    R7. TOTAL NÓMINA TALLER Y COSTO PROMEDIO POR PRENDA VÁLIDA
    ===============================================================
     * Total Nómina Pagada por el Taller: $#{Util.formatear_moneda(total_pagado)}
     * Total Prendas Válidas           : #{total_prendas_validas}
     * Costo Promedio por Prenda Válida: #{promedio_str}
    """
  end

  def generar_r8(confeccionistas_list, lineas_list, lotes_validos) do
    total_lineas = Enum.count(lineas_list)

    cumplen =
      for conf <- confeccionistas_list do
        lineas_trabajadas =
          lotes_validos
          |> Enum.filter(&(&1.confeccionista == conf.codigo))
          |> Enum.map(& &1.linea)
          |> Enum.uniq()
          |> Enum.count()

        if lineas_trabajadas == total_lineas, do: conf, else: nil
      end
      |> Enum.reject(&is_nil/1)

    filas =
      if Enum.empty?(cumplen) do
        " Ningún confeccionista registró lotes en todas las líneas de producción."
      else
        for c <- cumplen do
          " - [#{c.codigo}] #{c.nombre}"
        end
        |> Enum.join("\n")
      end

    """
    ===============================================================
    R8. CONFECCIONISTAS QUE TRABAJARON EN TODAS LAS LÍNEAS (#{total_lineas}/#{total_lineas})
    ===============================================================
    #{filas}
    """
  end

  def ranking(liquidaciones, opts \\ []) do
    campo = Keyword.get(opts, :campo, :neto)
    orden = Keyword.get(opts, :orden, :desc)
    limite = Keyword.get(opts, :limite, Enum.count(liquidaciones))

    llave_orden =
      case campo do
        :prendas -> :prendas
        :bruto -> :valor_bruto
        _ -> :pago_neto
      end

    ordenados = Enum.sort_by(liquidaciones, &Map.get(&1, llave_orden), orden)
    Enum.take(ordenados, limite)
  end
end
