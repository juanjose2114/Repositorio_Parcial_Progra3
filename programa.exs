defmodule Programa do
  @moduledoc """
  Modulo orquestador principal. Carga la semilla de datos, invoca el módulo de validaciones
  y administra el menú interactivo para la ejecución de reportes.
  """
  Code.require_file("datos.exs")

  @doc """
  Punto de entrada de la aplicación.
  """
  def main do
    Util.mostrar_mensaje("=========================================================")
    Util.mostrar_mensaje("=== TALLER DE CONFECCIONES - LIQUIDACIÓN DE PRODUCCIÓN ===")
    Util.mostrar_mensaje("=========================================================\n")

    confeccionistas_list = Datos.confeccionistas()
    lineas_list = Datos.lineas()
    lotes_iniciales = Datos.lotes()

    {lotes_validados, lotes_invalidados} =
      Validacion.validar_lotes(lotes_iniciales, confeccionistas_list, lineas_list)

    lotes_validos = Enum.map(lotes_validados, fn {:ok, lote} -> lote end)
    lotes_rechazados = Enum.map(lotes_invalidados, fn {:error, motivo, lote} -> {motivo, lote} end)

    menu(lotes_rechazados, lineas_list, lotes_validos, confeccionistas_list)
  end

  @doc """
  Controla el flujo de la CLI en consola evaluando las opciones del menú de forma recursiva.
  """
  def menu(lotes_rechazados, lineas_list, lotes_validos, confeccionistas_list) do
    liquidaciones = Liquidacion.liquidar_todos(confeccionistas_list, lotes_validos)

    Util.mostrar_mensaje("""
      \n--- Generador de Reportes ---
      1. Lotes rechazados con su motivo y cantidad de rechazos por cada motivo.
      2. Prendas elaboradas por línea y productividad semanal en prendas por puesto.
      3. Prendas producidas por el taller en cada uno de los 6 días.
      4. Liquidación de todos los confeccionistas, numerada y ordenada por pago.
      5. Confeccionista que produjo más prendas cada día.
      6. Confeccionista con mejor calidad: menor porcentaje de defectos ponderado.
      7. Total que debe pagar el taller durante la semana y costo promedio pagado por prenda valida.
      8. Confeccionistas que elaboraron al menos un lote válido en todas las lineas.
      9. Generar comprobante individual.
      10. Demostrar Investigación C1
      11. Demostrar Investigación C2
      12. Agregar lote adicional
      13. Salir
    """)

    opcion = Util.ingresar("Seleccione una opcion: ", :texto)

    continuar =
      case opcion do
        "1" ->
          Util.mostrar_mensaje("\n" <> Reportes.generar_r1(lotes_rechazados))
          true

        "2" ->
          Util.mostrar_mensaje(Reportes.generar_r2(lineas_list, lotes_validos))
          true

        "3" ->
          Util.mostrar_mensaje(Reportes.generar_r3(lotes_validos))
          true

        "4" ->
          Util.mostrar_mensaje(Reportes.generar_r4(liquidaciones))
          true

        "5" ->
          Util.mostrar_mensaje(Reportes.generar_r5(confeccionistas_list, lotes_validos))
          true

        "6" ->
          Util.mostrar_mensaje(Reportes.generar_r6(confeccionistas_list, lotes_validos))
          true

        "7" ->
          Util.mostrar_mensaje(Reportes.generar_r7(liquidaciones, lotes_validos))
          true

        "8" ->
          Util.mostrar_mensaje(Reportes.generar_r8(confeccionistas_list, lineas_list, lotes_validos))
          true

        "9" ->
          Reportes.generar_comprobante_individual_consola(liquidaciones, confeccionistas_list)
          true

        "10" ->
          Extra.demostrar_c1(liquidaciones)
          true

        "11" ->
          Extra.demostrar_c2(lotes_validos)
          true

        "12" ->
          resultado = Validacion.agregar_lote_adicional(confeccionistas_list, lineas_list)

          case resultado do
            :omitido ->
              true

            {motivo, lote_adicion} ->
              Util.mostrar_mensaje("Lote invalido, moviendo a rechazados...")
              menu([{motivo, lote_adicion} | lotes_rechazados], lineas_list, lotes_validos, confeccionistas_list)
              false

            {lote_adicion} ->
              Util.mostrar_mensaje("Lote validado y agregado correctamente...")
              menu(lotes_rechazados, lineas_list, [lote_adicion | lotes_validos], confeccionistas_list)
              false
          end

        "13" ->
          Util.mostrar_mensaje("\n Saliendo del programa.")
          Util.mostrar_mensaje("\n=== PROCESAMIENTO FINALIZADO EXITOSAMENTE ===")
          false

        _ ->
          Util.mostrar_mensaje("Opcion invalida")
          true
      end

    if continuar do
      menu(lotes_rechazados, lineas_list, lotes_validos, confeccionistas_list)
    end
  end
end

Programa.main()
