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
