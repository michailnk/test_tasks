
--USE master ;  
--GO  

--IF EXISTS ( SELECT name FROM master.dbo.sysdatabases WHERE name = N'DBSuperMarket')
--	BEGIN
--		EXEC sp_detach_db 'DBSuperMarket', 'true';
--	    SELECT 'Database Name already Exist' AS Message
--		SET NOCOUNT ON
--		--DECLARE @databasename VARCHAR(100)
--		--DECLARE @query VARCHAR(max)
--		--SET @query = ''

--		--SET @databasename = 'DBSuperMarket'
--		--IF DB_ID(@databasename) < 4
--		--BEGIN
--		--PRINT 'system database connection cannot be killeed'
--		--RETURN
--		--END
		
--		--SELECT @query = COALESCE(@query,',' ) + 'kill '+ CONVERT(VARCHAR, spid)+ '; '
--		--FROM MASTER..sysprocesses WHERE DBID = DB_ID(@databasename)
		
--		--IF LEN(@query) > 0
--		--BEGIN
--		--PRINT @query
--		--EXEC (@query)
--		--END

--		DROP DATABASE DBSuperMarket;
--		SELECT 'DBSuperMarket IS DROP'
--	END

--	BEGIN
--	    CREATE DATABASE [DBSuperMarket]
--		ON							 
--		(
--			NAME = 'DBSuperMarket',			
--			FILENAME = 'j:\SQLData\DBSuperMarket.mdf',       -- change J to C
--			SIZE = 30MB,                 
--			MAXSIZE = 100MB,			
--			FILEGROWTH = 10MB			
--		)
--		LOG ON						 
--		( 													
--			NAME = 'LogDBSuperMarket',		 
--			FILENAME = 'j:\SQLData\DBSuperMarket.ldf',      -- change J to C
--			SIZE = 5MB,                  
--			MAXSIZE = 50MB,              
--			FILEGROWTH = 5MB             
--		)               
--		COLLATE Cyrillic_General_CI_AS
		
--	    SELECT 'New Database DBSuperMarket is Created'
--	END
--GO
	
--	USE DBSuperMarket
--	GO

---- 3.	Создать таблицы. Прежде чем создать таблицу, проверить есть ли она в БД. 
--      --ВОПРОС: ели есть то что? удалить, или проверить на совместимость столбцы или удалить и заново создать? 

--IF EXISTS(SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID('Customers'))
--BEGIN;
--    DROP TABLE Customers;
--END;
--GO
------------ 3 -------------------------------------

--CREATE TABLE Products(
--ProdID	  INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
--ProdName  VARCHAR(300) NOT NULL,                              
--Article   CHAR(20) CONSTRAINT un_Products_Article UNIQUE 
--		  CONSTRAINT ck_Products_Article CHECK (Article LIKE('XX[0-9][0-9][0-9][0-9][0-9][0-9]')) NOT NULL, 
--Color	  VARCHAR(25),
--ProdDate  DATETIME CONSTRAINT ck_Products_ProdDate CHECK (ProdDate > '20170101' AND ProdDate <= GETDATE()) NOT NULL,
--Country	  VARCHAR(50) NOT NULL,
--ProdPrice DECIMAL(10,2) NOT NULL,
--Currency  CHAR(3)
-- );
-- GO

-- CREATE TABLE Customers(
--CustomID	  INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
--CustomName	  VARCHAR(50) NOT NULL,
--CustomSurname VARCHAR(50)NOT NULL,
--CustomMiddle  VARCHAR(50),       
--BeginDate	  SMALLDATETIME CONSTRAINT ck_Customers_BeginDate CHECK  ( BeginDate > '20170101' AND BeginDate <= GETDATE()),
--CustomMail 	  VARCHAR(100),
--CustomPhone	  VARCHAR(20) CONSTRAINT uk_Customers_CustomPhone UNIQUE
--			  CONSTRAINT ck_Customers_CustomPhone CHECK (CustomPhone LIKE '+38(0[0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]') NOT NULL,
--Birthday	  SMALLDATETIME CHECK (Birthday BETWEEN  DATEADD(YEAR, -120, GETDATE()) AND DATEADD(YEAR, -16, GETDATE())),   
--Town	      VARCHAR(50)
--);
--GO

-- CREATE TABLE Invoice(
--InvID	 INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
--InvNum	 VARCHAR(25) NOT NULL,
--InvDate	 DATETIME DEFAULT GETDATE(),
--Sum_nt	 DECIMAL(10,2) NOT NULL,
--Tax	     AS CAST( Sum_nt*20.0/100 AS DECIMAL(10,2)),			    --DECIMAL(10,2), PERSISTED
--Sum_wt	 AS CONVERT(DECIMAL(21,2),Sum_nt+(Sum_nt*20.0/100 )),		--DECIMAL(21,2),
--CustomID INT CONSTRAINT fk_Invoice_Customers FOREIGN KEY
--		 REFERENCES Customers (CustomID)
-- );
--GO

--CREATE TABLE InvoiceDetail(
--InvDID	INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
--InvID	INT UNIQUE CONSTRAINT fk_InvoiceDetail_Customers FOREIGN KEY
--			REFERENCES Invoice (InvID), 
--ProdID	INT CONSTRAINT fk_InvoiceDetail_Products FOREIGN KEY
--			REFERENCES Products (ProdID),
--Quant	DECIMAL(10,2) CHECK (Quant > 0) NOT NULL,
--Price	DECIMAL(10,2) CHECK (Price > 0) NOT NULL,
--[Sum]	DECIMAL(10,2) CHECK ([Sum] > 0)  NOT NULL
--  );
--GO

