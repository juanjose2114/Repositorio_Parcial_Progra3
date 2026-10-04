defmodule Programa do

  def main do

    lotes_validados = Validacion.validar_lotes(Datos.lotes, Datos.confeccionistas, Datos.lineas)   #lotes_validos es una tupla con lotes validos y rechazados

    menu(lotes_validados)

  end

  def menu(lotes_validados) do


    Util.mostrar_mensaje("""
      \n--- Generador de Reportes ---
      1. Lotes rechazados con su motivo y cantidad de rechazos por cada motivo.
      2. Prendas elaboradas por línea y productividad semanal en prendas por puesto.
      3. Prendas producidas por el taller en cada uno de los 6 días
      4. Liquidación de todos los confeccionistas, numerada y ordenada por pago
      5. Confeccionista que produjo más prendas cada día
      6. Confeccionista con mejor calidad: menor porcentaje de defectos ponderado
      7. Total que debe pagar el taller durante la semana y costo promedio pagado por
      8. Confeccionistas que elaboraron al menos un lote válido en todas las
      9. Salir
    """)

    opcion = Util.ingresar("Seleccione una opcion: ", :texto)

    case opcion do
      "1" -> r1()
      "2" -> r2()
      "3" -> r3()
      "4" -> r4()
      "5" -> r5()
      "6" -> r6()
      "7" -> r7()
      "8" -> r8()
      "9" -> Util.mostrar_mensaje("\n Saliendo del programa.")
      _ ->
        Util.mostrar_error("Opcion invalida")
        menu(lotes_validados)        #recursividad UNICAMENTE por comodidad, perdonaran este terrible pecado :_(
    end
  end


  #-------------------------------------------reportes#-------------------------------------------

  #R1
  # Lotes rechazados con su motivo y cantidad de rechazos por cada motivo.
  def r1 do

  end

  #R2
  # Prendas elaboradas por línea y productividad semanal en prendas por puesto
  # (prendas / puestos), ordenadas de mayor a menor productividad. Las líneas sin
  # lotes válidos deben aparecer con cero prendas.
  def r2 do

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

Programa.main()
