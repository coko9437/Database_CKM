-- 중복 되지 않는 값 UNIQUE 제약조건

-- 기본문법
-- 테이블 생성시 제약 조건 추가
-- CREATE TABLE 테이블명 ()

-- 추가방법1)
-- EMAIL VARCHAR2(50) CONSTRAINT email_unique UNIQUE 
                    -- CONSTRAINT : 제약조건명 제약조건 종류

-- 추가방법1-2) 이름을 자동으로 생성 ==> 예시)
-- EMAIL VARCHAR2(50) UNIQUE


-- 추가방법2) 테이블 생성 후 제약조건만 따로 추가
-- ALTER TABLE 테이블명 ADD CONTSTRAINT 제약조건명 제약조건종류 (컬럼명);
ALTER TABLE TABLE_UNIQUE ADD CONSTRAINT email_unique2 UNIQUE (EMAIL);

CREATE TABLE TABLE_UNIQUE (
    ID NUMBER(5) PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,

    EMAIL VARCHAR2(50) CONSTRAINT email_unique UNIQUE
    -- 방법1) 수동으로 제약조건 이름을 만들어서 직접 추가
);

-- 제약조건 확인
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'TABLE_UNIQUE';

-- 시퀀스 생성 후  샘플데이터 추가시 자동번호 생성이용하기
CREATE SEQUENCE TABLE_UNIQUE_SEQ
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 99999
    NOCYCLE;

-- 시퀀스 생성 확인
SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'TABLE_UNIQUE_SEQ';

-- 샘플 데이터추가
INSERT INTO TABLE_UNIQUE(ID, NAME, EMAIL) 
    VALUES(TABLE_UNIQUE_SEQ.NEXTVAL, '홍길동', 'HONG@NAVER.COM');

    -- 데이터 조회
    SELECT * FROM TABLE_UNIQUE;

-- 데이터 중복 방지확인 ==> 이메일이 같은지 로 확인
INSERT INTO TABLE_UNIQUE(ID, NAME, EMAIL) 
    VALUES(TABLE_UNIQUE_SEQ.NEXTVAL, '홍길동2', 'HONG@NAVER.COM');  -- 이메일중복됨.
INSERT INTO TABLE_UNIQUE(ID, NAME, EMAIL) 
    VALUES(TABLE_UNIQUE_SEQ.NEXTVAL, '홍길동2', 'HONG2@NAVER.COM'); -- 이메일 다름

-- 제약조건 삭제
-- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE TABLE_UNIQUE DROP CONSTRAINT email_unique;

-- 퀴즈1) 테이블생성시 UNIQUE 지정해보기 (방법 1,2,3)
    -- 테이블명 : USER_TABLE, 컬럼: USER_ID에 유니크 설정
CREATE TABLE USER_TABLE (
    ID NUMBER(5) PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    -- 방법 1) -- 수동으로 제약조건 이름을 만들어서 직접 추가
    EMAIL VARCHAR2(50) CONSTRAINT email_unique_mini UNIQUE
    -- 방법 2)    
    --EMAIL2 VARCHAR2(50) UNIQUE -- 시스템이 자동으로 설정
    --EMAIL3 VARCHAR2(50)
);
-- 방법3)
ALTER TABLE USER_TABLE ADD CONSTRAINT EMAIL UNIQUE(EMAIL3);
DROP TABLE USER_TABLE3;
SELECT * FROM USER_TABLE;
-- 퀴즈2) 테이블 생성 후 제약조건 추가
    -- 테이블명 : USER_TABLE2, 컬럼, USER_ID에 유니크 설정

create table user_table2(
    ID NUMBER(5) PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    user_id varchar2(50) not null
);
alter table user_table2 add constraint email_unique_1 unique (user_id);
-- 제약조건확인
select * from user_constraints where table_name = 'user_table2';

-- 퀴즈3) USER_TABLE2 시퀀스 생성 후 자동 번호 생성기를 이용해서 데이터 입력
CREATE SEQUENCE USER_TABLE2_SEQ
START WITH 1
INCREMENT BY 1  
MAXVALUE 99999
NOCYCLE;
-- 시퀀스 생성 확인
SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'USER_TABLE2_SEQ';
-- 샘플 데이터 추가
INSERT INTO user_table2(ID, NAME, USER_ID) VALUES(
    USER_TABLE2_SEQ.NEXTVAL, '홍길동', 'HONG');
