#-----------------------------------配置-----------------------------------------
CREATE DATABASE IF NOT EXISTS myuser						;#数据库名
USE myuser
SET @userNum = 5000000								;#插入用户数量
SET @alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'					;#用于生成随机Email
SET @firName = CONCAT(
    '赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨'						,
    '朱秦尤许何吕施张孔曹严华金魏陶姜')						;#用于生成姓

SET @secName = CONCAT(
    '口士夕千子寸小山川才干工弓久己土'						, 
    '大丈女己巾勺丸也于凡伉再冲刑向在'						,
    '夙如宅守字存寺式戌收早旭旬曲次此'						,
    '求肉臣自舌血行圳西休交件企匠光匡'						,
    '共各考交件价企伍伎仰吉圭曲机艮六'						,
    '仲吉州朱兆决匠地旨朵吏列年劣同打')						;#用于生成名字中间字

SET @lastName = CONCAT(
    '伟刚勇毅俊峰强军平保东文辉力承乐'						,
    '明永健世广志义兴良海山仁波宁心邦'						,
    '贵福生龙元全国胜学祥才发武新群豪'						,
    '利清飞彬富顺信子杰涛昌成康星会思'						,
    '光天达安岩中茂进林有坚和彪博振壮')						;#用于生成名字第三个字

SET @grade ='A:5000,B:10000,C:30000,D:100000,E:1000000,'  			;#用于生成vip表数据

SET @city    =  CONCAT(
    '北京:,'    , '上海:,'    , '广州:广东,', '深圳:广东,'   			,
    '成都:四川,', '杭州:浙江,', '重庆:,'    , '武汉:湖北,'   			, 
    '西安:陕西,', '苏州:江苏,', '天津:,'    , '南京:江苏,')  			;#用于生成city表数据
SET @firNum   =    LENGTH( @firName )  / 3					;
SET @secNum   =    LENGTH( @secName )  / 3					;
SET @lastNum  =    LENGTH( @lastName ) / 3					;
SET @alpNum   =    LENGTH( @alphabet )						;
SET @range1   =    10000							;#用于生成cons(消费金额)
SET @range2   =    100000							;#0      ~ range1 60%
SET @range3   =    1000000							;#range1 ~ range2 30% 
										;#range2 ~ range3 30% 
#--------------------------------------------------------------------------------

#-----------------------------创建表---------------------------------------------
CREATE TABLE IF NOT EXISTS city (
    city_id     INT ( 10 )      PRIMARY KEY  AUTO_INCREMENT                     , 
    city_name   VARCHAR ( 20 )  NOT NULL                                        , 
    city_pro    VARCHAR ( 20 )  DEFAULT NULL )                                  ;
SELECT	'创建city表!'								;
CREATE TABLE IF NOT EXISTS vip (
    id 		INT ( 10 )	PRIMARY KEY AUTO_INCREMENT			,
    grade       VARCHAR ( 20 )  NOT NULL					,
    cons_min    INT ( 10 )      NOT NULL					,
    cons_max    INT ( 10 )      NOT NULL)					;
SELECT	'创建vip表!'								;
CREATE TABLE IF NOT EXISTS user (
    user_id 	INT ( 10 ) 	PRIMARY KEY AUTO_INCREMENT			,
    user_name 	CHAR ( 4 ) 	NOT NULL					,
    sex 	CHAR ( 1 ) 	NOT NULL					,
    email 	VARCHAR ( 20 ),
    tel 	CHAR ( 11 ),
    cons 	INT ( 10 ) 	NOT NULL DEFAULT 0				,
    city_id 	INT ( 10 ) 	NOT NULL					,
    CONSTRAINT fk_cityid FOREIGN KEY(city_id) REFERENCES city (city_id))	;
SELECT	'创建user表!'								;
#--------------------------------------------------------------------------------

#----------------------------函数及存储过程---------------------------------------
DELIMITER $
CREATE FUNCTION getName () RETURNS CHAR ( 4 ) BEGIN				#得到一个随机姓名
    DECLARE    result   CHAR ( 4 )   DEFAULT ''					;
    DECLARE    fir      CHAR ( 1 )   DEFAULT ''					;
    DECLARE    sec      CHAR ( 1 )   DEFAULT ''					;
    DECLARE    last     CHAR ( 1 )   DEFAULT ''				        ;
	
    SET fir    =   SUBSTR( @firName,  CEIL( @firNum  * RAND()), 1 )             ;
    SET sec    =   SUBSTR( @secName,  CEIL( @secNum  * RAND()), 1 )		;
    SET last   =   SUBSTR( @lastName, CEIL( @lastNum * RAND()), 1 )		;
    SET last   =   IF ( RAND()> 0.3, last, '' )					;
    SET result =   CONCAT( fir, sec, last )					;
    RETURN result;
END										$ 
#--------------------------------------------------------------------------------
CREATE FUNCTION getSex () RETURNS CHAR ( 1 ) BEGIN				#得到一个随机性别
    DECLARE    result CHAR ( 1 ) DEFAULT ''					;
    SET result = IF( RAND() > 0.5, '男', '女' )					;
    RETURN result								;
