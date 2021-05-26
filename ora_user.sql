/*새로운 태이블 생성*/
CREATE TABLE ex2_2(
/*테이블 컬럼 데이터 정의*/
column1 VARCHAR2(3),
column2 VARCHAR2(3 BYTE),
column3 VARCHAR2(3 CHAR)
);

INSERT INTO ex2_2 VALUES('abc','abc','abc');
/*문자열 길이 확인 하는 문구*/
SELECT column1, length(column1) as len1,
    column2, length(column2) as len2,
    column3, length(column3) as len3
FROM ex2_2;

/*한글은 한글자 당 2byte로 형성되어 있어 오류 발생 */
/*INSERT INTO ex2_2 VALUES('홍길동','홍길동','홍길동');*/

INSERT into ex2_2(column3) VALUES('홍길동');

SELECT column3, length(column3) as len3, LENGTHB(column3) as bytelen
FROM ex2_2;

CREATE TABLE ex2_3(
COL_INT INTEGER,
COL_DEC DECIMAL,
COL_NUM NUMBER
);

SELECT column_id, column_name, data_type, data_length
    FROM user_tab_cols
    WHERE table_name = 'EX2_3'
    ORDER BY column_id;

CREATE TABLE EX2_4(
    COL_FLOT1 FLOAT(32),
    COL_FLOT2 FLOAT
);

INSERT INTO ex2_4 (col_flot1, col_flot2) VALUES (1234567891234, 1234567891234);

CREATE TABLE EX2_5(
    COL_DATE DATE,
    COL_TIMESTAMP TIMESTAMP
);

INSERT INTO EX2_5 VALUES (SYSDATE, SYSTIMESTAMP);
SELECT *
FROM EX2_5;


CREATE TABLE EX2_6(
    COL_NULL VARCHAR2(10),
    COL_NOT_NULL VARCHAR2(10) NOT NULL
);

INSERT INTO EX2_6 VALUES ('AA','BB');

SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_6';

CREATE TABLE EX2_7(
COL_UNIQUE_NULL VARCHAR2(10) UNIQUE,
COL_UNIQUE_NNULL VARCHAR2(10) UNIQUE NOT NULL,
COL_UNIQUE VARCHAR2(10),
CONSTRAINTS unique_nm1 UNIQUE (COL_UNIQUE)
);

SELECT constraint_name, constraint_type, table_name, search_condition FROM user_constraints WHERE table_name = 'EX2_7';

INSERT INTO EX2_7 VALUES ('AA', 'AA', 'AA');
INSERT INTO EX2_7 VALUES ('AA', 'AA', 'AA');

INSERT INTO EX2_7 VALUES ('', 'BB', 'BB');
INSERT INTO EX2_7 VALUES ('', 'CC', 'CC');


CREATE TABLE EX2_8(
    COL1 VARCHAR2(10) PRIMARY KEY,
    COL2 VARCHAR2(10)
);

SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_8';

--INSERT INTO EX2_8 VALUES ('','AA'); NULL 입력 불가

INSERT INTO EX2_8 VALUES ('AA','AA');

--INSERT INTO EX2_8 VALUES ('AA','AA'); 무결성 제약 조건 위배

CREATE TABLE ex2_9(
num1 NUMBER
CONSTRAINTS check11 check (num1 BETWEEN 1  and 9),
gender VARCHAR2(10)
CONSTRAINTS check22 check ( gender in ('MAKES','FEMALES'))
);

drop table ex2_91;

SELECT constraint_name, constraint_type, table_name , search_condition
from user_constraints
WHERE table_name='EX2_9';

-- check1은 1부터 9까지 제약을 두고 있으며 ,check2는 make,female 값만 들어갈수 있도록
--설정되어 출력되지 않는다
--insert into EX2_9 VALUES(10,'man')

insert into EX2_9 VALUES (5,'FEMALES');


CREATE TABLE  ex2_10 (
col1 varchar2(10) not null,
col2 VARCHAR2(10) null,
Create_date DATE DEFAULT SYSDATE);

--5/18일 오라클 

--행에 데이터  삽입
INSERT into ex2_10(col1, col2) VALUES('AA','BB');

-- 테이블 데이터 조회 
SELECT *
FROM ex2_10;

-- 테이블 삭제
--DROP TABLE ex2_10 (생략 가능 /CASCADE CONSTRAINTS);


-- 테이블 변경 명령어  
--ALTER TABLE명령어로 변경 

