/*SQL TUTORIALs!!

To create a table, click on a database and selecte new Query
Make sure you save these as individual sql files

create table Users=> creates table called Users. Terminate SQL statements with semicolon.
				     Column Definitions go in parenthesis.
					 
Most basic table has one column definition you have to have atleast 
Column has datatype and length to it. Not all columns require a length.
To run click execute
Created in tables, dbo.Users
*/
use BigMachineTutorial;

create table Users(

email varchar(50) --This is a column definition with type varchar which is a character varying specification
				  --The 50 represents the length
 
);

/*
If we want to get rid of the table do this:
*/

drop table Users;

/*
Databases - You need a thing called a Primary Key: Uniquely identifies each row in a table. Relational Theory. 
Check the Columns of table you will see Id with key picture
*/

create table Users2(

	Id integer primary key --Integer primary key 
	--So now whenever we insert data into the Users table, we need to have a ID go in 
	--along with any other values that we have 
	--Right Click Users table, click edit top 200 rows and add some data
	--You cant put in 1 twice for primary key cause not unique
);

drop table Users2;

/*
Sometimes your data will need to be identifiable outside the database. Having an enterprise wide ID
available to you can be very very helpless. Having ID that is guranteed to be unique across all timespace
and dimension, => Guranteed Unique ID called GUID usng System.GUID in .net framework. 
You can store GUIDs directly in SQL server. They have their own datatype. 
*/

create table Users3(
Id uniqueidentifier primary key --GUID primary key
--uniqueidentifier is a guid. How do you use this. To use this, in code you create a new GUID, assign to a 
--specific property using entity framework, and then gets saved directly in database as primary key. 

)

drop table Users3;

/*Auto Incrementing primary key for database for each row inserted. Useful for integer based keys. So
you dont have to go into the database to see what the last value was to insert a new one. You can also 
do this with GUIDs.

Edit table top 200, just add email and press enter. The Id gets entered for you and when you add new 
data just by adding email, the id gets incremented. 
*/

create table Users4(
	Id integer primary key identity (1,1), --identity means start at one and increment by 1 for each new record
	--Tip: To specify that the "ID" column should start at value 10 and increment by 5, change it to IDENTITY(10,5)
	email varchar(50)
);

drop table Users4;

--Now change primary key to be unique identifier that gets auto incremented. 

create table Users5(

Id uniqueidentifier primary key default newId(), -- default of a new id, built in function that will return a guid
email varchar(50)
--When you add data, the ID field will show error, just rerun query and it will be fixed
);

drop table Users5;

/*
create table Users(
 --Id integer primary key identity(1,1), 
 --Id uniqueidentifier primary key default newid(), => autoincrementing with newid function which generates guid
 --email varchar(50) primary key not null => primary key via string

);

Email as primary key => Not good idea, because this value here has a business value to application, helps
identify a user and communicate with a user. Bad idea because this is changeable, often changeable by your
users. Nightmare because if they change email, go through database and update every single record where email
appears. DO NOT EVER HAVE PRIMARY KEY BE SOMETHING RELEVANT TO THE USER THAT THEY CAN CHANGE

GUID is great for globally identifying a user. Should you default to use this for everything everytime. 
If you dont have alot of data in the table do this go ahead. But if you have thousands of records, in table
its ok. GUID is quite large in taking up space. When you millions and millions of records, that guid will 
take up space. Important because primary key is indexed. That means indexer in sql server has to churn through
and sort those primary keys everytime a record is added. This requires overhead and diskspace. 
=> Therefore using newid() and new guid not a good idea. 

Way around that if you use newsequentialid() like so:
 Id uniqueidentifier primary key default newsequentialid()
=> Creates guid with logic to them so that they are easier sortable by the indexer, this is optimization
   Use when there is alot of data

Integer primary keys are fine, fast, small, easy to index, and easy to database engine. Bad part
comes when you hit the limit of integers, sometimes application reaches this limit, breaks database,
limit is 2,147,483,647


*/

