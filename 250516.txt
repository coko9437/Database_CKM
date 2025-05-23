select * from dept;
select * from emp;
select * from salgrade; 

desc emp;
desc dept;
desc salgrade;

select * from emp where job ='MANAGER';
-- 오라클 SQL developer 에서 주석(-)2번
-- 행 기준으로 검색, where 조건 이용.

SELECT * FROM EMP WHERE JOB = 'MANAGER';
-- 열 기준으로 프로젝션, 보고싶은 열 만 선택해서 조회해보기
select ename, job from emp;
select ename, job from emp where job ='MANAGER';

-- 기본퀴즈1) 셀렉션 이용, 'SALES'부서에 소속 직원만 조회
select ename, job from emp where deptno =30;
-- 기본퀴즈2) 사원명과 입사일만 조회
select ename, hiredate from emp;
-- 기본퀴즈3) 급여가 3000 이상인 직원만 조회
select ename from emp where sal >=3000;
-- 기본퀴즈4) emp 테이블에서 이름(ename), 급여(sal), 부서번호(deptno)만 조회해보기
select ename, sal, deptno from emp;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- Distinct : 중복제거
select all job from emp;
select job from emp;
-- 직무+부서번호 조합의 고유 데이터 추출
-- JOB 직무, 부서번호 조합에 대해서 중복이 되지 않는 행만 조회.
-- 결론 : 동일한 직무와 동일한 부서 번호를 가진 직원이 여러명 있어도
-- 한번만 결과로 나타냄
select DISTINCT JOB, DEPTNO FROM EMP;
select JOB, DEPTNO from emp;

-- 퀴즈1) EMP 테이블에서 중복되지않는 부서번호만 출력하기
SELECT DISTINCT DEPTNO FROM EMP;
-- 퀴즈2) EMP 테이블에서 사원의 직무와 부서번호 조합이 고유한(중복없이) 결과 한번더 해보기
SELECT DISTINCT JOB, DEPTNO FROM EMP;
-- 퀴즈3) EMP 테이블에서 중복을 제거하지 않고 사원의 직무와 부서번호를 모두출력(ALL키워드)
SELECT ALL JOB, DEPTNO FROM EMP;

-- 주의사항) DISTINCT는 SELECT문 뒤에 위치를 하고, 하나의 컬럼에 적용 되는게 아니라
-- 2개의 컬럼이 하나처럼 취급이 되어서 동작함.

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- ALIAS (=AS) 별칭  사용해보기
SELECT ENAME AS "사원명" FROM EMP;
SELECT ENAME "사원명" FROM EMP;
SELECT ENAME AS "사원명", SAL*12 AS "연봉" FROM EMP;

-- 퀴즈1) EMP 테이블에서 사원 이름에 '퇴사자명' 부여해서 출력
SELECT ENAME AS "퇴사자 명" FROM EMP;
-- 퀴즈2) EMP 테이블에서 급여(SAL)를 연봉으로 계산해서 출력해보기
SELECT SAL * 12 AS "연봉" FROM EMP;
-- 퀴즈3) 사원명과 직무를 각각 지정해서 출력
SELECT ENAME AS "퇴사자이름", JOB AS "하는일" FROM EMP;
-- 퀴즈4) 사원명과 급여, 커미션(COMM)이 있을 경우, 총 수입을 계산하기, 출력 별칭은 "총 급여"로 지정
-- 특정 옵션함수 NVL( COMM, 0) : COMM이 있으면 COMM이 값으로 출력/ COMM이 없으면 "0"값 으로
-- NVL => N (null) V (value) L (logic)
SELECT ENAME, SAL*12+COMM AS "총 급여" FROM EMP;
SELECT NVL(COMM,0) AS "상여금", SAL*12 + NVL(comm,0) AS "총급여" FROM EMP;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- ASC 오름차순, DESC 내림차순
SELECT * FROM EMP ORDER BY SAL ASC;
SELECT * FROM EMP ORDER BY SAL DESC;
-- 복합 컬럼 이용.. 부서 내에서 부서번호를 오름차순으로, 부서번호가 같은사람은 급여를 내림차순으로 정렬
SELECT * FROM EMP ORDER BY DEPTNO ASC, SAL DESC;

-- 열 인덱스로 정렬하기.. ename(1), job(2), sal(3) 순으로 내림차순
select ename, job, sal from emp order by 3 desc;

-- 시간은, 최신의 값으로 하면 큰값 <--> 과거일수록 값은 작은값
-- EMP 테이블에서 모든 사원의 입사일 기준을 최신순(즉, 내림차순)으로 정렬해보기
select ename, hiredate from emp order by hiredate desc;

