-- 데이터베이스를 위한 데이터를 저장한 데이터 사전

-- | 접두어  | 설명 | 사용 권한 |
-- |--------|------|------------|
-- | `USER_`| 현재 사용자가 소유한 객체 정보 | 모든 사용자 사용 가능 |
-- | `ALL_` | 현재 사용자가 접근 가능한 객체 정보 | 모든 사용자 사용 가능 |
-- | `DBA_` | 모든 사용자의 모든 객체 정보 | DBA, SYSTEM 사용자 전용 |

--데이터 사전 목록 조회
SELECT * FROM DICT;


-- SCOTT 계정 객체 조회
SELECT * FROM USER_OBJECTS;

-- SCOTT 계정 접근 가능한 테이블 조회
SELECT * FROM ALL_TABLES WHERE OWNER = 'SCOTT';

-- SYSTEM 계정에서 모든 사용자 조회
SELECT * FROM DBA_USERS;

-- USER 접두어
SELECT * FROM USER_TABLES;

-- ALL 접두어 사용해서 VIEW 조회
SELECT * FROM ALL_VIEWS WHERE OWNER = 'SCOTT';

-- SYSTEM 계정에서 DBA_접두어 사용
SELECT USERNAME, CREATED FROM DBA_USERS;

-- SCOTT 계정에서 현재 자신이 소유한 객체 리스트 조회
SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS;

-- SOCTT 계정에서 모든 테이블의 컬럼 구조를 조회
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH FROM USER_TAB_COLUMNS;

-- 인덱스의 정의 : 테이블에서 특정 열에 대한 빠른 검색을 지원하는 데이터 구조

-- | 항목 | 설명 |
-- |------|------|
-- | 인덱스(Index) | 특정 열 기준으로 검색 속도를 높이는 보조 구조 |
-- | 생성 구문 | `CREATE INDEX 인덱스명 ON 테이블명(열명)` |
-- | 삭제 구문 | `DROP INDEX 인덱스명` |
-- | 자동 생성 | PRIMARY KEY, UNIQUE 제약 시 자동 생성 |
-- | 수동 생성 | 성능 최적화를 위해 직접 지정 가능 |

-- 인덱스 생성 하기 
-- 기본 문법 : CREATE INDEX 인덱스명 ON 테이블명 (열1, 열2, ...);
-- EMP의 SAL 급여를 이용해서 이름은 EMP_SAL_IDX로 인덱스 생성
CREATE INDEX EMP_SAL_IDX ON EMP (SAL);

--인덱스 목록 조회
SELECT * FROM USER_INDEXES;

-- 인덱스 컬럼 조회
SELECT * FROM USER_IND_COLUMNS WHERE INDEX_NAME = 'EMP_SAL_IDX';

-- 인덱스 삭제하기
DROP INDEX EMP_SAL_IDX;


CREATE INDEX EMP_JOB_INDEX ON EMP (JOB);
CREATE INDEX EMP_ENAME_SAL_IDX ON EMP (ENAME, SAL);
SELECT * FROM USER_IND_COLUMNS WHERE INDEX_NAME = 'EMP_JOB_INDEX';

-- 인덱스를 이용한 성능 테스트
-- 더미테이블 생성, EMP_INDEX_TEST 테이블 생성
DESC EMP;
-- 기존 EMP 테이블은 4자리 사원번호까지만 이용가능해서(EMPNO) 6자리로 변경하기.
CREATE TABLE EMP_INDEX_TEST (
    EMPNO NUMBER(100) PRIMARY KEY,
    ENAME VARCHAR2(50),
    JOB VARCHAR2(20),
    MGR NUMBER(6),
    HIREDATE DATE,
    SAL NUMBER(8,2),
    COMM NUMBER(8,2),
    DEPTNO NUMBER(2)
);
SELECT * FROM EMP_INDEX_TEST;

-- 더미데이터 삽입... 10만건 삽입
BEGIN
  FOR i IN 1..10000000 LOOP
    INSERT INTO EMP_INDEX_TEST(empno, ename, job, sal, deptno)
    VALUES (
      10000 + i,
      'USER' || i,
      CASE MOD(i, 5)
        WHEN 0 THEN 'CLERK'
        WHEN 1 THEN 'MANAGER'
        WHEN 2 THEN 'SALESMAN'
        WHEN 3 THEN 'ANALYST'
        ELSE 'PRESIDENT'
      END,
      1000 + MOD(i, 5000),
      MOD(i, 4) * 10 + 10  -- 10, 20, 30, 40 중 하나
    );
  END LOOP;
  COMMIT;
