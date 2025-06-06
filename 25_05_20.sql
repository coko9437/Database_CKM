select * from emp;
select * from dept;
select * from salgrade; 

desc emp;
desc dept;
desc salgrade;

SELECT JOB, SUBSTR(JOB,1,2), SUBSTR(JOB,6) FROM EMP;
-- 조금 어려운 표현 
-- PRESIDENT
-- 123456789 ,정방향 표현
-- -9-8-7-6-5-4-3-2-1
SELECT JOB, SUBSTR(JOB,-LENGTH(JOB)),
SUBSTR(JOB,-LENGTH(JOB),3)
FROM EMP;
SELECT SUBSTR('HELLO',-5, 2) FROM DUAL;

--INSTR ,  문자의 특정 위치 추출 해보기. 
-- INSTR(컬러명(문자열),찾기 위한 문자, 시작 위치, 몇번째 출현 )
SELECT INSTR('HELLO HI LOTTO', 'L'),
INSTR('HELLO HI LOTTO', 'L',5),
INSTR('HELLO HI LOTTO', 'L',2,2),
INSTR('HELLO HI LOTTO', 'O',2,2)
FROM DUAL;

--REPLACE 
SELECT '010-7661-3709' AS "변경전 문자열",
REPLACE('010-7661-3709','-',' ') AS "-,공백으로 변경",
REPLACE('010-7661-3709','-') AS "변경 옵션이 없을경우"
FROM DUAL;

-- 검색 결과 대소문자 상관없이 검색이 되게
SELECT ENAME FROM EMP WHERE LOWER(ENAME) = LOWER('scott');
SELECT ENAME FROM EMP WHERE ENAME LIKE UPPER('%am%');
-- 기존 데이터를 전부 소문자로 바꾼 후 입력도 소문자로만 검색
SELECT ENAME FROM EMP WHERE LOWER(ENAME) LIKE LOWER('%Am%');

SELECT SYSDATE FROM DUAL;
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;
SELECT MONTHS_BETWEEN(SYSDATE, HIREDATE) FROM EMP;

-- ////////////////////////////////////////////////////////////////////////////
SELECT SYSDATE FROM DUAL;
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;
SELECT ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE),3) FROM EMP;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
SELECT SYSDATE FROM DUAL;

-- 다음 금요일.. 서버언어가 한국어라서.
SELECT NEXT_DAY(SYSDATE, '금요일') FROM DUAL;

SELECT LAST_DAY(SYSDATE) FROM DUAL;

SELECT ROUND(SYSDATE, 'MONTH'), TRUNC(SYSDATE, 'MONTH') FROM DUAL;

SELECT ENAME, ADD_MONTHS(HIREDATE, 120) AS "입사 10주년" FROM EMP;

-- 퀴즈1) 입사일로부터 32년d이 지난 사원만 출력해보기
SELECT * FROM EMP WHERE ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE),0)>384;
-- 퀴즈2) 사원별로 입사일 기준 다음 월요일 출력해보기
SELECT ename, hiredate, NEXT_DAY(HIREDATE, '월요일') AS "입사일기준다음월요일" FROM EMP;
-- 퀴즈3) 사원의 입사일을 월 단위로 반올림해서 출력해보기.
SELECT ROUND(HIREDATE,'MONTH') AS "입사일" FROM EMP;
SELECT ename, HIREDATE AS "입사일", ROUND(HIREDATE,'MONTH') AS "반올림후 월단위로" FROM EMP;

-- 변환함수 : 날짜 <--> 문자열 , 숫자 <--> 문자열
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS "날짜를 문자열으로" FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL;
SELECT ENAME, TO_CHAR(SAL,'999,999.0') AS "숫자를 문자열으로" FROM EMP;
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"', 'NLS_DATE_LANGUAGE=KOREAN') FROM DUAL;

-- 급여에 끝자리 단위를 달러 표기 해보기
SELECT '급여 : ' ||TO_CHAR(3000, '999,999.0')|| '$' FROM DUAL;
SELECT ENAME, '급여 :'||TO_CHAR(SAL, '999,999.0')||'$' FROM EMP;