/*
Database Normalization
The process of organizing the columns (attributes) and tables (relations) of a relational database to minimize 
data redundancy. Normalization involves decomposing a table into less redundant (and smaller) tables without losing 
information, and then linking the data back together by defining foreign keys in the old table referencing the 
primary keys of the new ones. The objective is to isolate data so that additions, deletions, and modifications 
of an attribute can be made in just one table and then propagated through the rest of the database using the 
defined foreign keys.

A typical example of normalization is that an entity's unique ID is stored everywhere in the system 
but its name is held in only one table. The name can be updated more easily in one row of one table. 
A typical update in such an example would be the RIM company changing its name to BlackBerry.[5] 
That update would be done in one place and immediately the correct "BlackBerry" name would be displayed 
throughout the system.

A basic objective of the first normal form defined by Codd in 1970 was to permit data to be queried and 
manipulated using a "universal data sub-language" grounded in first-order logic.[6] (SQL is an example of such a 
data sub-language)

The objectives of normalization beyond 1NF (First Normal Form) were stated as follows by Codd:

1. To free the collection of relations from undesirable insertion, update and deletion dependencies;
2. To reduce the need for restructuring the collection of relations, as new types of data are introduced, and 
	thus increase the life span of application programs;
3. To make the relational model more informative to users;
4. To make the collection of relations neutral to the query statistics, where these statistics are liable to 
	change as time goes by.

Free the database of modification anamolies
When an attempt is made to modify (update, insert into, or delete from) a table, undesired side-effects may 
arise in tables that have not been sufficiently normalized. An insufficiently normalized table might 
have one or more of the following characteristics:

The same information can be expressed on multiple rows; therefore updates to the table may result in 
logical inconsistencies. For example, each record in an "Employees' Skills" table might contain an 
Employee ID, Employee Address, and Skill; thus a change of address for a particular employee will 
potentially need to be applied to multiple records (one for each skill). If the update is not carried 
through successfully—if, that is, the employee's address is updated on some records but not others—then 
the table is left in an inconsistent state. Specifically, the table provides conflicting answers to the 
question of what this particular employee's address is. This phenomenon is known as an update anomaly.

There are circumstances in which certain facts cannot be recorded at all. For example, each record in a "Faculty 
and Their Courses" table might contain a Faculty ID, Faculty Name, Faculty Hire Date, and Course Code—thus we 
can record the details of any faculty member who teaches at least one course, but we cannot record the details 
of a newly hired faculty member who has not yet been assigned to teach any courses except by setting the Course 
Code to null. This phenomenon is known as an insertion anomaly.

Under certain circumstances, deletion of data representing certain facts necessitates deletion of data representing 
completely different facts. The "Faculty and Their Courses" table described in the previous example suffers from 
this type of anomaly, for if a faculty member temporarily ceases to be assigned to any courses, we must delete the 
last of the records on which that faculty member appears, effectively also deleting the faculty member, unless we
 set the Course Code to null in the record itself. This phenomenon is known as a deletion anomaly.

Minimize redesign when extending the database structure
When a fully normalized database structure is extended to allow it to accommodate new types of data, 
the pre-existing aspects of the database structure can remain largely or entirely unchanged. As a result, 
applications interacting with the database are minimally affected.
Normalized tables, and the relationship between one normalized table and another, mirror real-world concepts 
and their interrelationships.
*/

drop table Users6;
drop table Users_Roles;
drop table Roles;

--Composite Primary Keys
create table Users6(
Id integer primary key identity(1,1),
email varchar(50) not null

);

create table Users_Roles(
UserId integer,
RoleId integer,

--Use 2 fields togethor for a composite primary key
--Sometimes 2 records do uniquely indentify each row in a table
--This is a many to many relationship.
-- One user related to many roles. And one role associated with many users. 
--To do this you need an intermediery table
--You may want to gurantee that only one user can be assigned to one given role
--User1 assigned to adminstrator which is 1, then this table will have (1,1)
--You dont  want to be able to come in and assign this relationship again so User1 is twice
--the adminstraator, to do this make a primary composite key like this:

primary key(UserId, RoleId)
);

create table Roles(

Id integer primary key identity(1,1),
Name varchar(50)

);

--DEFINING COLUMNS --

-- Creating tables and columns -- (Started at Defining Columns)
--Create table using create table function, must have atleast one column --
-- Can indicate primary key by writing primary key
-- identity(1,1) means start at 1 and auto increment table by 1 when new data is added
-- Each column specified in table is in a comma sperated list, with the first part being the 
--identifier, then the type, then extra info
-- datetime gives both the date and the time, you can also have a type that is just date, or a type
-- that is just time

-- varchar is alphanumeric and the parameter indiciates the length the field can contain
--if you need to support UTF-8, use nvarchar
-- to drop the table do, drop table Users7
-- SQL staements seperated by semicolons,
--Click execute to create table in BigMachine, then click edit top 200 fields on the table to add data
--You need to refresh after adding executing script to see new tables added 

--If space is a concern use varchar or varchar(max), if space is not a concern, use text.
-- When you look at columns in the table,  
-- the Id column is PK, int, not null
-- The other columns are its type and null 
--This means you can enter records in this table, and have them all be null except for the 
--primary key
/*
In SQL, we have the following constraints:

NOT NULL - Indicates that a column cannot store NULL value
UNIQUE - Ensures that each row for a column must have a unique value
PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Ensures that a column (or combination of two or more columns) have a unique identity which helps to find a particular record in a table more easily and quickly
FOREIGN KEY - Ensure the referential integrity of the data in one table to match values in another table
CHECK - Ensures that the value in a column meets a specific condition
DEFAULT - Specifies a default value for a column

*/
create table Users7(

 Id integer primary key identity(1,1),
 Email varchar(25),
 CreateAt datetime, --You can insert into this data like 12/12/2003
 First varchar(25),
 Last varchar(25),
 Bio varchar(MAX), --User varchar(max) whenever to reduce space consumed
 Bio2 text
);

