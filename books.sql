#建库12312312312cccc
CREATE DATABASE books;
USE books;

#建表
CREATE TABLE type(
	type_id INT PRIMARY KEY AUTO_INCREMENT,
	type_name VARCHAR(20) NOT NULL
);

CREATE TABLE book(
	book_id INT PRIMARY KEY AUTO_INCREMENT,
	book_name VARCHAR(20) NOT NULL,
	book_price FLOAT NOT NULL DEFAULT 0,
	type_id INT NOT NULL,
	book_count INT NOT NULL DEFAULT 0,
	CONSTRAINT fk_typeid FOREIGN KEY(type_id) REFERENCES type(type_id) 
);
DELIMITER $ 
SET @base='abcdefghigklmnopqrstuvwxyzABCDEFGHIGKLMNOPQRSTUVWXYZ';

#随机字符串函数，输入需要生成的串的长度n
CREATE FUNCTION rand_str(n INT) RETURNS VARCHAR(20)
BEGIN
	DECLARE i INT DEFAULT 0;
	DECLARE tmp VARCHAR(20) DEFAULT '';
	WHILE i<n DO
		SET tmp  =  CONCAT(tmp,SUBSTR(@base,FLOOR(RAND()*52)+1,1));
		SET i = i+1;
	END WHILE;
RETURN tmp;
END$

#生成一个[s,e)的浮点数
CREATE  FUNCTION rand_float(s INT,e INT) RETURNS FLOAT(6,2)
BEGIN
	DECLARE f FLOAT(6,2) DEFAULT 0;
	SET f = ROUND(RAND()*(e-s)+s,2);
	RETURN f;
END$

#生成一个[s,e)的整数
CREATE  FUNCTION rand_int(s INT,e INT) RETURNS INT#[s,e)
BEGIN
	DECLARE i INT DEFAULT 0;
	SET i=FLOOR(RAND()*(e-s)+s);
	RETURN i;
END$

#插入type表数据，n为记录数
CREATE PROCEDURE insert_type(n INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	WHILE i<n DO
	INSERT into type(type_name) VALUES(rand_str(5));
	SET i=i+1;
END WHILE;
END$

#插入book表数据，n为记录数,type_num为type表的记录数（因为有外键）
CREATE PROCEDURE insert_book(n INT,type_num INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	WHILE i<n DO
			INSERT INTO book(book_name,book_price,type_id,book_count) VALUES(rand_str(4),rand_float(0,100),rand_int(1,type_num+1),rand_int(0,10));
			SET i = i+1;
	END WHILE;
END$

CALL insert_type(10)$
CALL insert_book(20,10)$
