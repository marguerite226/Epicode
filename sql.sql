CREATE TABLE TestChar (CharColumn CHAR(5));
INSERT INTO TestChar (CharColumn)VALUES ('ABC'), ('ABCDE');product
SET sql_mode= 'PAD_CHAR_TO_FULL_LENGTH';
SELECT char_length(CharColumn)
 FROM
 productDROP Table Product;
