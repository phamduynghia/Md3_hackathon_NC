-- bài 1: Tạo CSDL [20 điểm]: 
create database QUANLYBANHANG;
use QUANLYBANHANG;
-- Bảng CUSTOMERS [5 điểm]
CREATE TABLE CUSTOMERS (
    customer_id VARCHAR(4) PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(25) UNIQUE,
    address VARCHAR(255)
);
-- Bảng ORDERS [5 điểm]
CREATE TABLE ORDERS (
    order_id VARCHAR(4) PRIMARY KEY,
    customer_id VARCHAR(4),
    order_date DATE,
    total_amount DOUBLE,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);
-- Bảng PRODUCTS [5 điểm]
CREATE TABLE PRODUCTS (
    product_id VARCHAR(4) PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    price DOUBLE,
    status BIT(1)
);
-- Bảng ORDERS_DETAILS [5 điểm]
CREATE TABLE ORDERS_DETAILS (
    order_id VARCHAR(4),
    product_id VARCHAR(4),
    quantity INT,
    price DOUBLE,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);
-- Bài 2:: Thêm dữ liệu [20 điểm]: 
-- Bảng CUSTOMERS [5 điểm] : 
insert into CUSTOMERS values('C001','NGUYỄN TRUNG MẠNH','manhnt@gmail.com','984756322','Cầu Giấy,Hà Nội'),
('C002','HỒ HẢI NAM','namhh@gmail.com','984875926','Ba Vì,Hà Nội'),
('C003','TÔ NGỌC VŨ','vutn@gmail.com','904725784','Mộc Châu,Sơn La'),
('C004','PHẠM NGỌC ANH','anhpn@gmail.com','984635365','Vinh,Nghệ An'),
('C005','TRƯƠNG MINH CƯỜNG','cuongtm@gmail.com','989735624','Hai Bà Trưng,Hà Nội');
-- Bảng PRODUCTS [5 điểm]:
insert into PRODUCTS values('P001','Iphone 13 ProMax','Bản 512GB,xanh lá','22999999',true),
('P002','Dell Vostro V3510','Core i5,RAM 8GB','14999999',true),
('P003','Macbook Pro M2','8CPU 10GPU 8GB 256GB','28999999',true),
('P004','Apple Watch Ultra','Titanium Alpine Loop Small','18999999',true),
('P005','Airpods 2 2022','Spatial Audio','4090000',true);
-- bảng ORDERS [5 điểm]:
insert into ORDERS(order_id,customer_id,total_amount,order_date) values
('H001','C001','52999997','2023-02-22'),
('H002','C001','80999997','2023-03-11'),
('H003','C002','54359998','2023-01-22'),
('H004','C003','102999995','2023-03-14'),
('H005','C003','80999997','2023-03-12'),
('H006','C004','110449994','2023-02-01'),
('H007','C004','79999996','2023-03-29'),
('H008','C005','29999998','2023-02-14'),
('H009','C005','28999999','2023-01-10'),
('H010','C005','149999994','2023-04-01');
-- bảng Orders_details [5 điểm]:
insert into Orders_details(order_id,product_id,price,quantity) values
('H001','P002','14999999',1),
('H001','P004','18999999',2),
('H002','P001','22999999',1),
('H002','P003','28999999',2),
('H003','P004','18999999',2),
('H003','P005','4090000',4),
('H004','P002','14999999',3),
('H004','P003','28999999',2),
('H005','P001','22999999',1),
('H005','P003','28999999',2),
('H006','P005','4090000',5),
('H006','P002','14999999',6),
('H007','P004','18999999',3),
('H007','P001','22999999',1),
('H008','P002','14999999',2),
('H009','P003','28999999',1),
('H010','P003','28999999',2),
('H010','P001','22999999',4);
-- Bài 3: Truy vấn dữ liệu [30 điểm]: 
-- Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers.[4 điểm] 
SELECT name, email, phone, address
FROM CUSTOMERS;

-- Thống kê những khách hàng mua hàng trong tháng 3/2023
-- (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).[4 điểm] 
SELECT C.name, C.phone, C.address
FROM CUSTOMERS C
JOIN ORDERS O ON C.customer_id = O.customer_id
WHERE MONTH(O.order_date) = 3 AND YEAR(O.order_date) = 2023;

-- Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023
-- (thông tin bao gồm tháng và tổng doanh thu).[4 điểm] 
SELECT MONTH(O.order_date) AS month, SUM(O.total_amount) AS total_revenue
FROM ORDERS O
WHERE YEAR(O.order_date) = 2023
GROUP BY MONTH(O.order_date);

-- Thống kê những người dùng không mua hàng trong tháng 2/2023
-- (thông tin gồm tên khách hàng, địa chỉ, email và số điện thoại).[4 điểm] 
SELECT C.name, C.address, C.email, C.phone
FROM CUSTOMERS C
WHERE C.customer_id NOT IN (
    SELECT O.customer_id
    FROM ORDERS O
    WHERE MONTH(O.order_date) = 2 AND YEAR(O.order_date) = 2023
);

-- Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023
-- (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra).[4 điểm] 
SELECT P.product_id, P.name, SUM(OD.quantity) AS total_quantity
FROM PRODUCTS P
JOIN ORDERS_DETAILS OD ON P.product_id = OD.product_id
JOIN ORDERS O ON O.order_id = OD.order_id
WHERE MONTH(O.order_date) = 3 AND YEAR(O.order_date) = 2023
GROUP BY P.product_id, P.name;
 
-- Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu 
-- (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm] 
SELECT C.customer_id, C.name, SUM(O.total_amount) AS total_spending
FROM CUSTOMERS C
JOIN ORDERS O ON C.customer_id = O.customer_id
WHERE YEAR(O.order_date) = 2023
GROUP BY C.customer_id, C.name
ORDER BY total_spending DESC;

-- Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên 
-- (thông tin bao gồm tên người mua, tổng tiền, ngày tạo hoá đơn, tổng số lượng sản phẩm). [5 điểm] 
SELECT C.name, O.total_amount, O.order_date, SUM(OD.quantity) AS total_quantity
FROM CUSTOMERS C
JOIN ORDERS O ON C.customer_id = O.customer_id
JOIN ORDERS_DETAILS OD ON O.order_id = OD.order_id
GROUP BY C.name, O.total_amount, O.order_date
HAVING total_quantity >= 5;

-- Bài 4: Tạo View, Procedure [30 điểm]:
-- Tạo VIEW lấy các thông tin hoá đơn bao gồm:
-- Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn. [3 điểm] 
CREATE VIEW View_Invoice_Info AS
SELECT C.name, C.phone, C.address, O.total_amount, O.order_date
FROM CUSTOMERS C
JOIN ORDERS O ON C.customer_id = O.customer_id;

-- Tạo VIEW hiển thị thông tin khách hàng gồm:
-- tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt. [3 điểm] 
CREATE VIEW View_Customer_Order_Info AS
SELECT C.name, C.address, C.phone, COUNT(O.order_id) AS total_orders
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.customer_id = O.customer_id
GROUP BY C.name, C.address, C.phone;

-- Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả,
-- giá và tổng số lượng đã bán ra của mỗi sản phẩm. [3 điểm] 
CREATE VIEW View_Product_Sales_Info AS
SELECT P.name, P.description, P.price, SUM(OD.quantity) AS total_sold
FROM PRODUCTS P
JOIN ORDERS_DETAILS OD ON P.product_id = OD.product_id
GROUP BY P.name, P.description, P.price;

-- Đánh INDEX cho trường phone và email của bảng CUSTOMERS. [3 điểm] 
CREATE INDEX idx_phone ON CUSTOMERS(phone);
CREATE INDEX idx_email ON CUSTOMERS(email);

-- Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng. [3 điểm] 
delimiter $$
CREATE PROCEDURE GetCustomerInfo(IN customerId VARCHAR(4))
BEGIN
    SELECT * FROM CUSTOMERS WHERE customer_id = customerId;
END$$

-- Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm] 
delimiter $$
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT * FROM PRODUCTS;
END$$
-- call GetAllProducts();
-- Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm] 
delimiter $$
CREATE PROCEDURE GetInvoicesByCustomer(IN customerId VARCHAR(4))
BEGIN
    SELECT * FROM ORDERS WHERE customer_id = customerId;
END$$

-- Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng,
-- tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm] 
CREATE PROCEDURE CreateNewOrder(IN customerId VARCHAR(4), IN totalAmount DOUBLE, IN orderDate DATE)
BEGIN
    INSERT INTO ORDERS (customer_id, total_amount, order_date) 
    VALUES (customerId, totalAmount, orderDate);
    SELECT LAST_INSERT_ID() AS order_id;
END$$

-- Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể
-- với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm] 
delimiter $$
CREATE PROCEDURE GetProductSalesInRange(IN startDate DATE, IN endDate DATE)
BEGIN
    SELECT P.product_id, P.name, SUM(OD.quantity) AS total_sold
    FROM PRODUCTS P
    JOIN ORDERS_DETAILS OD ON P.product_id = OD.product_id
    JOIN ORDERS O ON OD.order_id = O.order_id
    WHERE O.order_date BETWEEN startDate AND endDate
    GROUP BY P.product_id, P.name;
END$$

-- Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần
-- của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm] 
delimiter $$
CREATE PROCEDURE GetProductSalesByMonth(IN month INT, IN year INT)
BEGIN
    SELECT P.product_id, P.name, SUM(OD.quantity) AS total_sold
    FROM PRODUCTS P
    JOIN ORDERS_DETAILS OD ON P.product_id = OD.product_id
    JOIN ORDERS O ON O.order_id = OD.order_id
    WHERE MONTH(O.order_date) = month AND YEAR(O.order_date) = year
    GROUP BY P.product_id, P.name
    ORDER BY total_sold DESC;
END$$