--CREATE TABLE Discount(
--DiscID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
--CustomID	INT  CONSTRAINT fk_Discount_Customer FOREIGN KEY
--  			REFERENCES Customers (CustomID), 
--DiscDate	DATETIME DEFAULT GETDATE(),
--DiscPercent	INT DEFAULT 0,
--DiscSumma	DECIMAL(10,2) DEFAULT(0.0),
--InvID		INT  CONSTRAINT fk_Discount_Invoice FOREIGN KEY
--  			REFERENCES Invoice(InvID)
--  			CONSTRAINT un_Disc_InvId UNIQUE (InvID)
--  );
--GO

----  add data
--INSERT INTO Customers([CustomName],[CustomSurname],[CustomMiddle],[BeginDate],[CustomMail],[CustomPhone],[Birthday],[Town]) VALUES
--('Elijah','Gonzalez','Scott','20180606','ac@tempuseu.ca','+38(036) 895-93-33','19170524','Kiev'),
--(N'Карл','Axel',NULL, '20180405','bibendum.ullamcorper.Duis@faucibusorci.com','+38(018) 449-15-24','19061217','Castel di Tora'),
--('Alan','Ewing','Hayden','20180217','Donec.porttitor@vulputate.org','+38(062) 752-39-84','19870816','Maransart'),
--(N'ЛSydnee4','Matthews','Ivan','20190323', NULL,'+38(023) 299-77-65','19670914','Jamshoro'),
--('Kelsey','Mckenzie','Noble','20200309','eu.dui@auctor.co.uk','+38(071) 114-19-72','19831022','Murmansk'),
--('Debra','Lawrence','Porter','20170523','sem.elit@semelitpharetra.edu','+38(019) 359-67-85','20021030','Pietragalla'),
--('Ezekiel','Weaver','Chaim','20200725','libero@egetlacus.org','+38(064) 256-22-95','19450804','Odessa'),
--('Kiona','Bonner','Reed','20190312','a@habitant.ca','+38(051) 556-62-41','19420723','Marabá'),
--('Lavinia','Pugh','Tanner','20170102','libero.Morbi@hendrerit.edu','+38(057) 366-88-45','19210223',NULL),
--('Jesse','Ball','Dante','20190801','rhoncus@Quisqueporttitor.edu','+38(032) 392-84-13','19111222','Béthune'),
--('Aretha','Payne','Rooney','20171106','Duis@auctornon.co.uk','+38(088) 838-43-42','20030904','Keith'),
--('Sybill','England','Tobias','20200613','urna.Nullam.lobortis@blandit.co.uk','+38(056) 596-35-93','19790531','Perth'),
--(N'ЮKelly','Delacruz','Yasir','20200529','ante.ipsum.primis@nonummy.edu','+38(097) 629-91-58','20010223','Odessa'),
--('Yetta','Saunders','Kuame','20200912','Sed.congue@dapibusligulaAliquam.net','+38(047) 453-69-52','19511121','Makurdi'),
--('Jena','Carrillo','Herrod','20191110','malesuada@euismodetcommodo.ca','+38(098) 793-87-79','19351223','Charlottetown'),
--('Oleg','Cabrera','Aidan','20200517','a@fermentumfermentumarcu.org','+38(084) 815-35-64','20001008','Zaporozhye'),
--('Madonna','Mcclain','Isaac','20201217','massa.Suspendisse@urnaconvalliserat.org','+38(053) 672-66-54','19201016','Vernole'),
--('Macey','Skinner','Travis','20170626','augue@sapienCrasdolor.ca','+38(011) 214-22-23','19370101','Odessa'),
--('Theodore','Foster','Avram','20191129','pede.nec@fermentumconvallisligula.com','+38(046) 915-31-71','19140514','Kiev'),
--('Florence','Erickson','Roth','20171002','magna.et.ipsum@nisimagna.co.uk','+38(054) 344-39-37','20011031','Zaporozhye'),
--('Delilah','Lee','Edan','20200504','felis.eget.varius@sempertellus.edu','+38(014) 174-86-59','19500502','Santa Bárbara'),
--('Nora','Prince','Alvin','20201217','pede.Nunc.sed@montesnasceturridiculus.com','+38(069) 696-14-43','19091201','Yongin'),
--('Faith','Oneil','Isaiah','20170806','libero.at@egestas.edu','+38(018) 756-88-55','19901220','Thon'),
--('Byron','Wall','Martin','20181125','Ut.tincidunt.vehicula@sem.ca','+38(077) 798-24-57','19670411','Sommethonne'),
--('Lawrence','Holland','Austin','20190212','fermentum.convallis@penatibuset.ca','+38(043) 852-83-15','19810907','Zaporozhye'),
--('Bernard','Fry','Quinlan','20200101','ultrices.Duis@risusMorbi.edu','+38(067) 429-24-11','19360118','Yeongju'),
--('Caldwell','Reilly','Lewis','20201030','erat@Aliquam.ca','+38(093) 361-36-69','19900613','Faisalabad'),
--(N'ЯJolene8','Gallegos','Jonas','20180807','augue.ac@leoelementum.ca','+38(013) 865-85-23','19811101','Kharkov'),
--('Erasmus','Horn','Akeem','20180717','auctor.vitae@sitametmetus.org','+38(043) 397-87-88','19940808','Zaporozhye'),
--('Juliet','Aguirre','Denton','20190929','sem.mollis.dui@iaculisnec.ca','+38(021) 897-34-71','19180504','Dnieper'),
--('Omar','Gentry','Merritt','20201108','amet.ultricies@Cras.edu','+38(067) 945-36-87','20011013','Ichtegem'),
--('Eve','Herrera','Merritt','20180122','aliquet.molestie@Phasellusdolor.com','+38(081) 385-56-47','19661123','Ottawa-Carleton'),
--('Dalton','Cooper','Arden','20180830','lectus.sit@imperdieteratnonummy.co.uk','+38(088) 237-24-39','19600820','Fontenoille'),
--('Iola','Leblanc','Ezekiel','20170501','Donec@nuncQuisqueornare.net','+38(042) 816-27-22','19250125','Magdeburg'),
--('Sawyer','Farley','Nasim','20170630','at@neque.net','+38(037) 856-52-93','19480127','Ife'),
--('Aurelia','Graves','Nissim','20190802','Curae.Phasellus@Integer.com','+38(047) 265-15-84','19150417','Soye'),
--('Prescott','Anthony','Hunter','20171214','amet.ante.Vivamus@tortor.net','+38(073) 497-35-62','20010108','Clarksville'),
--(N'ИYoshio','Elliott','Brennan','20210129','Nunc@luctusfelis.ca','+38(094) 641-94-32','19490102','Teodoro Schmidt'),
--('Jarrod5','Wright','Elliott','20180122','gravida@idblandit.co.uk','+38(045) 626-41-95','19771228','Simferopol'),
--('Chastity', 'Devin', NULL,'20190210','at@velitCras.co.uk','+38(044) 483-66-31','19801101','Kiev');
--GO