-- 데이터 조회
SELECT * FROM user_table2;
-- 샘플 데이터 추가
INSERT INTO user_table2(ID, NAME, USER_ID) VALUES(
    USER_TABLE2_SEQ.NEXTVAL, '홍길동2', 'HONG2');

-- //////////////////////////////////////////////////////////////////////////
-- primary key 제약조건을 가진 테이블 생성

-- 방법1) 테이블 생성시 기본으로 이름 지정안하고 만들기
CREATE TABLE user_table(
    ID NUMBER(5) PRIMARY KEY, --방법1
    NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(20) CONSTRAINT user_id_unique UNIQUE
);

-- 방법2) 테이블 생성시 제약조건 이름을 설정해서 만들기
CREATE TABLE user_table(
    ID NUMBER(5) CONSTRAINT user_table_pk PRIMARY KEY, -- 방법2
    NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(20) CONSTRAINT user_id_unique UNIQUE
);

-- 방법3) 테이블 생성 후 제약조건을 추가해서 만들기
CREATE TABLE user_table(
    ID NUMBER(5) ,
    NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(20) CONSTRAINT user_id_unique UNIQUE
);
ALTER TABLE user_table ADD CONSTRAINT user_table_pk PRIMARY KEY(ID);
----------

DROP TABLE user_table;

-- 제약조건 확인 , 데이터 사전
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'USER_TABLE';

--PK 생성 시 , 자동으로 인덱스 설정함, 인덱스 확인 , 데이터 사전 
SELECT * FROM USER_INDEXES WHERE TABLE_NAME = 'USER_TABLE';

-- PK 제약조건 삭제 
ALTER TABLE user_table DROP CONSTRAINT user_table_pk;

-- 샘플 데이터 추가, 중복 방지 확인
INSERT INTO user_table(ID, NAME, USER_ID) VALUES(1, '홍길동', 'HONG');
INSERT INTO user_table(ID, NAME, USER_ID) VALUES(1, '이순신', 'LEE');

-- 샘플 데이터 추가, NULL 방지 확인
INSERT INTO user_table(ID, NAME, USER_ID) VALUES(NULL, '강감찬', 'KANG');

-- 퀴즈1, 
-- 테이블 생성 시 PRIMARY 지정 해보기, 방법 1, 2,3 
-- 테이블명 :  user_primary, 컬럼, user_id에 PRIMARY 설정 
CREATE TABLE user_primary(
    ID NUMBER(5) not null,
    NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(20) primary key -- 방법1
);
drop table user_primary;

CREATE TABLE user_table(
    ID NUMBER(5) not null,
    NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(20) CONSTRAINT user_id_pk primary key --방법2
);
drop table user_primary;

create table user_primary(
    ID NUMBER(5) not null,
    NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(20)
);
alter table user_primary add constraint user_id_pk primary key(USER_ID); --방법3
drop table user_primary;
    -- 제약조건 확인
    SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'user_primary';

-- 퀴즈2, ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- 테이블 생성 후, 제약 조건 추가 , 
-- 테이블명 :  user_primay2, 컬럼, user_id에 PRIMARY 설정 
 create table user_primary2(
    id number(5),
    name varchar2(50) not null,
    user_id varchar2(50) not null
 ); 
alter table user_primary2 add constraint user_primary2_pk primary key(id);
    -- 제약조건 확인
    SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'user_primary';

-- 퀴즈3, ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- user_primay2 , 데이터 입력 . 
-- 중복 , null 테스트도 해보기. 

insert into user_primary2(id, name, user_id) 
    values(1, '홍길동', 'hong');
    insert into user_primary2(id, name, user_id) 
        values(1, '김철수', 'kim');
        insert into user_primary2(id, name, user_id) 
            values(2, '홍길동', 'hong');
    
    -- 제약조건 확인
    SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'user_primary2';

select * from user_primary2;

-- 복합키, : 
-- 2개이상의 컬럼을 묶어서, 하나의 키로 사용
-- 하나의 테이블에 pk 보통 하나인 경우가 많아요. 
-- 
-- 기본 문법 
-- 방법1) 테이블 생성시
-- ```sql
-- CREATE TABLE 주문상세 (
--   주문번호     VARCHAR2(10),
--   상품번호     VARCHAR2(10),
--   수량         NUMBER,
--   CONSTRAINT pk_주문상세 PRIMARY KEY (주문번호, 상품번호)
-- );
-- ```
-- 예시 
-- 주문번호,   상품번호,       수량 
-- 1,          1001(청바지),    2
-- 1,          1002(반팔티),    1
-- 1,          1001(청바지),    2 -- 중복 발생하면 안됨. 

