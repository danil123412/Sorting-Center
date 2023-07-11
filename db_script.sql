USE master
drop database Delivery1
CREATE DATABASE Delivery1
ON 
(	
	NAME = Delivery,
	FILENAME = 'D:\Base\delivery1_945.mdf',
	SIZE = 8,
	MAXSIZE = 64,
	FILEGROWTH = 4
)
LOG ON
(
	NAME = Delivery_log,
	FILENAME = 'D:\Base\delivery1_log_945.mdf',
	SIZE = 8,
	MAXSIZE = 64,
	FILEGROWTH = 4
);
GO

USE Delivery1

-- ���������������� ����
CREATE TYPE phoneNumber
FROM bigint
GO

-- ���������������� ���������

CREATE DEFAULT defaultStatus 
AS 0
GO

-- �������

CREATE RULE FIO
AS @x like N'%[�-��-�]%'
GO

CREATE RULE numberPhone
AS @x BETWEEN 70000000000 AND 79999999999
GO
sp_bindrule 'numberPhone', 'phoneNumber'
GO

CREATE RULE realValues 
AS @x > 0
GO

-- �������� ������ ���� ������

CREATE TABLE ����� (
	[ID ������] int not null,
	[������������ ������] nvarchar(25) not null
	CONSTRAINT PK_����� PRIMARY KEY ([ID ������])
)

CREATE TABLE ���������� (
	[ID ����������] int not null,
	������� nvarchar(25) not null, 
	��� nvarchar(25) not null,
	�������� nvarchar(25) not null,
	����� nvarchar(65) not null,
	����� int not null,
	[���� ��������] date not null,
	������� phoneNumber not null
	CONSTRAINT PK_���������� PRIMARY KEY ([ID ����������]),
	CONSTRAINT FK_����������_����� FOREIGN KEY (�����)
								REFERENCES �����([ID ������])
)
GO

sp_bindrule 'FIO', '����������.�������';
GO

sp_bindrule 'FIO', '����������.���';
GO

sp_bindrule 'FIO', '����������.��������';
GO

CREATE TABLE ����������� (
	[ID �����������] int not null,
	������� nvarchar(25) not null, 
	��� nvarchar(25) not null,
	�������� nvarchar(25) not null,
	����� nvarchar(65) not null,
	����� int not null,
	[���� ��������] date not null,
	������� phoneNumber not null
	CONSTRAINT PK_����������� PRIMARY KEY ([ID �����������]),
	CONSTRAINT FK_�����������_����� FOREIGN KEY (�����)
								REFERENCES �����([ID ������])
)
GO

sp_bindrule 'FIO', '�����������.�������';
GO

sp_bindrule 'FIO', '�����������.���';
GO

sp_bindrule 'FIO', '�����������.��������';
GO


CREATE TABLE [��� �����] (
	[ID ����] int not null,
	[������������ ����] varchar(25) not null
	CONSTRAINT PK_�������� PRIMARY KEY ([ID ����])
)
GO

CREATE TABLE ����� (
	[ID ������] int not null,
	[������������ ������] nvarchar(25) not null,
	����� int not null,
	����� nvarchar(65) not null,
	CONSTRAINT PK_����� PRIMARY KEY ([ID ������]),
	CONSTRAINT FK_�����_����� FOREIGN KEY (�����)
							REFERENCES �����([ID ������])
)
GO

CREATE TABLE [����� ������ �������] (
	[ID ���] int not null,
	[������������ ���] nvarchar(25) not null,
	����� int not null,
	����� varchar(65) not null
	CONSTRAINT PK_������������������ PRIMARY KEY ([ID ���])
	CONSTRAINT FK_������������������_����� FOREIGN KEY (�����)
								REFERENCES �����([ID ������])
)
GO

CREATE TABLE ������ (
	[ID ������] int not null, 
	[������������ ������] varchar(25) not null,
	������ money not null
	CONSTRAINT PK_������ PRIMARY KEY ([ID ������])
)
GO


CREATE TABLE [������ ��������] (
	[ID �������] int not null, 
	[������������ �������] varchar(30) not null
	CONSTRAINT PK_�������������� PRIMARY KEY ([ID �������])
)
GO