drop table Users7;

--Lets constraint the columns
drop table Users8; --Simplifies query by dropping tables and adding again

create table Users8(

 Id integer primary key identity(1,1),
 Email varchar(255) not null unique, --If a column cannot have null values, i like to specify 
 --specify a default if it makes sense. Doesnt make sense here because it is unique
 --We can specify column cannot be null, and that is has to
--be unique, check everytime an email is entered to see if
--it already exists in the table and throws error if it does 
MoneySpent decimal(10, 2) default 0, --Can default this 
-- Use decimal type for numeric formats, in parameters	
--State length and precision in brackets.
--Maximum allowable lenght of 10 with 2 decimal places
-- Take a look at columns. 
--What if you put into MoneySpent field the data 1000.0000000, it will simplify to 1000.00
--What if you put in 1000.9929289, that will simplify when you press enter to 1000.99
--It gets rounded. 
--Put in 1000.90000002222 => gets rounded to 1000.90
--Put in 999.995 => Rounded to 1000.00, Put in 999.994 => Rounded to 999.99
 CreatedAt datetime not null default getdate(), --Defaults this to the getdate function which returns
												--the current date
--Default also used for uniqueidentifier default newid()
 First varchar(50), --We can leave First, Last, and Bio, Bio2 nullable
 Last varchar(50),
 Bio varchar(MAX),

 --If we try to add into table, an email that is longer than 25 characters, the error,
 --String or binary data will be truncated, will be thrown
 --Just drop it create a bigger table go from length 50 to 255
 --Switch text to varchar(max) to save space

 --Because of defaults, when you enter data, you just have to enter email and everything else defaulted
 --When you enter email and press enter, data will not show, so rerun query to fetch the committed data not being shown
 --Now to create new user all you need is email

);

/*
Numeric Types:
int variables store 4-byte whole numbers ranging from -2,147,483,648 to 2,147,483,647.

bigint variables store 8-byte whole numbers ranging from -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807.

smallint variables store 2-byte whole numbers ranging from -32,768 to 32,767.

tinyint variables store 1-byte whole numbers ranging from 0 to 255.

decimal and numeric variables are functionally equivalent and store numbers of 
fixed precision and scale. Precision indicates the maximum number of digits 
that may be stored (including those before and after the decimal point. 
Scale indicates the number that may be stored to the right of the decimal point.

money variables store 8-byte currency values ranging from 
-922,337,203,685,477.5808 to 922,337,203,685,477.5807. They may reflect any currency type.
*/



--NAMING CONVENTIONS--
/*
Right now lower case preference for key words
Some DBA's like to capitalize all key words
so instead of create table Users(); You might see CREATE TABLE Users();
This helps dbas differentiate commands from column names

Naming fields, tables, what not 
Proper Casing and Camel Casing .NET Framework
Use Proper Casing.
Primary Keys => you can put Id but ppl want you to put TableName + Id so like UserId

Should table name be pluralized?
Tables should be thought of plural => Standard
but some ppl think that creating the table is just a definition of a Row for that table so singular, up to you
*/

--INSERTING DATA TO Users8--
--Insert simplest possible record and let defaulting take care of things for you:

insert into Users8(Email)
values ('test@test.com');

--Now you could have inserted a whole bunch of data, the criteria for values must also match the insert criteria directly

insert into Users8(Email, CreatedAt, First, Last, Bio)
values('test2@test.com', GETDATE(), 'Test','User','Some person'); --cant put test@test.com for this insert because it has
																  --already been put in the last insert and email is unqiue.

--select * from Users8;

--Bulk inserts from another database chinook --
--Import all the customers from the chinook database to the users database--
--Gunna use query to insert data which will go out to different source--

insert into Users8(Email, First, Last)
select Email, FirstName, LastName
from Chinook.dbo.Customer

--select * from Users8;

--Updates--
--Update luisg record cause his account was actually created a year ago

update Users8 set
CreatedAt = '09/23/2014'
where Id = 3;  --Specify user to update either with primary key

--Lets update his record again cause he was actually created 2 years ago. Also we dont have Id handy,
--We just have his email address. So...

update Users8 set
CreatedAt = '09/23/13'
where Email = 'luisg@embraer.com.br'; 
--If you cant get with primary key, next best thing is to update with unique constraint, there is an index
--on the email field so it will be found quickly

--BULK UPDATES---------------------------------

update Users8 set 
CreatedAt = '09/23/2013'
where Id <= 10;
--Particularly useful if you want to update categories of things or update against a partial match--

---------Deleting Data--------------------------------------
--Single
delete from Users8
where Id = 3; --Delete Louis

--Bulk Delete
delete from Users8
where Id <= 10; --Delete first 10 users in system--