-- D-Day 예제) 문자열 --> 날짜타입
SELECT TO_DATE('2025-06-01', 'YYYY-MM-DD') - SYSDATE AS "6월1일 디데이" FROM DUAL;
SELECT ROUND(TO_DATE('2025-06-01', 'YYYY-MM-DD') - SYSDATE) AS "6월1일 디데이 반올림" FROM DUAL;
SELECT TRUNC(TO_DATE('2025-06-01', 'YYYY-MM-DD') - SYSDATE) AS "6월1일 디데이 버림" FROM DUAL;
SELECT TRUNC((TO_DATE('2025-06-01', 'YYYY-MM-DD') - SYSDATE) * 24) AS "남은시간 표기" FROM DUAL;

-- 퀴즈1) 1981년 1월 이후 입사한 사원 출력
DESC EMP;
-- HIREDATE : DATE타입, 즉 문자열에서 -> 날짜 타입으로 변환
-- SELECT ENAME, TO_CHAR(H IREDATE, 'YYYY-MM') AS "날짜를 문자열로" FROM EMP WHERE HIREDATE>'1981-01-31' ORDER BY HIREDATE;
SELECT * FROM EMP WHERE HIREDATE > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- 퀴즈2) 월 / 요일을 각각 'MM월', '요일' 형식으로 출력 날짜를 문자열로
SELECT TO_CHAR(SYSDATE, 'MM')||'월' AS "MM월",TO_CHAR(SYSDATE, 'DAY') AS "무슨요일" FROM DUAL;
-- TO_CHAR(SYSDATE, 'MM')||'월' ---> TO_CHAR(SYSDATE, 'MM"월"') AS "MM월" //// TO_CHAR(SYSDATE, 'DAY')||'요일'

-- 퀴즈3) 숫자 문자열 '1,200'을 숫자로 변환하여 300을 더한 값 출력해보기
SELECT TO_NUMBER('1,200' , '9,999') +300 AS "출력하면?" FROM DUAL;

SELECT ENAME, JOB, COMM, NVL(COMM,0), NVL2(COMM,'O','X') FROM EMP;

-- 퀴즈1)EMP테이블에서 커미션이 있는 직원 'O' 나머지 'X' NVL2 사용, 별칭: 수당 //
SELECT ENAME, COMM, NVL2(COMM,'O','X') AS "수당", SAL*12 + NVL(COMM,0) AS "전체급여"  FROM EMP;
-- 퀴즈2) 연봉계산해보기 NVL사용 NULL인 경우 0으로. 별칭 : 전체급여
SELECT ENAME, SAL, COMM, NVL(COMM,0) AS "상여금 액수", SAL*12 + NVL(COMM,0) AS "전체급여" FROM EMP;

-- DECODE(표현식,  값1,반환값1, 값2,반환값2, ... '기본값')
SELECT ENAME, DECODE(JOB, 'MANAGER','관리자', 'CLERK','직원', 'SALESMAN','영업사원', 'PRESIDENT','왕', 'ANALYST','조사팀', '잡부')AS "DECODE 결과" FROM EMP;
-- CASE 컬럼명 WHEN 값1 THEN 변환값1, WHEN 값2 THEN 변환값2, WHEN 값3 THEN 변환값3, ... END 
SELECT ENAME, CASE DEPTNO WHEN 10 THEN'인사과' WHEN 20 THEN'개발과' WHEN 30 THEN'영업과'  ELSE '기타부서' END AS "부서명" FROM EMP;

-- 급여에 따라 등급부여 
-- E : EMP , S : SALGRADE , D : DEPT
SELECT E.ENAME, E.SAL, CASE WHEN E.SAL BETWEEN S.LOSAL AND S.HISAL THEN S.GRADE END AS "급여 등급" FROM EMP E, SALGRADE S;
SELECT E.ENAME, E.SAL, CASE WHEN E.SAL BETWEEN 1000 AND 1500 THEN 'C' WHEN E.SAL BETWEEN 1501 AND 2000 THEN 'B' END AS "BETWEEN" FROM EMP E, SALGRADE S;