END;

-- 기본 EMP_INDEX_TEST 테이블에서 자동 생성된 인덱스(EMPNO)로 생성 조회
SELECT * FROM USER_INDEXES WHERE TABLE_NAME = 'EMP_INDEX_TEST';
--ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- 인덱스 없이 실행
SELECT * FROM EMP_INDEX_TEST WHERE ENAME = 'USER50000';

-- 성능 비교 : (실행계획 확인) 명령어 
EXPLAIN PLAN FOR
SELECT * FROM EMP_INDEX_TEST WHERE ENAME = 'USER50000';

-- 실행계획 확인
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
--ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- 인덱스 생성
CREATE INDEX EMP_INDEX_TEST_ENAME_DIX ON EMP_INDEX_TEST (ENAME);
-- 인덱스 생성 확인
SELECT * FROM USER_INDEXES WHERE TABLE_NAME = 'EMP_INDEX_TEST';

-- 성능 비교 : (실행계획 확인) 명령어 
EXPLAIN PLAN FOR
SELECT * FROM EMP_INDEX_TEST WHERE ENAME = 'USER50000';

-- 실행계획 확인
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
--ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

--  /////복합키 예시///////
-- 순서?  JOB, DEPTNO 컬럼의 순서로 인덱스 생성... 전/후 비교
-- 1) 인덱스 생성 전
SELECT * FROM EMP_INDEX_TEST WHERE JOB = 'CLERK' AND DEPTNO = 10;
-- 성능 비교 : (실행계획 확인) 명령어
EXPLAIN PLAN FOR
SELECT * FROM EMP_INDEX_TEST WHERE JOB = 'CLERK' AND DEPTNO = 10;
-- 실행계획 확인
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- 결과 
--| Id  | Operation         | Name           | Rows  | Bytes | Cost (%CPU)| Time     |
--|*  1 |  TABLE ACCESS FULL| EMP_INDEX_TEST |  5285 |   583K|   148   (3)| 00:00:02 |

-- 2) 인덱스 생성 후
CREATE INDEX EMP_INDEX_TEST_JOB_DEPTNO_IDX ON EMP_INDEX_TEST (JOB, DEPTNO);
-- 인덱스 조회
SELECT * FROM USER_INDEXES WHERE TABLE_NAME = 'EMP_INDEX_TEST';

SELECT * FROM EMP_INDEX_TEST WHERE JOB = 'CLERK' AND DEPTNO = 10;
-- 성능 비교 : (실행계획 확인) 명령어
EXPLAIN PLAN FOR
SELECT * FROM EMP_INDEX_TEST WHERE JOB = 'CLERK' AND DEPTNO = 10;
-- 실행계획 확인
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- 결과 ... 


--ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- 복합키 인덱스 예시 2
-- 기존 복합키 인덱스 삭제
DROP INDEX EMP_INDEX_TEST_JOB_DEPTNO_IDX;
-- 기존 단일키 인덱스도 삭제
DROP INDEX EMP_INDEX_TEST_ENAME_DIX;
-- 인덱스 조회
SELECT * FROM USER_INDEXES WHERE TABLE_NAME = 'EMP_INDEX_TEST';
-- ENAME, JOB 컬럼의 순서로 인덱스 생성 전.
SELECT * FROM EMP_INDEX_TEST WHERE ENAME = 'USER50000' AND JOB = 'CLERK';
-- 성능 비교 : (실행계획 확인) 명령어
EXPLAIN PLAN FOR
SELECT * FROM EMP_INDEX_TEST WHERE ENAME = 'USER50000' AND JOB = 'CLERK';
-- 실행계획 확인
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- 결과

--ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- 인덱스 생성
CREATE INDEX EMP_INDEX_TEST_ENAME_JOB_IDX ON EMP_INDEX_TEST (ENAME, JOB);
SELECT * FROM EMP_INDEX_TEST WHERE ENAME = 'USER50000' AND JOB = 'CLERK';
-- 성능 비교 : (실행계획 확인) 명령어
EXPLAIN PLAN FOR
SELECT * FROM EMP_INDEX_TEST WHERE ENAME = 'USER50000' AND JOB = 'CLERK';
-- 실행계획 확인
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- 결과
--| Id  | Operation                   | Name                         | Rows  | Bytes | Cost (%CPU)| Time     |
--|*  2 |   INDEX RANGE SCAN          | EMP_INDEX_TEST_ENAME_JOB_IDX |     1 |       |     1   (0)| 00:00:01 |

