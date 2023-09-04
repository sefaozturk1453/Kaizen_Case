
CREATE PROCEDURE [dbo].[check_code]
@Code varchar(8),
@IsValid int out
AS
BEGIN
    SET @IsValid = 1; -- Varsayýlan

    -- Kodun uzunluðunun ve karakterlerin karakter kümesinde olup olmadýðýný kontrol ediyoruz
    IF LEN(@Code) = 8
    BEGIN
		
		DECLARE @i INT = 1;
        WHILE @i <= 8
        BEGIN
            IF CHARINDEX(SUBSTRING(@Code, @i, 1), 'ACDEFGHKLMNPRTXYZ234579') = 0
            BEGIN
                SET @IsValid = 0; -- Durumunu güncelle
                BREAK; -- Eðer geçerli olmayan bir karakter bulunursa döngüyü sonlandýr
            END
            SET @i = @i + 1; -- Sayaç
        END

		IF(@IsValid = 1)
		BEGIN
			BEGIN TRY
			INSERT INTO kodlar (kod) VALUES (@Code)
			END TRY
			BEGIN CATCH
			SELECT 'Hata Oluþtu: '+@Code+' zaten kullanýlýyor. Yenisi üretildi.'  + ERROR_MESSAGE(); -- Hata mesajýný yazdýrýr
			SET @IsValid = 0
			END CATCH;
		END
        
		
	END
	
END;