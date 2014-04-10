require './repositorio'
require './lib/cheque'
require './lib/empleado'
require './lib/generador_cheque'
require './lib/contrato_mensual'
require './lib/clasificador_por_hora'
require './lib/clasificador_salario_fijo'
require 'date'

class Cheques

	
	def initialize
		@cheques = []
		#@aux_cheque = []
	end


	def generar_cheque(empleado)
		fecha_emision = Date.today	
		#if(empleado.es_dia_pago?(fecha_emision))
					
		beneficiario = empleado.nombre + " " + empleado.apellido
	  	monto = empleado.salario
	  	ci = empleado.ci
	  	cheque = Cheque.new(ci, beneficiario, fecha_emision, monto)  		  		
	  	return cheque
	  	#else
	  	#	return nil
	  	#end
	  	#cheque = GeneradorCheque.new(fecha_emision)
	  	#cheque.ejecutar(empleado)
	  	#return cheque
	end

	def agregar_cheque_a_lista(cheque)
		@cheques.push(cheque)
	end

	def generar_cheques_para_lista(empleados)
		empleados.each do |empleado|
			cheque = generar_cheque(empleado)
			agregar_cheque_a_lista(cheque)
		end
		return @cheques
	end

	def buscar_cheques_por_ci(ci)
		@cheques.each do |cheque|
			if(cheque.ci == ci)
				aux_cheque.push(cheque)
				return aux_cheque
			end
		end			
	end

	def validacion_fecha_trimestral(fecha_de_ejecucion,cheque)
    	
    	cheques.each do |cheque|
				ultimo_cheque=cheque.fecha_emision
				resta_fecha = fecha_de_ejecucion.to_i-ultimo_cheque.to_i
				if (resta_fecha == 3)
					return true
				else
					return false
				end
			end
		
    	
  	end
end
