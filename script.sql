-- B) Crea un dispositivo de backups múltiples para la base de datos Adventureworks.
		use AdventureWorks2019
		go

		--Crea dispositivo de almacenamiento
		EXEC sp_addumpdevice 'disk', 'AdventureWorksBackupDevice',   
		'C:\Backup_SQL\AdventureWorks2019\AdventureWorksBackupDevice.bak';  
		GO

		-- Para borrar el dispositivo de almacenamiento
		Exec sp_dropdevice 'AdventureWorksBackupDevice','delfile'

		--Ver los dispositivos de backup del servidor
		SELECT * FROM sys.backup_devices
		GO

-- C) Crea una rutina que asigne nombres de backups únicos y haz 
--    que ejecute 4 backups sobre el dispositivo de backup creado en el punto anterior. 
		
		

		DECLARE @BACKUP_NAME VARCHAR(100)
		SET @BACKUP_NAME = N'AdventureWorks Full Backup ' + FORMAT(GETDATE(),'yyyyMMdd_hhmmss');
		BACKUP DATABASE AdventureWorks2019   
		TO AdventureWorksBackupDevice  
		WITH NOFORMAT, NOINIT, NAME = @BACKUP_NAME;  
		GO


		BACKUP DATABASE AdventureWorks2019  
		TO AdventureWorksBackupDevice  
		WITH DIFFERENTIAL, NAME = N'AdventureWorks Differential Backup 2' ;    
		GO

		RESTORE HEADERONLY FROM AdventureWorksBackupDevice
		RESTORE FILELISTONLY FROM  AdventureWorksBackupDevice

-- d)  Crea una rutina rutina que restuare uno de los backups con nombre 
--     AwExamenBDII basado en el número del archivo de backup.

use master
go
RESTORE DATABASE [AwExamenBDII] 
FROM  [AdventureWorksBackupDevice] 
WITH  FILE = 1,  
	MOVE N'AdventureWorks2017' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AwExamenBDII.mdf',  
	MOVE N'AdventureWorks2017_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AwExamenBDII_log.ldf', 
	NORECOVERY,  NOUNLOAD,  STATS = 5
		
		

		﻿