-- * `주문번호 + 상품번호` 조합이 **유일하게** 행을 식별
-- * `수량`은 기본키와 무관한 일반 컬럼

-- 테이블 생성 후, 방법2 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- ALTER TABLE 주문상세
-- ADD CONSTRAINT pk_주문상세 PRIMARY KEY (주문번호, 상품번호);


--예시 
-- 학생 수강 정보 테이블
-- | 학번   | 과목코드 | 성적 |
-- | ----   | ----     | -- |
-- | 1001   | C001     | A  |
-- | 1001   | C002     | B+ |
-- | 1002   | C001     | B  | -- 중복 발생하면 안됨

-- | 학번   | 과목코드  -> 복합키 로 사용함. 

-- CREATE TABLE 학생수강정보 (
--   학번      VARCHAR2(10),
--   과목코드  VARCHAR2(10),
--   성적      CHAR(2),
--   CONSTRAINT pk_학생수강 PRIMARY KEY (학번, 과목코드)
-- );

-- 필요한 상황 
-- 1) 주문번호 + 상품번호 : 주문 내 상품 항목 식별 
-- 2) 학생 + 과목코드 : 학생의 특정 과목 수강 정보 식별
-- 3) 도서id + 저자 id : 다대다 관계 테이블에서 많이 사용.
-- //////////////////////////////////////

-- 다른 테이블과 관계를 맺는 foreign key 제약조건
-- 기본 문법

--방법1)
create table dept_fk ( -- 부모테이블 : 1
    deptno number primary key, -- 기본키(부모)
    dname varchar2(20),
    loc varchar2(20)
);
drop table dept_fk;
-- 테이블 삭제시 순서) 자식 테이블 먼저 삭제한 후 부모테이블 삭제
create table emp_fk ( -- 자식테이블 : N
    empno number primary key, -- 기본키(자식)
    ename varchar2(20),
    deptno number,
    -- constraint 제약조건_이름 foreign key(현재 테이블 컬럼명: deptno) 
        -- references (부모테이블 dept_fk) <-- 부모테이블의 컬럼명 : deptno 
    constraint fk_dept foreign key (deptno)
         references dept_fk(deptno)
);
drop table emp_fk;
-- 결론) 외래키 설정은 자식 테이블에서 한다.
-- 제약조건 확인
select * from user_constraints where table_name = 'EMP_FK';

-- 제약조건 위배되는상황
    -- 1) emp_fk 테이블에 데이터를 추가시, 부서 번호가 없는번호를 입력하면 오류남.
        --샘플데이터 추가
        insert into dept_fk values(10, '인사부', '서울');
        insert into dept_fk values(20, '개발부', '판교');
        select * from dept_fk;
            insert into emp_fk values(100, '홍길동', 10); -- 정상
            insert into emp_fk values(101, '이순신', 20); 
            insert into emp_fk values(200, '강감찬', 30); -- 오류발생: 30번부서없음.
            insert into emp_fk values(201, '강감찬', null); -- NULL은 허용됨


-- 자식 테이블에 외래키 설정시 부모데이터가 삭제되면 같이 삭제되는옵션(CASCADE)설정 확인
delete from dept_fk where deptno = 10; --CASCADE 설정 안하고 삭제// 오류남.

-- 기존 자식 테이블에서 외래키 삭제 후 , CASCADE 설정 추가해서 제약조건 다시설정.
alter table emp_fk drop constraint fk_dept; -- 기존 외래키 제약조건 삭제

-- CASCADE 설정 추가
alter table emp_fk add constraint fk_dept foreign key (deptno)
    references dept_fk(deptno) ON DELETE CASCADE;

    -- 다시 삭제 테스트 (CASCADE 설정됨)
    delete from dept_fk where deptno = 10; -- 정상적으로 삭제됨

-- 퀴즈1)부모테이블 : DEPT_FK2 /// 컬럼 : deptno number primary key, dname varchar2(20)
        -- 자식테이블 : EMP_FK2 /// 컬럼 : empno, ename, deptno || 제약조건명 : fk_dept2