--Delete all the data--
delete from Users8;

-------------------CHINOOK TABLES REVIEW---------------------------------------------------------------

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Chinook2')
BEGIN
	ALTER DATABASE [Chinook2] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [Chinook2] SET ONLINE;
	DROP DATABASE [Chinook2];
END

GO

/*******************************************************************************
   Create database
********************************************************************************/
CREATE DATABASE [Chinook2];
GO


USE [Chinook2];
GO

/*******************************************************************************
   Create Tables
********************************************************************************/
CREATE TABLE [dbo].[Album]
(
    [AlbumId] INT NOT NULL IDENTITY,
    [Title] NVARCHAR(160) NOT NULL,
    [ArtistId] INT NOT NULL,
    CONSTRAINT [PK_Album] PRIMARY KEY CLUSTERED ([AlbumId])
	/*
	Brackets are a form of quoting. It's only necessary if the column name 
	contains spaces or punctuation or conflicts with a reserved word, but many 
	wizards will just add the brackets for all field names to avoid the logic for 
	deciding whether they are necessary.	
	Brackets allow you to use characters and names which are not allowed like spaces, 
	reserved words and names starting with numbers

invalid my column, 1column col%umn, table

valid [my column], [1column], [col%umn], [table]

of course now you can become really creative :-)

create table [table]([table] varchar(20))
insert [table] values ('table')
select [table] from [table]		
		*/
);

GO
CREATE TABLE [dbo].[Artist]
(
    [ArtistId] INT NOT NULL IDENTITY,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_Artist] PRIMARY KEY CLUSTERED ([ArtistId])
);

/*
A clustered index is a special type of index that reorders the way records in the table are 
physically stored. Therefore table can have only one clustered index. The leaf nodes of a 
clustered index contain the data pages. A nonclustered index is a special type of index in 
which the logical order of the index does not match the physical stored order of the rows on 
disk. The leaf node of a nonclustered index does not consist of the data pages. Instead, the 
leaf nodes contain index rows.With a clustered index the rows are stored physically on the disk 
in the same order as the index. Therefore, there can be only one clustered index. With a non clustered 
index there is a second list that has pointers to the physical rows. You can have many non 
clustered indexes, although each new index will increase the time it takes to write new records.
It is generally faster to read from a clustered index if you want to get back all the columns. 
You do not have to go first to the index and then to the table. Writing to a table with a clustered 
index can be slower, if there is a need to rearrange the data.

A clustered index means you are telling the database to store close values actually close to 
one another on the disk. This has the benefit of rapid scan / retrieval of records falling 
into some range of clustered index values.

For example, you have two tables, Customer and Order:

Customer
----------
ID
Name
Address

Order
----------
ID
CustomerID
Price
If you wish to quickly retrieve all orders of one particular customer, you may wish to create a 
clustered index on the "CustomerID" column of the Order table. This way the records with the same 
CustomerID will be physically stored close to each other on disk (clustered) which speeds up their 
retrieval.

P.S. The index on CustomerID will obviously be not unique, so you either need to add a second 
field to "uniquify" the index or let the database handle that for you but that's another story.
Regarding multiple indexes. You can have only one clustered index per table because this defines 
how the data is physically arranged. If you wish an analogy, imagine a big room with many tables in it. 
You can either put these tables to form several rows or pull them all together to form a big 
 table, but not both ways at the same time. A table can have other indexes, they will then point to 
 the entries in the clustered index which in its turn will finally say where to find the actual data.

The Primary Key constraint itself is defined on a logical level – you just tell SQL Server 
that you want to have unique values in a specific column. But SQL Server also has to enforce 
that uniqueness on the physical level – in the data structures where you store your table data. 
In the case of SQL Server, the uniqueness on the physical level is enforced with an index structure 
– with a Clustered Index or Non-Clustered Index. Let’s have a more detailed look at this.

When you specify the Primary Key constraint, SQL Server enforces it by default with a Unique 
Clustered Index on the physical level. When you look at sys.indexes, you can see that under the 
covers SQL Server has generated a Unique Clustered Index that is used to enforce the Primary Key 
constraint.

As I have said, the Unique Clustered Index is created by default. 
You can also enforce a Primary Key constraint with a Unique Non-Clustered Index 
as shown in the following listing.

-- Enforces the Primary Key constraint with a Unique Non-Clustered Index
CREATE TABLE Foo1
(
	Col1 INT NOT NULL PRIMARY KEY NONCLUSTERED,
	Col2 INT NOT NULL,
	Col3 INT NOT NULL
)
GO

The option CLUSTERED is the default one, and therefore you don’t have to specify it. 
When you look now again at sys.indexes, you can see now that you have a heap table 
in front of you (a table without a Clustered Index), and that SQL Server has generated 
an additional Unique Non-Clustered Index to enforce the Primary Key constraint.


*/


