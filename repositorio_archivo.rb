class RepositorioArchivo

	def initialize
		@empleados = File.open('archive.json', 'a')
	end

	def obtener_empleados
		@empleados = File.open('archive.json', 'r')
		@lista = []
  		while empleado = @empleados.gets
    		@lista.push(empleado)
  		end
  		return @lista
	end

	def to_json(empleado)
    	hash = {}
    	empleado.instance_variables.each do |var|
      		hash[var] = empleado.instance_variable_get var
    	end
    	hash.to_json
  	end

	def adicionar(empleado)
		@empleados = File.open('archive.json', 'a')
		archivo = to_json(empleado)
    	@empleados << archivo
    	@empleados << "\n"
    	@empleados.close
	end

	def mostrar(ci)
		@lista.each do |empleado|
			datos = JSON.load empleado
			if datos['@ci'] == ci
				return datos
			end
		end
	end

	def actualizar(empleado)
		eliminar(empleado.ci)
		adicionar(empleado)
	end

	def eliminar(ci)
		@lista.each do |empleado|
			datos = JSON.load empleado
			if datos['@ci'] == ci
				@lista.delete(datos)
			end
		end
		@empleados = File.open('archive.json', 'w')
	end
end