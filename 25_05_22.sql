SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
SELECT SYSDATE FROM DUAL;

-- 실행 결과가 하나인 단일행 서브쿼리

-- 기본 문법형식
-- SELECT 컬럼 FROM 테이블
--     WHERE 컬럼 비교연산자 (SELECT 단일값 FROM 서브쿼리);

-- 예시) 부서번호가 30인 사원의 평균 급여보다 많은 전체 사원
SELECT DEPTNO, ENAME, SAL FROM EMP
    WHERE SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO=30);
    
-- 가장 최근 입사자 출력 (최근일수록 큰값 = MAX)
SELECT DEPTNO, ENAME, HIREDATE FROM EMP
    WHERE HIREDATE = (SELECT MAX(HIREDATE) FROM EMP);
    
-- 오늘 입사한 사원 출력
SELECT ENAME, HIREDATE FROM EMP 
    WHERE HIREDATE = TRUNC(SYSDATE);
    
-- 퀴즈1) 부서번호 10번 사원의 최대급여보다 높은 급여를 가진사원
SELECT ENAME, JOB, SAL FROM EMP
    WHERE SAL > (SELECT MAX(SAL) FROM EMP WHERE DEPTNO=10);
-- 퀴즈2) 오늘(TRUNC(SYSDATE)) 날짜보다 이전에 입사한 사원
SELECT ENAME, JOB, HIREDATE SAL FROM EMP
    WHERE HIREDATE <TRUNC(SYSDATE);
-- 퀴즈3) 평균급여보다 낮은 급여를 받는사원 출력
SELECT ENAME, JOB, SAL FROM EMP
    WHERE SAL<(SELECT AVG(SAL) FROM EMP);
    
-- ///////////////////////////////////////////////////////////   
-- 다중행 서브쿼리 : 2개 이상의 값을 반환, 단일행 연산자로는 사용할 수 없음

-- DALLAS에 위치한 부서의 부서번호중 하나에 속한 사원의 이름을 출력
-- IN 연산자) 서브쿼리의 결과 중 하나라도 일치하면 참
SELECT ENAME, DEPTNO FROM EMP
    WHERE DEPTNO IN(SELECT DEPTNO FROM DEPT WHERE LOC='DALLAS');
    
    
-- 부서 번호가 30번에 속한 사원들 중 적어도 한명보다 급여가 적은 사원의 이름을 출력
-- 부서번호 30번인 누구의 급여중 하나라도 큰값이 있다면.
-- ANY/SOME 연산자) 조건에 만족하는 하나라도 존재하면 ]

-- ANY 는 최소 하나의 조건만 만족해도 참이 되는 경우 
-- > , 또는 < 와 같이 비교 연산자와 함께 사용되고 
-- 최소/최대 비교를 하는 경우도 유연하게 사용이됨
SELECT ENAME, DEPTNO, SAL FROM EMP
    WHERE SAL <= ANY(SELECT SAL FROM EMP WHERE DEPTNO=30);
    -- 즉 DEPTNO=30인 사원중 MAX(SAL)보다 적은사람이 있다면 해당하는사람 모두 출력 ... SAL < MAX(SAL) WHERE DEPTNO=30;



-- ALL 연산자) 전부 만족해야 참이되는조건
-- 부서번호가 30번인 모든 사원보다 급여가 많은 사원의 이름 출력
SELECT ENAME, SAL FROM EMP
    WHERE SAL >= ALL(SELECT SAL FROM EMP WHERE DEPTNO=30);
    
--EXISTS 연산자 
-- 사원이 소속하는 부서의 이름을 출력 
-- 하나라도 존재하면 참(TRUE) 
-- 매우 빠른 조건에 존재 확인에 유리(데이터 확인 아님)
-- 서브쿼리의 실제 데이터가 아니라 존재 유무만 확인함. 
-- 반환값이 있으면 무조건 TRUE
SELECT DNAME, DEPTNO FROM DEPT D
    WHERE EXISTS(SELECT * FROM EMP E WHERE E.DEPTNO=D.DEPTNO);
    
-- 부서번호별 최대 급여
SELECT DEPTNO, MAX(SAL) FROM EMP GROUP BY DEPTNO;
    