-- VIEW 생성
CREATE VIEW EMP_VIEW AS
SELECT EMPNO, ENAME, DEPTNO FROM EMP WHERE DEPTNO=10;
--데이터 사전에서 VIEW 정보 확인
SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'EMP_VIEW';

SELECT * FROM EMP_VIEW;

DROP VIEW EMP_VIEW;

-- INLINE VIEW 예시
SELECT EMPNO, ENAME, SAL FROM EMP; --현재사원 총 19명

SELECT * FROM (SELECT EMPNO, ENAME, SAL FROM EMP --서브쿼리
                ) WHERE ROWNUM <= 5; -- 상위 5개 행만 조회

-- ROWNUM을 같이 출력하는 예제
SELECT ROWNUM, EMPNO, ENAME, SAL FROM 
    (SELECT EMPNO, ENAME, SAL FROM EMP
    ) WHERE ROWNUM <= 5;

-- WITH절 사용한 VIEW 예시
WITH EMP_SAL_TOP_3 AS(
    SELECT EMPNO, ENAME, SAL FROM EMP
        ORDER BY SAL DESC
) SELECT * FROM EMP_SAL_TOP_3  -- 상위 SAL값 3명만 조회
    WHERE ROWNUM <= 3;

-- EMP 테이블에서 부서번호가 20인 사원만 표시하는 뷰 생성
CREATE VIEW EMP_DEPTNO20_VIEW AS
SELECT EMPNO, ENAME, DEPTNO, HIREDATE FROM EMP WHERE DEPTNO = 20;

-- 뷰에서 데이터 조회
SELECT * FROM EMP_DEPTNO20;
-- 생성된 뷰의 구조 정보 확인
DESC EMP_DEPTNO20_VIEW;
DROP VIEW EMP_DEPTNO20;

-- 퀴즈1) SAL이 높은상위5명 추출하는 뷰 EMP_TOP5생성
    CREATE VIEW EMP_TOP5 AS 
        SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP ORDER BY SAL;
    --  CREATE VIEW EMP_TOP5 AS
        --  SELECT * FROM (SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP
            -- WHERE SAL IS NOT NULL ORDER BY DESC) WHERE ROUNUM <= 5;
    WITH EMP_TOP5 AS (SELECT ROWNUM, EMPNO, ENAME, SAL, DEPTNO FROM EMP ORDER BY SAL DESC) SELECT * FROM EMP_TOP5 WHERE ROWNUM <=5;
    --  SELECT ROWNUM, EMPNO, ENAME, SAL, DEPTNO FROM (SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP ORDER BY SAL DESC) WHERE ROWNUM <=5;

-- 퀴즈2) 인라인 뷰 사용 부서별 평균급여 구한뒤, 평균이 2000 이상인 부서만 추출
SELECT * FROM (SELECT DEPTNO, AVG(SAL) AS "부서별 평균급여" FROM EMP GROUP BY DEPTNO) WHERE "부서별 평균급여" >= 2000;
SELECT * FROM DEPT;
-- 퀴즈3)WITH절을 이용해 JOB별 최고 급여를 구한 후, 최고급여가 3000 이상인 직무만 출력하시오.
WITH EMP_JOB_SAL AS (SELECT JOB, MAX(SAL) AS "직무별 최고급여" FROM EMP GROUP BY JOB)
    SELECT * FROM EMP_JOB_SAL WHERE "직무별 최고급여" >= 3000;


-- 시퀀스 기본 개념
-- | 항목 | 설명 |
-- |------|------| 
-- | 시퀀스(Sequence) | 고유한 숫자 생성 객체 |
-- | NEXTVAL | 다음 숫자 생성 |
-- | CURRVAL | 최근 생성된 번호 |
-- | STRT WITH | 시작 값 지정 |
-- | INCREMENT BY | 증가 값 지정 |
-- | CYCLES | MAX 도달 시 초기화 여부 설정 |
-- | 생성 구문 | `CREATE SEQUENCE 시퀀스명 START WITH 시작값 INCREMENT BY 증가값` |
-- | 사용 구문 | `시퀀스명.NEXTVAL` |
-- | 삭제 구문 | `DROP SEQUENCE 시퀀스명` |

-- 시퀀스 생성 
CREATE SEQUENCE EMP_SEQ -- 시퀀스 이름... 의미있는이름으로 지정
START WITH 1
INCREMENT BY 1
MAXVALUE 9999
NOCYCLE;