--컬럼명 이름 변경하기
ALTER TABLE ex2_10 RENAME COLUMN cloll to COL11;

DESC ex2_10;

--컬럼 타입 변경 하기
ALTER TABlE ex2_10 MODIFY col2 VARCHAR2(30);

DESC ex2_10;

--컬럼  및 타입 추가 명령어
ALTER TABle ex2_10 add col3 NUMBER;

DESC ex2_10;

--특정 컬럼 삭제하기
ALTER TABLE ex2_10 DROP COLUMN col3;

DESC ex2_10;

-- 제약조건추가 /기본키 추가

ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY (col11);

SELECT constraint_name,constraint_type, table_name, search_condition
FROM user_constraints
where table_name = 'EX2_10';

--제약 조건 삭제/ 기본키 삭제
ALTER TABLE ex2_10 DROP CONSTRAINT pk_ex2_10;

SELECT constraint_name,constraint_type, table_name, search_condition
FROM user_constraints
where table_name = 'EX2_10';

--테이블 복사

CREATE TABLE  ex2_9_1 AS
SELECT *
from ex2_9;

--테이블 삭제
DROP TABLE ex2_9_1;


--5/21일 수업
--뷰 생성하기

CREATE OR REPLACE VIEW  emp_dept_v1 AS
-- 뷰 테이블 생성 명렁어 

SELECT a.employee_id, a.emp_name, a.department_id, b.department_name  --부서명 컬럼
FROM employees a, departments b  
WHERE a.department_id = b.department_id;


-- 뷰 실헹
SELECT
    *
FROM emp_dept_v1;

--뷰 삭제

drop view emp_dept_v1;

--인덱스 
                           
                           --5/24 수업

--인덱스 
--create unique index ex2_10_ix01
--on ex2_10(col11);


--시노님(동의어) 생성, (채널 테이블으로 만듬.)
create or replace synonym syn_channe1
for channels;

SELECT COUNT(*)
    FROM syn_channe1;

--다른 계정으로 로그인하여참조 해보기

alter user hr IDENTIFIED by hr ACCOUNT UNLOCK;

--hr사용자로 로그인후 조회
--실행명령어는  grant 권한부여 후 동일 
--out_user 을 사용하여 접근해야함.

select COUNT(*)
from out_user.syn_channe1;

--오류 발생 시 grant 권한 부여

--grant select on syn_channel to hr;

--public 나노님 생성(생성후 조희시 out_user. 작성하지 않아도 된다.)

create or replace public synonym syn_channel2
for channels;

--조회 권한을 public에 전달

grant select on syn_channel2 to public;

--hr로 로그인 후 조회

select count(*)
from syn_channel2;

--synonym 삭제

drop synonym syn_channe1;

--public synonym 삭제
drop public synonym syn_channel2;

--시퀀스 생성

create SEQUENCE my_seq1  
increment by 1
start with 1
minvalue 1
maxvalue 1000
nocycle
nocache;

--기존 데이터 삭제
delete ex2_8; 
--삭세 후  my.seq1 데이터 삽입
insert into ex2_8 (col1) values (my_seq1.nextval);
insert into ex2_8 (col1)values (my_seq1.nextval);

select *
from ex2_8;

--시퀀스명.currval 현재 값 확인 
select my_seq1.currval
from dual;

--nextval (다음숫자로 넘길시)값 가져오기
insert into ex2_8 (col1)values (my_seq1.nextval);

select *
from ex2_8;

--SELECT 문을 사용하여 값 증가하기
select my_seq1.nextval
from dual;

insert into ex2_8 (col1)values (my_seq1.nextval);

select*
from ex2_8;

--시퀸스 삭제

drop sequence my_seq1;


--ex1)
-- 테이블 생성
--ORDER_ID 기본키
--ORDER_MODE ,ORDER_TOTAL 제약

CREATE TABLE ORDESR(
ORDER_ID number(12,0) PRIMARY KEY,
ORDER_DATE DATE,
ORDER_MODE VARCHAR2(8 BYTE)CONSTRAINT ck_ORDER1 check(ORDER_MODE in ('dirrct', 'online')),
CUSTOMER_ID NUMBER(6,0),
ORDER_STATUS NUMBER(2,0),
ORDER_TOTAL  NUMBER(8,2) Default 0,
SALES_REP_ID NUMBER(6,0),
PROMOTION_ID NUMBER(6,0)
);

--제약조건

drop table ORDESR;

