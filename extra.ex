defmodule Extra do

  def demostrar_c1(liquidaciones) do
    Util.mostrar_mensaje("===============================================================")
    Util.mostrar_mensaje("C.1 PRUEBAS DE RANKING CON KEYWORD LISTS")
    Util.mostrar_mensaje("===============================================================")

    r1 = Reportes.ranking(liquidaciones, [])

    Util.mostrar_mensaje(
      "1. Reportes.ranking(liquidaciones, []): #{Enum.count(r1)} elementos (por defecto :neto :desc)"
    )

    r2 = Reportes.ranking(liquidaciones, campo: :prendas, limite: 3)
    top3_prendas = Enum.map(r2, &"#{&1.codigo}: #{&1.prendas} prendas")

    Util.mostrar_mensaje(
      "2. Reportes.ranking(liquidaciones, campo: :prendas, limite: 3): #{Enum.join(top3_prendas, ", ")}"
    )

    r3 = Reportes.ranking(liquidaciones, orden: :asc, campo: :bruto)

    bottom_bruto =
      Enum.map(r3, &"#{&1.codigo}: $#{Util.formatear_moneda(&1.valor_bruto)}") |> Enum.take(3)

    Util.mostrar_mensaje(
      "3. Reportes.ranking(liquidaciones, orden: :asc, campo: :bruto) [Top 3 menor bruto]: #{Enum.join(bottom_bruto, ", ")}\n"
    )
  end

  def demostrar_c2(lotes_validos) do
    Util.mostrar_mensaje("===============================================================")
    Util.mostrar_mensaje("C.2 COMBINACIÓN DE PRODUCCIÓN CON TALLER ALIADO (Map.merge/3)")
    Util.mostrar_mensaje("===============================================================")

    prod_propia =
      for dia <- 1..6, into: %{} do
        prendas =
          lotes_validos |> Enum.filter(&(&1.dia == dia)) |> Enum.map(& &1.prendas) |> Enum.sum()

        {dia, prendas}
      end

    taller_aliado = %{1 => 550, 2 => 620, 3 => 480, 5 => 710, 7 => 200}

    combinado =
      Map.merge(prod_propia, taller_aliado, fn _dia, prendas_propias, prendas_aliado ->
        prendas_propias + prendas_aliado
      end)

    Util.mostrar_mensaje("Producción Propia : #{inspect(prod_propia)}")
    Util.mostrar_mensaje("Taller Aliado     : #{inspect(taller_aliado)}")
    Util.mostrar_mensaje("Combinado         : #{inspect(combinado)}\n")
  end

end