CREATE TABLE ���� (
	[ID �����] int not null,
	[������������ �����] nvarchar(50) not null,
	����� int not null,
	[���� �����������] date not null,
	[����� �����������] time not null,
	��� real not null, 
	������ real not null,
	������ real not null,
	������� real not null,
	[��� �����] int not null
	CONSTRAINT PK_���� PRIMARY KEY ([ID �����])
	CONSTRAINT FK_���_����� FOREIGN KEY ([��� �����]) 
								REFERENCES [��� �����]([ID ����]),
	CONSTRAINT FK_����_����� FOREIGN KEY (�����) 
								REFERENCES �����([ID ������]),
)
GO

sp_bindrule 'realValues', '����.���'
GO

sp_bindrule 'realValues', '����.������'
GO

sp_bindrule 'realValues', '����.������'
GO

sp_bindrule 'realValues', '����.�������'
GO

CREATE TABLE [������������� �����] (
	[ID ��] int not null,
	[������������ ��] nvarchar(25) not null,
	����� int not null,
	����� varchar(65) not null
	CONSTRAINT PK_������������������ PRIMARY KEY ([ID ��])
	CONSTRAINT FK_������������������_����� FOREIGN KEY (�����)
								REFERENCES �����([ID ������])
)
GO

CREATE TABLE �������� (
	[ID ��������] int IDENTITY(1, 1),
	���� int not null,
	���������� int not null,
	����������� int not null,
	����� int not null,
	����� varchar(50) not null,
	������ int,
	���� smalldatetime,
	����� smalldatetime,
	��������� money not null,
	����� int not null,
	�� int,
	��� int not null
	CONSTRAINT PK_�������� PRIMARY KEY ([ID ��������])
	CONSTRAINT FK_��������_���������� FOREIGN KEY (����������)
									REFERENCES ����������([ID ����������]),
	CONSTRAINT FK_��������_����������� FOREIGN KEY (�����������)
									REFERENCES �����������([ID �����������]),
	CONSTRAINT FK_��������_������ FOREIGN KEY (������)
									REFERENCES [������ ��������]([ID �������]),
	CONSTRAINT FK_��������_����� FOREIGN KEY (�����)
									REFERENCES ������([ID ������]),
	CONSTRAINT FK_��������_��� FOREIGN KEY (���)
										REFERENCES [����� ������ �������]([ID ���]),
	CONSTRAINT FK_��������_�� FOREIGN KEY (��)
										REFERENCES [������������� �����]([ID ��]),
	CONSTRAINT FK_��������_����� FOREIGN KEY (�����)
									REFERENCES �����([ID ������]),
	CONSTRAINT FK_��������_���� FOREIGN KEY (����)
									REFERENCES ����([ID �����])
)
GO

sp_bindefault 'defaultStatus', '��������.������'
GO

CREATE TABLE ������������ (
	���� int not null,
	�������� int not null
	CONSTRAINT PK_������������ PRIMARY KEY (����, ��������),
	CONSTRAINT FK_���� FOREIGN KEY (����)
						REFERENCES ����([ID �����]),
	CONSTRAINT FK_����_�������� FOREIGN KEY (��������)
						REFERENCES ��������([ID ��������])
)
GO

CREATE TABLE [��������� ��� ����������] (
	����� int not null,
	�������� int not null
	CONSTRAINT PK_���������������������� PRIMARY KEY (�����),
	CONSTRAINT FK_��������_����� FOREIGN KEY (��������)
						REFERENCES �����([ID ������])
)
GO

INSERT INTO ����� 
VALUES  (0, '�����������'), 
		(1, '������'),
		(2, '������'),
		(3, '������'),
		(4, '����'),
		(5, '��������'),
		(6, '�������')
GO

INSERT INTO ���������� 
VALUES (0, '������', '����', '��������', '��������, 8', 2, '28.05.2000', '+79103638349'),
		(1, '������', '����', '����������', '���������, 1', 5, '23.01.2001', '+79103849539'),
		(2, '�������', '����', '��������', '������, 9', 3, '04.05.1999', '+79154854954')
GO