-- 퀴즈1) 30번 부서의 최소급여를 받는사람보다 많이받는사람
SELECT SAL FROM EMP WHERE DEPTNO=30;
SELECT ENAME, SAL, DEPTNO FROM EMP
    WHERE SAL > ANY(SELECT SAL FROM EMP WHERE DEPTNO=30);
    
    -- ANY : 하나라도 참일때 즉, 950~2850중 950보다 크기만하면 출력
    -- ALL : 전부 만족해야 참 즉, 950~2850중 2850도 만족해야하므로 2850보다 큰 값만 출력  ==> ANY와 같게 되려면 SAL > ALL(SELECT MIN(SAL) FROM EMP ...);
    
    
-- 퀴즈2) 30번 부서의 최대급여를 받는사람중 낮은 급여를 받는 사원 출력  
SELECT ENAME, SAL, DEPTNO FROM EMP
    WHERE SAL < ANY(SELECT SAL FROM EMP WHERE DEPTNO=30);
           -- <(SELECT MAX(SAL) FROM EMP WHERE DEPTNO=30);
-- 퀴즈3) EMP 테이블에 소속된 사원이 있는 부서의 이름(DEPT.DNAME)을 출력 (`EXISTS`) 
SELECT DNAME FROM DEPT
    WHERE EXISTS(SELECT * FROM EMP WHERE EMP.DEPTNO = DEPT.DEPTNO);


-- 비교할 열이 여러개 인 다중열 서브쿼리
-- 비교 방식 : (COL1, COL2) IN (SELECT COL1, COL2 FROM ...)
-- 주의점 : 컬럼 수와 순서 일치 필요. 반환 열이 다르면 오류 발생

-- 부서번호가 10번인 사원들의 직무,부서번호 조합과 동일한 (직무,부서번호)를 가진 사원을 조회
SELECT ENAME, JOB, DEPTNO FROM EMP WHERE DEPTNO=10;

SELECT ENAME, JOB, DEPTNO FROM EMP WHERE (JOB, DEPTNO) IN(SELECT JOB, DEPTNO FROM EMP WHERE DEPTNO=10);

-- 직책과 부서 (직책, 부서번호) 튜플 과 일치하는 사원 출력 
SELECT JOB, DEPTNO FROM EMP WHERE DEPTNO = 20;
SELECT ENAME, JOB, DEPTNO FROM EMP WHERE (JOB,DEPTNO) 
                                    IN (SELECT JOB, DEPTNO FROM EMP WHERE DEPTNO = 20);
        

-- (사원번호, 부서번호) 특정 목록과 일치하는 데이터 출력 
SELECT EMPNO, ENAME, SAL FROM EMP WHERE (EMPNO, DEPTNO) 
                        IN (SELECT EMPNO,DEPTNO FROM EMP WHERE SAL > 2000
                            );

-- (급여, 부서번호) 기준으로 특정 조건과 일치하는 
-- 사원 추출 
SELECT ENAME, SAL, DEPTNO FROM EMP 
    WHERE (SAL, DEPTNO ) IN (
            SELECT MAX(SAL), DEPTNO FROM EMP 
         GROUP BY DEPTNO 
); --ORDER BY SAL;


-- 퀴즈1, WHERE(JOB, DEPTNO)
-- 20번과 30번 부서에 있는 ‘MANAGER’ 
-- 직책 사원과 동일한 (직책, 부서번호) 조합을 가진 사원 출력  
SELECT ENAME, JOB, DEPTNO FROM EMP
    WHERE (JOB, DEPTNO) IN (SELECT JOB, DEPTNO FROM EMP WHERE DEPTNO IN(20,30) AND JOB = 'MANAGER');
-- 퀴즈2, WHERE(SAL, DEPTNO)
-- 각 부서별 최저 급여를 받는 사원 출력  
SELECT ENAME, JOB, SAL, DEPTNO FROM EMP
    WHERE(SAL, DEPTNO) IN (SELECT MIN(SAL),DEPTNO FROM EMP GROUP BY DEPTNO);
-- 퀴즈3, WHERE(EMPNO, DEPTNO)
-- 특정 기준 사원들과 동일한 (사원번호, 부서번호) 조합을 
-- 가진 사원을 출력하되, 급여는 2000 이상인 경우만 표시  
SELECT ENAME, SAL, EMPNO, DEPTNO FROM EMP
    WHERE(EMPNO, DEPTNO) IN (SELECT EMPNO, DEPTNO FROM EMP WHERE SAL>=2000 GROUP BY EMPNO,DEPTNO);
                                                                    -- GROUP BY 는 사실상 DISTINCT 역할을 함.
    
