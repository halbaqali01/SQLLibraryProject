DROP DATABASE dawnlibraryproject;
CREATE DATABASE dawnlibraryproject;

USE dawnlibraryproject;

-- Create Tables 
CREATE TABLE clients (
  Client_ID INT NOT NULL,
  Client_Name VARCHAR(50) NOT NULL,
  Client_Email VARCHAR(50) NOT NULL,
  Client_Phone INT,
  Book_ID INT,
  Outstanding_Fines INT,
  CONSTRAINT PRIMARY KEY (Client_ID)
);

CREATE TABLE employee (
Employee_ID INT NOT NULL,
Employee_Name VARCHAR(50) NOT NULL,
Employee_Email VARCHAR(50),
Employee_Phone INT,
Employee_Position VARCHAR(50),
Total_Hours INT,
CONSTRAINT PRIMARY KEY (Employee_ID)
);

CREATE TABLE books (
Book_ID INT NOT NULL,
Book_Title VARCHAR(100) NOT NULL,
Book_Author VARCHAR(100) NOT NULL,
Book_Status VARCHAR(50),
Employee_ID INT,
Client_ID INT,
CONSTRAINT PRIMARY KEY (Book_ID)
);

CREATE TABLE salary (
Employee_ID INT NOT NULL,
Employee_Name VARCHAR(50) NOT NULL,
Per_Hour DECIMAL (10,4),
Total_Hours INT,
Extra_Pay INT,
Total_Salary DECIMAL (10,4),
CONSTRAINT PRIMARY KEY (Employee_ID)
);

CREATE TABLE points(
Client_ID INT NOT NULL ,
Benefit_Points INT,
Preferred_Benefit_Item VARCHAR(50),
CONSTRAINT PRIMARY KEY (Client_ID)
);

-- Add Foreign Keys
ALTER TABLE clients
ADD FOREIGN KEY (Book_ID) REFERENCES books(Book_ID);

ALTER TABLE salary
ADD FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID);

ALTER TABLE points
ADD FOREIGN KEY (Client_ID) REFERENCES clients(Client_ID);

ALTER TABLE books
ADD FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID),
ADD FOREIGN KEY (Client_ID) REFERENCES clients(Client_ID);

-- Add Data to Tables
INSERT INTO books
VALUES
(1, 'The Alchemist', 'Paulo Coelho', 'Borrowed', 2, 10),
(2, 'The Break', 'Marian Keyes', 'Borrowed', 4, 9),
(3, 'Normal People', 'Sally Rooney', 'Borrowed', 6, 8),
(4, 'Anxious People', 'Fredrik Backman', 'Due', 8, 7),
(5, 'Conversations with Friends', 'Sally Rooney', 'Due', 10, 6),
(6, 'If We Were Villains', 'M.L. Rio', 'Late', 1, 5),
(7, 'Me Before You', 'Jojo Moyes', 'Late', 3, 4),
(8, 'After You', 'Jojo Moyes', 'Late', 5, 3),
(9, 'The Goldfinch', 'Donna Tartt', 'Borrowed', 7, 2),
(10, 'Dark Matter', 'Blake Crouch', 'Due', 9, 1);

INSERT INTO clients
VALUES
(1, 'Ingrid', 'Ingrid@FakeMail.com', 123456789, 10,  0),
(2, 'Maire', 'Maire@Fakemail.com', 987654321, 9,  10),
(3, 'Billy', 'Billy@Fakemail.com', 123456789, 8,  5),
(4, 'Robbie', 'Robbie@Fakemail.com', 987654321, 7,  0),
(5, 'Jill', 'Jill@Fakemail.com', 123456789, 6, 0),
(6, 'Jamie', 'Jamie@FakeMail.com', 987654321, 5,  0),
(7, 'Ellie', 'Ellie@Fakemail.com', 123456789, 4, 10),
(8, 'Frank', 'Frank@Fakemail.com', 987654321, 3,  5),
(9, 'Dottie', 'Dottie@Fakemail.com', 123456789, 2,  0),
(10, 'Joanna', 'Joanna@Fakemail.com', 987654321, 1, 0);

