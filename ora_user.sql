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
    
3)
SELECT employee_id ,emp_name
FROM employees 
WHERE commission_pct IS NULL
ORDER BY employee_id;

4)
SELECT employee_id, emp_name,salary, manager_id
FROM employees
WHERE  salary >=2000 and salary <= 2500
ORDER BY employee_id;

--5) p123

---5/27 수업
--함수

--숫자함수
-- ABS() - 절대값 반환 함수
SELECT ABS(10), ABS(-10), ABS(-10.234)
FROM DUAL;
-- CEIL(N) - n과 같거나 가장 큰 정수 반환
SELECT  CEIL(10.123), CEIL(10.541), CEIL(11.001)
FROM DUAL;
-- FLOOR(n) - n보다 작거나 가장 작은 정수 반환
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.001)
FROM DUAL;
-- ROUND( n , i) - n을 소수점 기준(n+1)번째에서 반올림한 결과 반환9 ( 소수점 두번째까지 보여준다)
SELECT ROUND(10.123), ROUND(10.541), ROUND(11.001)
FROM DUAL;
SELECT ROUND(10.123,1), ROUND(10.541,2), ROUND(10.541,3)
FROM DUAL;
SELECT ROUND(0,3) , ROUND(115.155,-1), ROUND(115.155, -2)
FROM DUAL;
--TRUNC(n1,n2) - n1을 소수점 기준 n2자리에서 무조건 잘라낸 결과 반환 
SELECT TRUNC(115.155), TRUNC(115.155,1), TRUNC(115.155,2), TRUNC(115.155,-2)
FROM DUAL;

--POWER(n2,n1) - n2를 n1 제곱한 결과를 반환 n2가 음수이면 n1은 반드시 정수
SELECT POWER(3,2), POWER(3,3), POWER(3,3.0001)
FROM DUAL;

--SQRT(n)- n의 제곱근 반환
SELECT SQRT(2), SQRT(5)
FROM DUAL;

--MOD(n2, n1) - n2를 n1으로 나눈 남너지 값을 반환
SELECT MOD(19,4), MOD(19.123, 4.2)
FROM DUAL;

SELECT REMAINDER(19,4),  REMAINDER(19.123, 4.2)
FROM DUAL;

SELECT EXP(2), LN(2.713), LOG(10,100)
FROM DUAL;

-- 문자함수
INITCAP -char의 첫 문자를 대문자로 변경 인식 기준 공백
SELECT INITCAP('naver say goodbay')
FROM DUAL;

LOWER - 소문자 변환
SELECT LOWER('NAVER SAY GOODBEY')
FROM DAUL;

UPPER - 대문자 변환 후 반환
SELECT UPPER('say goodbye')
FROM DAUL;

CONCAT- 두문자를 연결
SELECT CONCAT('I HAVE' , 'good boy') , 'I HAVE ' | | 'Good boy'
FROM DUAL;

SUBSTR (CHAR, POS, len)-  len길이만큼 잘라낸 결과
SELECT SUBSTR ('ABCDEF' 1,4),  SUBSTR('ABCDEFG' ,-1,4)
FROM DUAL;

SUBSTRB (CHAR, POS, len)-  바이트 수 단위로 반환
SELECT SUBSTRB ('ABCDEF' 1,4) , SUBSTRB('가나다라마바사' ,-1,4)
FROM DUAL;


LTRIM(CHAR,SET) - char 에서 set으로 지정된 문자열을 왼쪽끝에서 제거 후 나머지 문자여 
RTRIM(CHAR,SET)- LTRIM 과 반대로 오른쪽 끝에서 제거 후 나머지 문자열 반환
SELECT LTRIM('ABCDEFG', 'ABC'),
        LTRIM('가나다라','가'),
        RTRIM('ABCDEFG', 'ABC'),
        RTRIM ('가나다라','라')
FROM DUAL;

LAPD(expr1,expr2) - 뒷 문자열을 n자리 만큼 왼쪽부터 채워서 반환

CREATE TABLE ex4_1(
phone_num VARCHAR2(30)
);
INSERT INTO ex4_1 VALUES('111-3333');
--                                    12는 총자리수를 의미한다.
SELECT LPAD(phone_num , 12,'(02)')
FROM ex4_1;

RPAD  -LAPD 반대 오른쪽
SELECT RPAD(phone_num , 12,'(02)')
FROM ex4_1;

REPLACE- char에서 변환
SELECT REPLACE('나는 너를', '나', '너')
FROM DUAL;

