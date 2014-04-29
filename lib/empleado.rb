require('date')

class Empleado
  
  attr_accessor :nombre, :apellido, :ci, :fecha_inicio_contrato, :contrato, :salario, :pertenece_sindicato, :tipo_salario, :check, :descuento_fijo_por_sindicato, :en_archivo, :tipo_almacenamiento
  attr_writer :clasificador_salario, :clasificador_contrato

  def initialize(ci, nombre, apellido, fecha_inicio_contrato,clasificador_contrato,contrato,salario,clasificador_salario, tipo_salario, pertenece_sindicato,descuento_fijo_por_sindicato)
    @ci = ci
    @nombre = nombre
    @apellido = apellido
    @fecha_inicio_contrato = fecha_inicio_contrato
    @descuento_fijo_por_sindicato = descuento_fijo_por_sindicato
    @tarjetas_de_servicio = Array.new
    @descuento_por_servicios = 0
    @clasificador_contrato=clasificador_contrato
    @clasificador_salario=clasificador_salario
    @contrato = contrato
    @salario = salario
    @tipo_salario = tipo_salario
    @pertenece_sindicato = pertenece_sindicato
    @check = false
    @en_archivo = false
  end
  
  def self.crear_empleado(ci, nombre, apellido, 
                          fecha_inicio_contrato,
                          salario,
                          tipo_contrato, 
                          tipo_salario, pertenece_sindicato, descuento_fijo_por_sindicato)

    if (tipo_contrato == 'mensual')
      clasificador_contrato = ContratoMensual.new
      contrato = "mensual"
    else
      clasificador_contrato = nil
    end

    if (tipo_contrato == 'quincenal')
      clasificador_contrato = ContratoQuincenal.new
      contrato = "quincenal"
    else
      clasificador_contrato = nil
    end

    if (tipo_contrato == 'trimestral')
      clasificador_contrato = ContratoTrimestral.new
      contrato = "trimestral"
    else
      clasificador_contrato = nil
    end
    
    if (tipo_salario == 'fijo')
      clasificador_salario = ClasificadorSalarioFijo.new(salario, fecha_inicio_contrato)
      tipo_salario = "fijo"
    end
      
    if (tipo_salario == 'hora')
      clasificador_salario = ClasificadorPorHora.new(salario)
      tipo_salario = "hora"
    end

    empleado = Empleado.new(ci,nombre, apellido, 
                                    fecha_inicio_contrato,
                                    clasificador_contrato, contrato, salario.to_i, clasificador_salario, tipo_salario, pertenece_sindicato, descuento_fijo_por_sindicato)     
    return empleado
  end
 
  def es_dia_pago?(fecha)
    @clasificador_contrato.es_dia_pago?(fecha)
  end

  def comprobar?(fecha_ejec,fecha_ini)
    @clasificador_contrato.comprobar?(fecha_ejec,fecha_ini)
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

  def obtener_tarjetas_de_servicio(ci)
    @tarjetas_de_servicio.each do |tarjeta_de_servicio|
      if tarjeta_de_servicio.id_empleado == ci
        @tarjeta_de_servicio = tarjeta_de_servicio
      end
    end
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

  def tarjetas_de_tiempo(ci)
    return @clasificador_salario.obtener(ci)
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