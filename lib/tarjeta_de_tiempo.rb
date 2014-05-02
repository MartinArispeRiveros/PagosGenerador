require('date')

class TarjetaDeTiempo
	
	attr_accessor :fecha, :id_empleado, :hora_ingreso, :hora_salida

	def initialize(fecha,id_empleado,hora_ingreso,hora_salida)
		@fecha = fecha
		@id_empleado = id_empleado
		@hora_ingreso = hora_ingreso
		@hora_salida = hora_salida
	end

	def calcular_horas_trabajadas
		@hora_salida.strftime("%H:%M:%S").to_i - @hora_ingreso.strftime("%H:%M:%S").to_i
	end

	def self.verificar_vacio(tarjeta)
		if(tarjeta.fecha != "" || tarjeta.hora_ingreso != "" || tarjeta.hora_salida != "")
			return true
		else		
			return false
		end
	end

	def self.crear_tarjeta_tiempo(fecha,id_empleado,hora_ingreso,hora_salida)
		tiempo = TarjetaDeTiempo.new(fecha,id_empleado,hora_ingreso,hora_salida)
		return tiempo
	end	
end