-- 퀴즈1) DECODE로 JOB에 따른 직책 명시 // CLERK:사원, MANAGER:관리자, ANALYST:분석가 // 별칭 : 직책이름
SELECT ENAME, JOB, DECODE(JOB, 'CLERK','사원', 'MANAGER','관리자', 'ANALYST','분석가', '잡부') AS "직책이름" FROM EMP;
-- 퀴즈2) CASE로 근속연수 분류, HIREDATE 기준, 1982년 이전 : 장기근속, 이후: 일반 // 별칭: 근속연수
SELECT ENAME, HIREDATE, CASE WHEN HIREDATE<'1982-01-01' THEN '장기근속' ELSE '일반' END AS "근속연수" FROM EMP;
--                                         TO_DATE('1982-01-01','YYYY-MM-DD')
-- 퀴즈3) CASE 단순형으로 DEPTNO에 따라 위치 표시 // 10:NEW YORK, 20: DALLAS, 30 : CHICAGO // 별칭 : 근무지역
SELECT ENAME, DEPTNO, CASE WHEN DEPTNO=10 THEN 'NEW YORK' WHEN DEPTNO=20 THEN 'DALLAS' WHEN DEPTNO=30 THEN 'CHICAGO' ELSE '노숙자' END AS "근무지역" FROM EMP; 
SELECT ENAME, DEPTNO, CASE DEPTNO WHEN 10 THEN 'NEW YORK' WHEN 20 THEN 'DALLAS' WHEN 30 THEN 'CHICAGO' ELSE '노숙' END AS "근무지역" FROM EMP; 

-- 하나의 열에 출력 결과를 담는 다중행 함수
--  => 집계함수 (AGGREGATE, 갯수, 평균, 합계, 최대, 최소 등

-- 전체 급여 합계
-- 결론 : 다중 행 함수는 단일 행 함수와 달리 집계처리가 핵심.
SELECT MAX(SAL), MIN(SAL), SUM(SAL) FROM EMP;

-- 갯수 구해보기 (급여를 받는 사원의 수) COUNT() : NULL값도 읽은뒤 제외한다!
SELECT COUNT(SAL), COUNT(COMM) FROM EMP;

-- 부서 번호가 30인 사원의 수
-- COUNT(*) : NULL 여부에 관계없이 해당 조건을 만족하는 전체 행의 수를 반환한다.
-- => COMM, MGR에 NULL도 포함.
SELECT COUNT(*) FROM EMP WHERE DEPTNO=30;

-- 퀴즈1) 부서번호가 10 인 사원들의 최대 / 최소 급여를 출력,  별칭 : 최대급여 / 최소급여
SELECT MAX(SAL) AS "최대급여", MIN(SAL) AS "최소급여" FROM EMP WHERE DEPTNO=10;
-- 퀴즈2) 부서번호가 20 인 사원들의 입사일중 가장 오래된 날짜 출력,  별칭 : 가장 오래된 날짜
SELECT MIN(HIREDATE) AS "가장 오래된 날짜" FROM EMP WHERE DEPTNO=20;
-- 퀴즈3) 중복된 급여를 제외한(DISTINCT) 평균 급여를 출력,  별칭 : 평균 급여 
SELECT AVG(DISTINCT(SAL)) AS "평균급여" FROM EMP;
SELECT ENAME, SAL, HIREDATE, DEPTNO FROM EMP WHERE DEPTNO=20;

