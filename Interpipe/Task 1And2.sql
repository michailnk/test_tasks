USE master ;  
GO  

IF EXISTS ( SELECT name FROM master.dbo.sysdatabases WHERE name = N'Factory')
	BEGIN
		EXEC sp_detach_db 'Factory', 'true';
	    SELECT 'Database Name already Exist' AS Message
		SET NOCOUNT ON
		DROP DATABASE Factory;
		SELECT 'Factory is REMOVED (DROP)'
END

	
	CREATE DATABASE Factory
		ON							 
		(
			NAME = 'Factory',			
			FILENAME = 'J:\SQLData\Factoryt.mdf',  
			SIZE = 30MB,                 
			MAXSIZE = 100MB,			
			FILEGROWTH = 10MB			
		)
		LOG ON						 
		( 													
			NAME = 'LogDBFactory',		 
			FILENAME = 'J:\SQLData\Factory.ldf',    
			SIZE = 5MB,                  
			MAXSIZE = 50MB,              
			FILEGROWTH = 5MB             
		)               
		COLLATE Cyrillic_General_CI_AS
		
	    SELECT 'New Database Factory is Created'
GO
	
USE Factory;
GO

TRUNCATE table Org


CREATE TABLE Org(
OrgID INT IDENTITY(1,1) PRIMARY KEY,
[Org Name] NVARCHAR(20) NOT NULL,
PID INT  CONSTRAINT fk_Org_itself FOREIGN KEY (PID) REFERENCES Org (OrgID)
);
GO

ALTER TABLE Org
NOCHECK CONSTRAINT fk_Org_itself;

INSERT INTO Org ([Org Name], PID) VALUES
(N'[НИКО ТЬЮБ]', 0);

ALTER TABLE Org
CHECK CONSTRAINT fk_Org_itself;


----ALTER TABLE Org
----ADD CONSTRAINT fk_Org_itself FOREIGN KEY (PID) REFERENCES Org (OrgID)

INSERT INTO Org ([Org Name], PID) VALUES
(N'[ТПЦ]', 1),
(N'[ТПЦ 2]', 1),
(N'[ТПЦ 7]', 2),
(N'[ТПЦ 6]', 2),
(N'[Обсадный участок]', 5);
GO


CREATE TABLE Post(
PostID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[Post Name] NVARCHAR(20) NOT NULL,
OrgID INT CONSTRAINT fk_Post_Users FOREIGN KEY  REFERENCES Org (OrgID)
);
GO

CREATE TABLE Users(
UserID INT IDENTITY PRIMARY KEY NOT NULL,
FIO NVARCHAR(100) NOT NULL,
PostID INT FOREIGN KEY REFERENCES Post (PostID)
)
GO

CREATE TABLE Emps(
EmpsID INT IDENTITY PRIMARY KEY NOT NULL,
UserID INT FOREIGN KEY REFERENCES Users (UserID),
OKLAD MONEY NOT NULL
)
GO


INSERT INTO Post ([Post Name],	[OrgID]) VALUES
(N'[Стропальщик]', 3),
(N'[Старший мастер]', 2), 
(N'[Сортировщик]', 2),
(N'[Мастер]', 3),
(N'[Сортировщик]', 3),
(N'[Мастер]', 5);


INSERT INTO Users(FIO,	[PostID]) VALUES
(N'(Петров)', 1),
(N'(Сидоров)', 1),
(N'(Иванов)',3 ),
(N'(Кулемин)', 5),
(N'(Сирко)', 5) ,
(N'(Петлюра)', 3),
(N'(Злой)',	3),
(N'(Мух)',	5),
(N'(Чек)',	1);

INSERT INTO Emps(USERID, OKLAD) VALUES
(1,	100),
(7,	110),
(3,	300),
(8,	850),
(9,	500),
(6,	130),
(2,	400),
(4,	700),
(5,	700);
GO


SELECT u.*, e.OKLAD
FROM Emps e
JOIN Users u
ON e.UserID = u.UserID
JOIN Post p
ON p.PostID = u.PostID
JOIN Org o
ON p.OrgID = o.OrgID
WHERE o.[Org Name] = N'[ТПЦ 2]' AND e.OKLAD IN 
(SELECT TOP 1 (MIN(OKLAD)) FROM Emps)





------------------------------------------------------------------
-------------------------  2  ------------------------------------
------------------------------------------------------------------
USE master
GO

CREATE DATABASE Sklad
COLLATE Cyrillic_General_CI_AS
GO

USE Sklad
GO

CREATE TABLE S_CEX (
  KodCex  INT PRIMARY KEY NOT NULL,
  NamCex  CHAR(100)
);

CREATE TABLE O_Sklad (
  KodCex  INT PRIMARY KEY NOT NULL,
  Kol     NUMERIC(18,3)
);

CREATE TABLE PR_Sklad (
  KodCex_p  INT, 
  KodCex_o  INT, 
  Kol       NUMERIC(18,3)
);
 
  INSERT INTO S_CEX (KodCex, NamCex) VALUES
(1,	N'Цех'),
(2,	N'Цех2');

 INSERT INTO O_Sklad(KodCex, Kol) VALUES
 (1, 100) 


 INSERT INTO PR_Sklad(KodCex_p, KodCex_o, Kol) VALUES
(2,	1,	50),
(1,	2,	20);


SELECT kc, SUM(q) AS quantity
FROM 
   (SELECT KodCex AS kc, Kol AS q
    FROM O_Sklad
    UNION
    SELECT KodCex_o AS kc, -Kol  AS q
    FROM PR_Sklad
    UNION  
    SELECT KodCex_p AS kc, Kol  AS q
    FROM PR_Sklad
) AS q
GROUP BY q.kc;