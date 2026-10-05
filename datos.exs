defmodule Datos do
  @moduledoc """
  Módulo de datos estáticos del taller.
  Contiene exactamente las funciones confeccionistas/0, lineas/0 y lotes/0.
  """

  def confeccionistas do
    [
      %{codigo: "C01", nombre: "María Elena Ríos", alquiler: true},
      %{codigo: "C02", nombre: "Andrés Salazar", alquiler: false},
      %{codigo: "C03", nombre: "Beatriz López", alquiler: true},
      %{codigo: "C04", nombre: "David Rodríguez", alquiler: false},
      %{codigo: "C05", nombre: "Elena Martínez", alquiler: true},
      %{codigo: "C06", nombre: "Fernando Ruíz", alquiler: false},
      %{codigo: "C07", nombre: "Gloria Castro", alquiler: true},
      %{codigo: "C08", nombre: "Hugo Morales", alquiler: false},
      %{codigo: "C09", nombre: "Isabel Torres", alquiler: true},
      %{codigo: "C10", nombre: "Jorge Vargas", alquiler: false}
    ]
  end

  def lineas do
    [
      %{id: "L1", nombre: "Línea Norte", puestos: 6},
      %{id: "L2", nombre: "Línea Central", puestos: 4},
      %{id: "L3", nombre: "Línea Sur", puestos: 5},
      %{id: "L4", nombre: "Línea Oriente", puestos: 5}
    ]
  end

  def lotes do
    lotes_validos = [
      # Lotes de prueba del enunciado (María Elena C01)
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L2", dia: 1, prendas: 55, defectos: 7.0},
      %{confeccionista: "C01", linea: "L1", dia: 2, prendas: 90, defectos: 12.0}
    ] ++ generar_lotes_validos_adicionales()

    lotes_invalidos = [
      # 1. :confeccionista_desconocido (2)
      %{confeccionista: "C99", linea: "L1", dia: 1, prendas: 50, defectos: 1.0},
      %{confeccionista: "C88", linea: "L2", dia: 2, prendas: 60, defectos: 2.0},

      # 2. :linea_desconocida (2)
      %{confeccionista: "C01", linea: "L99", dia: 3, prendas: 70, defectos: 1.0},
      %{confeccionista: "C02", linea: "L88", dia: 4, prendas: 80, defectos: 2.0},

      # 3. :dia_invalido (2)
      %{confeccionista: "C03", linea: "L3", dia: 0, prendas: 50, defectos: 0.0},
      %{confeccionista: "C04", linea: "L4", dia: 7, prendas: 60, defectos: 1.0},

      # 4. :prendas_fuera_de_rango (2)
      %{confeccionista: "C05", linea: "L1", dia: 1, prendas: 0, defectos: 0.0},
      %{confeccionista: "C06", linea: "L2", dia: 2, prendas: 200, defectos: 1.0},

      # 5. :porcentaje_invalido (2)
      %{confeccionista: "C07", linea: "L3", dia: 3, prendas: 40, defectos: -2.0},
      %{confeccionista: "C08", linea: "L4", dia: 4, prendas: 30, defectos: 105.0}
    ]

    lotes_validos ++ lotes_invalidos
  end

  defp generar_lotes_validos_adicionales do
    for i <- 4..80 do
      conf_num = rem(i, 10) + 1
      conf_id = "C" <> String.pad_leading(Integer.to_string(conf_num), 2, "0")
      linea_num = rem(i, 4) + 1
      linea_id = "L" <> Integer.to_string(linea_num)
      dia_num = rem(i, 6) + 1
      cant = 50 + rem(i * 11, 120)
      defec = Float.round(rem(i, 8) * 1.2, 1)

      %{
        confeccionista: conf_id,
        linea: linea_id,
        dia: dia_num,
        prendas: cant,
        defectos: defec
      }
    end
  end
end
