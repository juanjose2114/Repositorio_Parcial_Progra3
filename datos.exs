defmodule Datos do

    def confeccionistas() do
        [
        %{codigo: "C01", nombre: "María Elena Ríos", alquiler: true},
        %{codigo: "C02", nombre: "Carlos Mendoza", alquiler: false},
        %{codigo: "C03", nombre: "Ana López", alquiler: false},
        %{codigo: "C04", nombre: "Luis García", alquiler: false},
        %{codigo: "C05", nombre: "Miguel Ángel Torres", alquiler: true},
        %{codigo: "C06", nombre: "Jorge Ramírez", alquiler: true},
        %{codigo: "C07", nombre: "Roberto Díaz", alquiler: false},
        %{codigo: "C08", nombre: "Marta Jiménez", alquiler: true},
        %{codigo: "C09", nombre: "Laura Martínez", alquiler: false},
        %{codigo: "C010", nombre: "Andrés Salazar", alquiler: true},
        ]
    end

    def lineas() do
        [
        %{id: "L1", nombre: "Línea Norte", puestos: 4},
        %{id: "L2", nombre: "Línea Central", puestos: 6},
        %{id: "L3", nombre: "Línea Sur", puestos: 5},
        %{id: "L4", nombre: "Línea Este", puestos: 3}
        ]
    end

    def lotes() do
        [
        # Día 1 - Errores en 30, 33, 40
        %{confeccionista: "C011", linea: "L1", dia: 1, prendas: 70, defectos: 1.5},
        %{confeccionista: "C02", linea: "L2", dia: 1, prendas: 85, defectos: 2.0},
        %{confeccionista: "C03", linea: "L3", dia: 1, prendas: 65, defectos: 1.0},
        %{confeccionista: "C04", linea: "L5", dia: 1, prendas: 50, defectos: 3.0},
        %{confeccionista: "C05", linea: "L1", dia: 1, prendas: 75, defectos: 2.5},
        %{confeccionista: "C06", linea: "L2", dia: 1, prendas: 90, defectos: 1.0},
        %{confeccionista: "C07", linea: "L3", dia: 1, prendas: 60, defectos: 4.0},
        %{confeccionista: "C08", linea: "L4", dia: 1, prendas: 55, defectos: 2.0},
        %{confeccionista: "C03", linea: "L2", dia: 1, prendas: 89, defectos: 1.5},
        %{confeccionista: "C04", linea: "L3", dia: 1, prendas: 65, defectos: 2.0},
        %{confeccionista: "C05", linea: "L4", dia: 1, prendas: 0, defectos: 3.0},
        %{confeccionista: "C07", linea: "L2", dia: 1, prendas: 90, defectos: 1.5},
        %{confeccionista: "C08", linea: "L3", dia: 1, prendas: 76, defectos: 2.0},
        %{confeccionista: "C09", linea: "L4", dia: 1, prendas: 52, defectos: 4.0},
        %{confeccionista: "C010", linea: "L1", dia: 1, prendas: 82, defectos: 1.0},

        # Día 2 - Errores en 49, 50
        %{confeccionista: "C09", linea: "L1", dia: 2, prendas: 80, defectos: 1.5},
        %{confeccionista: "C010", linea: "L2", dia: 2, prendas: 95, defectos: 1.0},
        %{confeccionista: "C011", linea: "L3", dia: 2, prendas: 72, defectos: 2.0},
        %{confeccionista: "C02", linea: "L4", dia: 2, prendas: 60, defectos: -3.5},
        %{confeccionista: "C03", linea: "L1", dia: 2, prendas: 68, defectos: 1.0},
        %{confeccionista: "C04", linea: "L2", dia: 2, prendas: 82, defectos: 2.5},
        %{confeccionista: "C05", linea: "L3", dia: 2, prendas: 77, defectos: 1.5},
        %{confeccionista: "C06", linea: "L4", dia: 2, prendas: 58, defectos: 3.0},
        %{confeccionista: "C06", linea: "L1", dia: 2, prendas: 87, defectos: 1.0},
        %{confeccionista: "C07", linea: "L2", dia: 2, prendas: 93, defectos: 2.5},
        %{confeccionista: "C08", linea: "L3", dia: 2, prendas: 74, defectos: 1.5},

        # Día 3 - Errores en 64, 65, 69
        %{confeccionista: "C07", linea: "L1", dia: 3, prendas: 73, defectos: 2.0},
        %{confeccionista: "C08", linea: "L2", dia: 3, prendas: 88, defectos: 1.5},
        %{confeccionista: "C09", linea: "L3", dia: 3, prendas: 64, defectos: 3.0},
        %{confeccionista: "C010", linea: "L4", dia: 3, prendas: 52, defectos: 2.5},
        %{confeccionista: "C011", linea: "L1", dia: 3, prendas: 78, defectos: 1.0},
        %{confeccionista: "C02", linea: "L2", dia: 3, prendas: 0, defectos: 2.0},
        %{confeccionista: "C03", linea: "L3", dia: 3, prendas: 69, defectos: 1.5},
        %{confeccionista: "C04", linea: "L4", dia: 3, prendas: 57, defectos: 4.0},
        %{confeccionista: "C09", linea: "L4", dia: 3, prendas: 50, defectos: 4.0},
        %{confeccionista: "C010", linea: "L1", dia: 3, prendas: 84, defectos: -1.0},

        # Día 4 - Errores 72, 73, 82
        %{confeccionista: "C05", linea: "L5", dia: 4, prendas: 83, defectos: 2.0},
        %{confeccionista: "C06", linea: "L6", dia: 4, prendas: 96, defectos: 1.0},
        %{confeccionista: "C07", linea: "L3", dia: 4, prendas: 71, defectos: 2.5},
        %{confeccionista: "C08", linea: "L4", dia: 4, prendas: 54, defectos: 3.0},
        %{confeccionista: "C09", linea: "L1", dia: 4, prendas: 76, defectos: 1.5},
        %{confeccionista: "C010", linea: "L2", dia: 4, prendas: 89, defectos: 2.0},
        %{confeccionista: "C01", linea: "L3", dia: 4, prendas: 67, defectos: 1.0},
        %{confeccionista: "C02", linea: "L4", dia: 4, prendas: 61, defectos: 3.5},
        %{confeccionista: "C05", linea: "L2", dia: 4, prendas: 97, defectos: 1.0},
        %{confeccionista: "C06", linea: "L3", dia: 4, prendas: 72, defectos: 2.0},
        %{confeccionista: "C07", linea: "L5", dia: 4, prendas: 54, defectos: 3.5},
        %{confeccionista: "C08", linea: "L1", dia: 4, prendas: 83, defectos: 1.5},

        # Día 5 - Errores en 87, 91, 92, 95
        %{confeccionista: "C03", linea: "L1", dia: 5, prendas: 74, defectos: 2.0},
        %{confeccionista: "C04", linea: "L2", dia: 5, prendas: 187, defectos: 1.5},
        %{confeccionista: "C05", linea: "L3", dia: 5, prendas: 79, defectos: 2.5},
        %{confeccionista: "C06", linea: "L4", dia: 5, prendas: 56, defectos: 1.0},
        %{confeccionista: "C07", linea: "L1", dia: 5, prendas: 81, defectos: 3.0},
        %{confeccionista: "C08", linea: "L2", dia: 5, prendas: -93, defectos: 1.0},
        %{confeccionista: "C09", linea: "L3", dia: 5, prendas: 66, defectos: 101.0},
        %{confeccionista: "C010", linea: "L4", dia: 5, prendas: 53, defectos: 4.0},
        %{confeccionista: "C09", linea: "L2", dia: 5, prendas: 91, defectos: 2.0},
        %{confeccionista: "C010", linea: "L3", dia: 0.5, prendas: 69, defectos: 1.0},
        %{confeccionista: "C01", linea: "L4", dia: 5, prendas: 58, defectos: 3.0},
        %{confeccionista: "C02", linea: "L1", dia: 5, prendas: 80, defectos: 2.5},
        %{confeccionista: "C01", linea: "L2", dia: 5, prendas: 88, defectos: 2.5},
        %{confeccionista: "C02", linea: "L3", dia: 5, prendas: 67, defectos: 1.5},
        %{confeccionista: "C03", linea: "L4", dia: 5, prendas: 60, defectos: 3.0},
        %{confeccionista: "C04", linea: "L1", dia: 5, prendas: 75, defectos: 2.0},

        # # Día 6 - Errores en 104, 105, 109, 118, 119
        %{confeccionista: "C01", linea: "L5", dia: 6, prendas: 84, defectos: 1.5},
        %{confeccionista: "C02", linea: "L3", dia: 0.6, prendas: 70, defectos: 2.0},
        %{confeccionista: "C03", linea: "L4", dia: 6, prendas: 59, defectos: 3.0},
        %{confeccionista: "C04", linea: "L1", dia: 6, prendas: 77, defectos: 1.0},
        %{confeccionista: "C05", linea: "L2", dia: 6, prendas: 0.92, defectos: 2.5},
        %{confeccionista: "C06", linea: "L3", dia: 6, prendas: 68, defectos: 1.5},
        %{confeccionista: "C07", linea: "L4", dia: 6, prendas: 51, defectos: 3.5},
        %{confeccionista: "C08", linea: "L1", dia: 6, prendas: 80, defectos: 2.0},
        %{confeccionista: "C09", linea: "L2", dia: 6, prendas: 86, defectos: 1.0},
        %{confeccionista: "C010", linea: "L3", dia: 6, prendas: 73, defectos: 2.5},
        %{confeccionista: "C01", linea: "L4", dia: 6, prendas: 55, defectos: 3.0},
        %{confeccionista: "C02", linea: "L1", dia: 6, prendas: 79, defectos: 1.5},
        %{confeccionista: "C03", linea: "L2", dia: 6, prendas: 94, defectos: 2.0},
        %{confeccionista: "C04", linea: "L3", dia: 6, prendas: 63, defectos: 1.0},
        %{confeccionista: "C05", linea: "L4", dia: 6, prendas: 57, defectos: -3.5},
        %{confeccionista: "C06", linea: "L1", dia: 7, prendas: 85, defectos: 2.0},
        ]
    end
end