-- 퀴즈2) 제약조건 위반확인 ---> 부모테이블 먼저 삭제시도, 오류 확인
                    -- 추가시, 부모테이블이 없는 데이터 추가시 오류확인


-- 퀴즈3) ON DELETE CASCADE 설정후 재시도

-- //////////////////////////////////////////////////////////////////
-- 데이터 형태/범위를 정하는 CHECK 제약조건

-- 방법1, 테이블 생성시 제약 조건 추가 
create table EMP_CHECK (
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(20) NOT NULL,
    JOB VARCHAR2(9),
    MGR NUMBER(4),
    HIREDATE DATE default sysdate,
    SAL NUMBER(7,2) CHECK (SAL >= 0), -- 급여는 0이상
    COMM NUMBER(7,2) CHECK (COMM >=0 OR COMM IS NULL),
    DEPTNO NUMBER(2) CHECK (DEPTNO IN (10, 20, 30, 40)) -- 부서번호는 10,20,30,40 중 하나
);

-- 방법2, 테이블 생성 후 ALTER TABLE 명령어로 제약 조건 추가
ALTER TABLE EMP_CHECK ADD CONSTRAINT EMP_SAL_CHECK CHECK (SAL >= 0);
ALTER TABLE EMP_CHECK ADD CONSTRAINT EMP_SAL_CHECK CHECK (COMM >= 0);
ALTER TABLE EMP_CHECK ADD CONSTRAINT EMP_SAL_CHECK CHECK (DEPTNO IN (10, 20, 30, 40));
-- 제약 조건 조회 
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMP_CHECK';
-- 제약 조건 삭제 
ALTER TABLE EMP_CHECK DROP CONSTRAINT EMP_SAL_CHECK;

-- 샘플 데이터 삽입, 제약 조건 위배 확인
INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, DEPTNO) VALUES (1, '홍길동', 'CLERK', 1000, 10); -- 정상
INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, DEPTNO) VALUES (2, '홍길동', 'CLERK', 1000, 50); -- 부서번호 50번이 없음.
INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, DEPTNO) VALUES (1, '홍길동', 'CLERK', -100, 40); -- 급여가 음수라서.


SELECT * FROM EMP_CHECK;
DROP TABLE EMP_CHECK;
-- 퀴즈1) 테이블명 : EMP_CHECK// SAL이 0이상 10000이하 경우에만 입력 허용
CREATE TABLE EMP_CHECK(
    EMPNO NUMBER(5) PRIMARY KEY,
    ENAME VARCHAR2(20) NOT NULL,
    JOB VARCHAR2(10),
    MGR NUMBER(5),
    HIREDATE DATE default sysdate,
    SAL NUMBER(8,2),
    COMM NUMBER(7,2),
    DEPTNO NUMBER(2)
);
ALTER TABLE EMP_CHECK ADD CONSTRAINT EMP_SAL_CHECK CHECK (SAL BETWEEN 0 AND 10000);

-- 퀴즈2) 테이블명 : EMP_CHECK// 직무(JOB) : 'MANAGER', 'CLERK', 'ANALYST', 
        -- 현재 직무 외에는 입력 불가
ALTER TABLE EMP_CHECK ADD CONSTRAINT EMP_SAL_CHECK CHECK (JOB IN('MANAGER', 'CLERK', 'ANALYST'));

-- 퀴즈3) 테이블명 : EMP_CHECK// COMM : NOT NULL 및 0이상인 조건만 허용
ALTER TABLE EMP_CHECK ADD CONSTRAINT EMP_COMM_CHECK CHECK (COMM >=0 AND COMM IS NOT NULL);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMP_CHECK';

INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, COMM) VALUES (1, '가', 'CLERK', 1000, 0);
INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, COMM) VALUES (2, '나', 'PRESIDENT', 2000, 200);
INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, COMM) VALUES (3, '다', 'MANAGER', 10101, 20);
INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, COMM) VALUES (4, '라', 'MANAGER', 3000, NULL);
INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, COMM) VALUES (5, '마', 'ANALYST', 3050, 0);
INSERT INTO EMP_CHECK (EMPNO, ENAME, JOB, SAL, COMM) VALUES (6, '바', 'CLERK', 3050, -1);
SELECT * FROM EMP_CHECK;

