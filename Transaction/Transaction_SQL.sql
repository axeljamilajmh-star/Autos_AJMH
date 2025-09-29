-- Transaction_SQL.sql
USE Autos_AJMH;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;

-- TRANSACCIÓN 1: INSERT de un vehículo (ejemplo)

PRINT '--- Transacción 1: Insertar vehículo ---';
BEGIN TRANSACTION;
BEGIN TRY
    
    INSERT INTO dbo.Vehiculo (Marca, Modelo, Anio, Precio, Estado)
    VALUES ('Toyota', 'Corolla', 2022, 18500, 'Disponible');

    COMMIT TRANSACTION;
    PRINT 'Transacción 1: COMMIT';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Transacción 1: ROLLBACK -> ', ERROR_MESSAGE());
END CATCH;
GO

PRINT '--- Transacción 2: Registrar venta ---';
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @IdCliente  INT  = 1; 
    DECLARE @IdVehiculo INT  = 1;  
    DECLARE @Total      DECIMAL(10,2);


    SELECT @Total = Precio FROM dbo.Vehiculo WHERE IdVehiculo = @IdVehiculo;

    INSERT INTO dbo.Venta (IdCliente, IdVehiculo, Fecha, Total)
    VALUES (@IdCliente, @IdVehiculo, SYSDATETIME(), @Total);

    UPDATE dbo.Vehiculo
    SET Estado = 'Vendido'
    WHERE IdVehiculo = @IdVehiculo;

    COMMIT TRANSACTION;
    PRINT 'Transacción 2: COMMIT';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Transacción 2: ROLLBACK -> ', ERROR_MESSAGE());
END CATCH;
GO

PRINT '--- Transacción 3: Actualizar cliente (demo rollback) ---';
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @ClienteDemoId INT = 1; -- Cambia a un cliente existente

    UPDATE dbo.Cliente
    SET Telefono = '88862427'
    WHERE IdCliente = @ClienteDemoId;

   
    THROW 50006, 'Error forzado para demostrar ROLLBACK.', 1;

    COMMIT TRANSACTION;  -- No se alcanzará
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Transacción 3: ROLLBACK -> ', ERROR_MESSAGE());
END CATCH;
GO