--INSERT INTO Products([ProdName],[Article],[Color],[ProdDate],[Country],[ProdPrice],[Currency]) VALUES
--('Caramel with fruit filling','XX223578','Lime','20170927','San Marino',25.81,'EUR'),
--('Butter butter','XX238881','Khaki','20190124','Antigua and Barbuda',1,'USD'),
--('Dried rosemary','XX132416','Black','20170918','Ukraine',38.09,'ERN'),
--(N'GМолотый имбирь','XX728772','Ivory','20170118','Iran',23.85,'USD'),
--('Candy caramel','XX979141','Khaki','20200603','Fiji',30.73,'XAF'),
--(N'Sponge cake  с фруктовой filling','XX827815','Charcoal','20171119','Ethiopia',44.6,'XCD'),
--('Turmeric','XX162793','Azure','20170815','Canada',5.45,'USD'),
--('Peasant butter','XX138751','Red','20180925','Ukraine',64.4,'HNL'),
--('Granulated sugar','XX074821','Blue','20170828','Marshall Islands',7.3,'GBP'),
--('Buckwheat noodles','XX299178','Maroon','20170908','Eritrea',8.52,'XP'),
--('Potato','XX914646','White','20180216','Falkland Islands',11.1,'XCD'),
--('Russian cheese','XX965283','Black','20200808','Ukraine',10.05,'TWD'),
--('Corn groats','XX351111','White','20170909','Nepal',10.9,'LKR'),
--('Whole milk powder','XX547925','Lime','20171112','Ukraine',11.8,'UA'),
--('Candy caramel','XX138911','Navy blue','20190711','Eritrea',52.7,'ISK'),
--('Bulgur dry','XX831844','Green','20200402','Iceland',10.65,'AMD'),
--('Milk sweets','XX538702','Lime','20180512','Ukraine',14.5,'BZD'),
--('Raw coconut pulp','XX590909','Navy blue','20191005','Armenia',15.4,'GBP'),
--('Cardamom','XX147333','','20170525','Tunisia',16.3,'ZMW'),
--('Sugar cookies','XX038843','Ivory','20170722','Taiwan',18.02,'RWF'),
--('Shelled peas','XX584846','Navy blue','20190511','Ukraine',18.1,'UA'),
--('Pearl barley','XX933495','','20200403','Latvia',19,'EUR'),
--('Bay leaf','XX524291','Orange','20171206','Brunei',19.9,'EUR'),
--('Nutmeg','XX370499','Red','20171012','Malawi',25.68,'TTD'),
--('Butter butter','XX148229','Pea green','20191123','Greenland',21.7,'TOP'),
--('Custard gingerbread','XX045797','Purple','20180121','Ukraine',22.36,'EUR'),
--('Caramel with fruit filling','XX064692','Magenta','20190606','Lithuania',23.5,'GMD'),
--('Corn12 groats','XX869679','Purple','20180518','Sint Maarten',24.4,'AUD'),
--('Poshekhonsky cheese','XX440415','Olive','20170215','Paraguay',25.33,'EUR'),
--('Peanut kernels (dried)','XX113925','Azure','20170716','Sri Lanka',26.2,'USD'),
--('Shelled peas','XX532889','Coral','20200905','Czech Republic',27.1,'XAF'),
--('Wheat flour(1), 1st grade','XX210071','Khaki','20190806','Cook Islands',28,'HNL'),
--('Nutmeg','XX444224','Fuchsia','20180829','Ukraine',28.9,'UA'),
--('Fennel seeds','XX236992','Black','20190926','Korea, South',29.58,'TWD'),
--('Raw coconut pulp2','XX148255','Magenta','20181118','Aruba',30.7,'EUR'),
--(N'Wheat крупа','XX821000','Silver','20190621','United Kingdom (Great Britain)',31.6,'GIP'),
--('Poshekhonsky сыр','XX756343','Red','20180225','Sao Tome and Principe',32.5,'VND'),
--('Pistachios','XX967497','Orange','20170309','Kuwait',33.45,'UGX'),
--('Premium pasta','XX249822','Red','20180820','Slovakia',34.3,'NOK'),
--('Kostroma cheese','XX761611','Khaki','20171207','Bahrain',35.2,'USD');


