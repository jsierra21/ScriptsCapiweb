SET LANGUAGE 'SPANISH' 
		--SET NOCOUNT ON;
		DECLARE @datFecha AS DATETIME
		DECLARE @diasemana VARCHAR(20)
		DECLARE @Planilla VARCHAR(20) = 'A-1'
		DECLARE @idEmpresa as int = 33
		DECLARE @EsDominical as int  = 0
	
		--SET @datfecha= (dbo.fnFechaTexto(GETDATE()))
		 SET @datfecha= (dbo.fnFechaTexto('20/07/2023'))

		 select * from RRH.[Turnos]  where IdEmpresa = @idEmpresa

		SET @diasemana= DATENAME(WEEKDAY, @datfecha) 
		SET @diasemana = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@diasemana, 'á','a'), 'é', 'e'), 'í', 'i'),'ó', 'o'), 'ú', 'u')
		
		select @diasemana as DiaSemana

		IF @diasemana = 'Domingo' BEGIN
				SET @EsDominical = 1
		END
	
	
		   SELECT DISTINCT
				  @datfecha AS                    [Fecha],
				  A.EmpresaTrabaja  AS            [IdEmpresa], 
				  p.Planilla AS                   [Planilla],
				  t.IdTurno        AS             [IdTurno],
				  Isnull(p.Equipo, 0)  AS         [Equipo], 
				  A.Cedula   AS                   [Cedula], 
				  A.CodigoHeinshon AS             [OtroCodigoNomina], 
				  RTRIM(LTRIM(ISNULL(A.apellido1,''))) + ' ' 
						+ RTRIM(LTRIM(ISNULL(A.apellido2,''))) + ' ' 
						+ RTRIM(LTRIM(ISNULL(A.nombre1,''))) + ' ' 
						+ RTRIM(LTRIM(ISNULL(A.nombre2,''))) AS Nombres, 
						cc.descripcion as Cargo,  
				  p.MovilPlaneado  AS             [Movil],
				  CASE @diasemana
						WHEN 'Lunes' THEN RutaLunes
						WHEN 'Martes' THEN RutaMartes
						WHEN 'Miercoles' THEN RutaMiercoles
						WHEN 'Jueves' THEN RutaJueves
						WHEN 'Viernes' THEN RutaViernes
						WHEN 'Sabado' THEN RutaSabado
						WHEN 'Domingo' THEN RutaDomingo
						ELSE '00000'
				  END as [Ruta],
				  0 [ConsecutivoNovedad],
				  0 [Descansa],
				  Temporal [EmpesaTemporal], 
				  p.Supervisor as [Supervisor],
				  t.Hora_Entrada as IngresoTurno,--Inicio Turno
				  t.Hora_de_Salida as SalidaTurno,---Salida Turno
				  t.Hora_Entrada as HoraIngreso,
				  t.Hora_de_Salida as HoraSalida,
				  t.Observacion,
				  t.[Horas_I_Descanso],
				  t.[Horas_F_Descanso],
				  '00000000000001' as  LiderValida,
				  '00000000000001' as [SupervisorAutoriza]
				  ,0 as [EsValidadoSupervisor]
				  ,0 as [AplRendimiento]
			FROM [RRH].Hojavida AS A    (NOLOCK)
			JOIN [RRH].Cargos cc  (NOLOCK)
			  ON A.[idarea] = cc.codarea 
			 AND A.[idcargo] = cc.codcargo 
			JOIN [RRH].PlanillasPlantilla (NOLOCK) AS p 
			  ON p.Cedula = a.cedula 
			 AND p.IdEmpresa = a.EmpresaTrabaja
			 AND p.Planilla = @Planilla
			 AND p.IdEmpresa = @idempresa
			JOIN RRH.[Turnos] t (NOLOCK)
			  ON t.Dia = DATEPART(dw,@datfecha) 
			 AND t.IdTUrno = p.IdTurno
			 AND t.IdEmpresa = p.IdEmpresa
			 AND t.IdEmpresa = @idempresa
			JOIN [RRH].CabezaPlanilla (NOLOCK) AS c 
			  ON c.idempresa = p.IdEmpresa 
			 AND c.planilla = p.Planilla
			 ---AND c.supervisor = p.supervisor
			 AND c.EstadoPlanilla = 'A'
			 AND c.Planilla = @Planilla
			 AND c.IdEmpresa = @idempresa
			 AND c.EsDominical = @EsDominical
			
			WHERE estadoempleado = 1 
		