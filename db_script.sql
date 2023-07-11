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

-- пользовательские типы
CREATE TYPE phoneNumber
FROM bigint
GO

-- пользовательские умолчания

CREATE DEFAULT defaultStatus 
AS 0
GO

-- правила

CREATE RULE FIO
AS @x like N'%[А-Яа-я]%'
GO

CREATE RULE numberPhone
AS @x BETWEEN 70000000000 AND 79999999999
GO
sp_bindrule 'numberPhone', 'phoneNumber'
GO

CREATE RULE realValues 
AS @x > 0
GO

-- создание таблиц базы данных

CREATE TABLE Город (
	[ID города] int not null,
	[Наименование города] nvarchar(25) not null
	CONSTRAINT PK_Город PRIMARY KEY ([ID города])
)

CREATE TABLE Получатель (
	[ID получателя] int not null,
	Фамилия nvarchar(25) not null, 
	Имя nvarchar(25) not null,
	Отчество nvarchar(25) not null,
	Адрес nvarchar(65) not null,
	Город int not null,
	[Дата рождения] date not null,
	Телефон phoneNumber not null
	CONSTRAINT PK_Получатель PRIMARY KEY ([ID получателя]),
	CONSTRAINT FK_Получатель_Город FOREIGN KEY (Город)
								REFERENCES Город([ID города])
)
GO

sp_bindrule 'FIO', 'Получатель.Фамилия';
GO

sp_bindrule 'FIO', 'Получатель.Имя';
GO

sp_bindrule 'FIO', 'Получатель.Отчество';
GO

CREATE TABLE Отправитель (
	[ID отправителя] int not null,
	Фамилия nvarchar(25) not null, 
	Имя nvarchar(25) not null,
	Отчество nvarchar(25) not null,
	Адрес nvarchar(65) not null,
	Город int not null,
	[Дата рождения] date not null,
	Телефон phoneNumber not null
	CONSTRAINT PK_Отправитель PRIMARY KEY ([ID отправителя]),
	CONSTRAINT FK_Отправитель_Город FOREIGN KEY (Город)
								REFERENCES Город([ID города])
)
GO

sp_bindrule 'FIO', 'Отправитель.Фамилия';
GO

sp_bindrule 'FIO', 'Отправитель.Имя';
GO

sp_bindrule 'FIO', 'Отправитель.Отчество';
GO


CREATE TABLE [Тип груза] (
	[ID типа] int not null,
	[Наименование типа] varchar(25) not null
	CONSTRAINT PK_ТипГруза PRIMARY KEY ([ID типа])
)
GO

CREATE TABLE Склад (
	[ID склада] int not null,
	[Наименование склада] nvarchar(25) not null,
	Город int not null,
	Адрес nvarchar(65) not null,
	CONSTRAINT PK_Склад PRIMARY KEY ([ID склада]),
	CONSTRAINT FK_Город_Склад FOREIGN KEY (Город)
							REFERENCES Город([ID города])
)
GO

CREATE TABLE [Пункт выдачи заказов] (
	[ID ПВЗ] int not null,
	[Наименование ПВЗ] nvarchar(25) not null,
	Город int not null,
	Адрес varchar(65) not null
	CONSTRAINT PK_ПунктВыдачиЗаказов PRIMARY KEY ([ID ПВЗ])
	CONSTRAINT FK_ПунктВыдачиЗаказов_Город FOREIGN KEY (Город)
								REFERENCES Город([ID города])
)
GO

CREATE TABLE Тарифы (
	[ID тарифа] int not null, 
	[Наименование тарифа] varchar(25) not null,
	Ставка money not null
	CONSTRAINT PK_Тарифы PRIMARY KEY ([ID тарифа])
)
GO


CREATE TABLE [Статус доставки] (
	[ID статуса] int not null, 
	[Наименование статуса] varchar(30) not null
	CONSTRAINT PK_СтатусДоставки PRIMARY KEY ([ID статуса])
)
GO

CREATE TABLE Груз (
	[ID груза] int not null,
	[Наименование груза] nvarchar(50) not null,
	Склад int not null,
	[Дата отправления] date not null,
	[Время отправления] time not null,
	Вес real not null, 
	Высота real not null,
	Ширина real not null,
	Глубина real not null,
	[Тип груза] int not null
	CONSTRAINT PK_Груз PRIMARY KEY ([ID груза])
	CONSTRAINT FK_Тип_Груза FOREIGN KEY ([Тип груза]) 
								REFERENCES [Тип груза]([ID типа]),
	CONSTRAINT FK_Груз_Склад FOREIGN KEY (Склад) 
								REFERENCES Склад([ID склада]),
)
GO

