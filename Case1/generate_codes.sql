
CREATE PROCEDURE [dbo].[generate_codes]
AS
-- Gerekli değişkenler
DECLARE @code VARCHAR(8)
DECLARE @counter INT = 1;
DECLARE @Result INT;
-- Kod üretimi ve benzersizlik kontrolü döngüsü
WHILE @counter <= 1000
BEGIN
		-- Rastgele 8 karakter uzunluğunda bir kod üretin
		SET @code = ''
		WHILE LEN(@code) < 8
		BEGIN
		    SET @code = @code + SUBSTRING('ACDEFGHKLMNPRTXYZ234579', CAST(RAND() * 21 AS INT) + 1, 1)
		END

		
		EXEC [dbo].[check_code] @code, @Result OUTPUT;

		IF(@Result = 1)
		BEGIN
		-- Sayaç
		SET @counter = @counter + 1;
		END
END;
    
    

	