--INSERT INTO Invoice (InvNum, InvDate, Sum_nt, CustomID) VALUES
--('U8M6G', '20170117', 40, 3),
--('S0L6T', '20181113', 19.0, 21),
--('J9G8O', '20170118', 19, 28),
--('N2C0M', '20171110', 33.0, 39),
--('O0L3O', '20190122', 84.67, 15),
--('E4A5D', '20171112', 345.00, 9),
--('E7V6L', '20201121', 20, 20),
--('C0T0T', '20171118', 27.56, 25),
--('L7N8G', '20170129', 634, 35),
--('B1C3H', '20170716', 161, 40),
--('C9G5C', '20191126', 238.0, 20),
--('R4D0C', '20170124', 29.67, 29),
--('G0X5O', '20170119', 376.90, 35),
--('Q1O4L', '20191124', 19, 38),
--('M5B2A', '20170123', 283.56,34),
--('U5Q0N', '20170128', 18.78, 15),
--('A3Q2A', '20190126', 13, 32),
--('F4I5T', '20170716', 172.56, 1),
--('R8S9N', '20170911', 155.60, 30),
--('I8Z2P', '20180114', 38.56, 39),
--('X5Q9U', '20171111', 17.90, 22),
--('P9Z4I', '20170130', 355.45, 7),
--('C8B5C', '20181127', 19.45, 9),
--('W4R4J', '20170911', 3.45, 19),
--('E8A7U', '20171110', 24.34, 7),
--('Q8C7S', '20170124', 6, 9),
--('Y5K4P', '20171112', 17, 22),
--('L7S4K', '20171127', 3.67, 1),
--('H5V2Q', '20170125', 9.23, 13),
--('W8D8Q', '20171111', 12.00, 25),
--('W1M8L', '20171111', 38.0, 37),
--('C5X1E', '20191130', 33.0, 2),
--('U8E7K', '20170122', 119.00, 26),
--('N4O9Q', '20170130', 21, 22),
--('C7G0B', '20200122', 7.89, 29),
--('R9U0X', '20180121', 37.67, 9),
--('V6F1V', '20171130', 25.5, 16),
--('T0N0M', '20191110', 387.6, 40),
--('W8O2Q', '20170115', 32.34, 17),
--('L3B8D', '20181121', 6.6, 23),
--('L2F2O', '20171011', 34.76, 27),
--('C9L8T', '20171115', 23.3, 4),
--('D7V2I', '20180113', 3.3, 6),
--('C6A9Q', '20171123', 390.87, 30),
--('L8N4U', '20191119', 29.78, 24),
--('G2A4Q', '20170116', 34.56, 20),
--('I9Y9L', '20191111', 370.67,37),
--('P4Z5S', '20201112', 25.78, 10),
--('W6S2J', '20171113', 267.09, 18),
--('C0H9O', '20171011', 38.56, 18),
--('V2C2R', '20180119', 130.34, 26),
--('TYUTY', '20190123',32.00, 7),
--('JJJJJ', '20170128', 140, 28);



--INSERT INTO InvoiceDetail (InvID, ProdID, Price, [Sum], Quant) VALUES
--(33, 15,  25.81,  122.10, 11),
--(39, 3,  1.00,  493.50, 20),
--(20, 18,  38.09,  422.50, 6),
--(10, 16,  23.85,  348.00, 26),
--(5, 8,  30.73,  728.00, 38),
--(28, 21,  44.60,  840.10, 19),
--(25, 17,  5.45,  38.09, 22),
--(22, 5,  64.40,  606.90, 17),
--(3, 39,  7.30,  362.10, 30),
--(18, 19,  8.52,  128.40, 24),
--(35, 21,  11.10,  1422.90, 1),
--(12, 22,  10.05,  1032.40, 34),
--(4, 13,  10.90,  323.00, 16),
--(32, 16,  11.80,  872.04, 27),
--(1, 23,  52.70,  576.40, 10),
--(6, 26,  10.65,  754.60, 8),
--(27, 27,  14.50,  65.40, 3),
--(31, 37,  15.40,  837.20, 18),
--(13, 21,  16.30,  169.40, 21),
--(11, 23,  18.02,  89.20, 23),
--(30, 5,  18.10,  20.00, 25),
--(37, 3,  19.00,  277.10, 12),
--(36, 16,  19.90,  158.05, 31),
--(14, 13,  25.68,  414.46, 9),
--(40, 16,  21.70,  315.24, 29),
--(23, 22,  22.36,  651.60, 13),
--(17, 1,  23.50,  214.65, 1),
--(7, 28,  24.40,  436.60, 37),
--(19, 35,  25.33,  506.60, 28),
--(38, 32,  26.20,  781.20, 14),
--(2, 4,  27.10,  189.80, 5),
--(15, 2,  28.00,  358.20, 4),
--(21, 6,  28.90,  903.15, 7),
--(29, 5,  29.58,  92.10, 36),
--(24, 20,  30.70,  10.05, 33),
--(26, 13,  31.60,  1264.00, 35),
--(16, 3,  32.50,  532.44, 2),
--(8, 4,  33.45,  902.80, 32),
--(9, 5,  34.30,  983.36, 15),
--(34, 27,  35.20,  70.40, 20),
--(52, 17, 15, 35, 2),
--(53, 8, 70, 150, 2);