TRANSLATE - 한글자씩 바꾼 결과
SELECT REPLACE('나는 너를', '나는', '너를') AS rep,
        TRANSLATE('나는 너를' ,'나는', '너를' ) AS trn
FROM DUAL;


--INSTR- 
SELECT INSTR('내가 만약 외로울 떄면,내가 만약 외로울 떄면,내가 만약 외로울 떄면','만약') AS INSTR1,
INSTR('내가 만약 외로울 떄면, 내가 만약 외로울 떄면, 내가 만약 외로울 떄면'  ,'만약',5) AS INSTR2,
INSTR('내가 만약 외로울 떄면, 내가 만약 외로울 떄면, 내가 만약 외로울 떄면' , '만약',5,2) AS INSTR3
FROM DUAL;


LENGTH - 길이반환
LENGTHB -문자열 BYTE수 반환

날짜 함수
--SYSDATE,                    SYSTIMESTAMP
--현재 일자와 시간 타입     일자 및 시간 및 초 
SELECT SYSDATE, SYSTIMESTAMP
FROM DUAL;

--ADD_MONTH0S 월을 더한 값 ,마이너스한 값
SELECT ADD_MONTHS(SYSDATE, 1) , ADD_MONTHS(SYSDATE , -1)
FROM DUAL;

--MONTHS_BETWEEN
--두 날짜 사이의 개왈 수 반환
SELECT MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE,1)) mon1,
        MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1),SYSDATE) mon2
FROM DUAL;

--LAST_DAY  해당월 의 마지막 일자 반환
SELECT LAST_DAY(TO_DATE(20240202))
FROM DUAL;

ROUND-반올림한 날짜
TRUNC - 잘라낸 날짜 반환

SELECT SYSDATE, ROUND(SYSDATE, 'month'), TRUNC(SYSDATE,'month')
FROM DUAL;

NEXT_DAY 명시한 날짜로 다음주 주중 일자를 반환
SELECT NEXT_DAY(SYSDATE, '금요일')
FROM DUAL;

--변환 함수

TO_CHAR (숫자 혹은 날짜) FORMAT 에 맞게 변환 후결과반환
SELECT TO_CHAR(123456789, '000,000,000')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YY-MM-DD-DL')
FROM DUAL;

TO_NUMBER -문자나 다른 유형의 숫자를 number 형으로 변환
SELECT TO_NUMBER('12345678')
FROM  dual;

TO_DATE -날짜형으로 변환
SELECT TO_DATE('20210527', 'YYYY-MM-DD')
FROM DUAL;
SELECT TO_DATE('2014010113:44:50', 'YYYY-MM-DDHH24:MI:SS')
FROM DUAL;

TO_TIMESTAMP -TIMESTAMP 형으로 변환
SELECT TO_TIMESTAMP('2014010113:44:50', 'YYYY-MM-DDHH24:MI:SS')
FROM DUAL;

NULL 함수
NVL expr1이 null일때 expr2를반환
SELECT NVL(manager_id, employee_id)
FROM employees
WHERE manager_id IS NULL;

NVL2  expr1이 null이 아니면 expr2, NULL이면 expr3 반환
SELECT employee_id,
        NVL2(commission_pct, salary +(salary *commission_pct), salary) AS salary2
--커미션이  nuLL인 사원 그냥 급여를       null이 아니면                        컬럼에 표시
FROM employees;

--COALESCE- null이 아닌 첫번쨰 표현식을 반환,
SELECT employee_id, salary, commission_pct,
            COALESCE ( salary * commission_pct, salary) AS salary2
FROM employees;

--GREATEST-표현식에서 가장 큰 값을 반환

LEAST- 표현식에서 가장 작은 값 반환




--1
CREATE TABLE PRODUCT(
PRODUCT_ID    NUMBER(12,0)  PRIMARY KEY,
PRODUCT_NAME   VARCHAR2(8 BYTE),
QUANTITY   NUMBER(10,0) DEFAULT 0,
ORDER_DATE DATE,
ORDER_MODE   VARCHAR2(8 BYTE)
CONSTRAINT ORDER1 check (ORDER_MODE in ('dirrct', 'online')),
DESCRIPTION   VARCHAR2(20 BYTE),
STANDARD_COST  NUMBER(4,0),
LIST_PRICE   NUMBER(8,2) DEFAULT 0,
CATEGORY_ID   NUMBER(6,0),
PROMOTION_ID   NUMBER(6,0)
);
DROP TABLE PRODUCT;

DROP TABLE EXAM2_2;;

CREATE TABLE EXAM2_1(
employee_id  NUMBER(6),
emp_name  VARCHAR2(80),
salary  NUMBER(8,2),
manager_id NUMBER(6)
);