-- 기본값 : DEFAULT
-- 방법1) 테이블 생성시 기본값 추가
CREATE TABLE EMP_DEFAULT (
    EMPNO NUMBER,
    ENAME VARCHAR2(20),
    HIREDATE DATE DEFAULT sysdate
);

-- 방법2) ALTER TABLE 로 기본값 추가
ALTER TABLE EMP_DEFAULT ADD (SAL NUMBER DEFAULT 1000);

-- 제약조건 확인
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'EMP_DEFAULT';
-- 제약조건 삭제
ALTER TABLE EMP_DEFAULT MODIFY (SAL DEFAULT NULL);

-- 샘플 데이터 추가
INSERT INTO emp_default (empno, ename) VALUES (1, '홍길동'); -- hiredate는 기본값 SYSDATE
SELECT * FROM emp_default;

-- 퀴즈1) 테이블명 : EMP_MEMBER/// 컬럼: ID(NUMBER), NAME(VARCHAR2), REGDATE(DATE) <<-- 제약조건 DEFAULT, 현재날짜로 설정

-- 퀴즈2) 테이블명 : PRODUCT /// 컬럼 : PCODE(VARCHAR2), PNAME(VARCHAR2), USE_YN(CHAR(1)) <<-- 제약조건 DEFAULT, 'Y'로 설정
    CREATE TABLE PRODUCT (
        PCODE VARCHAR2(5), 
        PNAME VARCHAR2(8),
        USE_YN CHAR(1) 
    );
    ALTER TABLE PRODUCT ADD (USE_YN CHAR DEFAULT 'Y');
-- 퀴즈3) 테이블명 : INVENTORY /// 컬럼 : ITEM_ID(NUMBER), QUANTITY (NUMBER) <<-- 제약조건 DEFAULT, 10으로 설정
    CREATE TABLE INVENTORY (
        ITEM_ID NUMBER,
        QUANTITY NUMBER
   ); 
   ALTER TABLE INVENTORY MODIFY QUANTITY NUMBER DEFAULT(10);


-- 사용자관리
    -- 접근 권한은 안줬음.

-- 사용자 테이블 생성
CREATE USER LSY2 IDENTIFIED BY 1234; -- 사용자 생성

-- 사용자의 정보 조회
SELECT * FROM ALL_USERS WHERE USERNAME = 'LSY2';
-- 사용자 상태 확인
SELECT USERNAME, ACCOUNT_STATUS, CREATED FROM DBA_USERS WHERE USERNAME = 'LSY2';
-- 사용자 비밀번호 변경
ALTER USER LSY2 IDENTIFIED BY 5678;

--사용자 삭제
DROP USER LSY2; -- 단순한 기본삭제
DROP USER LSY2 CASCADE; -- 관련된 모든 객체 삭제

-- 사용자 권한부여 --> 기본권한, 접근권한 2가지 확인

-- GRANT CONNECT, RESOURCE TO LSY2; 
-- CONNECT : 접속 권한
-- RESOURCE : 테이블, 뷰, 인덱스 등 객체 생성 권한
GRANT CONNECT TO LSY2;
GRANT RESOURCE TO LSY2;

-- 퀴즈1) 사용자생성 ... 시스템 계정에서 'LSY3' 사용자를 생성, 비밀번호는 1234
    CREATE USER LSY3 IDENTIFIED BY 1234;
    SELECT * FROM ALL_USERS WHERE USERNAME = 'LSY3';
    SELECT USERNAME, ACCOUNT_STATUS, CREATED FROM DBA_USERS WHERE USERNAME = 'LSY3';
-- 퀴즈2) 접근권한, 자원권한 부여, 패스워드는 5678 변경
    GRANT CONNECT TO LSY3; --접근권한
    GRANT RESOURCE TO LSY3; -- 자원권한
    GRANT SELECT ON SCOTT.EMP TO LSY3; -- SCOTT.EMP 테이블에 대한 SELECT 권한 부여
    ALTER USER LSY3 IDENTIFIED BY 5678; --비밀번호 변경
    SELECT * FROM SCOTT.EMP;
-- 퀴즈3) 삭제
    DROP USER LSY2 CASCADE;

-- /////////////////////////////////////////////////////////////////////////////

-- 사용자 권한 관리
-- ###시스템 권한 (SYSTEM PRIVILEGES)
-- 데이터베이스 **시스템 전체에 영향**을 주는 권한

