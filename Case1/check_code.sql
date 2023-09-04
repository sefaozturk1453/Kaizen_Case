
CREATE PROCEDURE [dbo].[check_code]
@Code varchar(8),
@IsValid int out
AS
BEGIN
    SET @IsValid = 1; -- Varsay�lan

    -- Kodun uzunlu�unun ve karakterlerin karakter k�mesinde olup olmad���n� kontrol ediyoruz
    IF LEN(@Code) = 8
    BEGIN
		
		DECLARE @i INT = 1;
        WHILE @i <= 8
        BEGIN
            IF CHARINDEX(SUBSTRING(@Code, @i, 1), 'ACDEFGHKLMNPRTXYZ234579') = 0
            BEGIN
                SET @IsValid = 0; -- Durumunu g�ncelle
                BREAK; -- E�er ge�erli olmayan bir karakter bulunursa d�ng�y� sonland�r
            END
            SET @i = @i + 1; -- Saya�
        END

		IF(@IsValid = 1)
		BEGIN
			BEGIN TRY
			INSERT INTO kodlar (kod) VALUES (@Code)
			END TRY
			BEGIN CATCH
			SELECT 'Hata Olu�tu: '+@Code+' zaten kullan�l�yor. Yenisi �retildi.'  + ERROR_MESSAGE(); -- Hata mesaj�n� yazd�r�r
			SET @IsValid = 0
			END CATCH;
		END
        
		
	END
	
END;