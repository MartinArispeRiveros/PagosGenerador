require('date')

class TarjetaDeServicio

	attr_accessor :fecha, :id_empleado, :descripcion
	attr_reader :monto

	def initialize(fecha,id_empleado,monto,descripcion)
		@fecha = fecha
		@id_empleado = id_empleado
		@monto = monto
		@descripcion = descripcion
	end
	def self.crear_tarjeta_servicio(fecha,id_empleado,monto,descripcion)
		servicio = TarjetaDeServicio.new(fecha,id_empleado,monto,descripcion)
		return servicio
	end
end