require('date')

class TarjetaDeTiempo
	def initialize(fecha,id_empleado,hora_ingreso,hora_salida)
		@fecha = fecha
		@id_empleado = id_empleado
		@hora_ingreso = hora_ingreso
		@hora_salida = hora_salida
	end

	def calcular_horas_trabajadas
		@hora_salida.strftime("%H:%M:%S").to_i - @hora_ingreso.strftime("%H:%M:%S").to_i
	end
end