--ex2
CREATE TABLE ORDER_ITEMS(
ORDER_ID NUMBER(12,0) ,
LINE_ITEM_ID NUMBER(3,0),
CONSTRAINT PK_ID PRIMARY KEY( ORDER_ID, LINE_ITEM_ID),
PRODUCT_ID NUMBER(3,0),
UNIT_PRICE NUMBER(8,2) DEFAULT 0,
QUANTITY NUMBER(8,0) DEFAULT 0
);

drop table ORDER_ITEMS;

--ex3)
CREATE TABLE PROMTIONS(
PROMO_ID NUMBER(6,0) PRIMARY KEY,
PROMO_NAME VARCHAR(20)
);
--ex4

--ex5
create SEQUENCE ORDERA_SEQ  
increment by 1
start with 1000
minvalue 1
maxvalue 99999999
nocycle
nocache;


---SELECT문
-- 원하는 정보를 조회

SELECT employee_id, emp_name
from  employees
where  salary> 5000
AND job_id = ' IT_PROG'
--사번으로 정렬
ORDER BY employee_id;
--조건을 통한 검색

--5/25 SQL 
--컬럼명 앞에 (a,b)는 별칭이다.
SELECT a.employee_id, a.emp_name,a.department_id, b.department_id
FROM employees a,  departments b
WHERE a.department_id = b.department_id;

--컬럼명에도 별칭을 붙일수 있으며, 원컬럼명 AS 컬럼별칭, AS 생략 가능
SELECT a.employee_id, a.emp_name,a.department_id, b.department_name AS dep_name
FROM employees a,  departments b
WHERE a.department_id = b.department_id;

--INSERT 데이터 신규 입력

CREATE TABlE ex3_1(
col1 VARCHAR(20),
col2 NUMBER,
col3 DATE);
--INSERT 데이터 신규 입력(컬럼 ,VALUES 순서 동일)
INSERT INTO ex3_1(col1,col2,col3)
VALUES('ABC',10,SYSDATE);

-- 컬럼 순서 상관 x valuse절의 값과 순서를 맟추면 상관 없다.
INSERT INTO ex3_1(col3,col1,col2)
VALUES(SYSDATE,'DEF',20);
--컬럼을 생략 후 입력 가능 단. 컬럼 순서와 동일해야함.전체 컬럼의 값을 입력해줘야함
INSERT INTO ex3_1
VALUES('GET',10,SYSDATE);

INSERT INTO ex3_1 (col1, col2)
VALUES ('GHI',30);

--입력할 컬럼의 값이 맞지않아 오류 발생
--INSERT INTO ex3_1
--VALUES ('GHQ',20);

CREATE TABLE ex3_2(
emp_id  NUMBER,
emp_name VARCHAR2(100)
);
--대소문자 구별,
INSERT INTO ex3_2( emp_id, emp_name)
SELECT employee_id, EMP_NAME
FROM employees
WHERE salary > 5000;

--묵시적 형변화
INSERT INTO ex3_1(col1,col2,col3)
VALUES(10,'10','2014-04-01');


--UPDATE문


-- 테이블 값 변경
UPDATE ex3_1
SET col2 = 50;

--널값을 찾아 SYSDATE 값으로 전환

UPDATE ex3_1
SET col3 =SYSDATE
WHERE col3 IS NULL;

--5/26일 수업
--MERGE문 
CREATE TABLE EX3_3(
    employee_id NUMBER,
    bonus_amt NUMBER DEFAULT 0);

DROP TABLE ex3_3;


INSERT INTO ex3_3(employee_id)
-- 같은 내용이 있는가
SELECT e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
--2000년 10,12월 달 매출을 달성한사원 번호 찾기(~사이에서)
AND s.sales_month BETWEEN '200010' AND '200012'
--중복 제거
GROUP BY e.employee_id;

--SELECT *
--FROM ex3_3
---- 순차적으로 정리
--ORDER BY employee_id;
--
----             
--SELECT employee_id, manager_id, salary, salary*0.01
---- ~에서 갖고오다.
--FROM employees
---- 
--WHERE employee_id IN (SELECT employee_id FROM ex3_3);
--
--SELECT employee_id, manager_id, salary, salary * 0.001
--FROM employees
--WHERE employee_Id NOT IN(SELECT employee_id FROM ex3_3)
--AND manager_id = 146;
--
---MERGE INTO ex3_3 d
---USING(SELECT employee_id, salary,manager_id
--            FROM employees
--            WHERE manager_id =146) b    
--            ON(d.employee_id = b.employee_id)
--WHEN MATCHED THEN
--UPDATE SET d.bonus_amt = d.bonus_amt + b.salary *0.01
--WHEN NOT MATCHED THEN
--INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary *0.001)
--WHERE (b.salary < 8000);
-- EX3_3 테이블 생성
CREATE TABLE EX3_3(
    employee_id NUMBER,
    bonus_amt NUMBER DEFAULT 0);
    
