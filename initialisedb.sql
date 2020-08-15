BEGIN TRANSACTION;
DROP TABLE IF EXISTS `Products`;
CREATE TABLE IF NOT EXISTS `Products` (
	`ProductID`	INTEGER PRIMARY KEY,
	`Name`	TEXT NOT NULL,
	`Price`	NUMERIC NOT NULL,
	`Currency`	TEXT NOT NULL,
	`ProductShortCode`	TEXT NOT NULL UNIQUE,
	`Path`	TEXT NOT NULL,
	`MaxDownloads`	INTEGER NOT NULL,
	`DownloadFileName`	TEXT NOT NULL,
	`ImageURL`	text
);
DROP TABLE IF EXISTS `Orders`;
CREATE TABLE IF NOT EXISTS `Orders` (
	`OrderID`	INTEGER PRIMARY KEY,
	`Currency`	text NOT NULL,
	`Price`	numeric NOT NULL,
	`ProductID`	int NOT NULL,
	FOREIGN KEY(`ProductID`) REFERENCES `Products`
);
DROP TABLE IF EXISTS `ExchangeRates`;
CREATE TABLE IF NOT EXISTS `ExchangeRates` (
	`ExchangeRateID`	INTEGER PRIMARY KEY,
	`MerchantPriceCurrency`	text NOT NULL,
	`CustomerPaymentCurrency`	text NOT NULL,
	`Timestamp`	timestamp NOT NULL,
	`Rate`	NUMERIC NOT NULL DEFAULT 1000000
);
DROP TABLE IF EXISTS `DownloadLog`;
CREATE TABLE IF NOT EXISTS `DownloadLog` (
	`DownloadLogID`	INTEGER PRIMARY KEY,
	`OrderID`	INTEGER NOT NULL UNIQUE,
	`VerificationHash`	TEXT UNIQUE,
	`NumDownloads`	INTEGER NOT NULL,
	`DownloadCode`	TEXT UNIQUE,
	FOREIGN KEY(`OrderID`) REFERENCES `Orders`
);
COMMIT;