-- 서브쿼리 재활용하기 ==> 함수처럼 사용함. 
-- FROM 절에 사용하는 서브쿼리 //// WITH 절

-- 예제) 부서 번호가 30번인 사원들만 추출한 뒤, 그 결과에서 직무별 평균급여를 계산.
-- "인라인 뷰" 방식
SELECT JOB, AVG(SAL) AS "평균급여" FROM (SELECT * FROM EMP WHERE DEPTNO=30) GROUP BY JOB;

-- "WITH 절" 방식
WITH DEPT30_EMP AS(SELECT * FROM EMP WHERE DEPTNO=30)
SELECT JOB, AVG(SAL) AS "평균급여" FROM DEPT30_EMP GROUP BY JOB;

-- WITH 절 에서 필터링한 데이터를 메인 쿼리에서 조인
WITH EMP30 AS(SELECT * FROM EMP WHERE DEPTNO = 
                (SELECT DEPTNO FROM DEPT WHERE LOC ='DALLAS')
            )
SELECT ENAME, JOB FROM EMP30;

-- 퀴즈1, 
-- 부서별 평균 급여가 2000 이상인 부서의 
-- 직책별 사원 수 출력 (WITH절 + GROUP BY)  
 WITH DEPT_AVG AS(SELECT DEPTNO, AVG(SAL)AS "평균급여" FROM EMP 
    GROUP BY DEPTNO HAVING AVG(SAL)>=2000)
        SELECT E.DEPTNO, E.JOB, COUNT(*) AS"사원수" FROM EMP E 
            JOIN DEPT_AVG D ON E.DEPTNO = D.DEPTNO GROUP BY E.DEPTNO, E.JOB;
            
-- 퀴즈2, 
-- 부서별 최고 급여자를 인라인 뷰로 추출하고, 사원명과 급여 출력  
  SELECT ENAME AS "사원명", SAL AS "급여", DEPTNO FROM EMP
    WHERE (SAL, DEPTNO) IN 
                    (SELECT MAX(SAL), DEPTNO FROM EMP GROUP BY DEPTNO);
  
-- 퀴즈3, 
-- WITH절로 정의된 사원 리스트에서, 급여가 평균 이상인 사원만 출력  DEPTNO 20을하던 30을 하던..
WITH EMP20 AS (
    SELECT * FROM EMP WHERE DEPTNO = 20)
        SELECT ENAME ,SAL FROM EMP20 
            WHERE SAL >= (SELECT AVG(SAL) FROM EMP20);
            
            
-- SELECT절 내부에 서브쿼리를 사용하는 방법
-- 사원 이름 급여 ... 해당 사원이 속한 부서의 평균 급여
SELECT ENAME, SAL, (SELECT TRUNC(AVG(SAL)) FROM EMP WHERE DEPTNO = E.DEPTNO) AS "평균급여" FROM EMP E;

-- 각 사원 옆에 부서 평균표시
SELECT ENAME, DEPTNO, SAL, (SELECT TRUNC(AVG(SAL)) FROM EMP WHERE DEPTNO = E.DEPTNO) AS "평균급여" FROM EMP E;

-- 사원명 옆 전체사원수 표시
SELECT ENAME, (SELECT COUNT(*) FROM EMP) AS "전체사원수" FROM EMP;

-- 사원명 옆에 관리자 이름 표시 (자체 서브쿼리 사용해서)
SELECT ENAME, (SELECT M.ENAME FROM EMP M WHERE M.EMPNO = E.MGR) AS "직속상관 이름" FROM EMP E;

-- 성능부분을 고려하여.. 차선색으로 쿼리 작업
-- 부서별 평균 급여를 미리 구한후, EMP 테이블과 조인해서 출력!
SELECT E.ENAME, E.SAL, D.DEPT_AVG AS "부서별평균급여" FROM EMP E
    JOIN (SELECT DEPTNO, TRUNC(AVG(SAL)) AS "DEPT_AVG" FROM EMP GROUP BY DEPTNO)
        D ON E.DEPTNO=D.DEPTNO;
        
