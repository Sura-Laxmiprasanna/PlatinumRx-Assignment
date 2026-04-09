CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),

    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description VARCHAR(100),
    amount DECIMAL(10,2),
    datetime DATETIME,

    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

INSERT INTO clinics VALUES
('c1', 'Apollo Clinic', 'Hyderabad', 'Telangana', 'India'),
('c2', 'City Care', 'Bangalore', 'Karnataka', 'India'),
('c3', 'Health Plus', 'Chennai', 'Tamil Nadu', 'India');

INSERT INTO customer VALUES
('u1', 'John Doe', '9876543210'),
('u2', 'Alice', '9123456780'),
('u3', 'Bob', '9012345678');

INSERT INTO clinic_sales VALUES
('o1', 'u1', 'c1', 2000, '2021-01-10 10:00:00', 'online'),
('o2', 'u2', 'c1', 3000, '2021-01-15 12:00:00', 'offline'),
('o3', 'u1', 'c2', 5000, '2021-02-10 09:30:00', 'online'),
('o4', 'u3', 'c2', 7000, '2021-02-20 11:00:00', 'offline'),
('o5', 'u2', 'c3', 4000, '2021-03-05 14:00:00', 'online');

INSERT INTO expenses VALUES
('e8', 'c1', 'Medicines', 1000, '2021-01-12 08:00:00'),
('e4', 'c2', 'Equipment', 2000, '2021-02-15 10:00:00'),
('e6', 'c3', 'Staff Salary', 1500, '2021-03-10 09:00:00');

INSERT INTO clinics VALUES
('c4', 'Care Plus', 'Hyderabad', 'Telangana', 'India'),
('c5', 'MediCare', 'Hyderabad', 'Telangana', 'India');

INSERT INTO clinic_sales VALUES
('o10', 'u1', 'c1', 5000, '2021-02-05 10:00:00', 'online'),
('o11', 'u2', 'c4', 3000, '2021-02-06 11:00:00', 'offline'),
('o12', 'u3', 'c5', 1000, '2021-02-07 12:00:00', 'online');

INSERT INTO expenses VALUES
('e7', 'c1', 'Maintenance', 1000, '2021-02-08 09:00:00'),
('e10', 'c4', 'Supplies', 500, '2021-02-08 09:00:00'),
('e9', 'c5', 'Salary', 200, '2021-02-08 09:00:00');