DROP TABLE EX3_3;
 
 -- 조회   
SELECT *
FROM EX3_3;

-- SALES 테이블에서 2000년 10월 ~ 200년 12월까지 매출을 달성한 사원번호 입력

INSERT INTO EX3_3 (employee_id)
SELECT e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
AND s.SALES_MONTH BETWEEN '200010' AND '200012'
-- 사원번호의 중복을 제거함
GROUP BY e.employee_id;

-- 조회
SELECT *
FROM EX3_3
ORDER BY employee_id;

-- 관리자 사번이 ex3_3 테이블에 있는 사원의 사번과 일치하면 1% 보너스
-- 일치 하지 않으면 급여의 0.1% 보너스 지급 (급여가 8000 미만인 사원만 해당)

-- 사번 , 관리자 사번, 급여, 급여 * 0.01 조회
SELECT employee_id, manager_id, salary,salary * 0.01
FROM employees
WHERE employee_id IN (SELECT employee_id FROM EX3_3);

-- 사원테이블에서 관리자 사번이 146 인 것 중 ex3_3 테이블에 없는 사원의 사번, 관리자 사번, 급여, 급여*0.001 조회
SELECT employee_id , manager_id, salary, salary * 0.001
FROM employees
WHERE employee_id NOT IN (SELECT employee_id FROM ex3_3)
AND manager_id = 146;

-- 병합하기
MERGE INTO ex3_3 d -- ex3_3 테이블을 d 로 정의
USING (SELECT employee_id, salary, manager_id
            FROM employees
            WHERE manager_id = 146) b -- 관리자 사번이 146
            ON (d.employee_id = b.employee_id) -- d , b 조건이 같을 때 업데이트
            
WHEN MATCHED THEN -- 조건이 맞다면
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 -- 1% 보너스 지급
    
WHEN NOT MATCHED THEN -- 조건이 틀리다면
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.001) -- 0.1 보너스 지급
    WHERE (b.salary < 8000); -- 급여가 8000 미만

-- 조회
SELECT *
    FROM ex3_3
    ORDER BY employee_id;
    
MERGE INTO ex3_3 d -- ex3_3 테이블을 d 로 정의
USING (SELECT employee_id, salary, manager_id
            FROM employees    --조회 테이블
            WHERE manager_id = 146) b -- 관리자 사번이 146
            ON (d.employee_id = b.employee_id) -- d , b 조건이 같을 때 업데이트
            
WHEN MATCHED THEN -- 조건이 맞다면
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 -- 1% 보너스 지급
    DELETE WHERE (B.employee_id = 161) -- 조건에 맞는 161 사원 삭제
    
WHEN NOT MATCHED THEN -- 조건이 틀리다면
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.001) -- 0.1 보너스 지급
    WHERE (b.salary < 8000); -- 급여가 8000 미만

-- 조회
SELECT *
    FROM ex3_3
    ORDER BY employee_id;