-- 퀴즈1) 커미션이 높은 순으로 , 급여가 낮은 순으로 정렬 출력
select * from EMP order by COMM desc, SAL asc;
-- 퀴즈2) emp 테이블에서 이름, 부서번호, 급여를 출력하되 급여가 높은 순으로 정렬
select ENAME, DEPTNO, SAL from EMP order by SAL desc;
-- 퀴즈3) salgrade 테이블에서 급여 등급(grade)를 오름차순, 최고급여(hisal) 내림차순으로 정렬해보기
select * from salgrade;
select * from SALGRADE order by GRADE ASC, HISAL desc;

-- where 조건식 => 조건식이 참(TRUE)일 때만 출력
select * from EMP where DEPTNO=30;

-- 예제1) 직무(JOB)가 'SALESMAN'인 사원 조회
select * from EMP where JOB='SALESMAN';

-- 퀴즈1) 급여(SAL)이 1000 이상인 사람만 조회
select * from EMP where SAL>=1000;
-- 퀴즈2) 입사일(HIREDATE)가 '1981-02-20' 이후인 사원만 조회
select * from EMP where HIREDATE>'81-02-20' order by HIREDATE DESC;
-- 퀴즈3) 부서 번호가 10이 아닌 사원만 조회 ...아니라는 표현은 ' <> ' ' != '
select * from EMP where DEPTNO<>10;
select * from EMP where DEPTNO!=10 order by DEPTNO;

-- AND, OR 연산자 사용
SELECT * FROM EMP WHERE DEPTNO = 30 AND JOB = 'SALESMAN';
SELECT * FROM EMP WHERE JOB = 'CLERK' or JOB = 'MANAGER';

-- 괄호 사용 => 우선순위 명확히 하기
-- 부서 번호가 10또는 20이고, 급여가 2000 초과인 경우
SELECT * FROM EMP WHERE (DEPTNO = 10 OR DEPTNO = 20) AND SAL >2000;

-- 퀴즈1) 급여가 1500이상이고, 커미션이 NULL이 아닌 사원만 조회 (= IS NOT NULL)
SELECT * FROM EMP WHERE SAL>=1500 AND COMM is not null ORDER BY SAL;
-- 퀴즈2) 직무가 'SALESMAN' 이거나, 급여가 3000 이상인 사원 출력
SELECT * FROM EMP WHERE JOB = 'SALESMAN' OR SAL >=3000 ORDER BY SAL;
-- 퀴즈3) 부서번호가 10 20 30중 하나이고(= IN(10,20,30), 급여가 2000이상인 사원 출력
SELECT * FROM EMP WHERE DEPTNO IN(10,20,30) AND SAL>=2000 ORDER BY DEPTNO;
-- => DEPTNO IN(10,20,30) = (DEPTNO =10 OR DEPTNO = 20 OR DEPTNO = 30)
SELECT * FROM EMP WHERE (DEPTNO = 10 OR DEPTNO = 20 OR DEPTNO = 30) AND SAL>=2000 ORDER BY DEPTNO;

SELECT ENAME, SAL * 12 AS "Annual Salary" FROM EMP;

-- 이름이 알파벳 'L'보다 뒤에
SELECT * FROM EMP WHERE ENAME > 'L';
-- 이름이 'MILLER'보다 알파벳순으로 앞에 오는
SELECT * FROM EMP WHERE ENAME < 'MILLER';

-- 등가비교 연산자 (아니다) !=, <>, ^=
--예제) JOB CLERK 이 아닌 사원만 출력해보기
SELECT * FROM EMP WHERE JOB != 'CLERK';
SELECT * FROM EMP WHERE JOB <> 'CLERK';
SELECT * FROM EMP WHERE JOB ^= 'CLERK';

-- NOT 연산자
--예제) JOB이 MANAGER가 아닌 사원만
SELECT * FROM EMP WHERE NOT JOB ='MANAGER';

-- IN 연산자 IN(값1, 값2, 값3, ...)
-- OR을 간결히 사용하기
-- 컬럼의 값이 IN 연산자 안의 값을 만족하면 TRUE
--예제) 부서 번호가 10, 30 이 아닌 사원을 출력 (NOT IN)
SELECT * FROM EMP WHERE DEPTNO NOT IN(10,30);

-- BETWEEN A AMD B
-- 예제) 급여가 1500이상, 3000이하 인 사원 출력해보기
SELECT * FROM EMP WHERE SAL BETWEEN 1500 AND 3000;
-- 예제 반대로 ...NOT BETWEEN 
SELECT * FROM EMP WHERE SAL NOT BETWEEN 1500 AND 3000;

