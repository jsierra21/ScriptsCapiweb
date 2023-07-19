EXECUTE [RRH].[SpCambioPlanillaOperario] 
   @idEmpresa = 37 ----idEmpresa
  ,@cedula = '00000005832386' ---- cedula del man
  ,@tipo = 'PN' --PN  planilla - PT PLAntilla
  ,@operacion = 'I' -- I Ingreso T -- transferencia
  ,@PlanillaOrigen = '' ---->cuando vas a transferir pones planilla origen
  ,@PlanillaDestino = 'D-1' ---->planilla destino
  ,@turno = 101 ------>turno
  ,@diaTurno = 7 ---->1 - 7=> Domingo 
  ,@fecha = '02/07/2023' ---->fecha de planilla
  ,@permanente = 0
  ,@ruta = '01961'

