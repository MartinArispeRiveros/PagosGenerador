class Consola
  def imprimir(cadena)
    print(cadena)
  end
  def imprimir_cheque(cheque)
    imprimir("Nombre completo: #{cheque.beneficiario}\nCi: #{cheque.ci}\nMonto a cobrar: #{cheque.monto}$\nFecha emision:"+Date.today.to_s+"\nFirma:___________________________")
  end
end