INSERT INTO EXAM2_1
SELECT employee_id, emp_name, salary,  manager_id
FROM employees
WHERE manager_id = '147' AND salary BETWEEN '6000' AND '7000'
ORDER BY employee_id;

SELECT *
FROM exam2_1;
DELETE TABLE  EXAM2_1;

CREATE TABLE exam2_2 (
employee_id  NUMBER,
bonus_amt   NUMBER DEFAULT 0
);

SELECT  employee_id, emp_name
FROM employees
WHERE department_id IS  NULL
ORDER BY employee_Id;

SELECT employee_id,salary
FROM employees
WHERE salary >=  4500 AND salary <= 5000
ORDER BY employee_id;

INSERT INTO exam2_2(employee_id)
SELECT b.employee_id
FROM employees b , sales s
WHERE b.employee_id = s.employee_id
AND s.SALES_MONTH BETWEEN '200010' AND '200013'
GROUP BY b.employee_id;

SELECT
    *
FROM exam2_2;

MERGE INTO exam2_2 d
USING (SELECT employee_id,salary,manager_id
            FROM employees
            WHERE manager_id = 146) b
            ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.05
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt )  VALUES (b.employee_id, b.salary * 0.02);
    
SELECT
    *
FROM exam2_2;

COMMIT; 

--5/27일 수업  
--
--GREATEST 큰 값을 나타내는것 
--LEAST 가장 작은값 
SELECT GREATEST(1,2,3,2),
            LEAST(1,2,3,2)
FROM DUAL;

SELECT prod_id ,  DECODE(channel_id,  3, 'Direct', 
                                                        9, 'Direct',
                                                        5,'Indirect',
                                                        4, 'Indirect',
                                                        'Others')  decodes
FROM sales -- 무작위 추출
WHERE rownum < 10;

--ex1
SELECT phone_number,LPAD( SUBSTR(phone_number, 4) ,13, '(02)' )
FROM employees;

-- 2

SELECT employee_id 사원번호, emp_name 사원명, HIRE_DATE 입사일자, ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) 근속년수
FROM employees
WHERE  ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12)>= 10
ORDER BY ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12);

-- 3

SELECT REPLACE(cust_main_phone_number, '-' , '/')
FROM CUSTOMERS;

-- 4

SELECT TRANSLATE(cust_main_phone_number, '0123456789', 'ABCDEFGHIJ')
FROM CUSTOMERS;

--ex5

SELECT cust_name, cust_year_of_birth,
DECODE(TRUNC(( TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth ) /10)  , 3, '30',
                                                                                        4,'40대',
                                                                                        5, '50' , 
                                                                                        '기타'  ) generation
FROM customers;

SELECT TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth year,
            CASE  WHEN TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth <= 30 THEN  '20'
              WHEN TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth <= 40 THEN  '30'
              WHEN TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth <= 50 THEN  '40'
              WHEN TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth <= 60 THEN  '50'
              WHEN TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth <= 70 THEN  '60'
              WHEN TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth <= 80 THEN  '70'
              WHEN TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth <= 90 THEN  '80'
              WHEN TO_CHAR(SYSDATE, 'YYYY') -cust_year_of_birth <= 100 THEN  '90'
            END AS  NewYear
FROM customers;


--6/1일 ORACLE 수업

SELECT cust_name ,TRANSLATE(cust_main_phone_number,  '0123456789', 'ABCDEFGHIJ') new_phone_number
FROM CUSTOMERS
ORDER By cust_name;

SELECT  cust_main_phone_number
FROM CUSTOMERS;

--암호화
--CREATE TABLE (
--name byte,
--NUM_)
--저장할 컬럼INSERT INTO 해당 테이블 (컬럼)
--SELECT  들어갈 컬럼의 해달 컬럼
--FROM 셀렉트에 들어간 커럼 해당 테이블


commit;

SELECT TO_CHAR(hire_date, 'YYYY') ,COUNT(*) 사원수
FROM employees
GROUP BY TO_CHAR(hire_date,'YYYY');

--조인 테이블 간의 관계를 맺는 방법
--내부조인 

--동등조인 
--
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
FROM employees a, departments b
-- a.department_id = b.department_id 아이디가 같은 컬럼을 조회 
WHERE a.department_id = b.department_id;