GO
CREATE TABLE [dbo].[Customer]
(
    [CustomerId] INT NOT NULL IDENTITY,
    [FirstName] NVARCHAR(40) NOT NULL,
    [LastName] NVARCHAR(20) NOT NULL,
    [Company] NVARCHAR(80),
    [Address] NVARCHAR(70),
    [City] NVARCHAR(40),
    [State] NVARCHAR(40),
    [Country] NVARCHAR(40),
    [PostalCode] NVARCHAR(10),
    [Phone] NVARCHAR(24),
    [Fax] NVARCHAR(24),
    [Email] NVARCHAR(60) NOT NULL,
    [SupportRepId] INT,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId])
);

/*
What does the CONSTRAINT KEYWORD DO? Take a look at this:

CREATE TABLE BuilderTable (
ColumnID INT IDENTITY(100000,1),
ColumnValue VARCHAR(50),
CONSTRAINT ID_PK PRIMARY KEY (ColumnID)
)

This simple T-SQL statement creates a table called BuilderTable with two columns. 
The first column has a unique value (IDENTITY) and has been set up as a primary key 
with the constraint line. The constraint keyword is followed by a name to assign to it, 
the constraint type (PRIMARY KEY), and the column name to which it is associated in parentheses.

If the table already exists, you can use the ADD command to add a new primary key constraint.
It follows the same format as adding a new column to the table:

ALTER TABLE BuilderTable
ADD CONSTRAINT ID_PK PRIMARY KEY (ColumnID)

When a new PRIMARY KEY or UNIQUE constraint is added to an existing column, 
the column data must be unique. The statement fails if duplicate values are found. 
Each PRIMARY KEY and UNIQUE constraint generates an index. Tables are limited to 
one primary key, so existing primary keys should be removed before issuing the 
ADD command. Deleting a constraint is simple using the DROP CONSTRAINT command:

ALTER TABLE BuilderTable
DROP CONSTRAIN ID_PK

Foreign keys resemble primary keys in their ability to be added before or after table creation. 
T-SQL creates our table with an identity column that is both a primary key for the existing table 
and a foreign key that references another table and column. The CONSTRAINT, FOREIGN KEY, and 
REFERENCES keywords are used to create the foreign key. The REFERENCES keyword precedes the table 
and column names for the foreign key container. FOREIGN KEY constraints are added and dropped 
using the same syntax:

ALTER TABLE BuilderTable
DROP CONSTRAINT FK_ID

And adding a FOREIGN KEY constraint looks like this:
ALTER TABLE BuilderTable
ADD CONSTRAINT FK_ID FOREIGN KEY REFERENCES BuilderTable2(ColumnID)

Foreign keys facilitate data consistency and the incorporation of data from one table into another. 
Both foreign and primary keys are based on the concept of unique values. That is, a column cannot 
be a key value if its values are not unique. Otherwise, how would a data value be located?
In addition to the key constraints, you may need additional columns to contain only unique values. 
You can achieve this with the UNIQUE constraint. Again, you can add it to a table during creation 
or modification.Each UNIQUE constraint generates an index. The number of UNIQUE constraints cannot cause 
the number of indexes on the table to exceed 249 nonclustered indexes and one clustered index. 
If clustered or nonclustered is not specified for a UNIQUE constraint, nonclustered is used by 
default.

ALTER TABLE BuilderTable
ADD CONSTRAINT ID_UNIQ_1 UNIQUE (ColumnValue)

Likewise, you can remove existing constraints from a table:
ALTER TABLE BuilderTable
DROP CONSTRAINT ID_UNIQ_1

CHECK constraints limit the values accepted by a column and control the values that are placed 
in a column. An acceptable value or range of values is specified. CHECK constraints determine the 
valid values from a logical expression that is not based on data in another column. The following 
example demonstrates the use of a CHECK constraint that ensures a column value is less than a specific 
value:

CREATE TABLE BuilderTable( ColumnID INT IDENTITY(100000,1),
ColumnValueVARCHAR(50),
ColumnValue2 int NOT NULL CHECK (ColumnValue2 <= 1000), CONSTRAINT ID_PK PRIMARY KEY (ColumnID)
)

Often, there are default values that should be assigned to database fields. 
The DEFAULT constraint makes this an easy process. You can assign default values 
during table creation or when modifying a column. Additionally, you can use the ALTER TABLE 
command to add new columns to an existing table with default values or edit an existing column 
in the table:

ALTER TABLE BuilderTable
ADD TestColumn2 int DEFAULT (400)

Nullability, involves whether or not table columns may store null values. 
Null values can often cause problems with data, but optional fields are common 
so null values are allowed in these particular fields.You can specify whether a column 
can store null values when a table is created via the NOT NULL and NULL keywords.
The column definition for ColumnValue2 does not allow null values. 
The column may be altered to allow null values by way of the ALTER TABLE command:

ALTER TABLE BuilderTable
ALTER COLUMN ColumnValue2 int NULL

NOT NULL can be specified in ALTER COLUMN only if the column contains no null values. 
The null values must be updated to some value before ALTER COLUMN NOT NULL is allowed.

Also, you can add new columns to the table. If the new column does not allow null values, 
you must add a DEFAULT definition with the new column, and the new column will automatically 
load with the default value in the new columns in each existing row.


*/