INSERT INTO ����������� 
VALUES (0, '�������', '����', '��������', '������, 8', 2, '19.06.1998', '+79106473854'),
		(1, '������', '�������', '���������', '�������, 1', 5, '12.02.2000', '+79106473849'),
		(2, '�������', '����', '��������', '������, 9', 3, '05.05.1995', '+79154839485')
GO

INSERT INTO [��� �����]
VALUES (0, '������'),
		(1, '���������'),
		(2, '�������'), 
		(3, '�������'),
		(4, '������� �������'),
		(5, '������������'), 
		(6, '���������'),
		(7, '�������')
GO

INSERT INTO �����
VALUES (0, '�����-1', 1, '������������ �����, 15'),
		(1, '��������-1', 1, '��. ��������, 16'),
		(2, '���������-1', 3,'������������� �����, 34')
GO

INSERT INTO [����� ������ �������]
VALUES (0, '���������', 1, '��. ����������, 30'),
		(1, '����������', 2, '��. �������, 5')
GO

INSERT INTO [������������� �����]
VALUES	(0, '�����������', 0, '�����������'),
		(1, '����������� ��', 6, '��. ����������, 30. ������� "���������'),
		(2, '���������� ��', 5, '��. �������, 2')
GO

INSERT INTO ������
VALUES (0, '�������', 350),
		(1, '�������', 450), 
		(2, '�������', 600),
		(3, '���������', 1200),
		(4, '��� ��������', 2000)
GO

INSERT INTO [������ ��������] 
VALUES (0, '� ���������'), 
		(1, '��������� �� ������'),
		(2, '�������� �� ��'), 
		(3, '������������'), 
		(4, '��������� � ����� ������'),
		(5, '���������')
GO	

INSERT INTO ����
VALUES (0, '���������', 0, '22.04.2023', '18:00', '12', '700', '1150', '100', 4),
		(1, '�������', 2, '23.04.2023', '15:00', '0.5', '200', '90', '30', 3),
		(2, '��', 1, '19.04.2023', '12:00', '6', '450', '500', '250', 7),
		(3, '�����������', 2, '19.05.2023', '15:00', '26', '450', '500', '250', 3)
GO



INSERT INTO ��������
VALUES (1, 1, 2, 6, '�������� 4', 0, '01.01.1900','00:00', 300, 0, 0, 1),
		(0, 2, 1, 4, '�������� 4', 0, '01.01.1900','00:00', 150, 1, 0, 0),
		(2, 0, 0, 3, '������ 9', 0, '01.01.1900','00:00', 500, 2, 0, 1)
GO

INSERT INTO ������������
VALUES (0, 1),
		(1, 2),
		(2, 3)
GO

INSERT INTO [��������� ��� ����������]
VALUES (0, 2),
		(1, 3),
		(2, 4)
GO

--��������� ���������� ��� ����������
CREATE PROCEDURE addParametr (@line int, @parametr int)
AS
BEGIN
UPDATE [��������� ��� ����������] SET �������� = @parametr
WHERE ����� = @line
END
GO

--���������� �������
CREATE PROCEDURE updateStatus (@status int, @id int)
AS
BEGIN
UPDATE �������� SET ������ = @status
WHERE [ID ��������] = @id
END
GO

--���������� ��
CREATE PROCEDURE updateSortingCentre (@sort int, @id int)
AS
BEGIN
UPDATE �������� SET �� = @sort
WHERE [ID ��������] = @id
END
GO

--���������� ���� � �������
CREATE PROCEDURE addDataTime (@id int, @optionDate date, @optionTime time)
AS
BEGIN
UPDATE �������� SET ���� = @optionDate, ����� = @optionTime
WHERE [ID ��������] = @id
END
GO

ALTER PROCEDURE [dbo].[updateStatus] (@id int)
AS
BEGIN
UPDATE �������� SET ������ = ������ + 1
WHERE [ID ��������] = @id
END
GO

--���������� ��������
CREATE PROCEDURE addDelivery (@cargo int, @city int, @adress varchar(50), @price money, @tariff int,  @pvz int)
AS
BEGIN
INSERT INTO ��������
VALUES (@cargo, '1', '1', @city, @adress, '0', '01-01-1900', '00:00:00', @price, @tariff, '0', @pvz)
END
GO