--세미조인 서브쿼리에 존재하는 데이터만 메인 쿼리에서 추출 
--exists 하나라도 만족하는 값이 있으면 참 
-- 서브쿼리의 테이블에서 연봉이 3000만원 이상인 부서가 있으면 반환
--SELECT 로 나눠서 실습 하면 이해에 도움.
SELECT a.department_id, department_name
FROM departments a
WHERE  exists ( SELECT * FROM employees b
                        WHERE a.department_id = b.department_id
                        AND b.salary > 3000)
ORDER BY a.department_id;
--세미코인 IN
SELECT a.department_id, department_name
FROM departments a
WHERE a.department_id IN (
                                SELECT b.department_id 
                                FROM employees b 
                                WHERE  b.salary > 3000)
ORDER BY a.department_id;

commit;

--6/1일 시험

--1번
SELECT replace(LPAD(SUBSTR(phone_number, 4,12), 14, '(031)') ,  '.', '-')
FROM employees;

--2번
SELECT employee_id 사번, emp_name 이름 ,ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) 근속년수
FROM employees
WHERE  ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12)>= 22
ORDER BY ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12);

-- 3번 
SELECT cust_main_phone_number "기존 전화번호", TRANSLATE(cust_main_phone_number,'1234567890','ABCDEFGHIJ') new_phone_number
FROM CUSTOMERS
ORDER BY cust_name;

--4번
CREATE TABLE exam3(
name   VARCHAR2(100),
new_phone_number   VARCHAR2(25)
);


--5번
INSERT INTO exam3 ( name, new_phone_number)
SELECT cust_name ,TRANSLATE(cust_main_phone_number, '0123456789' ,'ABCDEFGHIJ')
FROM CUSTOMERS;


--6번
SELECT name ,TRANSLATE(new_phone_number,   'ABCDEFGHIJ', '0123456789') new_phone_numbe
FROM exam3;

--7번
SELECT 년생,
CASE WHEN 년생  BETWEEN 1950 AND 1959 THEN '1950년'
         WHEN 년생 BETWEEN 1960 AND 1969 THEN '1960년'
          WHEN 년생  BETWEEN 1970 AND 1979 THEN '1970년'
          WHEN 년생  BETWEEN 1980 AND 1989 THEN '1980년'
          WHEN 년생  BETWEEN 1990 AND 1999 THEN '1990년'
          ELSE '기타 '
          END AS 출생년도
FROM(SELECT cust_year_of_birth AS 년생 FROM customers)
ORDER BY 1 desc;

--8번
SELECT TO_CHAR(hire_date,'MM') 월별, COUNT(*) 인원수
FROM employees
GROUP BY TO_CHAR(hire_date,'MM');


--9번
SELECT region, SUM(loan_jan_amt) 금액
FROM kor_loan_status
WHERE period LIKE '2011%'
GROUP BY region
ORDER BY SUM(loan_jan_amt) dese;

-- 6/2일 SQL
--안티조인 세미조인 반대 서브쿼리에 없는 데이터 추출
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
FROM employees a,  departments b
WHERE a.department_id =b.department_id
--                                   서브쿼리                                                           
AND a.department_id NOT IN( SELECT department_id 
                                    FROM departments 
                                    WHERE manager_id IS NULL);
                                    
SELECT COUNT(*)
FROM  employees a 
WHERE NOT EXISTS(SELECT 1 
                            FROM departments c
                            WHERE a.department_id = c.department_id
                            AND manager_id IS NULL);
--셀프조인 서로다른 두 테이블이 아닌 동일한 한 테이블을 사용하여 조인
SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
FROM employees a ,employees b
WHERE a.employee_id  >  b.employee_id
AND a.department_id = b.department_id
AND a.department_id =20;

--외부조인 (+)모든 데이터를 보여준다.조인데이터에 컬럼이 없는 데이터에 붙인다.
SELECT a.department_id, a.department_name, b.job_id,b.department_id
FROM departments a, job_history  b
WHERE a.department_id = b.department_id(+);

SELECT a.employee_id, a.emp_name, b.job_id,b.department_id
FROM employees a, job_history  b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);

--카타시안 조인 조인 조건이 없는 조인
SELECT a.employee_id, a.emp_name , b.department_id , b.department_name
FROM employees a, departments b;

--ANSI 조인 내부조인의 경우 FROM 절애 INNER JOIN을 명시 조인 조건은 ON절 명시

SELECT  a.employee_id, a.emp_name ,b.department_id, b.department_name, a.hire_date
FROM employees a --비교 테이블1
INNER JOIN  departments b --비교테이블 2
ON  (a.department_id =b.department_id) --비교 조건
WHERE a.hire_date >=TO_DATE('2003-01-01', 'YYYY-MM-DD'); -- 그밖에 조건 
