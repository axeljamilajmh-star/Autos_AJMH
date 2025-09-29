
USE master;
GO
IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'autos_narla')
BEGIN
    CREATE LOGIN autos_narla
    WITH PASSWORD = 'Autos_NarlaPG25',
         CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
    PRINT 'Login autos_narla creado.';
END
ELSE
    PRINT 'Login autos_narla ya existe.';
GO

USE Autos_AJMH;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'autos_narla')
BEGIN
    CREATE USER autos_narla FOR LOGIN autos_narla;
    PRINT 'Usuario autos_narla creado en la base.';
END
ELSE
    PRINT 'Usuario autos_narla ya existe en la base.';
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    JOIN sys.database_principals r ON r.principal_id = drm.role_principal_id AND r.name = 'db_owner'
    JOIN sys.database_principals u ON u.principal_id = drm.member_principal_id AND u.name = 'autos_narla'
)
BEGIN
    EXEC sp_addrolemember 'db_owner', 'autos_narla';
    PRINT 'Usuario agregado al rol db_owner.';
END
ELSE
    PRINT 'Usuario ya pertenece al rol db_owner.';
GO

SELECT SUSER_SNAME() AS LoginActual, DB_NAME() AS BaseActual;