-- 퀴즈1, 
-- 각 사원의 급여, 부서 평균 급여, 전체 평균 급여를 함께 출력하시오.
SELECT ENAME, SAL, DEPTNO ,
(SELECT TRUNC(AVG(SAL)) FROM EMP WHERE DEPTNO = E.DEPTNO) AS "부서평균",
(SELECT TRUNC(AVG(SAL)) FROM EMP ) AS "전체 평균"
FROM EMP E;
-- 퀴즈2, 
-- 각 사원의 이름, 직책, 부서 위치를 함께 출력하시오.  
SELECT E.ENAME, E.JOB, 
(SELECT D.LOC FROM DEPT D WHERE D.DEPTNO = E.DEPTNO) AS LOCATION
FROM EMP E;

-- 퀴즈3, 
-- 각 사원의 이름, 급여, 같은 부서의 최대 급여를 함께 출력하시오.  
SELECT ENAME, SAL, DEPTNO,
(SELECT MAX(SAL) FROM EMP WHERE DEPTNO = E.DEPTNO) AS "최대급여"
FROM EMP E;


INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES (60, '개발부','서울');
SELECT * FROM DEPT;

-- 테이블에 테이터 추가하기 
-- 기본 문법 , 열의 순서에는 상관없음
-- INSERT INTO 테이블명 (열1,열2,...) VALUES (값1,값2,...);

-- 열 이름 생략 , 테이블에 정의된 열의 순서대로 작성하기. 
-- INSERT INTO 테이블명 VALUES (값1,값2,...);

-- NULL 삽입 , 날짜 입력
-- INSER INTO 테이블명 VALUES (101,NULL,'2025/05/22', SYSDATE)

-- 서브쿼리 삽입
-- INSERT INTO 테이블명 (열1,열2)
-- SELECT 열1, 열2 FROM 다른 테이블 WHERE 조건;

-- 예시
-- 열 지정 INSERT 
insert into dept (dname, deptno, loc) values ('개발부2', 70, '서울2' );
select *  from dept;
-- 열 생략 INSERT
insert into dept values ( 80,'개발부3','서울3' );
commit;
-- SYSDATE 삽입
INSERT INTO EMP (empno, ename, hiredate) VALUES ( 1000, '홍길동', SYSDATE );
SELECT * FROM EMP;

-- 퀴즈1, 
-- DEPT 테이블에 (99, ‘AI팀’, ‘JEJU’) 데이터를 추가하시오. 
 INSERT INTO dept (deptno, dname, loc) VALUES (99, 'AI팀', 'JEJU');
 SELECT * FROM dept;
-- 퀴즈2, 
-- EMP 테이블에 사번 1234, 이름 'LEE', 입사일을 SYSDATE로 추가하시오.
  INSERT  INTO emp (empno, ename, hiredate) VALUES (1234, 'LEE', SYSDATE);
  SELECT * FROM emp;
-- 퀴즈3, 
-- DEPT에 NULL을 포함한 값 삽입 
-- 테이블에 PK 값 의무적으로 입력하기, 
-- PK : NOT NULL, UNIQUE 제약조건이 있는 열
INSERT INTO dept (deptno, dname, loc) VALUES (NULL, 'AI팀', NULL);
SELECT * FROM dept;

-- 데이터 사전에서 테이블의 제약조건 확인해보기 DEPT 테이블
SELECT * FROM user_constraints WHERE table_name = 'DEPT';
-- 제약조건 확인하기

-- 테이블 복사하는 방법 
-- EMP 테이블에서 부서번호가 30인 사원 데이터를 
-- EMP_TEMP_30 테이블에 복사하기
-- 새로운 테이블을 생성하는 기본 문법 
-- CREATE TABLE 테이블명 AS SELECT * FROM 테이블명 WHERE 조건;
-- EMP_TEMP_30 테이블 생성 , 단순 빈테이블 생성
CREATE TABLE EMP_TEMP_30 AS SELECT * FROM EMP WHERE 1=0;
-- 실제 데이터 삽입
CREATE TABLE EMP_TEMP_40 AS SELECT * FROM EMP WHERE 1=1;

INSERT INTO EMP_TEMP_30
SELECT * FROM EMP WHERE deptno = 30;

-- EMP_TEMP_30 테이블 확인
SELECT * FROM EMP_TEMP_30;
-- EMP_TEMP_40 테이블 확인
SELECT * FROM EMP_TEMP_40;