-- ### 객체권한 (OBJECT PRIVILEGES)
-- 특정 **객체(테이블, 뷰, 시퀀스 등)의 객체에 대한 접근 권한

-- 사용자 생성 LSY4
CREATE USER LSY4 IDENTIFIED BY 1234;
--시스템 권한 부여 ,  
-- CREATE SESSION : 데이터베이스 접속 권한
-- CREATE TABLE : 테이블 생성 권한
-- 실제로 , 디비에서 , 용량에 대한 사용 권한이 없어서, 
-- 만들기 는 가능하지만, 실제 용량을 이용할 권한이 없어서,ㅣ 
-- 결론, 생성 불가. 
GRANT CREATE SESSION , CREATE TABLE TO LSY4

-- 추가 권한을 주기, 실제 용량을 이용할 권한
-- 새롭게 권한 추가
GRANT UNLIMITED TABLESPACE TO LSY4; -- 무제한 테이블스페이스 권한 부여
-- 기존 권한에 용량 관련 권한 부여
ALTER USER LSY4 QUOTA 100M ON USERS; -- USERS 테이블스페이스에 100M 쿼터 부여
ALTER USER LSY4 QUOTA UNLIMITED ON USERS; -- USERS 테이블스페이스에 무제한 쿼터 부여

-- LSY4 , 테이블 생성 확인, 조회 확인. 
CREATE TABLE LSY4.user_table (
    ID NUMBER(5),
    NAME VARCHAR2(20) NOT NULL,
    USER_ID2 VARCHAR2(20)
);
SELECT * FROM LSY4.user_table; -- 테이블 생성 확인

-- 권한이 부여 되지 않은 쓰기 작업, INSERT 작업, 
-- 자기가 만든 테이블에 대해서는 , 따로 설정이 없어도 자동 쓰기가 가능함. 
INSERT INTO LSY4.user_table (ID, NAME, USER_ID2) VALUES (1, 'Test User', 'test_user'); -- 권한이 없어서 실패
-- 수정 확인. 
UPDATE LSY4.user_table SET NAME = 'Updated User' WHERE ID = 1; -- 자기가 만든 테이블이라서 자동 권한 설정
-- 삭제 확인. 
DELETE FROM LSY4.user_table WHERE ID = 1; -- 자기가 만든 테이블이라서 자동 권한 설정

-- 권한 조회 
SELECT * FROM USER_SYS_PRIVS WHERE USERNAME = 'LSY4'; -- 시스템 권한 조회

-- 권한 회수 
REVOKE CREATE TABLE FROM LSY4; -- 테이블 생성 권한 회수

-- 샘플 테이블 생성 
CREATE TABLE LSY4.sample_table (
    ID NUMBER(5),
    NAME VARCHAR2(20) NOT NULL,
    USER_ID2 VARCHAR2(20)
);

-- SCOTT 계정에서 샘플 테이블 생성
CREATE TABLE SCOTT.sample_table1234 (
    ID NUMBER(5),
    NAME VARCHAR2(20) NOT NULL,
    USER_ID2 VARCHAR2(20)
);

-- 객체 권한 부여, 
-- SCOTT 에서 샘플테이블 만들어서, LSY4 , SELECT, INSERT 만 부여, 수정, 삭제 불가. 
GRANT SELECT, INSERT ON SCOTT.sample_table1234 TO LSY4; -- 객체 권한 부여

-- LSY4 계정에서 SCOTT.sample_table1234 테이블 조회
SELECT * FROM SCOTT.sample_table1234; -- SCOTT.sample_table1234 테이블 조회
-- LSY4 계정에서 SCOTT.sample_table1234 테이블에 INSERT 작업    
INSERT INTO SCOTT.sample_table1234 (ID, NAME, USER_ID2) VALUES (1, 'Test User', 'test_user'); -- INSERT 작업


--수정 작업, 권한이 없어서 실패
UPDATE SCOTT.sample_table1234 SET NAME = 'Updated User' WHERE ID = 1; -- 수정 작업, 권한이 없어서 실패
-- 삭제 작업, 권한이 없어서 실패
DELETE FROM SCOTT.sample_table1234 WHERE ID = 1; -- 삭제 작업, 권한이 없어서 실패


-- 다시 SCOTT 계정에서 LSY4 계정에 UPDATE, DELETE 권한 부여
GRANT UPDATE, DELETE ON SCOTT.sample_table1234 TO LSY4; -- 객체 권한 부여