----7.Вывести список клиентов, у которых день рождения 1 ноября. Формат вывода: Фамилия Имя Отчество, дата рождения, электронный адрес, номер телефона. 

--SELECT c.CustomSurname, c.CustomName, c.CustomMiddle ,c.Birthday, c.CustomMail, c.CustomPhone
--FROM Customers c
----WHERE CONVERT(VARCHAR(10), c.Birthday, 112) LIKE '%1101%'
--WHERE DATEPART(MONTH, c.Birthday) =11
--AND DATEPART(DAY,c.Birthday) = 1;

----8 Вывести список клиентов, которые зарегистрировались в первой половине 2017 года. Формат вывода: Фамилия И.О., дата регистрации, город   
--SELECT c.CustomSurname, c.CustomName,  c.CustomMiddle ,c.BeginDate, c.Town
--FROM Customers c
--WHERE c.BeginDate > '20170101' AND c.BeginDate < '20170601'

----9 Вывести список товара с указанием страны где он изготовлен, страна должна быть отсортирована по алфавиту. Формат вывода: 
----  название продукта, дата изготовления, страна, валюта.
--SELECT p.ProdName, CAST(p.ProdDate AS DATE) ProdDate,  p.Country, p.Currency
--FROM Products p
--ORDER BY p.Country ASC

---- 10.Вывести список клиентов, у которых не все сведения заполнены. Сортировка полей фамилия, имя, отчество по алфавиту 
----    Формат вывода: дата регистрации, город, Фамилия, Имя, Отчество, электронная почта, телефон, день рождения. +

--SELECT CAST(c.BeginDate AS date) BeginDate, c.Town, c.CustomSurname, c.CustomMail, c.CustomPhone, c.Birthday
--FROM Customers c
--WHERE c.CustomName   IS NULL
--OR  c.CustomSurname  IS NULL
--OR  c.CustomMiddle   IS NULL
--OR  c.BeginDate  IS NULL
--OR  c.CustomMail IS NULL
--OR c.CustomPhone IS NULL
--OR c.Birthday   IS NULL
--OR  c.Town   IS NULL
--ORDER BY c.CustomSurname, c.CustomName, c.CustomID


----11. Вывести сумму покупок без ндс по каждому клиенту за сентябрь 2017 года, отсортировав от 
----   30 сентября до 1 сентября. Формат вывода: дата покупки, сумма без ндс, сумма ндс.

----12. Вывести всех клиентов из города Киев. Формат вывода: Фамилия Имя Отчество, сумма покупки.
--SELECT c.CustomName, c.CustomMiddle, c.CustomSurname, sum(id.[Sum]) [Sum]
--FROM Customers c 
--JOIN Invoice i
--ON c.CustomID = i.CustomID
--JOIN InvoiceDetail id
--ON i.InvID = id.InvID
--where c.Town = 'Kiev'
--GROUP BY i.CustomID,  c.CustomName, c.CustomMiddle, c.CustomSurname

----13. Вывести количество клиентов по городам. Формат вывода: Город, количество клиентов. 

--SELECT COUNT(c.CustomID) [Count Customers], c.Town
--FROM Customers c
--GROUP BY c.Town
--HAVING c.Town IS NOT NULL
--GO

----14. Вывести все продукты, у которых дата изготовления июль 2017 года. Формат вывода:
----    Наименование, артикул, дата изготовления. Сортировка: артикул, дата изготовления, наименование.
--UPDATE Products 
--SET ProdDate = '20170705'
--WHERE ProdID IN (10, 25)

--SELECT p.ProdName, p.Article, CAST(p.ProdDate AS DATE) ProdDate
--FROM Products p
--WHERE DATEPART(MONTH, p.ProdDate) = 7 AND
--DATEPART(YEAR, p.ProdDate) = 2017
--ORDER BY p.Article, p.ProdDate, p.ProdName
--GO


---- 15.	Вывести список клиентов, которые делали покупки 16.07.2017

--UPDATE Invoice 
--SET InvDate = '20170716'
--WHERE CustomID = 6
--GO 
----------------------------------------------
--SELECT CAST(i.InvDate AS date) DateBuy, c.*
--FROM Invoice i
--JOIN Customers c
--ON i.CustomID = c.CustomID
--WHERE DATEPART(MONTH, i.InvDate) = 7 AND
--DATEPART(DAY, i.InvDate) = 16 AND
--DATEPART(YEAR, i.InvDate) = 2017
---- WHERE  i.InvDate = '20170716'


----16.	Изменить цену продуктов, у которых идентификаторы – 7, 13, 45, 10, 27, 33, и они были проданы 11.09.2017. Снизить на 2%  в таблице Product.
--UPDATE Invoice
--SET InvDate = '20170911'
--WHERE  InvID IN (SELECT id.InvID FROM InvoiceDetail id WHERE id.ProdID  IN ( 7, 13, 45, 10, 27, 33))
--------------------------------------
--UPDATE Products
--SET ProdPrice = ProdPrice - ProdPrice * 2/ 100.
--FROM Products p 
--JOIN InvoiceDetail id
--ON p.ProdID = id.ProdID
--JOIN Invoice i
--ON i.InvID = id.InvID
--WHERE id.ProdID IN (7, 13, 10, 27, 33) 
--AND i.InvDate  = '20170911'

----17.	Для всех продуктов у которых артикул в диапазоне от ХХ138000 до ХХ150000 изменить цвет на Зелёный.
--UPDATE Products
--SET Article = 'XX138040' WHERE ProdID = 4
--UPDATE Products
--SET Article = 'XX132010' WHERE ProdID = 9
--UPDATE Products
--SET Article = 'XX148010' WHERE ProdID = 22
------------------------------------
--UPDATE Products
--SET Color = 'Green'
--WHERE Article >='XX138000' AND Article <= 'XX150000'


