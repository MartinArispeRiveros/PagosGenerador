require ('date')

class GeneradorCheque
  
  def initialize(fecha_de_ejecucion)
    @fecha_de_ejecucion = fecha_de_ejecucion
  end

  def ejecutar(empleado)
    if empleado.contrato_mensual? || empleado.contrato_quincenal? || empleado.contrato_trimestral?
      if(empleado.es_dia_pago?(@fecha_de_ejecucion))
        if (empleado.comprobar?(@fecha_de_ejecucion,empleado.fecha_inicio_contrato))
          ci = empleado.ci
          beneficiario = empleado.nombre+ " " +empleado.apellido
          monto = empleado.calcular_salario(@fecha_de_ejecucion)
            cheque = Cheque.new(ci, beneficiario, @fecha_de_ejecucion, monto)
            return cheque
        else
          return nil
        end
      end
    else
      return nil
    end
  end
  
end
