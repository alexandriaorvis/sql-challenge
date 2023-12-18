-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/du1WtC
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" varchar   NOT NULL,
    "emp_title_id" varchar   NOT NULL,
    "birth_date" varchar   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" varchar   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "dept_employee" (
    "emp_no" varchar   NOT NULL,
    "dept_no" varchar   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar   NOT NULL,
    "emp_no" varchar   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" varchar   NOT NULL,
    "salary" int   NOT NULL
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_employee" ADD CONSTRAINT "fk_dept_employee_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_employee" ADD CONSTRAINT "fk_dept_employee_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


--- QUESTION 1 List the employee number, last name, first name, sex, and salary of each employee.

CREATE VIEW question_1 AS
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
LEFT JOIN salaries s
ON e.emp_no = s.emp_no;

--- QUESTION 2 List the first name, last name, and hire date for the employees who were hired in 1986.

CREATE VIEW question_2 AS
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '%1986';

--- QUESTION 3 List the manager of each department along with their department number, department name, employee number, last name, and first name.

CREATE VIEW question_3 AS
SELECT m.dept_no, m.emp_no, d.dept_name, e.last_name, e.first_name
FROM dept_manager m
	LEFT JOIN departments d
	ON m.dept_no = d.dept_no
		LEFT JOIN employees e
		ON m.emp_no = e.emp_no;

--- QUESTION 4 List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

CREATE VIEW question_4 AS
SELECT d.emp_no, d.dept_no, e.last_name, e.first_name, dn.dept_name
FROM dept_employee d
	JOIN employees e
	ON d.emp_no = e.emp_no
		JOIN departments dn
		ON d.dept_no = dn.dept_no
ORDER BY emp_no;

--- QUESTION 5 List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

CREATE VIEW question_5 AS
SELECT emp_no, first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND
	  last_name LIKE 'B%';

--- QUESTION 6 List each employee in the Sales department, including their employee number, last name, and first name.

CREATE VIEW question_6 AS
SELECT emp_no, last_name, first_name
FROM employees
WHERE emp_no IN (
	
	SELECT emp_no
	FROM dept_employee
	WHERE dept_no = 'd007'
)

--- QUESTION 7 List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

CREATE VIEW question_7 AS
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
	JOIN dept_employee de
	ON e.emp_no = de.emp_no
		Join departments d
		ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' OR
	  d.dept_name = 'Development';

--- QUESTION 8 List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
	  
CREATE VIEW question_8 AS	  
SELECT last_name, COUNT(last_name) AS name_counts
FROM employees
GROUP by last_name
ORDER BY last_name