GO
CREATE TABLE [dbo].[Employee]
(
    [EmployeeId] INT NOT NULL IDENTITY,
    [LastName] NVARCHAR(20) NOT NULL,
    [FirstName] NVARCHAR(20) NOT NULL,
    [Title] NVARCHAR(30),
    [ReportsTo] INT,
    [BirthDate] DATETIME,
    [HireDate] DATETIME,
    [Address] NVARCHAR(70),
    [City] NVARCHAR(40),
    [State] NVARCHAR(40),
    [Country] NVARCHAR(40),
    [PostalCode] NVARCHAR(10),
    [Phone] NVARCHAR(24),
    [Fax] NVARCHAR(24),
    [Email] NVARCHAR(60),
    CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED ([EmployeeId])
);

GO
CREATE TABLE [dbo].[Genre]
(
    [GenreId] INT NOT NULL IDENTITY,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED ([GenreId])
);
GO
CREATE TABLE [dbo].[Invoice]
(
    [InvoiceId] INT NOT NULL IDENTITY,
    [CustomerId] INT NOT NULL,
    [InvoiceDate] DATETIME NOT NULL,
    [BillingAddress] NVARCHAR(70),
    [BillingCity] NVARCHAR(40),
    [BillingState] NVARCHAR(40),
    [BillingCountry] NVARCHAR(40),
    [BillingPostalCode] NVARCHAR(10),
    [Total] NUMERIC(10,2) NOT NULL,
    CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED ([InvoiceId])
);
GO
CREATE TABLE [dbo].[InvoiceLine]
(
    [InvoiceLineId] INT NOT NULL IDENTITY,
    [InvoiceId] INT NOT NULL,
    [TrackId] INT NOT NULL,
    [UnitPrice] NUMERIC(10,2) NOT NULL,
    [Quantity] INT NOT NULL,
    CONSTRAINT [PK_InvoiceLine] PRIMARY KEY CLUSTERED ([InvoiceLineId])
);
GO
CREATE TABLE [dbo].[MediaType]
(
    [MediaTypeId] INT NOT NULL IDENTITY,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_MediaType] PRIMARY KEY CLUSTERED ([MediaTypeId])
);
GO
CREATE TABLE [dbo].[Playlist]
(
    [PlaylistId] INT NOT NULL IDENTITY,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_Playlist] PRIMARY KEY CLUSTERED ([PlaylistId])
);
GO
CREATE TABLE [dbo].[PlaylistTrack]
(
    [PlaylistId] INT NOT NULL,
    [TrackId] INT NOT NULL,
    CONSTRAINT [PK_PlaylistTrack] PRIMARY KEY NONCLUSTERED ([PlaylistId], [TrackId])
);
GO
CREATE TABLE [dbo].[Track]
(
    [TrackId] INT NOT NULL IDENTITY,
    [Name] NVARCHAR(200) NOT NULL,
    [AlbumId] INT,
    [MediaTypeId] INT NOT NULL,
    [GenreId] INT,
    [Composer] NVARCHAR(220),
    [Milliseconds] INT NOT NULL,
    [Bytes] INT,
    [UnitPrice] NUMERIC(10,2) NOT NULL,
    CONSTRAINT [PK_Track] PRIMARY KEY CLUSTERED ([TrackId])
);
GO


/*******************************************************************************
   Create Primary Key Unique Indexes
********************************************************************************/

