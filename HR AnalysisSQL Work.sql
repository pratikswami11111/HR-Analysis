use hr_project;
select * from hr1;
select * from hr2;
create view hr_data as select * from hr1 left join hr2 on hr1.EmployeeNumber=hr2.EmployeeID;
alter table hr2 change `Employee ID` EmployeeID int;
select monthlyrate from hr_data;

 
 ALTER TABLE hr1 ADD COLUMN AttritionRate int;
UPDATE hr1 SET AttritionRate =
  CASE
    WHEN Attrition = 'No' THEN '0'
    WHEN Attrition = 'Yes' THEN '1'
    ELSE 'default'
  END;
  SET SQL_SAFE_UPDATES=0;
-- kpi1:Average Attrition rate for all Departments
select Department,round(avg(AttritionRate)*100,2) from hr1 group by Department;

-- kpi2:Average Hourly rate of Male Research Scientist
select Gender,avg(HourlyRate),JobRole from hr1 where Gender='Male'and JobRole='Research Scientist';

-- kpi3:Attrition rate Vs Monthly income stats
SELECT FLOOR(MonthlyIncome/5000)*5000 as MonthlyIncomeBin,count(case when attrition='Yes' then 1 end)as Yes,
count(case when attrition='No' then 0 end)as 'No',COUNT(attrition) as Total_emp
FROM hr_data 
GROUP BY MonthlyIncomeBin
ORDER BY MonthlyIncomeBin
;

-- Kpi4:Average working years for each Department
select department,avg(totalworkingyears) from hr_data group by department;

-- kpi5:Job Role Vs Work life balance
SELECT JobRole, 
    SUM(CASE WHEN Worklifebalance = '1' THEN 1 ELSE 0 
    END) AS Poor, 
    SUM(CASE WHEN Worklifebalance = '2' THEN 1 ELSE 0 
    END) AS Average, 
    SUM(CASE WHEN Worklifebalance = '3' THEN 1 ELSE 0 
    END) AS Good, 
    SUM(CASE WHEN Worklifebalance = '4' THEN 1 ELSE 0 
    END) AS Excellent
FROM hr_data 
GROUP BY JobRole order by jobrole;

-- kpi6:Attrition rate Vs Year since last promotion relation
select YearsSinceLastPromotion,concat(round(count(case when Attrition='Yes' then "" end)/count(EmployeeNumber)*100,2),"%")as "Average Attrition Rate" from hr_data
group by YearsSinceLastPromotion order by YearsSinceLastPromotion;



-- some extra kpi
-- kpi7:Departmentwise No of Employees
select department,count(employeenumber) from hr1 group by department;

-- kpi8:Count of Employees based on Educational Fields
select educationfield,count(employeenumber) from hr1 group by educationfield;


-- kpi9:Gender based Percentage of Employee
SELECT gender, COUNT(*) * 100 / total_count AS percentage
FROM hr1, (SELECT COUNT(*) AS total_count FROM hr1) AS total_counts
GROUP BY gender;

-- kpi10:Deptarment / Job Role wise job satisfaction
SELECT department,COUNT(*) AS num_employees, avg(jobsatisfaction) AS avg_satisfaction
FROM hr1
GROUP BY department;
SELECT jobrole,COUNT(*) AS num_employees, avg(jobsatisfaction) AS avg_satisfaction
FROM hr1
GROUP BY jobrole;














































