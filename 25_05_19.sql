select * from emp;
select * from dept;
select * from salgrade; 

desc emp;
desc dept;
desc salgrade;

-- 예제) 이름을 모두 대문자로 출력
SELECT ENAME ,UPPER(ENAME) AS "사원명 대문자" FROM EMP;
SELECT ENAME ,LOWER(ENAME) AS "사원명 소문자" FROM EMP;
SELECT ENAME ,INITCAP(ENAME) AS "첫글자 대문자" FROM EMP;
SELECT ENAME ,UPPER(ENAME) AS "사원명 대문자" ,LOWER(ENAME) AS "사원명 소문자" ,INITCAP(ENAME) AS "첫글자 대문자" FROM EMP;

-- 예제) 사원 이름의 길이 출력
SELECT ENAME ,LENGTH(ENAME) AS "사원이름의 길이",
LENGTHB(ENAME) AS "사원의 바이트 길이" FROM EMP;

-- 문자열찾기 INSTR (컬럼명('문자열'), '찾을문자', 시작위치, 몇번째)
-- 직문 문자열 안에 'A'가 포함된 위치
SELECT JOB ,INSTR (JOB,'A') AS "A의 위치" ,
SUBSTR (JOB,1,3) AS "1~3번째의 문자열",
REPLACE (JOB,'CLERK','직원') "한글 뜻" FROM EMP;
 -- SELECT * FROM table; - LPAD RPAD : 포맷 맞추기
 -- LPAD(컬럼명, 총길이, '채워질 문자') <--> RPAD //////////////////////////
 -- 남은 부분은 '채워질 문자'로 채움
SELECT ename, LPAD(ENAME, 5, '*') AS "5글자포맷,마스킹처리" FROM EMP;
SELECT ename, RPAD(ENAME, 5, '*') AS "5글자포맷,마스킹처리" FROM EMP;
SELECT ename, LPAD(ENAME, 9, '*') AS "9글자포맷,마스킹처리" FROM EMP;

-- 문자열찾기 INSTR (컬럼명(문자열), '찾을문자', 시작위치, 몇번째)
-- TRIM : 문자열 양쪽 제거 ==> 목적 : 공백 또는 지정문자 제거 목적
-- TRIM(LEADING 앞에서제거| TRAILING 뒤에서제거| BOTH 양쪽제거[DEFAULT] '제거문자' FROM 문자열)
SELECT TRIM('   ORACLE   ') AS "양쪽 공백 제거",
LTRIM('   ORACLE   ') AS "왼쪽 공백 제거",
RTRIM('   ORACLE   ') AS "오른쪽 공백 제거" FROM DUAL;
-- DUAL 테이블 : 더미테이블임. 없는테이블 ... 주로 간단한 함수 테스트 목적으로 씀.

SELECT TRIM (BOTH '#' FROM '###HELLO###') AS "BOTH 결과",
TRIM ('#' FROM '###HELLO###') AS "BOTH (생략) 결과",
TRIM (LEADING '#' FROM '###HELLO###') AS "LEADING 결과",
TRIM (TRAILING '#' FROM '###HELLO###') AS "TRAILING 결과"
FROM DUAL;

-- 문자열 연결해보기
-- CONCAT(컬럼명1('문자열1'), 컬럼명2('문자열2')) ==> 문자열을 연결하는 함수
-- CONCAT : 2개까지만 가능, 그 이상 연결이 버티컬(||)사용
SELECT CONCAT(ENAME, JOB) AS "이름+직무" FROM EMP;
SELECT CONCAT('이', '상용') AS "성+이름" FROM DUAL;
SELECT '연결할 문자열 2개이상' || ' 버티컬 바 2개를 붙여서 사용' || '그러면 연결한 문자열을 합치기 가능함' FROM DUAL;


-- 퀴즈1) 주민번호에서 생년월일만 추출, SUBSTR 사용
SELECT SUBSTR('940323-1234567',1,6) AS "생년월일추출" FROM DUAL;

-- 퀴즈2) 이메일에서 @ 위치 찾기, 별칭은 '골뱅이위치',INSTR 사용
SELECT INSTR('coko9437@gmail.com', '@') AS "골뱅이위치" FROM DUAL;

-- 퀴즈3) 전화번호에서 - 제거해보기, 별칭은 '정리된 번호', REPLACE , FROM DUAL; 사용
SELECT REPLACE('010-8505-2594', '-', '') AS "정리된 번호" FROM DUAL;

-- 퀴즈4) 부서번호를 왼쪽으로 공백채우기, 별칭은 '정렬용' LPAD, emp테이블
SELECT DEPTNO, LPAD(DEPTNO, 11, ' ') AS "정렬용" FROM EMP;

-- 퀴즈5) 앞뒤 공백 제거해보기, 별칭은 '정리된 문자' 예제 문자열 : 공백공백공백(본인이름)공백공백공백, FROM DUAL; 사용
SELECT TRIM('   추교문   ') AS "정리된 문자" FROM DUAL;

-- 퀴즈6) 사원명+부서번호 합치기, 별칭은 '사원명+부서번호'CONCAT 사용, emp테이블
SELECT CONCAT (ENAME, JOB) AS "사원명+부서번호" FROM EMP;
SELECT ENAME || '-' || JOB AS "사원명+부서번호" FROM EMP;

-- 급여의 소수점 두번째 자리에서 반올림
SELECT ENAME, SAL, ROUND(SAL,-2) AS "ROUND(SAL,-2)" FROM EMP;
SELECT ENAME, SAL, ROUND(123.456,1) AS "ROUND(SAL,1)" FROM EMP;
-- 급여의 소수점 이하 자리제거
SELECT ENAME, SAL, TRUNC(123.456,2) AS "(123.456,2)" FROM EMP;
-- 사원 번호를 2로 나눈 나머지를 출력
SELECT ENAME, EMPNO, MOD(EMPNO,2) AS "2로나눈 나머지" FROM EMP;
--CEIL, FLOOR 비교 나눈값 SELECT올림/내림
SELECT ENAME, SAL, CEIL(SAL /3), FLOOR(SAL /3) FROM EMP;


-- 퀴즈1) 소수점 둘째자리까지 반올림해보기 / 123.4567
SELECT ROUND(123.4567,2) AS "둘째자리 반올림" FROM DUAL;
-- 퀴즈2) 소수점 첫째자리에서 내림해보기 TRUNC /123.4567
SELECT TRUNC(123.4567,0) AS "첫째 자리 내림" FROM DUAL;
-- 퀴즈3) CEIL, FLOOR / 1.5 -1.5
SELECT SAL, CEIL(SAL/1.5) AS "1.5로나눈후올림", FLOOR(SAL/-1.5) AS "-1.5로나눈후내림" FROM EMP;
-- 퀴즈4) 사원의 번호를 4로 나눈 나머지값을 출력 / 별칭은 "4로 나눈 나머지"
SELECT EMPNO, MOD(EMPNO,4) AS "4로 나눈 나머지" FROM EMP;
SELECT ROUND(1.5) AS "ROUND 1", CEIL(1.5)AS "CEIL 1", FLOOR(1.5)AS "FLOOR 1", ROUND(-1.5)AS "ROUND 2", CEIL(-1.5)AS "CEIL 2", FLOOR(-1.5)AS "FLOOR 2" FROM DUAL;
--/////////////////////////////////////////////////////////////////
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