SELECT * FROM DEPT;
INSERT INTO DEPT (dname, deptno, loc) VALUES (80, '개발부' , '서울');
-- SYSDATE 삽입;

commit;
select * from dept;

-- 퀴즈1) DEPT 테이블에 (99, 'AI팀','JEJU') 데이터를 추가하시오.ALTER
INSERT INTO DEPT (dname, DEPTNO, LOC) VALUES (99,'AI팀','JEJU');
COMMIT;
select * from dept;
-- 퀴즈2) EMP 테이블에 사번 1234, 이름 'LEE', 입사일을 SYSDATE로 추가하시오.ALTER

-- 퀴즈3) DEPT 테이블에 NULL을 포함한 값 삽입.