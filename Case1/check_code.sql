
CREATE PROCEDURE [dbo].[check_code]
@Code varchar(8),
@IsValid int out
AS
BEGIN
    SET @IsValid = 1; -- Varsayılan

    -- Kodun uzunluğunun ve karakterlerin karakter kümesinde olup olmadığını kontrol ediyoruz
    IF LEN(@Code) = 8
    BEGIN
		
		DECLARE @i INT = 1;
        WHILE @i <= 8
        BEGIN
            IF CHARINDEX(SUBSTRING(@Code, @i, 1), 'ACDEFGHKLMNPRTXYZ234579') = 0
            BEGIN
                SET @IsValid = 0; -- Durumunu güncelle
                BREAK; -- Eğer geçerli olmayan bir karakter bulunursa döngüyü sonlandır
            END
            SET @i = @i + 1; -- Sayaç
        END

		IF(@IsValid = 1)
		BEGIN
			BEGIN TRY
			INSERT INTO KOD (Kodlar) VALUES (@Code)
			END TRY
			BEGIN CATCH
			SELECT 'Hata Oluştu: '+@Code+' zaten kullanılıyor. Yenisi üretildi.'  + ERROR_MESSAGE(); -- Hata mesajını yazdırır
			SET @IsValid = 0
			END CATCH;
		END
        
		
	END
	
END;