--DELETE 문
--테이블의 내용을 삭ㅈ[
DELETE ex3_3;

--삭제 된 행 확인
SELECT *
FROM ex3_3
ORDER BY employee_id;

--파티션 조회
SELECT partition_name
FROM user_tab_partitions
WHERE table_name='SALES';
--COMMIT, TRUNCATE  ROLLBACK
CREATE TABLE ex3_4(
employee_id     NUMBER);
INSERT INTO ex3_4 VALUES (20);

SELECT *
FROM ex3_4;

COMMIT;
ROLLBACK;

TRUNCATE TABLE ex3_4;

--의사컬럼

SELECT ROWNUM, employee_id --순서 값 나타내기
FROM employees
-- 조건 삽입하여 사용 가능
WHERE ROWNUM <= 5;

SELECT ROWNUM, employee_id , ROWID --순서 , 주소 값 나타내기
FROM employees
WHERE ROWNUM <5;

--연산자
--문자 연산자
--              id와        붙인 후  name을 붙인 후  세로운 칼럼을 만든다
SELECT employee_id || '-' || emp_name AS employee_info
-- employees 테이블로 부터 가져온다.
FROM employees
-- 순서가 5미만인것들만 출력 
WHERE ROWNUM < 5;

--표현식
--            두개의 컬럼을 사용한다
SELECT employee_id, salary,                                                                         
                CASE WHEN salary <=5000 THEN 'C등급'
--                             5000보다 다 그리고 15000보다 작거나 같다
                WHEN salary < 5000 AND salary <=15000 THEN 'B등급'
                ELSE 'A등급'  --나머지 값들을 A등급으로 표시
--                                칼럼 추가
                END AS  salary_grade
--                employees 테이블로 부터 가져온다
                 FROM employees;

--조건식

--ANY조건식
SELECT employee_id, salary
    FROM employees
--                           3가지 값중 일치하는것을 모든 사원 추출 
    WHERE salary= ANY (2000,3000,4000)
    ORDER BY employee_id;
    
--ANY 조건식 or사용 
SELECT employee_id, salary
    FROM employees
    WHERE salary =2000
    OR salary=3000
    OR salary=4000
    ORDER BY employee_id;
    
--ALL조건식(모든 조건이 동시에 만족해야함.)

SELECT employee_id, salary
    FROM employees
    WHERE salary = ALL(2000,3000,0400)
    ORDER BY employee_id;
    
--SOME 식별자 =ANY 와 동일한 작용
SELECT employee_id, salary
    FROM employees
    WHERE salary = SOME(2000,3000,4000 )
    ORDER BY employee_id;
    
--논리조건식(OR,NOT,AND)
--NOT 조건식
SELECT employee_id, salary
    FROM employees
--                        크거나 같지 않다.
    WHERE NOT (salary >=3000) 
    ORDER BY employee_id;

-- NULL 조건식

SELECT employee_id,salary
FROM employees
WHERE (salary IS NOT NULL)
ORDER BY employee_id;

--BETWEEN ~       사이에서           AND  범위에 해당하는 값을 찾는거 
--어디서부터 어디까지        그리고
SELECT employee_id, salary
FROM employees
WHERE salary BETWEEN 5000 AND 6000
ORDER BY employee_id;

--IN 조건식 명시한 값이 포함된 것을 반환 하는것 ANY 와 비슷
--NOT IN 명시한 값을 제외한 나머지 값을 반환하는것 
SELECT employee_id, salary
FROM employees
WHERE salary NOT IN (2000,3000,4000)
ORDER BY employee_id;

EXISTS 조건식 동일한 컬럼 부분이 있어야 출력이 된다. (SOME조건식과 비슷)

SELECT department_id ,department_name
FROM departments a
WHERE EXISTS(SELECT * FROM employees b
WHERE a.department_id = b.department_id
AND b.salary >3000)
ORDER BY a.department_name;

--LIKE 문자열 패턴 검색할떄 사용

SELECT emp_name
FROM employees
--A로 시작하는 사원을 조회  (%나머지는 어떤 글자와도 상관없다,)
WHERE  emp_name LIKE 'A%'
ORDER BY emp_name;

SELECT emp_name
FROM employees
--                  대소문자구별 유의!
    WHERE  emp_name LIKE 'Al%'
ORDER BY emp_name;

CREATE TABLE ex3_5
(
names VARCHAR2(20));

INSERT INTO ex3_5 VALUES ('홍길동');
INSERT INTO ex3_5 VALUES ('홍길용');

INSERT INTO ex3_5 VALUES ('홍길상동');

SELECT*
FROM ex3_5
WHERE names LIKE '홍길_';

--ex1
CREATE TABLE ex3_6(
employee_id  NUMBER,
 emp_name  VARCHAR(100),
 salary   NUMBER,
 manager_id   NUMBER
);


INSERT INTO EX3_6( employee_id, emp_name,salary, manager_id)
SELECT employee_id, emp_name,salary, manager_id
FROM employees
WHERE  manager_id =124
AND salary BETWEEN 2000 AND 3000;

SELECT
*
FROM ex3_6;

2)
DELETE ex3_6;

MERGE INTO ex3_3 d
USING (SELECT employee_id, salary, manager_id
            FROM employees    
            WHERE manager_id = 145) b
            ON (d.employee_id = b.employee_id) 
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 
WHEN NOT MATCHED THEN 
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.005) ;
    

SELECT
    *
FROM ex3_3;