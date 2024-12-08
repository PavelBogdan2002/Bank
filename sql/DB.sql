prompt PL/SQL Developer Export User Objects for user HR@XEPDB1
prompt Created by blekk on 7 Июль 2024 г.
set define off
spool DB.log

prompt
prompt Creating table CHETA
prompt ====================
prompt
create table HR.CHETA
(
  id_chet       NUMBER(20) not null,
  num_chet      NUMBER(20) not null,
  id_client     NUMBER(20) not null,
  tip_klienta   NUMBER(1),
  status_sheta  NUMBER(1) not null,
  date_otkrytia DATE not null,
  date_zakrytia DATE
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
alter table HR.CHETA
  add constraint ID_CHET_PK primary key (ID_CHET)
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

prompt
prompt Creating table CLIENTS
prompt ======================
prompt
create table HR.CLIENTS
(
  id       NUMBER(10) not null,
  fio      VARCHAR2(100) not null,
  birthday DATE not null
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

prompt
prompt Creating table CLIENTS_ALL
prompt ==========================
prompt
create table HR.CLIENTS_ALL
(
  id       NUMBER(10) not null,
  fio      VARCHAR2(50) not null,
  birthday DATE not null,
  city_id  NUMBER not null
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

prompt
prompt Creating table CLIENTS_BANK
prompt ===========================
prompt
create table HR.CLIENTS_BANK
(
  id_client    NUMBER(20) not null,
  first_name   VARCHAR2(50) not null,
  middle_name  VARCHAR2(50) not null,
  last_name    VARCHAR2(50) not null,
  date_birhday DATE not null,
  ser_passport NUMBER(4) not null,
  num_passport NUMBER(6) not null,
  type_clent   NUMBER(1)
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
alter table HR.CLIENTS_BANK
  add constraint ID_CLIENT_PK primary key (ID_CLIENT)
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

prompt
prompt Creating table COUNTRIES
prompt ========================
prompt
create table HR.COUNTRIES
(
  country_id   CHAR(2),
  country_name VARCHAR2(40),
  region_id    NUMBER,
  constraint COUNTRY_C_ID_PK primary key (COUNTRY_ID)
)
organization index;
comment on table HR.COUNTRIES
  is 'country table. Contains 25 rows. References with locations table.';
comment on column HR.COUNTRIES.country_id
  is 'Primary key of countries table.';
comment on column HR.COUNTRIES.country_name
  is 'Country name';
comment on column HR.COUNTRIES.region_id
  is 'Region ID for the country. Foreign key to region_id column in the departments table.';
alter table HR.COUNTRIES
  add constraint COUNTR_REG_FK foreign key (REGION_ID)
  references HR.REGIONS (REGION_ID);
alter table HR.COUNTRIES
  add constraint COUNTRY_ID_NN
  check ("COUNTRY_ID" IS NOT NULL);

prompt
prompt Creating table CREDITS
prompt ======================
prompt
create table HR.CREDITS
(
  numdog    VARCHAR2(20),
  date_plat DATE,
  summa     VARCHAR2(20)
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

prompt
prompt Creating table DEISTVIA_DEP
prompt ===========================
prompt
create table HR.DEISTVIA_DEP
(
  id_deistvia   NUMBER(20) not null,
  id_provodki   NUMBER(20) not null,
  type_deistvia NUMBER(1) not null,
  data_deistvia DATE,
  chet_debeta   NUMBER(20) not null,
  chet_credita  NUMBER(20) not null
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255;
alter table HR.DEISTVIA_DEP
  add constraint ID_DEISTVIA_PK primary key (ID_DEISTVIA)
  using index 
  tablespace SYSAUX
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table DEP
prompt ==================
prompt
create table HR.DEP
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

prompt
prompt Creating table DEPARTMENTS
prompt ==========================
prompt
create table HR.DEPARTMENTS
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
comment on table HR.DEPARTMENTS
  is 'Departments table that shows details of departments where employees
work. Contains 27 rows; references with locations, employees, and job_history tables.';
comment on column HR.DEPARTMENTS.department_id
  is 'Primary key column of departments table.';
comment on column HR.DEPARTMENTS.department_name
  is 'A not null column that shows name of a department. Administration,
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public
Relations, Sales, Finance, and Accounting. ';
comment on column HR.DEPARTMENTS.manager_id
  is 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';
comment on column HR.DEPARTMENTS.location_id
  is 'Location id where a department is located. Foreign key to location_id column of locations table.';
create index HR.DEPT_LOCATION_IX on HR.DEPARTMENTS (LOCATION_ID)
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
alter table HR.DEPARTMENTS
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
alter table HR.DEPARTMENTS
  add constraint DEPT_LOC_FK foreign key (LOCATION_ID)
  references HR.LOCATIONS (LOCATION_ID);
alter table HR.DEPARTMENTS
  add constraint DEPT_MGR_FK foreign key (MANAGER_ID)
  references HR.EMPLOYEES (EMPLOYEE_ID);
alter table HR.DEPARTMENTS
  add constraint DEPT_NAME_NN
  check ("DEPARTMENT_NAME" IS NOT NULL);

prompt
prompt Creating table EMPLOYEES
prompt ========================
prompt
create table HR.EMPLOYEES
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
comment on table HR.EMPLOYEES
  is 'employees table. Contains 107 rows. References with departments,
jobs, job_history tables. Contains a self reference.';
comment on column HR.EMPLOYEES.employee_id
  is 'Primary key of employees table.';
comment on column HR.EMPLOYEES.first_name
  is 'First name of the employee. A not null column.';
comment on column HR.EMPLOYEES.last_name
  is 'Last name of the employee. A not null column.';
comment on column HR.EMPLOYEES.email
  is 'Email id of the employee';
comment on column HR.EMPLOYEES.phone_number
  is 'Phone number of the employee; includes country code and area code';
comment on column HR.EMPLOYEES.hire_date
  is 'Date when the employee started on this job. A not null column.';
comment on column HR.EMPLOYEES.job_id
  is 'Current job of the employee; foreign key to job_id column of the
jobs table. A not null column.';
comment on column HR.EMPLOYEES.salary
  is 'Monthly salary of the employee. Must be greater
than zero (enforced by constraint emp_salary_min)';
comment on column HR.EMPLOYEES.commission_pct
  is 'Commission percentage of the employee; Only employees in sales
department elgible for commission percentage';
comment on column HR.EMPLOYEES.manager_id
  is 'Manager id of the employee; has same domain as manager_id in
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';
comment on column HR.EMPLOYEES.department_id
  is 'Department id where employee works; foreign key to department_id
column of the departments table';
create index HR.EMP_DEPARTMENT_IX on HR.EMPLOYEES (DEPARTMENT_ID)
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
create index HR.EMP_JOB_IX on HR.EMPLOYEES (JOB_ID)
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
create index HR.EMP_MANAGER_IX on HR.EMPLOYEES (MANAGER_ID)
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
create index HR.EMP_NAME_IX on HR.EMPLOYEES (LAST_NAME, FIRST_NAME)
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
alter table HR.EMPLOYEES
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
alter table HR.EMPLOYEES
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
alter table HR.EMPLOYEES
  add constraint EMP_DEPT_FK foreign key (DEPARTMENT_ID)
  references HR.DEPARTMENTS (DEPARTMENT_ID);
alter table HR.EMPLOYEES
  add constraint EMP_JOB_FK foreign key (JOB_ID)
  references HR.JOBS (JOB_ID);
alter table HR.EMPLOYEES
  add constraint EMP_MANAGER_FK foreign key (MANAGER_ID)
  references HR.EMPLOYEES (EMPLOYEE_ID);
alter table HR.EMPLOYEES
  add constraint EMP_EMAIL_NN
  check ("EMAIL" IS NOT NULL);
alter table HR.EMPLOYEES
  add constraint EMP_HIRE_DATE_NN
  check ("HIRE_DATE" IS NOT NULL);
alter table HR.EMPLOYEES
  add constraint EMP_JOB_NN
  check ("JOB_ID" IS NOT NULL);
alter table HR.EMPLOYEES
  add constraint EMP_LAST_NAME_NN
  check ("LAST_NAME" IS NOT NULL);
alter table HR.EMPLOYEES
  add constraint EMP_SALARY_MIN
  check (salary > 0);

prompt
prompt Creating table DEP_DOG
prompt ======================
prompt
create table HR.DEP_DOG
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
alter table HR.DEP_DOG
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


prompt Done
spool off
set define on