-- 테스트 할 빈 테이블 복사 
CREATE TABLE EMP_SEQUENCE_TEST AS SELECT * FROM EMP WHERE 1=0;
-- 테이블의 내용만 삭제
TRUNCATE TABLE EMP_SEQUENCE_TEST;

-- 빈 테이블 조회 
SELECT * FROM EMP_SEQUENCE_TEST;

-- 시퀀스 조회 
SELECT EMP_SEQ.NEXTVAL FROM DUAL;
DESC EMP_SEQUENCE_TEST;
-- 시퀀스 이용해서, 데이터 추가 해보기. 
INSERT INTO EMP_SEQUENCE_TEST VALUES(
    EMP_SEQ.NEXTVAL, -- empno 기존에는 숫자 형태로 직접 지정 했고, 자동 생성.자 타입
    '홍길동',         -- ename 문자열 타입
    '강사',         -- job 문자열 타입
    7839,           -- mgr, 숫자 타입
    SYSDATE,    -- hiredate, DATE 타입
    1000,            -- sal 숫자 타입
    500,             -- comm 숫자 타입
    10               -- deptno 숫자 타입
);
SELECT * FROM EMP_SEQUENCE_TEST;

-- 기존 시퀀스 삭제 후 다시 생성
DROP SEQUENCE EMP_SEQ;


SELECT EMP_SEQ.CURRVAL FROM DUAL; -- CURRVAL은 NEXTVAL을 먼저 호출해야 사용 가능

-- 퀴즈1) DEPT -> DEPT_SEQ_TEST 테이블 복사 후 작업
-- 1부터 시작하는 DEPT_SEQ 시퀀스 생성
-- 증감은 10씩, 최대값 9999999, 순환하지 않음
CREATE TABLE DEPT_SEQ_TEST AS SELECT * FROM DEPT WHERE 1=0;
-- DESC DEPT;
-- SELECT * FROM DEPT_SEQ_TEST;
CREATE SEQUENCE DEPT_SEQ
START WITH 1
INCREMENT BY 10
MAXVALUE 9999999
NOCYCLE;

SELECT DEPT_SEQ.NEXTVAL FROM DUAL; -- 시퀀스 확인

INSERT INTO DEPT_SEQ_TEST VALUES(
    DEPT_SEQ.NEXTVAL, -- deptno
    '개발팀',          -- dname
    '제주도'         -- loc
);
ALTER TABLE DEPT_SEQ_TEST MODIFY
    DEPTNO NUMBER(38) NOT NULL; -- deptno 컬럼의 숫자 타입을 100자리로 변경
SELECT * FROM DEPT_SEQ_TEST;

-- 퀴즈2, 
-- DEPT_SEQ_TEST, 샘플 데이터를 추가해서, 
    -- 증감값 확인,.(자동증가 확인이 목적)
  

-- 퀴즈3, 
-- 마지막으로 생성된 시퀀스 번호 확인 및 증감 10 -> 100 변경도 해보고,
    --  삭제도 해보기
CREATE TABLE DEPT_SEQ_TEST AS SELECT * FROM DEPT WHERE 1=0;
DESC DEPT;
SELECT * FROM DEPT_SEQ_TEST;
CREATE SEQUENCE DEPT_SEQ
START WITH 1
INCREMENT BY 132
MAXVALUE 9999999
NOCYCLE;

INSERT INTO DEPT_SEQ_TEST VALUES(
    DEPT_SEQ.NEXTVAL, -- deptno
    '인사팀',          -- dname
    '경기도'         -- loc
);
SELECT * FROM DEPT_SEQ_TEST;
-- 시퀀스 삭제하기
DROP SEQUENCE DEPT_SEQ;
SELECT * FROM USER_SEQUENCES; -- 현재 사용자의 시퀀스 목록 조회

-- 시퀀스가 개념이 이해가 안될경우, 예시 회원가입
-- 사용자 웹에서 회원가입 진행함. 
-- 사용자가 개인정보와 자기의 사용자 아이디 번호를 입력을 하기 어렵다(거의 불가능)
-- 그러면, 개발자가 대신, 사용자의 아이디 번호를 매번 수동으로 입력하기 어렵다. 
-- 그래서, 시퀀스, 테이블에 자동 번호 증가 기능(함수)이용하면, 알아서, 번호를 생성 해줌. 
-- 예시 
-- ID(자동생성), 이름, 이메일, 비밀번호, 가입일시
-- 1(자동생성), 홍길동, 
-- 2(자동생성), 김철수,
-- 3(자동생성), 이영희,
--ID(자동생성), 사용자는 순서 걱정 말고, 단순 입력만 하면, 시스템에서 알아서 자동으로 번호를 생성해줌.
-- 회원 가입 할 때, 등록 시간, 같은 케이스, 어떻게 내가 가입 또는 글쓰는 시간을 수동으로 입력 불가능, 
-- 시스템에서 자동으로 처리 하게끔 만들어야 함. 



