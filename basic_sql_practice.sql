CREATE DATABASE retail_analytics;
USE retail_analytics;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'Sales'),
(3, 'IT'),
(4, 'Finance'),
(5, 'Operations');
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    dept_id INT,
    salary INT,
    join_date DATE,
    CONSTRAINT fk_department
        FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
);
INSERT INTO employees (emp_id, emp_name, dept_id, salary, join_date) VALUES
(101, 'Amit', 1, 42000, '2021-03-15'),
(102, 'Neha', 2, 52000, '2020-07-10'),
(103, 'Rahul', 2, 48000, '2019-01-25'),
(104, 'Sneha', 3, 65000, '2018-11-05'),
(105, 'Karan', 3, 72000, '2017-06-18'),
(106, 'Pooja', 4, 58000, '2020-09-30'),
(107, 'Vikas', 5, 40000, '2022-02-12');
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_date DATE,
    amount INT,
    CONSTRAINT fk_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
);
INSERT INTO sales (sale_id, emp_id, sale_date, amount) VALUES
(1, 102, '2023-01-10', 12000),
(2, 102, '2023-01-15', 18000),
(3, 103, '2023-02-05', 15000),
(4, 104, '2023-02-20', 22000),
(5, 105, '2023-03-10', 30000),
(6, 106, '2023-03-18', 17000),
(7, 102, '2023-03-22', 25000),
(8, 107, '2023-04-01', 9000);
SHOW TABLES;
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM sales;

#TASK 1 (Start Now)
#1️⃣ Show all employees with their department names
SELECT e.emp_name,d.dept_name
FROM employees e
INNER JOIN Departments d ON e.dept_id=d.dept_id;


#2️⃣ Count employees in each department
SELECT d.dept_name,count(e.emp_name) as Count_of_employees
FROM employees e
INNER JOIN departments d ON e.dept_id=d.dept_id
group by d.dept_name;

#3️⃣ Find average salary per department#
SELECT d.dept_name, avg(e.salary) as Average_Salary
FROM employees e
INNER JOIN departments d ON e.dept_id=d.dept_id
GROUP BY d.dept_name;

#TAST 2
# 4.List employees earning above company average salary
SELECT emp_name
FROM employees
WHERE salary > (SELECT avg(salary) from employees);

# 5.Show highest and lowest salary per department
SELECT d.dept_name,max(e.salary) as Max_salary,min(e.salary) as Min_salary
FROM employees e
JOIN departments d ON e.dept_id=d.dept_id
GROUP BY d.dept_name
ORDER BY d.dept_name;

# Task 3: 

#6.Sales Performance Analysis
# Total sales by each employee
SELECT e.emp_name, sum(s.amount) as Total_Sales
FROM employees e
JOIN sales s on e.emp_id=s.emp_id
GROUP BY e.emp_name;

# 7. Total sales by department
SELECT d.dept_name, sum(s.amount) as Total_Department_sales
FROM employees e
JOIN Sales s ON e.emp_id=s.emp_id
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

# 8. Employees who have NOT made any sales (Where concept should be used)
SELECT e.emp_name
FROM employees e
LEFT JOIN sales s ON e.emp_id=s.emp_id
WHERE S.emp_id is NULL;

# Task 4 — Business Insights:
# 9.Ranking employees by sales
SELECT emp_name,
Total_sales,
RANK () OVER (ORDER BY Total_sales DESC) AS Sales_Rank
FROM(
SELECT 
e.emp_name as emp_name, sum(s.amount) as Total_sales
FROM employees e
JOIN sales s ON e.emp_id=s.emp_id
GROUP BY e.emp_name) t;

# 10 Identify Top 2 performing employees
SELECT emp_name, Total_sales, Sales_Rank
FROM (
    SELECT e.emp_name,
           SUM(s.amount) AS Total_sales,
           RANK() OVER (ORDER BY SUM(s.amount) DESC) AS Sales_Rank
    FROM employees e
    JOIN sales s 
        ON e.emp_id = s.emp_id
    GROUP BY e.emp_name
) t
WHERE Sales_Rank <= 2;