/*******************************************************************************
   Create Foreign Keys
********************************************************************************/
ALTER TABLE [dbo].[Album] ADD CONSTRAINT [FK_AlbumArtistId]
    FOREIGN KEY ([ArtistId]) REFERENCES [dbo].[Artist] ([ArtistId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_AlbumArtistId] ON [dbo].[Album] ([ArtistId]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_CustomerSupportRepId]
    FOREIGN KEY ([SupportRepId]) REFERENCES [dbo].[Employee] ([EmployeeId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_CustomerSupportRepId] ON [dbo].[Customer] ([SupportRepId]);
GO
ALTER TABLE [dbo].[Employee] ADD CONSTRAINT [FK_EmployeeReportsTo]
    FOREIGN KEY ([ReportsTo]) REFERENCES [dbo].[Employee] ([EmployeeId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_EmployeeReportsTo] ON [dbo].[Employee] ([ReportsTo]);
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_InvoiceCustomerId]
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_InvoiceCustomerId] ON [dbo].[Invoice] ([CustomerId]);
GO
ALTER TABLE [dbo].[InvoiceLine] ADD CONSTRAINT [FK_InvoiceLineInvoiceId]
    FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[Invoice] ([InvoiceId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_InvoiceLineInvoiceId] ON [dbo].[InvoiceLine] ([InvoiceId]);
GO
ALTER TABLE [dbo].[InvoiceLine] ADD CONSTRAINT [FK_InvoiceLineTrackId]
    FOREIGN KEY ([TrackId]) REFERENCES [dbo].[Track] ([TrackId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_InvoiceLineTrackId] ON [dbo].[InvoiceLine] ([TrackId]);
GO
ALTER TABLE [dbo].[PlaylistTrack] ADD CONSTRAINT [FK_PlaylistTrackPlaylistId]
    FOREIGN KEY ([PlaylistId]) REFERENCES [dbo].[Playlist] ([PlaylistId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [dbo].[PlaylistTrack] ADD CONSTRAINT [FK_PlaylistTrackTrackId]
    FOREIGN KEY ([TrackId]) REFERENCES [dbo].[Track] ([TrackId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_PlaylistTrackTrackId] ON [dbo].[PlaylistTrack] ([TrackId]);
GO
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [FK_TrackAlbumId]
    FOREIGN KEY ([AlbumId]) REFERENCES [dbo].[Album] ([AlbumId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_TrackAlbumId] ON [dbo].[Track] ([AlbumId]);
GO
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [FK_TrackGenreId]
    FOREIGN KEY ([GenreId]) REFERENCES [dbo].[Genre] ([GenreId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_TrackGenreId] ON [dbo].[Track] ([GenreId]);
GO
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [FK_TrackMediaTypeId]
    FOREIGN KEY ([MediaTypeId]) REFERENCES [dbo].[MediaType] ([MediaTypeId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX [IFK_TrackMediaTypeId] ON [dbo].[Track] ([MediaTypeId]);
GO



-----------------------------------QUUERYING DATA-------------------------------------------------
--We will be querying from the Chinook database

Use Chinook

select *
--selecting a set of data you are going to specify, wild card * to select all the columns of a given table
from Artist;

select FirstName, LastName, Email --Select certain columns only, put in comma delimited list
from Customer

--You can also add friendlier names, AND Alias Column Names
--Column names in results will change to alias names, headers now will say First and Last
select FirstName as 'First', LastName as Last, Email, Country
--When Last turns blue in alias could indicate potential problem with keywords, doe we dont have that 
--problem rie now
from customer

--You could also do it like this

select FirstName as 'First', LastName as [Last Name], Email, Country --Need quote or brackets here
--For the alias
from customer

--What if we want full name rather than First Name and Last Name--
--Use concatentation operator--

select FirstName + ' ' + LastName, Email, Country 
from Customer
--You will notice that the FirstName+LastName column in thre results does not have a columnName
--because FirstName + ' ' + LastName is an expression, it is not selecting an actual column out
--so what we can do is alias

select FirstName + ' ' + LastName as 'Customer Name', 
Email, Country 
from Customer

--Using Alter Table Statement --
/*
The syntax to add a column in a table in SQL Server (Transact-SQL) is:

ALTER TABLE table_name
	ADD column_name column-definition;

ALTER TABLE employees
	ADD last_name VARCHAR(50);

The syntax to add multiple columns to an existing table in SQL Server (Transact-SQL) is:

ALTER TABLE table_name
  ADD column_1 column-definition,
      column_2 column-definition,
      ...
      column_n column_definition;


ALTER TABLE employees
  ADD last_name VARCHAR(50),
      first_name VARCHAR(40);

The syntax to modify a column in an existing table in SQL Server (Transact-SQL) is:

ALTER TABLE table_name
  ALTER COLUMN column_name column_type;

ALTER TABLE employees
  ALTER COLUMN last_name VARCHAR(75) NOT NULL;

This SQL Server ALTER TABLE example will modify the column called last_name to be a data type of 
VARCHAR(75) and force the column to not allow null values.

The syntax to drop a column in an existing table in SQL Server (Transact-SQL) is:

ALTER TABLE table_name
  DROP COLUMN column_name;

ALTER TABLE employees
  DROP COLUMN last_name;

You can not use the ALTER TABLE statement in SQL Server to rename a column in a table. 
However, you can use sp_rename, though Microsoft recommends that you drop and recreate the 
table so that scripts and stored procedures are not broken.
The syntax to rename a column in an existing table in SQL Server (Transact-SQL) is:
This SQL Server example will use sp_rename to rename the column in the employees table from 
last_name to lname.
sp_rename 'table_name.old_column_name', 'new_column_name', 'COLUMN';
sp_rename 'employees.last_name', 'lname', 'COLUMN';

You can not use the ALTER TABLE statement in SQL Server to rename a table. 
However, you can use sp_rename, though Microsoft recommends that you drop and 
recreate the table so that scripts and stored procedures are not broken.
he syntax to rename a table in SQL Server (Transact-SQL) is:
sp_rename 'old_table_name', 'new_table_name';
sp_rename 'employees', 'emps';

*/

--To have column Names with spaces use brackets---


select FirstName, LastName, [Column With Space]
from Customer;

-----------------------------Joins -------------------------------------------------


/*

JOOIINING DATAAAAAAAAAAAAAA---------------------------------------------------


Assuming you're joining on columns with no duplicates, which is a very common case:

An inner join of A and B gives the result of A intersect B, i.e. the inner part of a Venn diagram intersection.
An outer join of A and B gives the results of A union B, i.e. the outer parts of a Venn diagram union.
Examples

Suppose you have two tables, with a single column each, and data as follows:

A    B
-    -
1    3
2    4
3    5
4    6
Note that (1,2) are unique to A, (3,4) are common, and (5,6) are unique to B.

Inner join

An inner join using either of the equivalent queries gives the intersection of the two tables, i.e. 
the two rows they have in common.

select * from a INNER JOIN b on a.a = b.b;
select a.*,b.*  from a,b where a.a = b.b;

a | b
--+--
3 | 3
4 | 4
Left outer join

A left outer join will give all rows in A, plus any common rows in B.

select * from a LEFT OUTER JOIN b on a.a = b.b;
select a.*,b.*  from a,b where a.a = b.b(+);

a |  b
--+-----
1 | null
2 | null
3 |    3
4 |    4
Right outer join

A right outer join will give all rows in B, plus any common rows in A.

select * from a RIGHT OUTER JOIN b on a.a = b.b;
select a.*,b.*  from a,b where a.a(+) = b.b;

a    |  b
-----+----
3    |  3
4    |  4
null |  5
null |  6
Full outer join

A full outer join will give you the union of A and B, i.e. all the rows in A and all the rows in B. If something in A doesn't have a corresponding datum in B, then the B portion is null, and vice versa.

select * from a FULL OUTER JOIN b on a.a = b.b;

 a   |  b
-----+-----
   1 | null
   2 | null
   3 |    3
   4 |    4
null |    6
null |    5
*/


/*
Why do we spread data across several tables?
Invoices are much different from the items they contain
Inside every table we have a primary key
Every item in a row in a table should be uniquely identifiable by the PK
Well the items that are in that row would not match that criteria, the items stand on its own
If we wanted to remove or add an item, then each one of those rows requires a primary key
So what we do instead is join it togethor
*/

/*
Invoice has InvoiceId
InvoiceLine has InvoiceLineId and InvoiceId which means every InvoiceLine has an Invoice

How do we do a query which shows both Invoice and InvoiceLine togethor
*/

select Invoice.InvoiceId, InvoiceDate 
from Invoice
inner join InvoiceLine
on InvoiceLine.InvoiceId = Invoice.InvoiceId --These have to equal to join

-- show me all the data in the invoiceline table which matches the invoice table
--red squiggly on InvoiceId in select says column is ambiguous b/c contained in both tables
--So to specify it, just use dot notation and write Invoice.InvoiceId
-- When you execute, the result will just have invoiceId and InvoiceDate,
--To get items from the InvoiceLine table which we joined to, specify some 
--columns from that table like so:

select Invoice.InvoiceId, InvoiceDate, UnitPrice, Quantity 
from Invoice
inner join InvoiceLine
on InvoiceLine.InvoiceId = Invoice.InvoiceId

----Subqueries--------

/*

Gets complicated when there is data in one table that is not present in another table
Alright so Alubum Table contains AlbumId, Title, and ArtistId,
The Artist table contains ArtistId, and Name

Lets say we wanted to know how many albums each artist has
*/

select *, --what we can do is perform an additional query inline with another select statment. 
(select count(1) from 
Album where Album.ArtistId = Artist.ArtistId
)	as AlbumCount	--We have to use parenthesis because this is an expression
from Artist	
order by AlbumCount;
--This is a nested subquery
-- count(1) which is like min, max, sum
-- put in 1 for count cause we are only interested in counting up the rows
--Running this creates three column chart with ArtistId, Name, and AlbumCount
--order by AlbumCount will tell which album has no albums/ 

--What happens when we change the way we are relating these 2 tables togethor. 
--Azymuth has no albums
--Lets interjoin artist to album, when we interjoin equality must exist or wont get record returned. 

select Artist.ArtistId, Album.AlbumId, Name, Title --This will show Name of Artist and the title of the music he played
from Artist inner join Album  --Because the album can have multiple ArtistId's of the same artist for multiple 
							  --records in the Album table, the result shows the same Artist with multiple titles
							  --in this select statement, each row corresponding to a different title for that 
							  --artist and the artist name6
on Album.ArtistId = Artist.ArtistId;
--You can check that the Artist Azymuth isnt there. THis is because of the inner join
--Innerjoin restricts result set to only results that can be matched by the join expression