require('date')

class Empleado
  attr_accessor :nombre, :apellido, :ci, :fecha_inicio_contrato, :contrato, :salario, :pertenece_sindicato
  attr_writer :clasificador_salario, :clasificador_contrato

  def initialize(ci, nombre, apellido, fecha_inicio_contrato,clasificador_contrato,contrato,salario)
    @ci = ci
    @nombre = nombre
    @apellido = apellido
    @fecha_inicio_contrato = fecha_inicio_contrato

    @descuento_fijo_por_sindicato = 0
    @tarjetas_de_servicio = Array.new
    @descuento_por_servicios = 0
    @clasificador_contrato=clasificador_contrato
    @contrato = contrato
    @salario = salario
  end
  
  def self.crear_empleado(ci, nombre, apellido, 
                          fecha_inicio_contrato,
                          salario,
                          tipo_contrato, 
                          tipo_salario)
                          
    if (tipo_contrato == 'mensual')
      clasificador_contrato = ContratoMensual.new
      contrato = "mensual"
    end
    if (tipo_contrato == 'quincenal')
      clasificador_contrato = ContratoQuincenal.new
      contrato = "quincenal"
    end

    if (tipo_contrato == 'trimestral')
      clasificador_contrato = ContratoTrimestral.new
      contrato = "trimestral"
    end

    empleado = Empleado.new(ci,nombre, apellido, 
                                    fecha_inicio_contrato,
                                    clasificador_contrato, contrato, salario)

    
    if (tipo_salario == 'fijo')
      empleado.clasificador_salario = ClasificadorSalarioFijo.new(salario, fecha_inicio_contrato)
    end
      
    if (tipo_salario == 'hora')
      empleado.clasificador_salario = ClasificadorPorHora.new(salario)
    end
     
    return empleado

  end
  
  def es_dia_pago?(fecha)
    @clasificador_contrato.es_dia_pago?(fecha)
  end
  def asignar_salario_fijo(monto)
     @clasificador_salario.salario = monto
  end

  def asignar_fecha_inicio_contrato(fecha)
    @clasificador_salario.fecha_inicio_contrato = fecha
  end

  def calcular_salario(fecha_ejecucion)
    @clasificador_salario.calcular_salario(fecha_ejecucion) - @descuento_fijo_por_sindicato - calcular_monto_por_servicios_sindicato
  end

  def asignar_descuento_sindicato(monto)
    @descuento_fijo_por_sindicato = monto
  end

  def registrar_tarjeta_de_servicio(tarjeta_de_servicio)
    @tarjetas_de_servicio.push(tarjeta_de_servicio)
  end

  def calcular_monto_por_servicios_sindicato
    @tarjetas_de_servicio.each { |t| @descuento_por_servicios += t.monto}
    @descuento_por_servicios
  end

  def asignar_pago_por_hora(monto)
    @clasificador_salario.monto_por_hora = monto
  end
  
  def registrar_tarjeta_de_tiempo(tarjeta_de_tiempo)
    @clasificador_salario.registrar_tarjeta_de_tiempo(tarjeta_de_tiempo)
  end

  def contrato_mensual?
    @clasificador_contrato.contrato_mensual?
  end
  
  def contrato_quincenal?
    @clasificador_contrato.contrato_quincenal?
  end
  
  def contrato_trimestral?
    @clasificador_contrato.contrato_trimestral?
  end

end