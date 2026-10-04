defmodule Programa do

  def main do
    #validar datos para generar reportes con datos validos
    #llamar reportes
    #imprimir reportes
  end

  #-------------------------------------------reportes#-------------------------------------------

  #R1
  # Lotes rechazados con su motivo y cantidad de rechazos por cada motivo.
  def r1 do
    rechazados = 1
    Enum.group_by(&(&1.motivo), &(&1.lote))
    |>Enum.map(rechazados, fn {motivo, lotes} -> {motivo, length(lotes)} end)
    |>Map.new()
  end

  #R2
  # Prendas elaboradas por línea y productividad semanal en prendas por puesto
  # (prendas / puestos), ordenadas de mayor a menor productividad. Las líneas sin
  # lotes válidos deben aparecer con cero prendas.
  def r2(lineas) do
    #prendas por linea
    lotes_por_linea = Enum.group_by(&(&1.lote), &(&1.linea))
    Enum.map(lotes_por_linea, fn {linea, lotes} -> {linea, length(lotes)} end)

    total_prendas = Enum.reduce(lotes_por_linea, 0, fn {linea, lotes}, acc -> acc + lote.prendas end)


    #prendas en semana por puesto
    #ordenadas de mayor a menor
    #las lineas sin lotes validos deben aparecer con cero prendas
    por_dia = Enum.group_by(&(&1.lote), &(&1.dia))
  end

  #R3
  # Prendas producidas por el taller en cada uno de los 6 días, indicando si se alcanzó
  # la meta de 600 prendas. Los días sin lotes válidos aparecen con cero. Al final se
  # indica si se alcanzó la meta todos los días y si se alcanzó al menos uno.
  def r3 do

  end

  #R4
  # Liquidación de todos los confeccionistas, numerada y ordenada por pago neto de
  # mayor a menor. Debe mostrar prendas, valor de lotes, bonificaciones, alquiler y neto.
  # Los valores monetarios se imprimen con dos decimales y sin notación científica.
  def r4 do

  end

  #R5
  # Confeccionista que produjo más prendas cada día; si hay empate, se muestran
  # todos. Los días sin lotes válidos se indican como tales. Al final se informa quién
  # ocupó el primer lugar más días y cuántos; si hay empate, se incluyen todos los
  # empatados.
  def r5 do

  end

  #R6
  # Confeccionista con mejor calidad: menor porcentaje de defectos ponderado por
  # prendas entre quienes tengan al menos 3 lotes válidos.
  def r6 do

  end

  #R7
  # Total que debe pagar el taller durante la semana y costo promedio pagado por
  # prenda válida (total pagado / total de prendas válidas). Si no hay prendas válidas,
  # se debe indicar que el promedio no puede calcularse.
  def r7 do

  end

  #R8
  # Confeccionistas que elaboraron al menos un lote válido en todas las líneas de
  # producción. Si no hay ninguno, debe indicarse.
  def r8 do

  end
end