-- GROUP BY는 지정한 열을 기준으로 데이터를 묶고 그 묶음에 대해 집계함수를 적용하는 기능
-- SELECT 그룹열, 집계함수~~ FROM 테이블 GROUP BY 그룹열 [ORDER BY 정렬열]   <=== 조건식
SELECT DEPTNO, AVG(SAL) AS "부서번호별 평균값" FROM EMP GROUP BY DEPTNO ORDER BY DEPTNO ASC;
SELECT JOB, AVG(SAL) AS "직책별 평균값"FROM EMP GROUP BY JOB ORDER BY AVG(SAL);
-- 부서번호별 + 직책별 월급의 평균값
SELECT DEPTNO, JOB, AVG(SAL) FROM EMP GROUP BY DEPTNO, JOB;
-- 부서 인원별
SELECT DEPTNO, COUNT(*), AVG(SAL) FROM EMP GROUP BY DEPTNO ORDER BY DEPTNO;

SELECT DEPTNO, AVG(SAL) AS "부서번호별 평균값" FROM EMP GROUP BY DEPTNO ORDER BY AVG(SAL) DESC;

-- 퀴즈1) 부서번호와 직책별 평균 급여 출력 / 평균 급여를 기준으로 내림차순(DESC); , 별칭 : 평균급여
SELECT DEPTNO, JOB, AVG(SAL) AS "평균급여" FROM EMP GROUP BY DEPTNO, JOB ORDER BY AVG(SAl) DESC;
-- 퀴즈2)GROUP BY 절에 포함되지 않은 ENAME을 사용하여 오류상황 만들기
SELECT EMPNO, HIREDATE, COUNT(*) FROM EMP GROUP BY HIREDATE;
-- 퀴즈3)각 부서별 보너스(COMM)가 있는 사원의 수 구하기 , 별칭 : 보너스
SELECT DEPTNO, COUNT(COMM) AS "부서별 보너스" FROM EMP WHERE COMM IS NOT NULL GROUP BY DEPTNO;
SELECT DEPTNO, COUNT(COMM) AS "부서별 보너스" FROM EMP GROUP BY DEPTNO;
-- WHERE COMM IS NOT NULL <-- 조건을 줘서 실행해도 안나오게 하고싶을때.

-- 그룹으로 나눈 대상에, 필터(집계하기) ... 평균 갯수 최대최소 카운트 ...
-- SELECT 그룹열, 집계함수 FROM 테이블명 / WHERE [조건] / GROUP BY 그룹열 / [HAVING 집계조건] / ORDER BY 정렬조건;
                                    -- 행 필터링                        -- 그룹 필터링

-- 평균 급여가 3000 이상인 부서 출력
SELECT DEPTNO, ROUND(AVG(SAL)) FROM EMP GROUP BY DEPTNO HAVING AVG(SAL) >=2000 ORDER BY DEPTNO ASC;
-- 사원수가 3명 이상인 집책 그룹만 출력
SELECT JOB, COUNT(JOB) FROM EMP GROUP BY JOB HAVING COUNT(JOB) >=3;
SELECT JOB, COUNT(*) FROM EMP GROUP BY JOB HAVING COUNT(*) >=3;

-- WHERE절과 HAVING절 같이 사용
SELECT DEPTNO, AVG(SAL) FROM EMP WHERE DEPTNO IN(10,20) GROUP BY DEPTNO HAVING AVG(SAL)>500;
SELECT DEPTNO, AVG(SAL) FROM EMP WHERE JOB='SALESMAN' GROUP BY DEPTNO HAVING AVG(SAL)>500;

-- 퀴즈1)평균 급여 2500 이상인 부서의 부서번호/평균급여 출력 AS 평균급여
    SELECT DEPTNO, AVG(SAL) FROM EMP GROUP BY DEPTNO HAVING AVG(SAL) >=2500;
-- 퀴즈2)부서별 사원수 4명 이상인 부서만 출력 AS 사원수
    SELECT DEPTNO, COUNT(*) FROM EMP GROUP BY DEPTNO HAVING COUNT(*) >=4;
-- 퀴즈3)WHERE 절 사용, 부서번호 10,20번 필터링, 그중 평균 급여가 3000 이상인 부서만 출력 AS 
    SELECT DEPTNO, AVG(SAL) FROM EMP WHERE DEPTNO IN(10,20) GROUP BY DEPTNO HAVING AVG(SAL)>=3000;