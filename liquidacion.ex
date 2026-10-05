defmodule Liquidacion do
  @moduledoc """
  Módulo de cálculos financieros puros (Reglas 2 a 5).
  """

  @tarifa_base 3200
  @meta_diaria_bono 120
  @bonificacion_diaria 18000
  @alquiler_diario 15000

  def calcular_valor_lote(%{prendas: prendas, defectos: defectos}) do
    valor_base = prendas * @tarifa_base

    factor =
      cond do
        defectos <= 2.0 -> 1.07
        defectos <= 5.0 -> 1.00
        defectos <= 10.0 -> 0.88
        true -> 0.75
      end

    Float.round(valor_base * factor, 2)
  end

  def acumular_produccion_diaria(lotes_validos) do
    Enum.reduce(lotes_validos, %{}, fn lote, acc ->
      llave = {lote.confeccionista, lote.dia}
      Map.update(acc, llave, lote.prendas, &(&1 + lote.prendas))
    end)
  end

  def calcular_bonificaciones(produccion_diaria_map) do
    Enum.reduce(produccion_diaria_map, %{}, fn {{codigo, _dia}, total_prendas}, acc ->
      bono = if total_prendas >= @meta_diaria_bono, do: @bonificacion_diaria, else: 0
      Map.update(acc, codigo, bono, &(&1 + bono))
    end)
  end

  def calcular_alquiler(confeccionista, dias_trabajados) do
    if confeccionista.alquiler and dias_trabajados > 0 do
      dias_trabajados * @alquiler_diario
    else
      0
    end
  end

  def liquidar_todos(confeccionistas_list, lotes_validos) do
    prod_diaria = acumular_produccion_diaria(lotes_validos)
    bonos_map = calcular_bonificaciones(prod_diaria)

    for conf <- confeccionistas_list do
      lotes_conf = Enum.filter(lotes_validos, &(&1.confeccionista == conf.codigo))

      dias_trabajados =
        lotes_conf
        |> Enum.map(& &1.dia)
        |> Enum.uniq()

      num_dias = Enum.count(dias_trabajados)
      total_prendas = Enum.sum(for l <- lotes_conf, do: l.prendas)
      valor_lotes = Enum.sum(for l <- lotes_conf, do: calcular_valor_lote(l))
      bono = Map.get(bonos_map, conf.codigo, 0)
      alquiler = calcular_alquiler(conf, num_dias)
      neto = valor_lotes + bono - alquiler

      %{
        codigo: conf.codigo,
        nombre: conf.nombre,
        alquiler: conf.alquiler,
        prendas: total_prendas,
        valor_bruto: Float.round(valor_lotes, 2),
        bonificaciones: bono,
        alquiler_descuento: alquiler,
        pago_neto: Float.round(neto, 2),
        dias_trabajados: num_dias,
        lotes: lotes_conf
      }
    end
  end
end