-- 공식 별칠을 지정하는 동의어 SYNONYM.
-- | 항목 | 설명 |
-- |------|------|
-- | 동의어(SYNONYM) | 객체에 대한 별칭 |
-- | 생성 구문 | `CREATE [PUBLIC] SYNONYM 동의어명 FOR 객체명` |
-- | 삭제 구문 | `DROP [PUBLIC] SYNONYM 동의어명` |
-- | PUBLIC | 모든 사용자에게 공유되는 동의어 |
-- | PRIVATE SYNONYM | 현재 사용자에게만 적용되는 동의어 |

-- 동의어 생성 예시
CREATE SYNONYM EMP_SYNONYM FOR EMP; -- 이름을 의미있게 사용.

-- 동의어 조회
SELECT * FROM USER_SYNONYMS;

-- 동의어를 이용한 데이터 조회
SELECT * FROM EMP_SYNONYM; -- EMP 테이블을 EMP_SYNONYM 동의어로 조회
-- 권한 부여
GRANT SELECT ON EMP TO PUBLIC; -- 모든 사용자에게 EMP 테이블 조회 권한 부여
GRANT SELECT ON EMP TO SCOTT; -- 특정 사용자에게 EMP 테이블 조회 권한 부여

-- 동의어 삭제
DROP SYNONYM EMP_SYNONYM;

-- 스키마 명 포함 접근
SELECT * FROM SCOTT.EMP;

-- PRIVATE 동의어 생성
CREATE SYNONYM MY_EMP FOR SCOTT.EMP;

-- 사용자 추가
CREATE USER CKM IDENTIFIED BY 1234;
-- 기본 접속권한만 추가
GRANT CREATE SESSION TO CKM;
-- ===> 세션 기존 SCOTT계정에서 CKM 계정으로 변경.
-- 사용자 조회
SELECT * FROM ALL_USERS WHERE USERNAME = 'CKM';

-- MY_EMP 동의어 이용한 조회
SELECT * FROM MY_EMP;
-- 동의어 조회 EMP2 
SELECT * FROM USER_SYNONYMS WHERE SYNONYM_NAME = 'EMP2';
DROP SYNONYM EMP2; -- 동의어 삭제

-- 사용하는 테이블이 EMP_MINI, DEPT_MINI, SALGRADE_MINI , 고려해보기. 
SELECT * FROM EMP_MINI; -- EMP_MINI 동의어를 이용한 조회
SELECT * FROM DEPT_MINI; -- DEPT_MINI 동의어를 이용한 조회
SELECT * FROM SALGRADE_MINI; -- SALGRADE_MINI 동의어를 이용한 조회

--ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- 퀴즈1, EMP, DEPT 조인 고려하기
-- 동의어를 활용해서 부서명이 ‘ACCOUNTING’인 사원 이름과 직무를 출력하라.
    CREATE SYNONYM ACC FOR DEPT;
    SELECT * FROM USER_SYNONYMS;
    SELECT ENAME, JOB FROM EMP WHERE DEPTNO = (SELECT DEPTNO FROM ACC WHERE DNAME = 'ACCOUNTING');
    SELECT * FROM EMP;

-- 퀴즈2, EMP, SALGRADE 조인 고려하기 
-- 급여 등급(GRADE) 3에 해당하는 사원 목록 출력
    SELECT * FROM SALGRADE;
    SELECT ENAME, JOB, SAL FROM EMP JOIN SALGRADE ON EMP.SAL BETWEEN SALGRADE.LOSAL AND SALGRADE.HISAL WHERE SALGRADE.GRADE=3;
    -- SELECT E.ENAME, E.JOB, E.SAL FROM EMP E JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL WHERE S.GRADE=3;

-- 퀴즈3, 자체 조인 및, SALGRADE 테이블 까지 조인을 고려하기
-- 관리자(직속상관=MGR) 이름과 급여 등급을 동의어 기반으로 출력
SELECT E.ENAME AS "사원명", M.ENAME AS "관리자명", S.GRADE AS "급여등급"
    FROM EMP E JOIN EMP M ON E.MGR = M.EMPNO
        JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL
            WHERE E.MGR IS NOT NULL;


