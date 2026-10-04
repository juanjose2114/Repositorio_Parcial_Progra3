defmodule Liquidacion do
  @moduledoc """
  Contiene las reglas financieras (Reglas 2 a 5).
  Calcula el valor base, ajustes por defectos, bonificaciones, descuentos
  por alquiler y el pago neto final por cada confeccionista.
  """

  @valor_unidad 3200
  @bono_diario 15000      # Valor de ejemplo. Cambiar si el parcial indica otro.
  @costo_alquiler 25000   # Valor de ejemplo. Cambiar si el parcial indica otro.

  @doc """
  Recibe la lista de lotes VÁLIDOS y la lista original de confeccionistas.
  Retorna una lista de mapas con la liquidación total de cada trabajador.
  """
  def procesar_liquidaciones(lotes_validos, confeccionistas) do
    # Agrupamos los lotes válidos por el código del confeccionista
    lotes_por_confeccionista = Enum.group_by(lotes_validos, fn lote -> lote.confeccionista end)

    # Iteramos sobre TODOS los confeccionistas para asegurar que los que no
    # tienen lotes válidos queden en 0, como pide el requerimiento.
    Enum.map(confeccionistas, fn conf ->
      lotes_del_trabajador = Map.get(lotes_por_confeccionista, conf.codigo, [])
      liquidar_confeccionista(conf, lotes_del_trabajador)
    end)
  end

  # --- Funciones Privadas de Liquidación ---

  defp liquidar_confeccionista(confeccionista, lotes) do
    # 1. Días trabajados (días únicos donde entregó lotes)
    dias_trabajados = lotes |> Enum.map(& &1.dia) |> Enum.uniq() |> Enum.count()

    # 2. Valor total de los lotes (Regla 2 aplicada a cada lote)
    valor_lotes = Enum.reduce(lotes, 0, fn lote, acc -> acc + calcular_valor_lote(lote) end)

    # 3. Bonificaciones (Regla 3)
    bonificaciones = calcular_bonificaciones(lotes)

    # 4. Alquiler (Regla 4)
    alquiler = calcular_alquiler(confeccionista.alquiler, dias_trabajados)

    # 5. Cálculo del Neto
    neto = valor_lotes + bonificaciones - alquiler

    # Retornamos el mapa de liquidación del confeccionista
    %{
      codigo: confeccionista.codigo,
      nombre: confeccionista.nombre,
      dias_trabajados: dias_trabajados,
      prendas_totales: Enum.reduce(lotes, 0, fn lote, acc -> acc + lote.prendas end),
      valor_lotes: valor_lotes,
      bonificaciones: bonificaciones,
      alquiler_descontado: alquiler,
      # max(0, neto) evita que el trabajador quede debiendo dinero si sus ingresos
      # fueron menores al costo del alquiler de la máquina.
      neto: max(0, neto)
    }
  end

  # Regla 2: Valor de un lote y ajuste por defectos usando 'cond'
  defp calcular_valor_lote(lote) do
    valor_base = lote.prendas * @valor_unidad
    defecto = lote.defectos

    # Calculamos el modificador y usamos round() para mantener el dinero como Integer
    resultado =
      cond do
        defecto <= 2.0 ->
          valor_base * 1.05  # +5% de bonificación por calidad
        defecto > 2.0 and defecto <= 5.0 ->
          valor_base         # Sin ajuste (se queda igual)
        defecto > 5.0 and defecto <= 10.0 ->
          valor_base * 0.90  # -10% de penalización
        defecto > 10.0 ->
          valor_base * 0.80  # -20% de penalización
      end

    round(resultado)
  end

  # Regla 3: Bonificación si la suma de prendas en el día es >= 120
  defp calcular_bonificaciones(lotes) do
    # Agrupamos los lotes por día para sumar las prendas diarias
    lotes_por_dia = Enum.group_by(lotes, fn lote -> lote.dia end)

    # Contamos cuántos días superó la meta
    dias_con_bono = Enum.count(lotes_por_dia, fn {_dia, lotes_del_dia} ->
      prendas_del_dia = Enum.reduce(lotes_del_dia, 0, fn lote, acc -> acc + lote.prendas end)
      prendas_del_dia >= 120
    end)

    dias_con_bono * @bono_diario
  end

  # Regla 4: Descuento de alquiler de máquinas
  defp calcular_alquiler(tiene_alquiler, dias_trabajados) do
    # Sintaxis idiomática: evaluamos directamente el booleano
    if tiene_alquiler and dias_trabajados > 0 do
      @costo_alquiler
    else
      0
    end
  end
end