----18.	Добавить 5 единиц товара с названием Носки, Артикул от ХХ100001 до ХХ100006;  цвет – серый, коричневый, черный и 2 красный, 
----  дата изготовления 01.06.2017, страна Украина, цена закупки 5 грн

--INSERT INTO Products (ProdName, Article, Color, ProdDate, Country, ProdPrice, Currency)
--VALUES
--('Socks', 'XX100001', 'Gray', '20170601', 'Ukrain',5.0, 'UAH'),
--('Socks', 'XX100002', 'Brown', '20170601', 'Ukrain',5.00,'UAH'),
--('Socks', 'XX100003', 'Black', '20170601', 'Ukrain',5.00,'UAH'),
--('Socks', 'XX100004', 'Red', '20170601', 'Ukrain',5.00,'UAH'),
--('Socks', 'XX100005', 'Red', '20170601', 'Ukrain',5.00,'UAH')
--GO

----19	Удалить товар красного цвета, если его нет в накладных.
--DELETE Products
--FROM (SELECT ProdID FROM InvoiceDetail) AS id
--Right JOIN Products p
--ON p.ProdID = id.ProdID
--WHERE p.Color = 'Red' and id.ProdID IS NULL
--GO

----20.	Вывести список клиентов из Днепра и Запорожья, у которых скидка 20 %.

----21.	Вывести список продуктов, которые больше всего продаются в Одессе.  
--SELECT  MAX(id.Quant) [max count], p.ProdName, c.Town, c.CustomID
--FROM Products p
--JOIN InvoiceDetail id
--ON p.ProdID = id.ProdID
--JOIN Invoice i
--ON i.InvID = id.InvID
--JOIN Customers c 
--ON i.CustomID = c.CustomID
--WHERE c.Town = 'Odessa'
--GROUP BY p.ProdName, c.Town, c.CustomID
--GO

----22.Вывести список продуктов, которые закупаются за границей. 
----   Формат вывода: Наименование, страна, валюта, валюта словами (если USD – доллар, EUR – евро и другие валюты также) 

--SELECT p.ProdName, p.Country,CASE  p.Currency
--WHEN 'USD' THEN  N'доллар'
--WHEN 'EUR' THEN  N'евро'
--ELSE p.Currency
--END  AS N'Валлюта' 

--FROM  Customers c
--JOIN Invoice i
--ON c.CustomID = i.CustomID
--JOIN InvoiceDetail id
--ON i.InvID = id.InvID
--JOIN Products p
--ON p.Country != 'Ukrain'
--WHERE c.Town IN ('Odessa', 'Kiev', 'Dnipro', 'Dnieper', 'Kharkov', 'Zaporozhye')
--GO

----23. Создать представление, которое выведет информацию о клиентах, скидках и купленных товарах, 
----  за весь период. Формат вывода Фамилия Имя Отчество, дата регистрации, дата дисконта, процент дисконта, 
----  сумма накопления, наименование продукта, количество.


----24.	Вывести сумму продаж по сезонам, зима, весна, лето, осень. Используя UNION. Формат вывода: сумма без ндс, ндс, сумма с ндс, сезон
--DECLARE @sezon varchar(10) ='winterr'
--SELECT  @sezon ' sezon ', COALESCE (SUM(i.Sum_nt), 0) AS Sum_nt, COALESCE (SUM(i.Tax), 0) Tax, COALESCE (SUM(i.Sum_wt), 0) Sum_wt
--FROM Invoice i 
--WHERE  DATEPART(MONTH, i.InvDate) < 3 or DATEPART(MONTH, i.InvDate) = 12
--UNION
--SELECT   'spring'  AS ' sezon ', COALESCE(SUM(i.Sum_nt), 0) AS Sum_nt, COALESCE(SUM(i.Tax), 0) Tax, COALESCE(SUM(i.Sum_wt), 0) Sum_wt
--FROM Invoice i 
--WHERE  DATEPART(MONTH, i.InvDate) > 2 and DATEPART(MONTH, i.InvDate) < 6
--UNION
--SELECT  'summer' 'sezon', COALESCE (SUM(i.Sum_nt), 0) AS Sum_nt, COALESCE (SUM(i.Tax), 0) Tax, COALESCE (SUM(i.Sum_wt), 0) Sum_wt
--FROM Invoice i 
--WHERE  DATEPART(MONTH, i.InvDate) > 5 and DATEPART(MONTH, i.InvDate) < 9
--UNION
--SELECT   'autumn' 'sezon', COALESCE (SUM(i.Sum_nt), 0) AS Sum_nt, COALESCE (SUM(i.Tax), 0) Tax, COALESCE (SUM(i.Sum_wt), 0) Sum_wt
--FROM Invoice i 
--WHERE  DATEPART(MONTH, i.InvDate) > 8 and DATEPART(MONTH, i.InvDate) < 12
--GO


----25 

---- функция для получения кол-ва дней после регистрации ( по условию регистрация на следующий день)
--CREATE FUNCTION fnCalculationDiscountDate (@cid INT)       --, @date DATETIME)
--RETURNS INT
--AS
--	BEGIN 
--		DECLARE @count INT, @date datetime = NULL
--		SET @date  = COALESCE(@date, GETDATE())
--		SELECT @count = DATEDIFF(DAY, DATEADD(DAY,1,Customers.BeginDate), @date) FROM Customers WHERE Customers.CustomID = @cid
--		RETURN @count
--	END
--GO


