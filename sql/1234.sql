prompt PL/SQL Developer Export Tables for user HR@XEPDB1
prompt Created by blekk on 7 Июль 2024 г.
set feedback off
set define off

prompt Creating DEP...
create table DEP
(
  num_cl  VARCHAR2(20) not null,
  summa   NUMBER,
  data_s  DATE,
  data_po DATE,
  com     NUMBER
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating JOBS...
create table JOBS
(
  job_id     VARCHAR2(10) not null,
  job_title  VARCHAR2(35),
  min_salary NUMBER(6),
  max_salary NUMBER(6)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table JOBS
  is 'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';
comment on column JOBS.job_id
  is 'Primary key of jobs table.';
comment on column JOBS.job_title
  is 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';
comment on column JOBS.min_salary
  is 'Minimum salary for a job title.';
comment on column JOBS.max_salary
  is 'Maximum salary for a job title';
alter table JOBS
  add constraint JOB_ID_PK primary key (JOB_ID)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table JOBS
  add constraint JOB_TITLE_NN
  check ("JOB_TITLE" IS NOT NULL);

prompt Creating DEPARTMENTS...
create table DEPARTMENTS
(
  department_id   NUMBER(4) not null,
  department_name VARCHAR2(30),
  manager_id      NUMBER(6),
  location_id     NUMBER(4)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table DEPARTMENTS
  is 'Departments table that shows details of departments where employees
work. Contains 27 rows; references with locations, employees, and job_history tables.';
comment on column DEPARTMENTS.department_id
  is 'Primary key column of departments table.';
comment on column DEPARTMENTS.department_name
  is 'A not null column that shows name of a department. Administration,
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public
Relations, Sales, Finance, and Accounting. ';
comment on column DEPARTMENTS.manager_id
  is 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';
comment on column DEPARTMENTS.location_id
  is 'Location id where a department is located. Foreign key to location_id column of locations table.';
create index DEPT_LOCATION_IX on DEPARTMENTS (LOCATION_ID)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table DEPARTMENTS
  add constraint DEPT_ID_PK primary key (DEPARTMENT_ID)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table DEPARTMENTS
  add constraint DEPT_LOC_FK foreign key (LOCATION_ID)
  references LOCATIONS (LOCATION_ID);
alter table DEPARTMENTS
  add constraint DEPT_MGR_FK foreign key (MANAGER_ID)
  references EMPLOYEES (EMPLOYEE_ID);
alter table DEPARTMENTS
  add constraint DEPT_NAME_NN
  check ("DEPARTMENT_NAME" IS NOT NULL);

prompt Creating EMPLOYEES...
create table EMPLOYEES
(
  employee_id    NUMBER(6) not null,
  first_name     VARCHAR2(20),
  last_name      VARCHAR2(25),
  email          VARCHAR2(25),
  phone_number   VARCHAR2(20),
  hire_date      DATE,
  job_id         VARCHAR2(10),
  salary         NUMBER(8,2),
  commission_pct NUMBER(2,2),
  manager_id     NUMBER(6),
  department_id  NUMBER(4)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table EMPLOYEES
  is 'employees table. Contains 107 rows. References with departments,
jobs, job_history tables. Contains a self reference.';
comment on column EMPLOYEES.employee_id
  is 'Primary key of employees table.';
comment on column EMPLOYEES.first_name
  is 'First name of the employee. A not null column.';
comment on column EMPLOYEES.last_name
  is 'Last name of the employee. A not null column.';
comment on column EMPLOYEES.email
  is 'Email id of the employee';
comment on column EMPLOYEES.phone_number
  is 'Phone number of the employee; includes country code and area code';
comment on column EMPLOYEES.hire_date
  is 'Date when the employee started on this job. A not null column.';
comment on column EMPLOYEES.job_id
  is 'Current job of the employee; foreign key to job_id column of the
jobs table. A not null column.';
comment on column EMPLOYEES.salary
  is 'Monthly salary of the employee. Must be greater
than zero (enforced by constraint emp_salary_min)';
comment on column EMPLOYEES.commission_pct
  is 'Commission percentage of the employee; Only employees in sales
department elgible for commission percentage';
comment on column EMPLOYEES.manager_id
  is 'Manager id of the employee; has same domain as manager_id in
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';
comment on column EMPLOYEES.department_id
  is 'Department id where employee works; foreign key to department_id
column of the departments table';
create index EMP_DEPARTMENT_IX on EMPLOYEES (DEPARTMENT_ID)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index EMP_JOB_IX on EMPLOYEES (JOB_ID)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index EMP_MANAGER_IX on EMPLOYEES (MANAGER_ID)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index EMP_NAME_IX on EMPLOYEES (LAST_NAME, FIRST_NAME)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table EMPLOYEES
  add constraint EMP_EMP_ID_PK primary key (EMPLOYEE_ID)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table EMPLOYEES
  add constraint EMP_EMAIL_UK unique (EMAIL)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table EMPLOYEES
  add constraint EMP_DEPT_FK foreign key (DEPARTMENT_ID)
  references DEPARTMENTS (DEPARTMENT_ID);
alter table EMPLOYEES
  add constraint EMP_JOB_FK foreign key (JOB_ID)
  references JOBS (JOB_ID);
alter table EMPLOYEES
  add constraint EMP_MANAGER_FK foreign key (MANAGER_ID)
  references EMPLOYEES (EMPLOYEE_ID);
alter table EMPLOYEES
  add constraint EMP_EMAIL_NN
  check ("EMAIL" IS NOT NULL);
alter table EMPLOYEES
  add constraint EMP_HIRE_DATE_NN
  check ("HIRE_DATE" IS NOT NULL);
alter table EMPLOYEES
  add constraint EMP_JOB_NN
  check ("JOB_ID" IS NOT NULL);
alter table EMPLOYEES
  add constraint EMP_LAST_NAME_NN
  check ("LAST_NAME" IS NOT NULL);
alter table EMPLOYEES
  add constraint EMP_SALARY_MIN
  check (salary > 0);

prompt Creating LOCATIONS...
create table LOCATIONS
(
  location_id    NUMBER(4) not null,
  street_address VARCHAR2(40),
  postal_code    VARCHAR2(12),
  city           VARCHAR2(30),
  state_province VARCHAR2(25),
  country_id     CHAR(2)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table LOCATIONS
  is 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';
comment on column LOCATIONS.location_id
  is 'Primary key of locations table';
comment on column LOCATIONS.street_address
  is 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';
comment on column LOCATIONS.postal_code
  is 'Postal code of the location of an office, warehouse, or production site
of a company. ';
comment on column LOCATIONS.city
  is 'A not null column that shows city where an office, warehouse, or
production site of a company is located. ';
comment on column LOCATIONS.state_province
  is 'State or Province where an office, warehouse, or production site of a
company is located.';
comment on column LOCATIONS.country_id
  is 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';
create index LOC_CITY_IX on LOCATIONS (CITY)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index LOC_COUNTRY_IX on LOCATIONS (COUNTRY_ID)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index LOC_STATE_PROVINCE_IX on LOCATIONS (STATE_PROVINCE)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table LOCATIONS
  add constraint LOC_ID_PK primary key (LOCATION_ID)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table LOCATIONS
  add constraint LOC_C_ID_FK foreign key (COUNTRY_ID)
  references COUNTRIES (COUNTRY_ID);
alter table LOCATIONS
  add constraint LOC_CITY_NN
  check ("CITY" IS NOT NULL);

prompt Creating DEP_DOG...
create table DEP_DOG
(
  id_dep_dog     NUMBER(20) not null,
  num_dog        NUMBER(20) not null,
  id_client      VARCHAR2(100) not null,
  id_chet        NUMBER(20) not null,
  ostatok        NUMBER(20),
  data_podps     DATE,
  data_end       DATE,
  proc           NUMBER(10),
  data_zakrutia  DATE,
  period_vuplaty NUMBER(1)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table DEP_DOG
  add constraint ID_DEP_DOG_PK primary key (ID_DEP_DOG)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating INTERVALS...
create table INTERVALS
(
  dog     NUMBER not null,
  data_s  DATE,
  data_po DATE,
  symma   NUMBER
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating INVITRO_2_TABLE...
create table INVITRO_2_TABLE
(
  key   VARCHAR2(20) not null,
  value VARCHAR2(20) not null
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating INVITRO_3_TABLE...
create table INVITRO_3_TABLE
(
  key     VARCHAR2(20),
  data    DATE,
  value   VARCHAR2(20),
  column1 VARCHAR2(20)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating JOB_HISTORY...
create table JOB_HISTORY
(
  employee_id   NUMBER(6),
  start_date    DATE,
  end_date      DATE,
  job_id        VARCHAR2(10),
  department_id NUMBER(4)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table JOB_HISTORY
  is 'Table that stores job history of the employees. If an employee
changes departments within the job or changes jobs within the department,
new rows get inserted into this table with old job information of the
employee. Contains a complex primary key: employee_id+start_date.
Contains 25 rows. References with jobs, employees, and departments tables.';
comment on column JOB_HISTORY.employee_id
  is 'A not null column in the complex primary key employee_id+start_date.
Foreign key to employee_id column of the employee table';
comment on column JOB_HISTORY.start_date
  is 'A not null column in the complex primary key employee_id+start_date.
Must be less than the end_date of the job_history table. (enforced by
constraint jhist_date_interval)';
comment on column JOB_HISTORY.end_date
  is 'Last day of the employee in this job role. A not null column. Must be
greater than the start_date of the job_history table.
(enforced by constraint jhist_date_interval)';
comment on column JOB_HISTORY.job_id
  is 'Job role in which the employee worked in the past; foreign key to
job_id column in the jobs table. A not null column.';
comment on column JOB_HISTORY.department_id
  is 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table';
create index JHIST_DEPARTMENT_IX on JOB_HISTORY (DEPARTMENT_ID)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index JHIST_EMPLOYEE_IX on JOB_HISTORY (EMPLOYEE_ID)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index JHIST_JOB_IX on JOB_HISTORY (JOB_ID)
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table JOB_HISTORY
  add constraint JHIST_EMP_ID_ST_DATE_PK primary key (EMPLOYEE_ID, START_DATE)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table JOB_HISTORY
  add constraint JHIST_DEPT_FK foreign key (DEPARTMENT_ID)
  references DEPARTMENTS (DEPARTMENT_ID);
alter table JOB_HISTORY
  add constraint JHIST_EMP_FK foreign key (EMPLOYEE_ID)
  references EMPLOYEES (EMPLOYEE_ID);
alter table JOB_HISTORY
  add constraint JHIST_JOB_FK foreign key (JOB_ID)
  references JOBS (JOB_ID);
alter table JOB_HISTORY
  add constraint JHIST_DATE_INTERVAL
  check (end_date > start_date);
alter table JOB_HISTORY
  add constraint JHIST_EMPLOYEE_NN
  check ("EMPLOYEE_ID" IS NOT NULL);
alter table JOB_HISTORY
  add constraint JHIST_END_DATE_NN
  check ("END_DATE" IS NOT NULL);
alter table JOB_HISTORY
  add constraint JHIST_JOB_NN
  check ("JOB_ID" IS NOT NULL);
alter table JOB_HISTORY
  add constraint JHIST_START_DATE_NN
  check ("START_DATE" IS NOT NULL);

prompt Creating KALENDAR...
create table KALENDAR
(
  kalendar_data DATE not null
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating ORDERS...
create table ORDERS
(
  id        INTEGER not null,
  type_id   INTEGER not null,
  id_client INTEGER not null,
  id_bank   INTEGER not null,
  name      VARCHAR2(30),
  stat      NUMBER(5)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ORDERS
  add constraint ORDERS_PK primary key (ID)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating PRODUCTS...
create table PRODUCTS
(
  id    NUMBER not null,
  name  VARCHAR2(300 CHAR),
  price NUMBER
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table PRODUCTS
  add primary key (ID)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating PROVODKI...
create table PROVODKI
(
  id_provodki     NUMBER(20) not null,
  num_chet_credet NUMBER(20) not null,
  num_chet_debet  NUMBER(20) not null,
  id_client       NUMBER(20) not null,
  tip_klienta     NUMBER(1) not null,
  date_provodki   DATE
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255;
alter table PROVODKI
  add constraint ID_PROVODKI_PK primary key (ID_PROVODKI)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255;

prompt Creating REGIONS...
create table REGIONS
(
  region_id   NUMBER,
  region_name VARCHAR2(25)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table REGIONS
  add constraint REG_ID_PK primary key (REGION_ID)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table REGIONS
  add constraint REGION_ID_NN
  check ("REGION_ID" IS NOT NULL);

prompt Creating TABLE_1...
create table TABLE_1
(
  id         NUMBER(10) not null,
  city       VARCHAR2(50) not null,
  employeeid NUMBER(10) not null,
  rrjcount   NUMBER(10)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating TABLE_2...
create table TABLE_2
(
  id           NUMBER(10) not null,
  employeename VARCHAR2(50) not null
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating TABLE_3...
create table TABLE_3
(
  id     VARCHAR2(20),
  marker BINARY_DOUBLE not null
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating USERS...
create table USERS
(
  id        NUMBER not null,
  login     VARCHAR2(60) not null,
  sign_date DATE default sysdate not null,
  is_active NUMBER(1) default 1 not null
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table USERS
  add primary key (ID)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating VUPLATA...
create table VUPLATA
(
  id_vuplatu     NUMBER(20) not null,
  id_dog         NUMBER(20) not null,
  date_vuplatu   NUMBER(20) not null,
  status_vuplatu NUMBER(1) not null
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255;
alter table VUPLATA
  add constraint ID_VUPLATU_PK primary key (ID_VUPLATU)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255;

prompt Disabling triggers for DEP...
alter table DEP disable all triggers;
prompt Disabling triggers for JOBS...
alter table JOBS disable all triggers;
prompt Disabling triggers for DEPARTMENTS...
alter table DEPARTMENTS disable all triggers;
prompt Disabling triggers for EMPLOYEES...
alter table EMPLOYEES disable all triggers;
prompt Disabling triggers for LOCATIONS...
alter table LOCATIONS disable all triggers;
prompt Disabling triggers for DEP_DOG...
alter table DEP_DOG disable all triggers;
prompt Disabling triggers for INTERVALS...
alter table INTERVALS disable all triggers;
prompt Disabling triggers for INVITRO_2_TABLE...
alter table INVITRO_2_TABLE disable all triggers;
prompt Disabling triggers for INVITRO_3_TABLE...
alter table INVITRO_3_TABLE disable all triggers;
prompt Disabling triggers for JOB_HISTORY...
alter table JOB_HISTORY disable all triggers;
prompt Disabling triggers for KALENDAR...
alter table KALENDAR disable all triggers;
prompt Disabling triggers for ORDERS...
alter table ORDERS disable all triggers;
prompt Disabling triggers for PRODUCTS...
alter table PRODUCTS disable all triggers;
prompt Disabling triggers for PROVODKI...
alter table PROVODKI disable all triggers;
prompt Disabling triggers for REGIONS...
alter table REGIONS disable all triggers;
prompt Disabling triggers for TABLE_1...
alter table TABLE_1 disable all triggers;
prompt Disabling triggers for TABLE_2...
alter table TABLE_2 disable all triggers;
prompt Disabling triggers for TABLE_3...
alter table TABLE_3 disable all triggers;
prompt Disabling triggers for USERS...
alter table USERS disable all triggers;
prompt Disabling triggers for VUPLATA...
alter table VUPLATA disable all triggers;
prompt Disabling foreign key constraints for DEPARTMENTS...
alter table DEPARTMENTS disable constraint DEPT_LOC_FK;
alter table DEPARTMENTS disable constraint DEPT_MGR_FK;
prompt Disabling foreign key constraints for EMPLOYEES...
alter table EMPLOYEES disable constraint EMP_DEPT_FK;
alter table EMPLOYEES disable constraint EMP_JOB_FK;
alter table EMPLOYEES disable constraint EMP_MANAGER_FK;
prompt Disabling foreign key constraints for LOCATIONS...
alter table LOCATIONS disable constraint LOC_C_ID_FK;
prompt Disabling foreign key constraints for JOB_HISTORY...
alter table JOB_HISTORY disable constraint JHIST_DEPT_FK;
alter table JOB_HISTORY disable constraint JHIST_EMP_FK;
alter table JOB_HISTORY disable constraint JHIST_JOB_FK;
prompt Loading DEP...
insert into DEP (num_cl, summa, data_s, data_po, com)
values ('1', 1000, to_date('15-04-2019', 'dd-mm-yyyy'), to_date('12-12-2019', 'dd-mm-yyyy'), 50);
insert into DEP (num_cl, summa, data_s, data_po, com)
values ('2', 1500, to_date('17-06-2021', 'dd-mm-yyyy'), to_date('16-06-2021', 'dd-mm-yyyy'), 50);
insert into DEP (num_cl, summa, data_s, data_po, com)
values ('3', 5000, to_date('01-08-2016', 'dd-mm-yyyy'), to_date('10-12-2018', 'dd-mm-yyyy'), 50);
insert into DEP (num_cl, summa, data_s, data_po, com)
values ('4', 50, to_date('05-09-2022', 'dd-mm-yyyy'), to_date('31-12-2022', 'dd-mm-yyyy'), 5);
insert into DEP (num_cl, summa, data_s, data_po, com)
values ('5', 20000, to_date('01-10-2022', 'dd-mm-yyyy'), to_date('01-07-2022', 'dd-mm-yyyy'), 2000);
commit;
prompt 5 records loaded
prompt Loading JOBS...
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('AD_PRES', 'President', 20080, 40000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('AD_VP', 'Administration Vice President', 15000, 30000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('AD_ASST', 'Administration Assistant', 3000, 6000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('FI_MGR', 'Finance Manager', 8200, 16000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('FI_ACCOUNT', 'Accountant', 4200, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('AC_MGR', 'Accounting Manager', 8200, 16000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('AC_ACCOUNT', 'Public Accountant', 4200, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('SA_MAN', 'Sales Manager', 10000, 20080);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('SA_REP', 'Sales Representative', 6000, 12008);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('PU_MAN', 'Purchasing Manager', 8000, 15000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('PU_CLERK', 'Purchasing Clerk', 2500, 5500);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('ST_MAN', 'Stock Manager', 5500, 8500);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('ST_CLERK', 'Stock Clerk', 2008, 5000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('SH_CLERK', 'Shipping Clerk', 2500, 5500);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('IT_PROG', 'Programmer', 4000, 10000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('MK_MAN', 'Marketing Manager', 9000, 15000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('MK_REP', 'Marketing Representative', 4000, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('HR_REP', 'Human Resources Representative', 4000, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary)
values ('PR_REP', 'Public Relations Representative', 4500, 10500);
commit;
prompt 19 records loaded
prompt Loading DEPARTMENTS...
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (10, 'Administration', 200, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (20, 'Marketing', 201, 1800);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (30, 'Purchasing', 114, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (40, 'Human Resources', 203, 2400);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (50, 'Shipping', 121, 1500);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (60, 'IT', 103, 1400);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (70, 'Public Relations', 204, 2700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (80, 'Sales', 145, 2500);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (90, 'Executive', 100, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (100, 'Finance', 108, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (110, 'Accounting', 205, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (120, 'Treasury', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (130, 'Corporate Tax', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (140, 'Control And Credit', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (150, 'Shareholder Services', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (160, 'Benefits', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (170, 'Manufacturing', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (180, 'Construction', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (190, 'Contracting', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (200, 'Operations', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (210, 'IT Support', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (220, 'NOC', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (230, 'IT Helpdesk', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (240, 'Government Sales', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (250, 'Retail Sales', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (260, 'Recruiting', null, 1700);
insert into DEPARTMENTS (department_id, department_name, manager_id, location_id)
values (270, 'Payroll', null, 1700);
commit;
prompt 27 records loaded
prompt Loading EMPLOYEES...
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (100, 'Steven', 'King', 'SKING', '515.123.4567', to_date('17-06-2003', 'dd-mm-yyyy'), 'AD_PRES', 24000, null, null, 90);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', to_date('21-09-2005', 'dd-mm-yyyy'), 'AD_VP', 17000, null, 100, 90);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', to_date('13-01-2001', 'dd-mm-yyyy'), 'AD_VP', 17000, null, 100, 90);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', to_date('03-01-2006', 'dd-mm-yyyy'), 'IT_PROG', 9000, null, 102, 60);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', to_date('21-05-2007', 'dd-mm-yyyy'), 'IT_PROG', 6000, null, 103, 60);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', to_date('25-06-2005', 'dd-mm-yyyy'), 'IT_PROG', 4800, null, 103, 60);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', to_date('05-02-2006', 'dd-mm-yyyy'), 'IT_PROG', 4800, null, 103, 60);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', to_date('07-02-2007', 'dd-mm-yyyy'), 'IT_PROG', 4200, null, 103, 60);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', to_date('17-08-2002', 'dd-mm-yyyy'), 'FI_MGR', 12008, null, 101, 100);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', to_date('16-08-2002', 'dd-mm-yyyy'), 'FI_ACCOUNT', 9000, null, 108, 100);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (110, 'John', 'Chen', 'JCHEN', '515.124.4269', to_date('28-09-2005', 'dd-mm-yyyy'), 'FI_ACCOUNT', 8200, null, 108, 100);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', to_date('30-09-2005', 'dd-mm-yyyy'), 'FI_ACCOUNT', 7700, null, 108, 100);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (112, 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', to_date('07-03-2006', 'dd-mm-yyyy'), 'FI_ACCOUNT', 7800, null, 108, 100);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', to_date('07-12-2007', 'dd-mm-yyyy'), 'FI_ACCOUNT', 6900, null, 108, 100);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', to_date('07-12-2002', 'dd-mm-yyyy'), 'PU_MAN', 11000, null, 100, 30);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', to_date('18-05-2003', 'dd-mm-yyyy'), 'PU_CLERK', 3100, null, 114, 30);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', to_date('24-12-2005', 'dd-mm-yyyy'), 'PU_CLERK', 2900, null, 114, 30);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', to_date('24-07-2005', 'dd-mm-yyyy'), 'PU_CLERK', 2800, null, 114, 30);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', to_date('15-11-2006', 'dd-mm-yyyy'), 'PU_CLERK', 2600, null, 114, 30);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', to_date('10-08-2007', 'dd-mm-yyyy'), 'PU_CLERK', 2500, null, 114, 30);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', to_date('18-07-2004', 'dd-mm-yyyy'), 'ST_MAN', 8000, null, 100, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', to_date('10-04-2005', 'dd-mm-yyyy'), 'ST_MAN', 8200, null, 100, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', to_date('01-05-2003', 'dd-mm-yyyy'), 'ST_MAN', 7900, null, 100, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', to_date('10-10-2005', 'dd-mm-yyyy'), 'ST_MAN', 6500, null, 100, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', to_date('16-11-2007', 'dd-mm-yyyy'), 'ST_MAN', 5800, null, 100, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', to_date('16-07-2005', 'dd-mm-yyyy'), 'ST_CLERK', 3200, null, 120, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (126, 'Irene', 'Mikkilineni', 'IMIKKILI', '650.124.1224', to_date('28-09-2006', 'dd-mm-yyyy'), 'ST_CLERK', 2700, null, 120, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (127, 'James', 'Landry', 'JLANDRY', '650.124.1334', to_date('14-01-2007', 'dd-mm-yyyy'), 'ST_CLERK', 2400, null, 120, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', to_date('08-03-2008', 'dd-mm-yyyy'), 'ST_CLERK', 2200, null, 120, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', to_date('20-08-2005', 'dd-mm-yyyy'), 'ST_CLERK', 3300, null, 121, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', to_date('30-10-2005', 'dd-mm-yyyy'), 'ST_CLERK', 2800, null, 121, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', to_date('16-02-2005', 'dd-mm-yyyy'), 'ST_CLERK', 2500, null, 121, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', to_date('10-04-2007', 'dd-mm-yyyy'), 'ST_CLERK', 2100, null, 121, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', to_date('14-06-2004', 'dd-mm-yyyy'), 'ST_CLERK', 3300, null, 122, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', to_date('26-08-2006', 'dd-mm-yyyy'), 'ST_CLERK', 2900, null, 122, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (135, 'Ki', 'Gee', 'KGEE', '650.127.1734', to_date('12-12-2007', 'dd-mm-yyyy'), 'ST_CLERK', 2400, null, 122, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', to_date('06-02-2008', 'dd-mm-yyyy'), 'ST_CLERK', 2200, null, 122, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', to_date('14-07-2003', 'dd-mm-yyyy'), 'ST_CLERK', 3600, null, 123, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', to_date('26-10-2005', 'dd-mm-yyyy'), 'ST_CLERK', 3200, null, 123, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (139, 'John', 'Seo', 'JSEO', '650.121.2019', to_date('12-02-2006', 'dd-mm-yyyy'), 'ST_CLERK', 2700, null, 123, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', to_date('06-04-2006', 'dd-mm-yyyy'), 'ST_CLERK', 2500, null, 123, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', to_date('17-10-2003', 'dd-mm-yyyy'), 'ST_CLERK', 3500, null, 124, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', to_date('29-01-2005', 'dd-mm-yyyy'), 'ST_CLERK', 3100, null, 124, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', to_date('15-03-2006', 'dd-mm-yyyy'), 'ST_CLERK', 2600, null, 124, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', to_date('09-07-2006', 'dd-mm-yyyy'), 'ST_CLERK', 2500, null, 124, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', to_date('01-10-2004', 'dd-mm-yyyy'), 'SA_MAN', 14000, .4, 100, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', to_date('05-01-2005', 'dd-mm-yyyy'), 'SA_MAN', 13500, .3, 100, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.429278', to_date('10-03-2005', 'dd-mm-yyyy'), 'SA_MAN', 12000, .3, 100, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.619268', to_date('15-10-2007', 'dd-mm-yyyy'), 'SA_MAN', 11000, .3, 100, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', to_date('29-01-2008', 'dd-mm-yyyy'), 'SA_MAN', 10500, .2, 100, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.129268', to_date('30-01-2005', 'dd-mm-yyyy'), 'SA_REP', 10000, .3, 145, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.345268', to_date('24-03-2005', 'dd-mm-yyyy'), 'SA_REP', 9500, .25, 145, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (152, 'Peter', 'Hall', 'PHALL', '011.44.1344.478968', to_date('20-08-2005', 'dd-mm-yyyy'), 'SA_REP', 9000, .25, 145, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (153, 'Christopher', 'Olsen', 'COLSEN', '011.44.1344.498718', to_date('30-03-2006', 'dd-mm-yyyy'), 'SA_REP', 8000, .2, 145, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.987668', to_date('09-12-2006', 'dd-mm-yyyy'), 'SA_REP', 7500, .2, 145, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.486508', to_date('23-11-2007', 'dd-mm-yyyy'), 'SA_REP', 7000, .15, 145, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (156, 'Janette', 'King', 'JKING', '011.44.1345.429268', to_date('30-01-2004', 'dd-mm-yyyy'), 'SA_REP', 10000, .35, 146, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.929268', to_date('04-03-2004', 'dd-mm-yyyy'), 'SA_REP', 9500, .35, 146, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.829268', to_date('01-08-2004', 'dd-mm-yyyy'), 'SA_REP', 9000, .35, 146, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.729268', to_date('10-03-2005', 'dd-mm-yyyy'), 'SA_REP', 8000, .3, 146, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.629268', to_date('15-12-2005', 'dd-mm-yyyy'), 'SA_REP', 7500, .3, 146, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.529268', to_date('03-11-2006', 'dd-mm-yyyy'), 'SA_REP', 7000, .25, 146, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.129268', to_date('11-11-2005', 'dd-mm-yyyy'), 'SA_REP', 10500, .25, 147, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.229268', to_date('19-03-2007', 'dd-mm-yyyy'), 'SA_REP', 9500, .15, 147, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.329268', to_date('24-01-2008', 'dd-mm-yyyy'), 'SA_REP', 7200, .1, 147, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (165, 'David', 'Lee', 'DLEE', '011.44.1346.529268', to_date('23-02-2008', 'dd-mm-yyyy'), 'SA_REP', 6800, .1, 147, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.629268', to_date('24-03-2008', 'dd-mm-yyyy'), 'SA_REP', 6400, .1, 147, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.729268', to_date('21-04-2008', 'dd-mm-yyyy'), 'SA_REP', 6200, .1, 147, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.929268', to_date('11-03-2005', 'dd-mm-yyyy'), 'SA_REP', 11500, .25, 148, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (169, 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.829268', to_date('23-03-2006', 'dd-mm-yyyy'), 'SA_REP', 10000, .2, 148, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.729268', to_date('24-01-2006', 'dd-mm-yyyy'), 'SA_REP', 9600, .2, 148, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (171, 'William', 'Smith', 'WSMITH', '011.44.1343.629268', to_date('23-02-2007', 'dd-mm-yyyy'), 'SA_REP', 7400, .15, 148, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.529268', to_date('24-03-2007', 'dd-mm-yyyy'), 'SA_REP', 7300, .15, 148, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.329268', to_date('21-04-2008', 'dd-mm-yyyy'), 'SA_REP', 6100, .1, 148, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.429267', to_date('11-05-2004', 'dd-mm-yyyy'), 'SA_REP', 11000, .3, 149, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.429266', to_date('19-03-2005', 'dd-mm-yyyy'), 'SA_REP', 8800, .25, 149, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', to_date('24-03-2006', 'dd-mm-yyyy'), 'SA_REP', 8600, .2, 149, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.429264', to_date('23-04-2006', 'dd-mm-yyyy'), 'SA_REP', 8400, .2, 149, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.429263', to_date('24-05-2007', 'dd-mm-yyyy'), 'SA_REP', 7000, .15, 149, null);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.429262', to_date('04-01-2008', 'dd-mm-yyyy'), 'SA_REP', 6200, .1, 149, 80);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', to_date('24-01-2006', 'dd-mm-yyyy'), 'SH_CLERK', 3200, null, 120, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', to_date('23-02-2006', 'dd-mm-yyyy'), 'SH_CLERK', 3100, null, 120, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', to_date('21-06-2007', 'dd-mm-yyyy'), 'SH_CLERK', 2500, null, 120, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', to_date('03-02-2008', 'dd-mm-yyyy'), 'SH_CLERK', 2800, null, 120, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', to_date('27-01-2004', 'dd-mm-yyyy'), 'SH_CLERK', 4200, null, 121, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', to_date('20-02-2005', 'dd-mm-yyyy'), 'SH_CLERK', 4100, null, 121, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', to_date('24-06-2006', 'dd-mm-yyyy'), 'SH_CLERK', 3400, null, 121, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', to_date('07-02-2007', 'dd-mm-yyyy'), 'SH_CLERK', 3000, null, 121, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', to_date('14-06-2005', 'dd-mm-yyyy'), 'SH_CLERK', 3800, null, 122, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', to_date('13-08-2005', 'dd-mm-yyyy'), 'SH_CLERK', 3600, null, 122, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', to_date('11-07-2006', 'dd-mm-yyyy'), 'SH_CLERK', 2900, null, 122, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', to_date('19-12-2007', 'dd-mm-yyyy'), 'SH_CLERK', 2500, null, 122, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', to_date('04-02-2004', 'dd-mm-yyyy'), 'SH_CLERK', 4000, null, 123, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', to_date('03-03-2005', 'dd-mm-yyyy'), 'SH_CLERK', 3900, null, 123, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', to_date('01-07-2006', 'dd-mm-yyyy'), 'SH_CLERK', 3200, null, 123, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (195, 'Vance', 'Jones', 'VJONES', '650.501.4876', to_date('17-03-2007', 'dd-mm-yyyy'), 'SH_CLERK', 2800, null, 123, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', to_date('24-04-2006', 'dd-mm-yyyy'), 'SH_CLERK', 3100, null, 124, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', to_date('23-05-2006', 'dd-mm-yyyy'), 'SH_CLERK', 3000, null, 124, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', to_date('21-06-2007', 'dd-mm-yyyy'), 'SH_CLERK', 2600, null, 124, 50);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', to_date('13-01-2008', 'dd-mm-yyyy'), 'SH_CLERK', 2600, null, 124, 50);
commit;
prompt 100 records committed...
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', to_date('17-09-2003', 'dd-mm-yyyy'), 'AD_ASST', 4400, null, 101, 10);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', to_date('17-02-2004', 'dd-mm-yyyy'), 'MK_MAN', 13000, null, 100, 20);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (202, 'Pat', 'Fay', 'PFAY', '603.123.6666', to_date('17-08-2005', 'dd-mm-yyyy'), 'MK_REP', 6000, null, 201, 20);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', to_date('07-06-2002', 'dd-mm-yyyy'), 'HR_REP', 6500, null, 101, 40);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', to_date('07-06-2002', 'dd-mm-yyyy'), 'PR_REP', 10000, null, 101, 70);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', to_date('07-06-2002', 'dd-mm-yyyy'), 'AC_MGR', 12008, null, 101, 110);
insert into EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', to_date('07-06-2002', 'dd-mm-yyyy'), 'AC_ACCOUNT', 8300, null, 205, 110);
commit;
prompt 107 records loaded
prompt Loading LOCATIONS...
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1000, '1297 Via Cola di Rie', '00989', 'Roma', null, 'IT');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1100, '93091 Calle della Testa', '10934', 'Venice', null, 'IT');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1300, '9450 Kamiya-cho', '6823', 'Hiroshima', null, 'JP');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2000, '40-5-12 Laogianggen', '190518', 'Beijing', null, 'CN');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2300, '198 Clementi North', '540198', 'Singapore', null, 'SG');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2400, '8204 Arthur St', null, 'London', null, 'UK');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2600, '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL');
insert into LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
values (3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,', 'MX');
commit;
prompt 23 records loaded
prompt Loading DEP_DOG...
insert into DEP_DOG (id_dep_dog, num_dog, id_client, id_chet, ostatok, data_podps, data_end, proc, data_zakrutia, period_vuplaty)
values (3, 33, '3', 3, 100000, to_date('20-06-2024', 'dd-mm-yyyy'), to_date('20-06-2025', 'dd-mm-yyyy'), 11, null, null);
insert into DEP_DOG (id_dep_dog, num_dog, id_client, id_chet, ostatok, data_podps, data_end, proc, data_zakrutia, period_vuplaty)
values (1, 11, '1', 1, 10000000, to_date('12-12-2001', 'dd-mm-yyyy'), to_date('12-12-2005', 'dd-mm-yyyy'), 13, null, null);
insert into DEP_DOG (id_dep_dog, num_dog, id_client, id_chet, ostatok, data_podps, data_end, proc, data_zakrutia, period_vuplaty)
values (2, 22, '2', 2, 1000, to_date('12-12-2000', 'dd-mm-yyyy'), to_date('12-12-2023', 'dd-mm-yyyy'), 12, null, null);
commit;
prompt 3 records loaded
prompt Loading INTERVALS...
insert into INTERVALS (dog, data_s, data_po, symma)
values (1, to_date('02-01-2023', 'dd-mm-yyyy'), to_date('04-01-2023', 'dd-mm-yyyy'), 100);
insert into INTERVALS (dog, data_s, data_po, symma)
values (1, to_date('05-01-2023', 'dd-mm-yyyy'), to_date('08-01-2023', 'dd-mm-yyyy'), 0);
insert into INTERVALS (dog, data_s, data_po, symma)
values (1, to_date('09-01-2023', 'dd-mm-yyyy'), null, 300);
insert into INTERVALS (dog, data_s, data_po, symma)
values (2, to_date('04-01-2023', 'dd-mm-yyyy'), to_date('06-01-2023', 'dd-mm-yyyy'), 3000);
insert into INTERVALS (dog, data_s, data_po, symma)
values (2, to_date('07-01-2023', 'dd-mm-yyyy'), null, 100);
commit;
prompt 5 records loaded
prompt Loading INVITRO_2_TABLE...
insert into INVITRO_2_TABLE (key, value)
values ('A1', 'O');
insert into INVITRO_2_TABLE (key, value)
values ('A1', 'O');
insert into INVITRO_2_TABLE (key, value)
values ('A1', 'O');
insert into INVITRO_2_TABLE (key, value)
values ('B1', 'O');
insert into INVITRO_2_TABLE (key, value)
values ('B1', 'X');
insert into INVITRO_2_TABLE (key, value)
values ('D1', 'P');
insert into INVITRO_2_TABLE (key, value)
values ('D1', 'P');
insert into INVITRO_2_TABLE (key, value)
values ('D1', 'P');
insert into INVITRO_2_TABLE (key, value)
values ('D1', 'P');
insert into INVITRO_2_TABLE (key, value)
values ('E1', 'X');
insert into INVITRO_2_TABLE (key, value)
values ('E1', 'V');
insert into INVITRO_2_TABLE (key, value)
values ('E1', 'N');
insert into INVITRO_2_TABLE (key, value)
values ('E1', 'N');
commit;
prompt 13 records loaded
prompt Loading INVITRO_3_TABLE...
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('A1', to_date('12-07-2017', 'dd-mm-yyyy'), '1', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('A1', to_date('13-07-2017', 'dd-mm-yyyy'), '4', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('A1', to_date('16-07-2017', 'dd-mm-yyyy'), '6', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('A1', to_date('15-07-2016', 'dd-mm-yyyy'), '3', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('B1', to_date('14-07-2016', 'dd-mm-yyyy'), '2', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('B1', to_date('18-07-2016', 'dd-mm-yyyy'), '6', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('B1', to_date('03-07-2016', 'dd-mm-yyyy'), '8', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('B1', to_date('11-07-2017', 'dd-mm-yyyy'), '9', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('C1', to_date('17-07-2017', 'dd-mm-yyyy'), '4', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('C1', to_date('22-07-2017', 'dd-mm-yyyy'), '6', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('C1', to_date('02-07-2017', 'dd-mm-yyyy'), '9', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('D1', to_date('03-07-2017', 'dd-mm-yyyy'), '2', null);
insert into INVITRO_3_TABLE (key, data, value, column1)
values ('D1', to_date('02-07-2017', 'dd-mm-yyyy'), '4', null);
commit;
prompt 13 records loaded
prompt Loading JOB_HISTORY...
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (102, to_date('13-01-2001', 'dd-mm-yyyy'), to_date('24-07-2006', 'dd-mm-yyyy'), 'IT_PROG', 60);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (101, to_date('21-09-1997', 'dd-mm-yyyy'), to_date('27-10-2001', 'dd-mm-yyyy'), 'AC_ACCOUNT', 110);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (101, to_date('28-10-2001', 'dd-mm-yyyy'), to_date('15-03-2005', 'dd-mm-yyyy'), 'AC_MGR', 110);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (201, to_date('17-02-2004', 'dd-mm-yyyy'), to_date('19-12-2007', 'dd-mm-yyyy'), 'MK_REP', 20);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (114, to_date('24-03-2006', 'dd-mm-yyyy'), to_date('31-12-2007', 'dd-mm-yyyy'), 'ST_CLERK', 50);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (122, to_date('01-01-2007', 'dd-mm-yyyy'), to_date('31-12-2007', 'dd-mm-yyyy'), 'ST_CLERK', 50);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (200, to_date('17-09-1995', 'dd-mm-yyyy'), to_date('17-06-2001', 'dd-mm-yyyy'), 'AD_ASST', 90);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (176, to_date('24-03-2006', 'dd-mm-yyyy'), to_date('31-12-2006', 'dd-mm-yyyy'), 'SA_REP', 80);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (176, to_date('01-01-2007', 'dd-mm-yyyy'), to_date('31-12-2007', 'dd-mm-yyyy'), 'SA_MAN', 80);
insert into JOB_HISTORY (employee_id, start_date, end_date, job_id, department_id)
values (200, to_date('01-07-2002', 'dd-mm-yyyy'), to_date('31-12-2006', 'dd-mm-yyyy'), 'AC_ACCOUNT', 90);
commit;
prompt 10 records loaded
prompt Loading KALENDAR...
prompt Table is empty
prompt Loading ORDERS...
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (1, 1, 1, 1, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (2, 1, 2, 2, null, 0);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (3, 2, 3, 3, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (4, 3, 4, 1, null, 0);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (5, 1, 1, 2, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (6, 3, 2, 3, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (7, 2, 2, 2, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (8, 1, 4, 2, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (9, 3, 1, 3, null, 0);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (10, 3, 1, 3, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (11, 2, 2, 2, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (12, 3, 2, 3, null, 0);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (13, 2, 1, 3, null, 1);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (14, 2, 1, 1, null, null);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (15, 3, 1, 1, null, null);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (16, 2, 1, 2, null, null);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (17, 3, 1, 2, null, null);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (18, 1, 3, 3, null, null);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (19, 1, 5, 1, null, null);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (20, 1, 6, 2, null, null);
insert into ORDERS (id, type_id, id_client, id_bank, name, stat)
values (21, 1, 6, 2, null, null);
commit;
prompt 21 records loaded
prompt Loading PRODUCTS...
insert into PRODUCTS (id, name, price)
values (1, 'Iphone', 1340);
insert into PRODUCTS (id, name, price)
values (2, 'mac', 55);
insert into PRODUCTS (id, name, price)
values (3, 'galaxy', 800);
commit;
prompt 3 records loaded
prompt Loading PROVODKI...
prompt Table is empty
prompt Loading REGIONS...
insert into REGIONS (region_id, region_name)
values (1, 'Europe');
insert into REGIONS (region_id, region_name)
values (2, 'Americas');
insert into REGIONS (region_id, region_name)
values (3, 'Asia');
insert into REGIONS (region_id, region_name)
values (4, 'Middle East and Africa');
commit;
prompt 4 records loaded
prompt Loading TABLE_1...
insert into TABLE_1 (id, city, employeeid, rrjcount)
values (1, 'Москва', 1, 4);
insert into TABLE_1 (id, city, employeeid, rrjcount)
values (2, 'Ростов', 3, 3);
insert into TABLE_1 (id, city, employeeid, rrjcount)
values (3, 'Азов', 3, 1);
commit;
prompt 3 records loaded
prompt Loading TABLE_2...
insert into TABLE_2 (id, employeename)
values (1, 'Вася');
insert into TABLE_2 (id, employeename)
values (2, 'Петя');
insert into TABLE_2 (id, employeename)
values (3, 'Игорь');
commit;
prompt 3 records loaded
prompt Loading TABLE_3...
insert into TABLE_3 (id, marker)
values ('1', 1.0E+000);
insert into TABLE_3 (id, marker)
values ('2', 1.0E+000);
insert into TABLE_3 (id, marker)
values ('3', 1.0E+000);
insert into TABLE_3 (id, marker)
values ('4', 0);
insert into TABLE_3 (id, marker)
values ('5', 0);
insert into TABLE_3 (id, marker)
values ('6', 0);
insert into TABLE_3 (id, marker)
values ('7', 1.0E+000);
commit;
prompt 7 records loaded
prompt Loading USERS...
insert into USERS (id, login, sign_date, is_active)
values (1, 'UserA', to_date('21-01-2019', 'dd-mm-yyyy'), 1);
insert into USERS (id, login, sign_date, is_active)
values (2, 'UserB', to_date('15-07-2017', 'dd-mm-yyyy'), 1);
insert into USERS (id, login, sign_date, is_active)
values (3, 'UserC', to_date('02-10-2015', 'dd-mm-yyyy'), 0);
insert into USERS (id, login, sign_date, is_active)
values (4, 'UserD', to_date('21-06-2024 19:01:53', 'dd-mm-yyyy hh24:mi:ss'), 1);
commit;
prompt 4 records loaded
prompt Loading VUPLATA...
prompt Table is empty
prompt Enabling foreign key constraints for DEPARTMENTS...
alter table DEPARTMENTS enable constraint DEPT_LOC_FK;
alter table DEPARTMENTS enable constraint DEPT_MGR_FK;
prompt Enabling foreign key constraints for EMPLOYEES...
alter table EMPLOYEES enable constraint EMP_DEPT_FK;
alter table EMPLOYEES enable constraint EMP_JOB_FK;
alter table EMPLOYEES enable constraint EMP_MANAGER_FK;
prompt Enabling foreign key constraints for LOCATIONS...
alter table LOCATIONS enable constraint LOC_C_ID_FK;
prompt Enabling foreign key constraints for JOB_HISTORY...
alter table JOB_HISTORY enable constraint JHIST_DEPT_FK;
alter table JOB_HISTORY enable constraint JHIST_EMP_FK;
alter table JOB_HISTORY enable constraint JHIST_JOB_FK;
prompt Enabling triggers for DEP...
alter table DEP enable all triggers;
prompt Enabling triggers for JOBS...
alter table JOBS enable all triggers;
prompt Enabling triggers for DEPARTMENTS...
alter table DEPARTMENTS enable all triggers;
prompt Enabling triggers for EMPLOYEES...
alter table EMPLOYEES enable all triggers;
prompt Enabling triggers for LOCATIONS...
alter table LOCATIONS enable all triggers;
prompt Enabling triggers for DEP_DOG...
alter table DEP_DOG enable all triggers;
prompt Enabling triggers for INTERVALS...
alter table INTERVALS enable all triggers;
prompt Enabling triggers for INVITRO_2_TABLE...
alter table INVITRO_2_TABLE enable all triggers;
prompt Enabling triggers for INVITRO_3_TABLE...
alter table INVITRO_3_TABLE enable all triggers;
prompt Enabling triggers for JOB_HISTORY...
alter table JOB_HISTORY enable all triggers;
prompt Enabling triggers for KALENDAR...
alter table KALENDAR enable all triggers;
prompt Enabling triggers for ORDERS...
alter table ORDERS enable all triggers;
prompt Enabling triggers for PRODUCTS...
alter table PRODUCTS enable all triggers;
prompt Enabling triggers for PROVODKI...
alter table PROVODKI enable all triggers;
prompt Enabling triggers for REGIONS...
alter table REGIONS enable all triggers;
prompt Enabling triggers for TABLE_1...
alter table TABLE_1 enable all triggers;
prompt Enabling triggers for TABLE_2...
alter table TABLE_2 enable all triggers;
prompt Enabling triggers for TABLE_3...
alter table TABLE_3 enable all triggers;
prompt Enabling triggers for USERS...
alter table USERS enable all triggers;
prompt Enabling triggers for VUPLATA...
alter table VUPLATA enable all triggers;

set feedback on
set define on
prompt Done