INSERT INTO employee
VALUES
(1, 'Minnie', 'Minnie@Library.com', 123456789, 'Librarian', 25),
(2, 'Mickey', 'Mickey@Library.com', 987654321, 'Manager', 20),
(3, 'Daisy', 'Daisy@Library.com', 987654321, 'Librarian', 30),
(4, 'Donald', 'Donald@Library.com', 123456789, 'Librarian', 27),
(5, 'Goofy', 'Goofy@Library.com', 123456789, 'Librarian', 35),
(6, 'Clarabelle', 'Clarabelle@Library.com', 987654321, 'Researcher', 40),
(7, 'Scrooge', 'Scrooge@Library.com', 123456789, 'Accountant', 15),
(8, 'Ludwig', 'Ludwig@Library.com', 123456789, 'Researcher', 40),
(9, 'Pluto', 'Pluto@Library.com', 987654321, 'Support Dog', 10),
(10, 'Pete', 'Pete@Library.com', 123456789, 'Manager', 10);

INSERT INTO salary
VALUES
(1, 'Minnie', 9.5, 25, 0, 0),
(2, 'Mickey', 10, 20, 20, 0),
(3, 'Daisy', 9.5, 30, 10, 0),
(4, 'Donald', 9.5, 27, 0, 0),
(5, 'Goofy', 9.5, 35, 40, 0),
(6, 'Clarabelle', 8.5, 40, 0, 0),
(7, 'Scrooge', 11, 15, 55, 0),
(8, 'Ludwig', 8.5, 40, 10, 0),
(9, 'Pluto', 5, 10, 60, 0),
(10, 'Pete', 10, 15, 0, 0);

INSERT INTO points
VALUES
(1, 250, 'Pen'),
(2, 200, 'Tote Bag'),
(3, 100, 'Magnet'),
(4, 150, 'Bookmark'),
(5, 300, 'Journal'),
(6, 250, 'Pen'),
(7,  200, 'Tote Bag'),
(8, 100, 'Magnet'),
(9,  150, 'Bookmark'),
(10, 300, 'Journal');



-- VIEW TO SEE WHICH CLIENTS CAN CLAIM BENEFIT POINTS
CREATE OR REPLACE VIEW Benefit_Claim AS
SELECT C.Client_ID, C.Client_Name, P.Benefit_Points, P.Preferred_Benefit_Item
FROM Clients AS C
INNER JOIN Points AS P ON C.Client_ID = P.Client_ID
WHERE P.Benefit_Points >= 200
;

SELECT * FROM Benefit_Claim;

-- STORED FUNCTION TO SEE WHAT ACTION TO TAKE DEPENDING ON BOOK STATUS
DELIMITER //
CREATE FUNCTION Return_Status(
	Book_Status VARCHAR(50)
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE return_Status VARCHAR(100);
	IF Book_Status = 'Late' THEN
		SET return_Status = 'Charge Customer';

	ELSEIF Book_Status = 'Due' THEN
		SET return_Status = 'Notify Customer';

	ELSEIF Book_Status = 'Borrowed' THEN
		SET return_Status = 'Remind Due';

	END IF;
	RETURN(return_Status);
END//
DELIMITER ;

SELECT Book_ID, Client_ID, Book_Title, Book_Status, Return_Status(Book_Status)
FROM Books
ORDER BY Book_ID;

-- QUERIES THAT WORK
-- Librarian wants to see which Clients to notify about the book being due
SELECT Client_Name, Client_Email
FROM Clients
WHERE Book_ID IN 
(SELECT Book_ID
FROM Books
WHERE Book_Status = 'Due');

-- Manager wants to update Total Salary Column & View Total Salary
SET SQL_SAFE_UPDATES = 0;
UPDATE Salary
SET Total_Salary = (Per_Hour * Total_Hours) + Extra_Pay;

SELECT * FROM Salary;
SET SQL_SAFE_UPDATES = 1;


-- Accountant wants to see which Employees and their Position have Extra Pay
SELECT E.Employee_Name, E.Employee_Position
FROM Employee AS E
INNER JOIN Salary AS S ON E.Employee_ID = S.Employee_ID
WHERE S.Extra_Pay >= 30;

-- Librarian Wants to See Which Clients Have Outstanding Fines
SELECT C.Client_Name, C.Outstanding_Fines
FROM Clients AS C
WHERE C.Outstanding_Fines > 0;

-- Event to Update_Points
CREATE EVENT Update_Points
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 5 MINUTE
DO UPDATE DawnLibrary.Points SET Benefit_Points = Benefit_Points + 50;

-- Owner Wants to see Which Employees have a Pay greater than 8.5 an hour and isn’t a librarian
SELECT E.Employee_ID, E.Employee_Name, E.Employee_Position
FROM Employee AS E
INNER JOIN Salary AS S ON E.Employee_ID = S.Employee_ID
WHERE S.Per_Hour >= 8.5
GROUP BY E.Employee_ID
HAVING E.Employee_Position != 'Librarian';