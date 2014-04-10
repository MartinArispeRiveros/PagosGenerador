class ClasificadorPorHora
  attr_writer :monto_por_hora

  def initialize(monto_por_hora)
    @tarjetas_de_tiempo = Array.new
    @monto_por_hora = monto_por_hora
  end

  def calcular_salario(fecha_ejecucion)
    @total_horas_trabajadas = 0
    @tarjetas_de_tiempo.each { |t| @total_horas_trabajadas += t.calcular_horas_trabajadas }
    @total_horas_trabajadas * @monto_por_hora
  end

  def registrar_tarjeta_de_tiempo(tarjeta_de_tiempo)
    @tarjetas_de_tiempo.push(tarjeta_de_tiempo)
  end
end