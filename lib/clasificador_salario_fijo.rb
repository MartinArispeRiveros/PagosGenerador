class ClasificadorSalarioFijo
  attr_writer :salario, :fecha_inicio_contrato

  def initialize(salario, fecha_inicio_contrato)
    @salario = salario
    @fecha_inicio_contrato = fecha_inicio_contrato
  end

  def calcular_salario(fecha_ejecucion)
    if (ha_sido_contratado_este_mes?(fecha_ejecucion))
      calcular_salario_prorrateado(fecha_ejecucion)
    else
      @salario
    end
  end

  private
  def calcular_salario_prorrateado(fecha_ejecucion)
    dias_trabajados = calcular_dias_trabajados_hasta(fecha_ejecucion)
    salario_diario = calcular_salario_diario(fecha_ejecucion)
    salario_diario * dias_trabajados
  end

  def calcular_salario_diario(fecha_ejecucion)
    fact_salario = @salario / (Date.civil(fecha_ejecucion.year, fecha_ejecucion.month, -1)).day.to_f
  end

  def calcular_dias_trabajados_hasta(fecha_ejecucion)
    dias_trabajados = (fecha_ejecucion.mjd - @fecha_inicio_contrato.mjd) + 1
  end

  def ha_sido_contratado_este_mes?(fecha_ejecucion)
    @fecha_inicio_contrato.month==fecha_ejecucion.month &&
        @fecha_inicio_contrato.year==fecha_ejecucion.year
  end


end