sp_bindrule 'realValues', 'Груз.Вес'
GO

sp_bindrule 'realValues', 'Груз.Высота'
GO

sp_bindrule 'realValues', 'Груз.Ширина'
GO

sp_bindrule 'realValues', 'Груз.Глубина'
GO

CREATE TABLE [Сортировочный центр] (
	[ID СЦ] int not null,
	[Наименование СЦ] nvarchar(25) not null,
	Город int not null,
	Адрес varchar(65) not null
	CONSTRAINT PK_СортировочныйЦентр PRIMARY KEY ([ID СЦ])
	CONSTRAINT FK_СортировочныйЦентр_Город FOREIGN KEY (Город)
								REFERENCES Город([ID города])
)
GO

CREATE TABLE Доставка (
	[ID доставки] int IDENTITY(1, 1),
	Груз int not null,
	Получатель int not null,
	Отправитель int not null,
	Город int not null,
	Адрес varchar(50) not null,
	Статус int,
	Дата smalldatetime,
	Время smalldatetime,
	Стоимость money not null,
	Тариф int not null,
	СЦ int,
	ПВЗ int not null
	CONSTRAINT PK_Доставка PRIMARY KEY ([ID доставки])
	CONSTRAINT FK_Доставка_Получатель FOREIGN KEY (Получатель)
									REFERENCES Получатель([ID получателя]),
	CONSTRAINT FK_Доставка_Отправитель FOREIGN KEY (Отправитель)
									REFERENCES Отправитель([ID отправителя]),
	CONSTRAINT FK_Доставка_Статус FOREIGN KEY (Статус)
									REFERENCES [Статус доставки]([ID статуса]),
	CONSTRAINT FK_Доставка_Тариф FOREIGN KEY (Тариф)
									REFERENCES Тарифы([ID тарифа]),
	CONSTRAINT FK_Доставка_ПВЗ FOREIGN KEY (ПВЗ)
										REFERENCES [Пункт выдачи заказов]([ID ПВЗ]),
	CONSTRAINT FK_Доставка_СЦ FOREIGN KEY (СЦ)
										REFERENCES [Сортировочный центр]([ID СЦ]),
	CONSTRAINT FK_Доставка_Город FOREIGN KEY (Город)
									REFERENCES Город([ID города]),
	CONSTRAINT FK_Доставка_Груз FOREIGN KEY (Груз)
									REFERENCES Груз([ID груза])
)
GO

sp_bindefault 'defaultStatus', 'Доставка.Статус'
GO

CREATE TABLE ГрузДоставка (
	Груз int not null,
	Доставка int not null
	CONSTRAINT PK_ГрузДоставка PRIMARY KEY (Груз, Доставка),
	CONSTRAINT FK_Груз FOREIGN KEY (Груз)
						REFERENCES Груз([ID груза]),
	CONSTRAINT FK_Груз_Доставка FOREIGN KEY (Доставка)
						REFERENCES Доставка([ID доставки])
)
GO

CREATE TABLE [Параметры для сортировки] (
	Линия int not null,
	Параметр int not null
	CONSTRAINT PK_ПараметрыДляСортировки PRIMARY KEY (Линия),
	CONSTRAINT FK_Параметр_Город FOREIGN KEY (Параметр)
						REFERENCES Город([ID города])
)
GO

INSERT INTO Город 
VALUES  (0, 'Отсутствует'), 
		(1, 'Рязань'),
		(2, 'Рыбное'),
		(3, 'Москва'),
		(4, 'Омск'),
		(5, 'Луховицы'),
		(6, 'Коломна')
GO

INSERT INTO Получатель 
VALUES (0, 'Иванов', 'Иван', 'Иванович', 'Пирогова, 8', 2, '28.05.2000', '+79103638349'),
		(1, 'Петров', 'Иван', 'Дмитриевич', 'Халтурина, 1', 5, '23.01.2001', '+79103849539'),
		(2, 'Сидоров', 'Петр', 'Иванович', 'Ленина, 9', 3, '04.05.1999', '+79154854954')
GO

INSERT INTO Отправитель 
VALUES (0, 'Сидоров', 'Петр', 'Иванович', 'Ленина, 8', 2, '19.06.1998', '+79106473854'),
		(1, 'Петров', 'Дмитрий', 'Семенович', 'Свободы, 1', 5, '12.02.2000', '+79106473849'),
		(2, 'Борисов', 'Петр', 'Олегович', 'Ленина, 9', 3, '05.05.1995', '+79154839485')
