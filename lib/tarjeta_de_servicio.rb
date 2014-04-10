require('date')

class TarjetaDeServicio
	attr_reader :monto
	def initialize(fecha,id_empleado,monto,descripcion)
		@fecha = fecha
		@id_empleado = id_empleado
		@monto = monto
		@descripcion = descripcion
	end
end