---- функция для получения дисконта больше 3 месяцев после регистрации 10 процентов...
--CREATE FUNCTION fnGetPerecentDiscount (@cid int)
--RETURNS INT
--AS
--	BEGIN
--			DECLARE @month INT,
--					@persent INT = -1
--			SELECT  @month =  dbo.fnCalculationDiscountDate(@cid)
	
--			SELECT  @persent = CASE
--									WHEN @month >= 30*9 THEN 20       
--									WHEN @month >= 30*6 THEN 15
--									WHEN @month >= 30*3 THEN 10
--									ELSE @persent
--								END
--			RETURN @persent
--	END
--GO

---- ф-ция определяет есть ли пустые поля в таблицы регистрации 
--CREATE FUNCTION fnHasIsNull(@customerID INT)
--RETURNS BIT
--AS
--	BEGIN
--	DECLARE  @isNull  BIT = 0 
--			IF EXISTS (SELECT 1 FROM Customers
--								WHERE Customers.CustomID = @customerID AND (Town  IS  NULL OR
--									  Birthday IS NULL OR CustomPhone IS NULL OR CustomMail IS NULL OR 
--									  BeginDate IS NULL OR CustomMiddle IS NULL OR CustomSurname IS NULL OR CustomName IS NULL))
--						SET @isNull = 1
--			RETURN @isNull
--	END
--GO

---- возварщает дату регистрации
--CREATE FUNCTION fnGetDateRegistration (@cId INT)
--RETURNS DATETIME
--AS
-- BEGIN 
-- DECLARE @myDate DATETIME = NULL

--			IF EXISTS (SELECT 1 FROM Customers c WHERE c.CustomID = @cId)
--			SET @myDate = (SELECT DATEADD(DAY, 1, c.BeginDate) FROM dbo.Customers c
--								 WHERE c.CustomID =  @cId);

--		   RETURN @myDate
--	END
--GO

----SELECT dbo.fnGetDateRegistration(16)
----select dbo.fnCalculationDiscountDate(16)
----select dbo.fnGetPerecentDiscount(16)
----SELECT dbo.fnHasIsNull(4)

---- процедура для установки данных в таблицу Discount
--CREATE PROCEDURE spLoadDataByCustomerToDiscount
--	@custId INT,
--	@InvID  INT

--AS
--	BEGIN
--	DECLARE @fildDiscDate DATETIME,
--			@dPercent DECIMAL(10,2),	
--			@dSumT DECIMAL(10,2),
--			@dSum DECIMAL(10,2)
			
--			BEGIN
--				SET @dPercent = dbo.fnGetPerecentDiscount (@custId)

--				IF(@dPercent = -1)
--					BEGIN
--						PRINT 'Sorry but you do not have discounts yet'
--						RETURN
--					END

--				SET @fildDiscDate = (SELECT DATEADD(DAY, 1, c.BeginDate) FROM dbo.Customers c
--									 WHERE c.CustomID =  @custId) 
									
--				IF( dbo.fnHasIsNull(@custId) = 1)
--					BEGIN
--						--THROW 5100,  'Нельзя оформить дисконт т.к. таблица Customers содеждит null данные по пользователю ID - ', @custId
--						-- я бы сдесь сделал тригер вместо вызова функции fnHasIsNull (как указано в задании)
--						PRINT 'Pleace fill in the data to get bonnuses'
--						PRINT CONCAT('You have discount ', @dPercent, ' percent')
--						SET @dSum = 0 -- NULL
--					END
				
--				ELSE 
--					BEGIN
--						SET @dSumT =  (SELECT  i.Sum_wt
--									   FROM    Customers c, Invoice i
--									   WHERE   c.CustomID = 9 and i.InvID = @InvID)
--						SET @dSum =	   @dSumT - @dSumT * @dPercent / 100
--					END

--				INSERT INTO dbo.Discount (CustomID,	DiscDate, DiscPercent, DiscSumma, InvID)
--				VALUES
--				(@custId, @fildDiscDate, @dPercent, @dSum, @InvID)
--			END	
--	END
--GO

