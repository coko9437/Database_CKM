-- 테이블에 있는 데이터 수정하기

-- 기본 문법
-- UPDATE 테이블명 SET 수정할컬럼명 = 수정할값 WHERE 조건절;

-- 예시

update emp
   set
   sal = 1000;

-- 복사한 테이블에서 연습하기.
-- EMP -> EMP_COPY 테이블 복사
create table emp_copy
   as
      select *
        from emp;

select *
  from emp_copy;

-- 전체 수정
update emp_copy
   set
   sal = 1000;
commit;  --반영

-- 조건 수정
update emp_copy
   set
   sal = 2000
 where deptno = 10;
rollback; --되돌리기

-- 서브쿼리 활용
update emp_copy
   set
   sal = 2000
 where deptno = (
   select deptno
     from emp
    where job = 'ALLEN'
);

-- 퀴즈1) DEPT -> DEPT_TEMP2 테이블 복사해보기
--  DEPT_TEMP2 테이블에서 부서번호가 20번인 행의 지역을 'JEJU'로 수정
create table dept_temp2
   as
      select *
        from dept;
select *
  from dept_temp2;
update dept_temp2
   set
   loc = 'JEJU'
 where deptno = 20;
-- 퀴즈2) DEPT_TEMP2 테이블의 전체지역을 'SEOUL'로 수정
update dept_temp2
   set
   loc = 'SEOUL';
-- 퀴즈3) 직책이 'MANAGER'인 사원의 급여를 5000으로 수정
-- UPDATE DEPT_TEMP2 SET SAL = 5000 WHERE JOB = 'MANAGER';

update emp_copy
   set
   sal = 5000
 where job = 'MANAGER';

-- 테이블에 있는 데이터 삭제하기

-- 조건에 맞는 데이터 삭제 (EMP테이블에서 DEPTNO=30인 행을 삭제하기.)
delete from emp_copy
 where deptno = 30;
select *
  from emp_copy;
-- DELETE FROM 테이블명 WHERE 조건;
-- <서브쿼리> 활용한 삭제
delete from emp_copy
 where deptno in (
   select deptno
     from dept
    where loc = 'DALLAS'
);

-- 테이블에 있는 모든 데이터 삭제
delete from emp_copy;

--서브쿼리로 'DALLAS'에 있는 부서의 사원 삭제
delete from emp_copy
 where deptno in (
   select deptno
     from dept
    where loc = 'DALLAS'
);
select deptno
  from dept
 where loc = 'DALLAS';

-- 퀴즈1) EMP_TEMP2 테이블에서 급여가 3000 이상인 사원 삭제
create table emp_temp
   as
      select *
        from emp;
select *
  from emp;
delete from emp_temp2
 where sal >= 3000;
-- 퀴즈2)EMP_TEMP2 테이블에서 부서번호가 10 또는 20인 사원을 삭제.
delete from emp_temp2
 where deptno in ( 10,
                   20 );
-- 퀴즈3) EMP_TEMP2 테이블의 모든 데이터를 삭제.
delete from emp_temp2;


-- ////////////////////////////////////////////////

-- 하나의 단위로 데이터를 처리하는 트랜잭션

select *
  from emp_copy;

insert into emp_copy
   select *
     from emp;
commit; -- 반영

-- 순서1) EMP_COPY 테이블내 데이터 변경
update emp_copy
   set
   sal = sal + 10000
 where deptno = 10;
    
-- 순서2) 트랜잭션 저장
commit;
-- 순서3) 트랜잭션 취소
rollback;
-- 순서4) 특정 지점으로 설정
savepoint sp1;
-- 순서5) 특정 지점으로 롤백
rollback to sp1;

-- 퀴즈1) EMP -> EMP_COPY2 테이블 복사, 
    -- 부서 번호가 20인 사원들의 급여를 10% 인상 후, 조건에 따라 되돌릴수 있도록 SAVEPOINT (SP2)를 설정하시오.
savepoint sp2;
create table emp_copy2
   as
      select *
        from emp;
select *
  from emp_copy2;
update emp_copy2
   set
   sal = sal * 1.1
 where deptno = 20;
-- 퀴즈2)사번이 7839인 사원의 급여를 5000으로 변경, ROLLBACK만 하기
commit;
    --SAVEPOINT SP2;