GO

INSERT INTO [Тип груза]
VALUES (0, 'Письмо'),
		(1, 'Бандероль'),
		(2, 'Посылка'), 
		(3, 'Коробка'),
		(4, 'Большая коробка'),
		(5, 'Негабаритный'), 
		(6, 'Токсичный'),
		(7, 'Хрупкий')
GO

INSERT INTO Склад
VALUES (0, 'Южный-1', 1, 'Михайловское шоссе, 15'),
		(1, 'Северный-1', 1, 'ул. Бирюзова, 16'),
		(2, 'Столичный-1', 3,'Новорязанское шоссе, 34')
GO

INSERT INTO [Пункт выдачи заказов]
VALUES (0, 'Рязанский', 1, 'ул. Мервинская, 30'),
		(1, 'Рыбновский', 2, 'ул. Большая, 5')
GO

INSERT INTO [Сортировочный центр]
VALUES	(0, 'Отсутствует', 0, 'Отсутствует'),
		(1, 'Коломенский СЦ', 6, 'ул. Мервинская, 30. Магазин "Пятерочка'),
		(2, 'Луховицкий СЦ', 5, 'ул. Луговая, 2')
GO

INSERT INTO Тарифы
VALUES (0, 'Обычный', 350),
		(1, 'Быстрый', 450), 
		(2, 'Хрупкий', 600),
		(3, 'Токсичный', 1200),
		(4, 'Все включено', 2000)
GO

INSERT INTO [Статус доставки] 
VALUES (0, 'В обработке'), 
		(1, 'Отправлен со склада'),
		(2, 'Поступил на СЦ'), 
		(3, 'Отсортирован'), 
		(4, 'Отправлен в пункт выдачи'),
		(5, 'Доставлен')
GO	

INSERT INTO Груз
VALUES (0, 'Телевизор', 0, '22.04.2023', '18:00', '12', '700', '1150', '100', 4),
		(1, 'Телефон', 2, '23.04.2023', '15:00', '0.5', '200', '90', '30', 3),
		(2, 'ПК', 1, '19.04.2023', '12:00', '6', '450', '500', '250', 7),
		(3, 'Холодильник', 2, '19.05.2023', '15:00', '26', '450', '500', '250', 3)
GO



INSERT INTO Доставка
VALUES (1, 1, 2, 6, 'Пирогова 4', 0, '01.01.1900','00:00', 300, 0, 0, 1),
		(0, 2, 1, 4, 'Пирогова 4', 0, '01.01.1900','00:00', 150, 1, 0, 0),
		(2, 0, 0, 3, 'Ленина 9', 0, '01.01.1900','00:00', 500, 2, 0, 1)
GO

INSERT INTO ГрузДоставка
VALUES (0, 1),
		(1, 2),
		(2, 3)
GO

INSERT INTO [Параметры для сортировки]
VALUES (0, 2),
		(1, 3),
		(2, 4)
GO

--установка параметров для сортировки
CREATE PROCEDURE addParametr (@line int, @parametr int)
AS
BEGIN
UPDATE [Параметры для сортировки] SET Параметр = @parametr
WHERE Линия = @line
END
GO

--обновление статуса
CREATE PROCEDURE updateStatus (@status int, @id int)
AS
BEGIN
UPDATE Доставка SET Статус = @status
WHERE [ID доставки] = @id
END
GO

--обновление СЦ
CREATE PROCEDURE updateSortingCentre (@sort int, @id int)
AS
BEGIN
UPDATE Доставка SET СЦ = @sort
WHERE [ID доставки] = @id
END
GO

--обновление даты и времени
CREATE PROCEDURE addDataTime (@id int, @optionDate date, @optionTime time)
AS
BEGIN
UPDATE Доставка SET Дата = @optionDate, Время = @optionTime
WHERE [ID доставки] = @id
END
GO

ALTER PROCEDURE [dbo].[updateStatus] (@id int)
AS
BEGIN
UPDATE Доставка SET Статус = Статус + 1
WHERE [ID доставки] = @id
END
GO

--добавление доставки
CREATE PROCEDURE addDelivery (@cargo int, @city int, @adress varchar(50), @price money, @tariff int,  @pvz int)
AS
BEGIN
INSERT INTO Доставка
VALUES (@cargo, '1', '1', @city, @adress, '0', '01-01-1900', '00:00:00', @price, @tariff, '0', @pvz)
END
GO