--exec dbo.spLoadDataByCustomerToDiscount @custId = 3,  @InvID = 1
--exec dbo.spLoadDataByCustomerToDiscount @custId = 21, @InvID = 2
--exec dbo.spLoadDataByCustomerToDiscount @custId = 28, @InvID = 3
--exec dbo.spLoadDataByCustomerToDiscount @custId = 39, @InvID = 4
--exec dbo.spLoadDataByCustomerToDiscount @custId = 15, @InvID = 5
--exec dbo.spLoadDataByCustomerToDiscount @custId = 20, @InvID = 7
--exec dbo.spLoadDataByCustomerToDiscount @custId = 25, @InvID = 8
--exec dbo.spLoadDataByCustomerToDiscount @custId = 35, @InvID = 9
--exec dbo.spLoadDataByCustomerToDiscount @custId = 29, @InvID = 12
--exec dbo.spLoadDataByCustomerToDiscount @custId = 34, @InvID = 15
--exec dbo.spLoadDataByCustomerToDiscount @custId = 32, @InvID = 17
--exec dbo.spLoadDataByCustomerToDiscount @custId = 30, @InvID = 19
--exec dbo.spLoadDataByCustomerToDiscount @custId = 7,  @InvID = 22
--exec dbo.spLoadDataByCustomerToDiscount @custId = 26, @InvID = 51
--exec dbo.spLoadDataByCustomerToDiscount @custId = 16, @InvID = 37
--exec dbo.spLoadDataByCustomerToDiscount @custId = 17, @InvID = 39
--exec dbo.spLoadDataByCustomerToDiscount @custId = 23, @InvID = 40
--exec dbo.spLoadDataByCustomerToDiscount @custId = 27, @InvID = 41
--exec dbo.spLoadDataByCustomerToDiscount @custId = 1,  @InvID = 28
--exec dbo.spLoadDataByCustomerToDiscount @custId = 13, @InvID = 29
--exec dbo.spLoadDataByCustomerToDiscount @custId = 9,  @InvID = 26
--exec dbo.spLoadDataByCustomerToDiscount @custId = 2,  @InvID = 32
--exec dbo.spLoadDataByCustomerToDiscount @custId = 25, @InvID =18
--exec dbo.spLoadDataByCustomerToDiscount @custId = 30, @InvID =19
--exec dbo.spLoadDataByCustomerToDiscount @custId = 39, @InvID =20
--exec dbo.spLoadDataByCustomerToDiscount @custId = 22, @InvID =21
--exec dbo.spLoadDataByCustomerToDiscount @custId = 7,  @InvID = 22
--exec dbo.spLoadDataByCustomerToDiscount @custId = 6,  @InvID = 43
--exec dbo.spLoadDataByCustomerToDiscount @custId = 30, @InvID =44
--exec dbo.spLoadDataByCustomerToDiscount @custId = 24, @InvID =45
--exec dbo.spLoadDataByCustomerToDiscount @custId = 20, @InvID =46
--exec dbo.spLoadDataByCustomerToDiscount @custId = 37, @InvID =47
--exec dbo.spLoadDataByCustomerToDiscount @custId = 10, @InvID =48
--exec dbo.spLoadDataByCustomerToDiscount @custId = 18, @InvID =49
--exec dbo.spLoadDataByCustomerToDiscount @custId = 18, @InvID =50
--exec dbo.spLoadDataByCustomerToDiscount @custId = 26, @InvID =51
--exec dbo.spLoadDataByCustomerToDiscount @custId = 7,  @InvID = 52
--exec dbo.spLoadDataByCustomerToDiscount @custId = 28, @InvID =53
--GO

--SELECT * FROM Discount
--GO

---- 26.	Написать функцию результатом которой будет список городов, в котором покупается товар. 
----	 Входной параметр – название товара, Результат функции таблица со списком городов.
--CREATE FUNCTION fnGetListBuyProdTown (@nameProduct VARCHAR(20))
--RETURNS TABLE 
--AS
--	RETURN
--		(SELECT c.Town 
--		FROM Products p
--		JOIN InvoiceDetail id
--		ON p.ProdID = id.ProdID
--		JOIN Invoice i
--		ON i.InvID = id.InvID
--		JOIN Customers c
--		ON i.CustomID = c.CustomID
--		WHERE p.ProdName = @nameProduct)
--GO

--SELECT  * FROM dbo.fnGetListBuyProdTown('Candy caramel')
--GO

----27. Написать процедуру. Для клиентов у которых день рождения сегодня добавить к сумме накопления 500, 
----	 если у них дата регистрации больше 30.06.2017 (второе полугодие 2017) и добавить 1000 – если они зарегистрированы в первом полугодии 2017 года. 
--UPDATE Customers
--SET Birthday = DATEADD(YEAR, -16, GETDATE())
--WHERE CustomID = 18

--CREATE PROC spAddBonus
--	@customId INT
--AS
--	SET NOCOUNT ON
--	BEGIN
--	DECLARE @currentDateDay INT = DATEPART(DAY,GETDATE()),
--			@beginDateReg DATETIME,
--			@bonus DECIMAL(10,2),
--			@birthday INT,
--		    @tempIdDisc INT

--		BEGIN
--		DECLARE @tDate DATETIME = (SELECT Birthday FROM Customers WHERE CustomID = @customId)
--		SET @birthday =  DATEPART(DAY, @tDate)

--		 SET @tempIdDisc = (SELECT TOP (1) d.DiscID
--							 FROM Discount d 
--							 WHERE d.CustomID = @customId)

--		SET @beginDateReg = (SELECT c.BeginDate
--							 FROM Customers c
--							 WHERE c.CustomID = @customId)
--		IF (@currentDateDay != @birthday OR @currentDateDay IS NULL
--		    OR @beginDateReg IS NULL OR @tempIdDisc IS NULL)
--			BEGIN
--			PRINT 'The bonuses are not credited'
--			RETURN
--			END
		
--		SET @bonus = CASE
--						WHEN @beginDateReg >= CAST('20170630' AS DATETIME)THEN 500
--						WHEN @beginDateReg <  CAST('20170630' AS DATETIME) THEN 1000
--					END
--		UPDATE Discount
--		SET DiscSumma = DiscSumma + @bonus
--		WHERE DiscID = @tempIdDisc
--		PRINT 'ADD BONULS '
--		END
--	END
--GO

--EXEC DBSuperMarket.dbo.spAddBonus  @customId = 18
--GO

----28  Написать скрипт. В переменной задаётся страна изготовитель. По этому условию вывести продукты.

--CREATE PROCEDURE GetAllProductsForCountry
--@country varchar(50)
--AS 
--	BEGIN
--			SET NOCOUNT ON
--			SELECT *
--			FROM Products p
--			WHERE p.Country = @country
--	END
--GO

--EXEC GetAllProductsForCountry @country = 'Ukrain'
--GO
-----------------------------------------------------------------
