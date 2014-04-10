class GeneradorCheque
  def initialize(fecha_de_ejecucion)
    @fecha_de_ejecucion = fecha_de_ejecucion
  end

  def ejecutar(empleado)
    if(empleado.es_dia_pago?(@fecha_de_ejecucion))
      ci = empleado.ci
      beneficiario = empleado.nombre+ " " +empleado.apellido
      monto = empleado.calcular_salario(@fecha_de_ejecucion)

      cheque = Cheque.new(ci,
                        beneficiario,
                        @fecha_de_ejecucion,
                        monto)
      cheque
    else
      nil
    end
  end
  
end