update emp_copy2
   set
   sal = 6000
 where empno = 7839;
rollback;
-- 퀴즈3)여러 UPDATE후 COMMIT하지않고 전체를 ROLLBACK하기
update emp_copy2
   set
   sal = sal * 0.5
 where deptno in ( 10,
                   20 );
update emp_copy2
   set
   mgr = 2025
 where deptno in ( 30,
                   50 );
update emp_copy2
   set
   mgr = 2025
 where job = 'MANAGER';
select *
  from emp_copy2;
rollback;


-- 객체를 생성, 변경, 삭제하는 데이터 정의어 : DDL

-- CREATE : 객체를 생성하는 명령어

-- ALTER : 객체를 변경하는 명령어

-- DROP : 객체를 삭제하는 명령어

-- TRUNCATE : 테이블의 모든 데이터를 삭제하는 명령어

-- 테이블 이름 명명 할 때, 각각 언어의 예약어를 사용하면 안됨.
create table member (
   member_id    number(5) primary key, -- PK = 기본키.. NOT NULL + UNIQUE(중복불가)
   member_name  varchar2(20) not null, -- 값이 비어있으면 안됨.
   member_email varchar2(50) not null
);
select *
  from member;
-- 샘플 데이터 추가
insert into member_info (
   mamber_id,
   member_name,
   member_email
) values ( 1,
           '홍길동',
           'HONG@GMAIL.COM' );

insert into member_info (
   mamber_id,
   member_name,
   member_email
) values ( 2,
           '청길동',
           'CHEONG@GMAIL.COM' );

insert into member_info (
   mamber_id,
   member_name,
   member_email
) values ( 3,
           '흑길동',
           'BLACK@GMAIL.COM' );

-- 테이블 구조 변경
alter table member add member_phone varchar2(20);

-- 테이블 이름 변경하기 MEMBER -> MEMBER_INFO
alter table member rename to member_info;
select *
  from member_info;

-- 테이블 내용만 전체 삭제하기 -> 빈 테이블만 남음.
truncate table member_info;
-- 테이블 자체를 삭제하기
drop table member_info;

-- CHAR(30)과 VARCHAR2(30)의 차이점
-- CHAR(30)은 고정 길이 문자열, VARCHAR2(30)은 가변 길이 문자열

-- 퀴즈1) 테이블 : BOARD // 컬럼 : BOARD_ID(NUMBER 5), TITLE(VARCHAR2(30)), CONTENT(VARCHAR2(300)), WRITER(VARCHAR2(30)), REGDATE(DATE)
create table board (
   board_id number(5) primary key,
   title    varchar2(30) not null,
   content  varchar2(300) not null,
   writer   varchar2(30) not null,
   regdate  date not null
);
select *  from board;
insert into board (
         board_id, title, content, writer, regdate) 
    values ( 1, '제목1', '내용1', '작성자1', sysdate );
insert into board (
         board_id, title, content, writer, regdate)
    values ( 2, 'CREATE11', 'CONTENT11', 'WRITTER11', sysdate );
insert into board (
         board_id, title, content, writer, regdate)
    values ( 3, 'CREATE22', 'CONTENT22', 'WRITTER22', sysdate );
-- 퀴즈2) BOARD 테이블에 특정 컬럼의 타입 변경해보기. // WRITER VARCHART2 40으로 변경
alter table board modify
   writer varchar2(40);
-- 퀴즈3) BOARD 테이블에 내용만, 삭제해보기
truncate table board;

-- 인덱스의 정의 : 테이블에서 특정 열에 대한 빠른 검색을 지원하는 데이터 구조
-- 인덱스 생성하기 
-- 기본 문법 : CREATE INDEX 인덱스명 ON 테이블명 (열1, 열2, ...);
-- EMP의 SAL 급여를 이용해서 이름은 EMP_SAL_IDX로 인덱스 생성
CREATE INDEX EMP_SAL_IDX ON EMP (SAL);

--인덱스 목록 조회
SELECT * FROM USER_INDEXES;

-- 인덱스 컬럼 조회
SELECT * FROM USER_IND_COLUMNS WHERE INDEX_NAME = 'EMP_SAL_IDX';

-- 인덱스 삭제하기
DROP INDEX EMP_SAL_IDX;
