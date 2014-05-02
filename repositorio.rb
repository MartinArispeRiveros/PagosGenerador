class Repositorio
 
  def initialize
    @repositorio_memoria = RepositorioMemoria.new
    @repositorio_archivo = RepositorioArchivo.new
    @cheques = []
  end  

  def adicionar(empleado,repositorio)
    if repositorio == "memoria"
      @repositorio_memoria.adicionar(empleado)
    else
      @repositorio_archivo.adicionar(empleado)
    end
  end

  def obtener_empleados_memoria
    @repositorio_memoria.obtener_empleados
  end

  def obtener_empleados_archivo
    @repositorio_archivo.obtener_empleados
  end

  def buscar_por_ci(ci)
    return @repositorio_memoria.buscar_por_ci(ci)
  end

  def actualizar(empleado)
    @repositorio_memoria.actualizar(empleado)
  end

  def mostrar_de_memoria(ci)
    @repositorio_memoria.mostrar(ci)
  end

  def mostrar_de_archivo(ci)
    @repositorio_archivo.mostrar(ci)
  end

  def eliminar(ci,repositorio)
    if repositorio == "memoria"
      @repositorio_memoria.eliminar(ci)
    else
      @repositorio_archivo.eliminar(ci)
    end
  end

  def adicionar_cheque(cheque)    
        @cheques.push(cheque)    
  end

  def obtener_cheques
    @cheques
  end
end