-- LIKE 연산자 컬럼명 LIKE '조건식'
-- % : 모든글자
-- _ : 특정글자수
-- 예제 )사원명이 S로 시작하는 사원 출력해보기 'S%'
SELECT * FROM EMP WHERE ENAME LIKE 'S%' ;
-- 예제) 사원명이 두번째 글자에 L로 시작하는 사원 출력해보기 '_글자명%'
SELECT * FROM EMP WHERE ENAME LIKE '_L%';
SELECT * FROM EMP WHERE ENAME NOT LIKE '_L%';
-- 예제) 사원명이 AM 글자를 포함하는 사원 출력해보기 '_글자명%'
SELECT * FROM EMP WHERE ENAME LIKE '%AM%';
SELECT * FROM EMP WHERE ENAME NOT LIKE '%AM%';

-- IS NULL / IS NOU NULL
-- 예제) 커미션이 NULL 인 사원만
SELECT * FROM EMP WHERE COMM IS NULL;
SELECT * FROM EMP WHERE COMM IS NOT NULL;

-- AND, OR 사용
SELECT * FROM EMP WHERE JOB = 'SALESMAN' AND COMM IS NOT NULL;
SELECT * FROM EMP WHERE JOB = 'MANAGER' OR MGR IS NULL;

-- 2 집합 연산자 UNION / UNION ALL
-- UNION 중복제거 // CLERK가 중복이 안 됨
SELECT * FROM EMP WHERE JOB = 'MANAGER' OR DEPTNO =10;

SELECT * FROM EMP WHERE JOB = 'MANAGER' UNION 
SELECT * FROM EMP WHERE DEPTNO = 10;
-- UNION ALL 중복 포함 CLERK가 중복이 됨
SELECT * FROM EMP WHERE JOB = 'MANAGER' UNION ALL
SELECT * FROM EMP WHERE DEPTNO = 10;

-- 3 MINUS (차집합)
-- 부서번호가 10번인 사원들중에서 직무가 MANAGER인 사원을 제외한 모든사원출력
SELECT * FROM EMP WHERE DEPTNO = 10 MINUS
SELECT * FROM EMP WHERE JOB = 'MANAGER';

-- 4 INTERSECT (교집합)
-- JOB이 CLERK 이면서 동시에, 부서번호가 20인 모든 사원 출력
SELECT * FROM EMP WHERE JOB = 'CLERK' INTERSECT
SELECT * FROM EMP WHERE DEPTNO = 20;

-- 퀴즈1)급여가 2500 이상인 사원들의 이름과 급여 조회
SELECT ENAME,SAL FROM EMP WHERE SAL >=2500;

-- 퀴즈2)부서번호가 10 또는 20 이면서, 직무가 'CLERK'인 사원 조회
SELECT * FROM EMP WHERE (DEPTNO =10 OR DEPTNO= 20) AND JOB = 'CLERK';
SELECT * FROM EMP WHERE DEPTNO IN(10, 20) AND JOB = 'CLERK';

-- 퀴즈3)AND 연산자 조합으로 수당이 존재하지 않는 사원 중에서 직무가 'SALESMAN'인 사원 조회하기
SELECT * FROM EMP WHERE COMM IS NULL AND JOB = 'SALESMAN';

-- 퀴즈4) 직무가 'CLERK'인 사원 중 급여가 1000 이상 1500 이하 인 사원 조회
SELECT * FROM EMP WHERE JOB = 'CLERK' AND SAL BETWEEN 1000 AND 1500;

-- 퀴즈5) 이름에 'DA'를 포함하는 사원 이름과 직무를 조회
SELECT ENAME, JOB FROM EMP WHERE ENAME LIKE '%DA%';

-- 퀴즈6) 부서번호가 10번인 사원 중에서 직무가 'MANAGER'가 아닌 사원을 출력하기
--  단, MGR이 NULL인 사원도 포함.
SELECT * FROM EMP WHERE DEPTNO =10 AND (JOB ^= 'MANAGER' OR MGR IS NULL);
SELECT * FROM EMP WHERE DEPTNO =10 AND JOB ^= 'MANAGER' AND MGR IS NOT NULL;
-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
SELECT ENAME, LENGTH(ENAME) FROM EMP;
SELECT SYSDATE - HIREDATE FROM EMP;
SELECT ENAME, CASE WHEN JOB = 'MANAGER' THEN 'Y' ELSE 'N' END AS IS_MANAGER FROM EMP;