--------------------------------------------------------------------------------------------------------------------------------------

-- 롤관리 
-- 사전 정의된 롤  
-- | 롤 이름         | 설명 |
-- |----------------|------|
-- | CONNECT        | 기본 접속 및 일반 SELECT/INSERT 권한 |
-- | RESOURCE       | 테이블, 인덱스 등 객체 생성 가능 |
-- | DBA            | 모든 권한 포함 (관리자 전용) |
-- 초반에 , 사용자 생성및, 권한 부여시 사용했던 명령어를 리뷰, 
create user scott identified by tiger;
grant connect,resource,dba to scott;


-- 사용자 정의 롤  
-- 사전에 정의된 롤 처럼, 우리가 임의로 롤을 만들수 있다. 

-- 사용자 정의 롤 생성
CREATE ROLE my_custom_role; -- 사용자 정의 롤 생성

-- 사용자 정의 롤에 권한 부여
GRANT CREATE SESSION , RESOURCE TO my_custom_role; -- 세션 생성 권한 부여

-- 사용자 정의 롤을 사용자에게 부여
GRANT my_custom_role TO LSY4; -- 사용자에게 사용자 정의 롤 부여


-- 퀴즈1, 
-- SYSTEM(계정 또는 스콧) 사용자 정의 롤 CREATE TABLE, CREATE VIEW )생성 하기. 
    CREATE ROLE MY_CUSTOM_1;
        GRANT CREATE TABLE, CREATE VIEW TO MY_CUSTOM_1;
            SELECT * FROM ALL_USERS WHERE USERNAME = 'LSY5';
            SELECT USERNAME, ACCOUNT_STATUS, CREATED FROM DBA_USERS WHERE USERNAME = 'LSY5';
-- LSY5 새로운 계정 생성하고, 
    CREATE USER LSY5 IDENTIFIED BY 1234;
-- 사용자 정의 롤 부여(CREATE TABLE, CREATE VIEW )
    GRANT MY_CUSTOM_1 TO LSY5;

-- 퀴즈2, 
-- 부여된 계정 LSY5 , 디비 접근 및 테이블 생성, 뷰 생성도 한번 해보기. 
    GRANT CONNECT, RESOURCE TO LSY5;
    CREATE TABLE LSY5.TEST_TABLE (
        ID NUMBER(5) PRIMARY KEY,
        NAME VARCHAR2(10) NOT NULL
    );
    -- 테이블 컬럼 추가

    ALTER TABLE LSY5.TEST_TABLE ADD (EMAIL VARCHAR2(50));
    ALTER TABLE LSY5.TEST_TABLE ADD (DEPTNO NUMBER(2));
    -- 테이블 조회
    SELECT * FROM LSY5.TEST_TABLE;
    
    -- VIEW 추가
    CREATE VIEW LSY5.TEST_VIEW AS SELECT * FROM LSY5.TEST_TABLE;
    -- 뷰 조회
    SELECT * FROM LSY5.TEST_VIEW;
    
    

    -- 시퀀스 추가
    CREATE SEQUENCE LSY5.TEST_TABLE_SEQ
        START WITH 1
        INCREMENT BY 1
        MAXVALUE 99999
        NOCYCLE;
-- 사용량 부분 오류 발생시, 조정해보기. 힌트) 미리 RESOURCE 권한 주기 
    INSERT INTO LSY5.TEST_TABLE (ID, NAME) VALUES (LSY5.TEST_TABLE_SEQ.NEXTVAL, 'Test User');
    INSERT INTO LSY5.TEST_TABLE (ID, NAME, EMAIL, DEPTNO) VALUES (LSY5.TEST_TABLE_SEQ.NEXTVAL, 'Test User','IT501@GMAIL.COM', 10);
    INSERT INTO LSY5.TEST_TABLE (ID, NAME, EMAIL, DEPTNO) VALUES (LSY5.TEST_TABLE_SEQ.NEXTVAL, 'Test User','IT501@GMAIL.COM', 10);
    --DELETE FROM LSY5.TEST_TABLE WHERE ID = 3; -- 삭제 작업

-- 퀴즈3, 
-- 권한 조회 확인. 
    SELECT * FROM USER_SYS_PRIVS WHERE USERNAME = 'LSY5';