END										$
#--------------------------------------------------------------------------------
CREATE FUNCTION getStr (n INT ( 10 )) RETURNS VARCHAR ( 20 ) BEGIN		#得到一个指定长度的随机字符串	
    DECLARE result   VARCHAR ( 20 )   DEFAULT ''				;
    DECLARE i        INT ( 10 )       DEFAULT 0					;
    WHILE i < n DO
        SET result = CONCAT (
            result								, 
            SUBSTR( @alphabet, CEIL( @alpNum * RAND()), 1 ) )			;
	SET i = i + 1								;
    END WHILE									;
    RETURN result								;
END										$
#--------------------------------------------------------------------------------
CREATE FUNCTION getTel () RETURNS CHAR ( 11 ) BEGIN				#得到一个随机的手机号
    DECLARE result   VARCHAR ( 20 )   DEFAULT '1'				;
    DECLARE i        INT ( 10 )       DEFAULT 0					;
	WHILE i < 10 DO
	    SET result  =  CONCAT ( result, FLOOR( RAND()* 10 ) )		;
	    SET i       =  i + 1						;
        END WHILE								;
    RETURN result								;
END										$
#--------------------------------------------------------------------------------
CREATE FUNCTION getCons () RETURNS INT ( 10 ) BEGIN				#得到一个随机的消费金额
    DECLARE i     INT ( 10 )   DEFAULT 0					;
    DECLARE tmp   INT ( 10 )   DEFAULT RAND()					;
    CASE
        WHEN tmp < 0.6 THEN 
            SET i = FLOOR( RAND()* @range1 )					;
        WHEN tmp BETWEEN 0.6 AND 0.9 THEN
            SET i = FLOOR( RAND()* @range2 )					;
        ELSE 
            SET i = FLOOR( RAND()* @range3 )					;
    END CASE									;
    RETURN i									;
END										$
#--------------------------------------------------------------------------------
CREATE PROCEDURE setCity () BEGIN						#给city表插入数据
    DECLARE    tmp   VARCHAR ( 255 )   DEFAULT  @city				;
    DECLARE    c     VARCHAR ( 10 )    DEFAULT  ''				;
    DECLARE    p     VARCHAR ( 10 )    DEFAULT  ''				;
    DECLARE    idx1  INT ( 10 )        DEFAULT  0				;
    DECLARE    idx2  INT ( 10 )        DEFAULT  0				;
    SET SESSION autocommit = 0							;
    WHILE  tmp <> '' DO
        SET idx1  =  INSTR( tmp, ':' )						;
        SET idx2  =  INSTR( tmp, ',' )						;
        SET c     =  SUBSTR( tmp, 1, idx1 - 1 )					;
        SET p     =  SUBSTR( tmp, idx1 + 1, idx2 - idx1 - 1 )			;
        SET tmp   =  SUBSTR( tmp, idx2 + 1 )					;
        INSERT INTO city ( city_name,      city_pro        )
		VALUES
			 (     c    , IF( p = '', NULL, p ))			;
		
    END WHILE									;
    COMMIT									;
END										$
#--------------------------------------------------------------------------------
CREATE PROCEDURE setVIP () BEGIN						#给VIP表插入数据
    DECLARE  tmp   VARCHAR ( 255 )   DEFAULT   @grade				;
    DECLARE  g     VARCHAR ( 10 )    DEFAULT   ''				;
    DECLARE  mn    INT ( 10 )        DEFAULT   0 				;
    DECLARE  mx    INT ( 10 )        DEFAULT   0				;
    DECLARE  idx1  INT ( 10 )        DEFAULT   0				;
    DECLARE  idx2  INT ( 10 )        DEFAULT   0				;
    SET SESSION autocommit = 0							;
    WHILE tmp <> '' DO
        SET idx1 = INSTR( tmp, ':' );
        SET idx2 = INSTR( tmp, ',' );
        SET g = SUBSTR( tmp, 1, idx1 - 1 );
        SET mx = SUBSTR( tmp, idx1 + 1, idx2 - idx1 - 1 );
        SET tmp = SUBSTR( tmp, idx2 + 1 );
        INSERT INTO vip ( grade, cons_min, cons_max )
                VALUES
			( g    ,   mn    ,   mx     )				;
        SET mn = mx + 1;	
    END WHILE									;
    COMMIT									;
END										$
#--------------------------------------------------------------------------------
CREATE PROCEDURE setUser (IN n INT ( 10 )) BEGIN
    DECLARE i INT ( 10 ) DEFAULT 0						;
    DECLARE c INT ( 10 ) DEFAULT 0						;
    SET SESSION autocommit = 0							;
    SET c = ( SELECT COUNT( 1 ) FROM city )					;
    WHILE i < n DO
        INSERT INTO user ( 
				user_name					, 
				sex						,
				email						, 
				tel						, 
				cons						, 
				city_id )
		VALUES
			(
				getName ()					,
				getSex ()					,
				getStr ( 5 )					,
				getTel ()					,
				getCons ()					,
				CEIL( RAND()* c ))				;
        SET i = i + 1								;
    END WHILE									;
    COMMIT									;
END										$
#--------------------------------------------------------------------------------

#--------------------------------调用存储过程-------------------------------------
DELIMITER ;
CALL setCity ()									;
SELECT	'插入city表数据成功'							;
CALL setVIP ()									;
SELECT	'插入vip表数据成功'							;
SELECT	CONCAT('开始插入user表的',@userNum,'条数据') tag				;
CALL setUser ( @userNum )							;
#--------------------------------------------------------------------------------
