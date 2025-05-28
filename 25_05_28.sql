-- 정규화 
-- 이상현상(삽입/갱신/삭제 이상)
-- 제1정규형(1NF), 제2정규형(2NF), 제3정규형(3NF)의 개념
-- 예시 
-- 퀴즈 

-- 이상현상(삽입/갱신/삭제 이상)
-- 1. 삽입 이상. (insertion Anomaly)
-- 일부 정보를 추가하려는데 다른 정보가 없어 입력이 불가능한 문제 

-- 예시) 주문/고객/상품 컬럼이 한 테이블에 존재 
-- | 주문번호 | 고객명 | 상품명 | 수량 |
-- | ----    | ---    | ---   | -- |
-- | O001    | 홍길동  | 키보드 | 2  |
-- | 없음    | 없음  | 모니터 | 2  | -- 다른 정보가 ,주문번호, 고객명이 없기 때문에 추가 불가.

-- 새로운 상품 '모니터'를 등록 해보기, 
-- 문제점) 아직 주문이 발생하지 않았기 때문에, 주문번호와 고객명이 없음. 
-- 상품 정보를 입력하려면 주문 정보도 같이 넣어야하는 함. 
-- 입력 불가 또는 가짜 데이터 추가 해야함. 

-- 2 갱신이상 ( Update Anomaly)
-- 데이터의 일부만 수정되어, 불일치가 생기는 문제 
-- 예시 
-- ### 🔸 예시: 고객 정보가 중복 저장된 경우

-- | 주문번호 | 고객명 | 주소            |
-- | ----    | ---    | ---------        |
-- | O001    | 홍길동 | 서울 강남구      |
-- | O002    | 홍길동 | 서울 강서구 ←❌  |
-- 고객이 이사했는데 한 행만 주소를 수정하는 경우, 나머지는 수정하지 않음. 
-- 문제점, 동일한 고객 정보가 다르게 저장되어 , 불일치 발생. 

-- 3 삭제 이상 (Deletion Anomaly)
-- 하나의 데이터를 삭제하려다가 다른 필요한 정보까지 함께 삭제되는 문제 
-- 예시 
-- 상품 없이 고객을 저장하는 구조 
-- | 주문번호 | 고객명 | 상품명 |
-- | ---- | --- | --- |
-- | O001 | 홍길동 | 마우스 |
-- 주문 O001 이 취소되어, 행을 삭제하면, 
-- 고객 홍길동 정보까지 완전히 사라짐, 
-- 주문을 지우면서, 고객 정보도 함께 손실됨. 

-- 결론, 이런 이상현상은 한 테이블에 정보를 다 모아둬서, 
-- 그래서, 정규화 과정을 통해, 중복을 최소화 하고, 무결성 유지, 효율적인 데이터베이스 설계하기. 

-- 1 정규화 ( 1NF) : 
-- 모든 속성의 값이 원자값이어야한다. -> 하나의 컬럼에 값이 하나만 있어야한다.

-- | 고객ID  | 고객명   | 전화번호            |
-- | ----    | ---      | ------------------ |
-- | C001    | 홍길동   | 010-1234, 010-5678 |

-- 1NF 정규화 진행하기. 
-- | 고객ID | 고객명 | 전화번호 |
-- | ----   | ---    | -------- |
-- | C001   | 홍길동 | 010-1234 |
-- | C001   | 홍길동 | 010-5678 |


-- 2NF 정규화 
-- 부분 함수 종속 제거 
-- 문제점 제시,  (복합키 포함)
-- | 주문ID | 상품ID | 상품명   | 단가  |
-- | ----   | ----   | ------   | ----  |
-- | O001   | P001   | 노트북   | 150만 |
-- | O001   | P002   | 키보드   | 5만   |
-- | O002   | P001   | 노트북   | 150만 |
-- 기본키 = (주문ID, 상품 ID)
-- 상품명, 단가 는 상품ID 에만 종속 -> 부분 종속 발생

-- 2 정규화 , 하나의 테이블를 , 2개의 테이블로 분리. 
-- #### 🔹 주문 상세

-- | 주문ID | 상품ID |
-- | ---- | ---- |
-- | O001 | P001 |
-- | O001 | P002 |
-- | O002 | P001 |

-- #### 🔹 상품 테이블

-- | 상품ID | 상품명 | 단가     |
-- | ----   | ---    | ----     |
-- | P001   | 노트북 | 150만    |
-- | P002   | 키보드 | 5만      |

-- 3 정규화 :
-- 이행적 종속 제거 
-- 문제점 제시, 

-- | 사번   | 이름   | 부서코드 | 부서명  | 부서위치 |
-- | ---    | ---    | ----     | ---    | ----     |
-- | 101    | 김유신 | D01      | 총무부  | 3층   |
-- | 102    | 이순신 | D01      | 총무부  | 3층   |

-- 부서코드 -> 부서명, 부서위치 , 1번째 종속
-- 사번, -> 부서코드 -> 부서명 , 2번째 종속, = 이행적 종속

-- 3 정규화를 적용해보기. 2개 테이블 분리. 
-- #### 🔹 사원 테이블

-- | 사번   | 이름   | 부서코드 |
-- | ---    | ---    | ----     |
-- | 101    | 김유신 | D01      |
-- | 102    | 이순신 | D01      |

-- #### 🔹 부서 테이블

-- | 부서코드 | 부서명  | 부서위치  |
-- | ----     | ---    | ----     |
-- | D01      | 총무부 | 3층      |


-- ///퀴즈 
-- 제시된 문제 테이블를 , 1,2,3, 정규화를 통해서, 분리 작업 해주세요. 
-- | 학번 |  이름  | 수강과목   |     교수명    |
-- | ---- | ---    | ------     | -----------   |
-- | 1001 | 홍길동 | DB, 자바   | 김교수, 박교수|


-- 1NF) -- | 학번 |  이름  |  수강과목  | 교수명 |
        -- | 1001 | 홍길동 |  DB        | 김교수 |
        -- | 1001 | 홍길동 |  자바      | 박교수 |

-- 1정규화, 하나의 컬럼에 하나의 값만, 원자값으로 가지기.

-- 2NF) -- | 학번 |  이름  |  
        -- | 1001 | 홍길동 |

        -- |  학번   | 수강과목 | 교수명 |
        -- |  1001   |  DB      | 김교수 |
        -- |  1001   |  자바    | 박교수 |

-- 2정규화
-- 학번, 이름 : 1 테이블,  학번, 수강과목 , 교수명 : 2테이블 

-- 3NF) -- | 학번 |  이름   |
        -- | 1001 |  홍길동 |  

        -- | 학번 | 수강과목  |
        -- | 1001 | DB        |
        -- | 1001 | 자바      |
        
        -- |  수강과목  | 교수명 |
        -- |  DB        | 김교수 |
        -- |  자바      | 박교수 |

-- 3정규화  이행적 종속 제거 
-- 학번 , 수강 과목 : 1테이블,  수강 과목 , 교수명 : 2테이블 


--////////////////////////////////////////////////////////////
-- copilot, GPT , ai 툴을 이용해서, 

-- 샘플 디비 설계, (쇼핑몰 예시)
-- ERD 다이어그램 확인. 
-- 시퀀스 다이어그램 확인. 
-- DFD 다이어그램 확인.

-- 샘플 디비 설계, 쇼핑몰을 예시로 해서, 
-- 간단한 프롬프트 명령어를 작성 해보기. 

-- 예시 
-- 간단한 쇼핑몰 DB 설계를 할거야, 
-- 생각한 테이블은 사용자, 게시글, 댓글, 상품, 장바구니, 주문, 결제, 배송,
-- 중간 테이블 (장바구니에 담긴 상품), (주문된 상품)등도 고려해줘. 
-- 혹시나 빠진 중간 테이블이 있다면, 추가도 해줘. 
-- 설계한 코드는 DDL.sql 파일로 제공해주고, 
-- create 코드 형식으로 코드 알려줘

-- 1차 견본, 받은 후, 
-- 누락된 부분, 또는 테스트나 검증등을 해서 수정될 가능성이 있음. 
-- 검사 도구로, 다이어그램 등을 이용해서 그림으로 확인. 

-- 유저 테이블
CREATE TABLE USERS (
    USER_ID       NUMBER PRIMARY KEY,
    USERNAME      VARCHAR2(50) NOT NULL,
    PASSWORD      VARCHAR2(100) NOT NULL,
    EMAIL         VARCHAR2(100),
    PHONE         VARCHAR2(20),
    CREATED_AT    DATE DEFAULT SYSDATE
);

-- 게시글 테이블
CREATE TABLE POSTS (
    POST_ID       NUMBER PRIMARY KEY,
    USER_ID       NUMBER NOT NULL,
    TITLE         VARCHAR2(200),
    CONTENT       CLOB,
    CREATED_AT    DATE DEFAULT SYSDATE,
    CONSTRAINT FK_POSTS_USERS FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

-- 댓글 테이블
CREATE TABLE COMMENTS (
    COMMENT_ID    NUMBER PRIMARY KEY,
    POST_ID       NUMBER NOT NULL,
    USER_ID       NUMBER NOT NULL,
    CONTENT       VARCHAR2(1000),
    CREATED_AT    DATE DEFAULT SYSDATE,
    CONSTRAINT FK_COMMENTS_POST FOREIGN KEY (POST_ID) REFERENCES POSTS(POST_ID),
    CONSTRAINT FK_COMMENTS_USER FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

-- 상품 테이블
CREATE TABLE PRODUCTS (
    PRODUCT_ID    NUMBER PRIMARY KEY,
    NAME          VARCHAR2(100) NOT NULL,
    DESCRIPTION   VARCHAR2(500),
    PRICE         NUMBER(10,2) NOT NULL,
    STOCK         NUMBER DEFAULT 0,
    CREATED_AT    DATE DEFAULT SYSDATE
);

-- 장바구니 테이블
CREATE TABLE CART (
    CART_ID       NUMBER PRIMARY KEY,
    USER_ID       NUMBER NOT NULL,
    CREATED_AT    DATE DEFAULT SYSDATE,
    CONSTRAINT FK_CART_USER FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

-- 장바구니에 담긴 상품 (중간 테이블)
CREATE TABLE CART_ITEM (
    CART_ITEM_ID  NUMBER PRIMARY KEY,
    CART_ID       NUMBER NOT NULL,
    PRODUCT_ID    NUMBER NOT NULL,
    QUANTITY      NUMBER DEFAULT 1,
    CONSTRAINT FK_CART_ITEM_CART FOREIGN KEY (CART_ID) REFERENCES CART(CART_ID),
    CONSTRAINT FK_CART_ITEM_PRODUCT FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID)
);

-- 주문 테이블
CREATE TABLE ORDERS (
    ORDER_ID      NUMBER PRIMARY KEY,
    USER_ID       NUMBER NOT NULL,
    ORDER_DATE    DATE DEFAULT SYSDATE,
    STATUS        VARCHAR2(30) DEFAULT 'PENDING',
    CONSTRAINT FK_ORDER_USER FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

-- 주문된 상품 (중간 테이블)
CREATE TABLE ORDER_ITEM (
    ORDER_ITEM_ID NUMBER PRIMARY KEY,
    ORDER_ID      NUMBER NOT NULL,
    PRODUCT_ID    NUMBER NOT NULL,
    QUANTITY      NUMBER NOT NULL,
    PRICE         NUMBER(10,2) NOT NULL,
    CONSTRAINT FK_ORDER_ITEM_ORDER FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID),
    CONSTRAINT FK_ORDER_ITEM_PRODUCT FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID)
);

-- 결제 테이블
CREATE TABLE PAYMENT (
    PAYMENT_ID    NUMBER PRIMARY KEY,
    ORDER_ID      NUMBER NOT NULL,
    AMOUNT        NUMBER(10,2) NOT NULL,
    METHOD        VARCHAR2(50),
    PAID_AT       DATE,
    CONSTRAINT FK_PAYMENT_ORDER FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID)
);

-- 배송 테이블
CREATE TABLE SHIPPING (
    SHIPPING_ID   NUMBER PRIMARY KEY,
    ORDER_ID      NUMBER NOT NULL,
    ADDRESS       VARCHAR2(300),
    STATUS        VARCHAR2(30) DEFAULT 'PREPARING',
    SHIPPED_AT    DATE,
    CONSTRAINT FK_SHIPPING_ORDER FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID)
);


-- 누락된 부분, 또는 테스트나 검증등을 해서 수정될 가능성이 있음. 
-- 예시)
-- 제공 해준 테이블을 이용해서 샘플 데이터를 추가하는 예시를 제공해줘.
-- 각각의 모든 테이블을 검사 할 수 있는 샘플 데이터를 추가하는 예시코드
-- 추가하는 명령어, 조회하는 명령어도 같이 첨부해줘.

-- 샘플 데이터 추가 예시 및 조회 예시)
-- INSERT // USERS
INSERT INTO USERS (USER_ID, USERNAME, PASSWORD, EMAIL, PHONE) 
                VALUES (1, 'john_doe', 'password123', 'john@example.com', '010-1234-5678');

-- SELECT
SELECT * FROM USERS;

-- INSERT // POSTS
INSERT INTO POSTS (POST_ID, USER_ID, TITLE, CONTENT) 
                VALUES (1, 1, '첫 번째 게시글', '이것은 테스트 게시글입니다.');

-- SELECT
SELECT * FROM POSTS;

-- INSERT // COMMENTS
INSERT INTO COMMENTS (COMMENT_ID, POST_ID, USER_ID, CONTENT) 
                VALUES (1, 1, 1, '좋은 글 감사합니다!');

-- SELECT
SELECT * FROM COMMENTS;

-- INSERT // PRODUCTS
INSERT INTO PRODUCTS (PRODUCT_ID, NAME, DESCRIPTION, PRICE, STOCK) 
                    VALUES (1, '무선 마우스', '편리한 무선 마우스', 25000, 100);

-- SELECT
SELECT * FROM PRODUCTS;

-- INSERT // CART
INSERT INTO CART (CART_ID, USER_ID) 
                VALUES (1, 1);

-- SELECT
SELECT * FROM CART;

-- INSERT // CART_ITEM
INSERT INTO CART_ITEM (CART_ITEM_ID, CART_ID, PRODUCT_ID, QUANTITY) 
                VALUES (1, 1, 1, 2);

-- SELECT
SELECT * FROM CART_ITEM;

-- INSERT // ORDERS
INSERT INTO ORDERS (ORDER_ID, USER_ID, STATUS) 
                VALUES (1, 1, 'PENDING');

-- SELECT
SELECT * FROM ORDERS;

-- INSERT // ORDER_ITEM
INSERT INTO ORDER_ITEM (ORDER_ITEM_ID, ORDER_ID, PRODUCT_ID, QUANTITY, PRICE) 
                    VALUES (1, 1, 1, 2, 25000);

-- SELECT
SELECT * FROM ORDER_ITEM;

-- INSERT // PAYMENT
INSERT INTO PAYMENT (PAYMENT_ID, ORDER_ID, AMOUNT, METHOD, PAID_AT) 
                VALUES (1, 1, 50000, 'Credit Card', SYSDATE);

-- SELECT
SELECT * FROM PAYMENT;

-- INSERT // SHIPPING
INSERT INTO SHIPPING (SHIPPING_ID, ORDER_ID, ADDRESS, STATUS, SHIPPED_AT) 
                    VALUES (1, 1, '서울특별시 강남구 테헤란로 123', 'SHIPPED', SYSDATE);

-- SELECT
SELECT * FROM SHIPPING;
                                                                                                                           



-- 검사 도구로, 다이어그램 등을 이용해서 그림으로 확인. 

-- 아래 사이트에서 그림 도식화 할 예정.
-- https://gist.github.com ==> .md 파일에 mermaid 라는 문법을 통해서 erd그림 그리기

-- 예시) 이미 코파일럿/챗GPT에 연속적으로 작업중이라 이미 메모리에 작성된 테이블이 있을것임.
        -- 만약 아니라면 실제 테이블을 같이 복사하고 물어보기.
-- 위에 작성된 ddl.sql 파일에 create 테이블을 참고해서 mermaid 문법으로 erd 다이어그램 작성하는 코드를 생성해줘.


-- 1차 결과 코드에서 앞쪽에 `백틱 3개가 있고, 맨 마지막에도 1백틱 3개가 있음.
-- 여기서 마지막 백틱 3개는 삭제.
```mermaid
erDiagram
    USERS ||--o{ POSTS : "writes"
    USERS ||--o{ COMMENTS : "writes"
    USERS ||--o{ CART : "owns"
    USERS ||--o{ ORDERS : "places"

    POSTS ||--o{ COMMENTS : "has"

    PRODUCTS ||--o{ CART_ITEM : "is in"
    PRODUCTS ||--o{ ORDER_ITEM : "is in"

    CART ||--o{ CART_ITEM : "contains"

    ORDERS ||--o{ ORDER_ITEM : "contains"
    ORDERS ||--|{ PAYMENT : "has"
    ORDERS ||--|{ SHIPPING : "has"

    USERS {
        NUMBER USER_ID PK
        VARCHAR USERNAME
        VARCHAR PASSWORD
        VARCHAR EMAIL
        VARCHAR PHONE
    }

    POSTS {
        NUMBER POST_ID PK
        NUMBER USER_ID FK
        VARCHAR TITLE
        CLOB CONTENT
    }

    COMMENTS {
        NUMBER COMMENT_ID PK
        NUMBER POST_ID FK
        NUMBER USER_ID FK
        VARCHAR CONTENT
    }

    PRODUCTS {
        NUMBER PRODUCT_ID PK
        VARCHAR NAME
        VARCHAR DESCRIPTION
        NUMBER PRICE
        NUMBER STOCK
    }

    CART {
        NUMBER CART_ID PK
        NUMBER USER_ID FK
    }

    CART_ITEM {
        NUMBER CART_ITEM_ID PK
        NUMBER CART_ID FK
        NUMBER PRODUCT_ID FK
        NUMBER QUANTITY
    }

    ORDERS {
        NUMBER ORDER_ID PK
        NUMBER USER_ID FK
        DATE ORDER_DATE
        VARCHAR STATUS
    }

    ORDER_ITEM {
        NUMBER ORDER_ITEM_ID PK
        NUMBER ORDER_ID FK
        NUMBER PRODUCT_ID FK
        NUMBER QUANTITY
        NUMBER PRICE
    }

    PAYMENT {
        NUMBER PAYMENT_ID PK
        NUMBER ORDER_ID FK
        NUMBER AMOUNT
        VARCHAR METHOD
        DATE PAID_AT
    }

    SHIPPING {
        NUMBER SHIPPING_ID PK
        NUMBER ORDER_ID FK
        VARCHAR ADDRESS
        VARCHAR STATUS
        DATE SHIPPED_AT
    }
    
--  ERD 다이어그램 예시 : https://gist.github.com/coko9437/41ff7a28938f2747aff082f374f67331

-- gist.github.com 사이트 접속,로그인 --> 
-- README.md 파일을 만들어서 위 코드를 복사할 예정.

-- 같은 형식으로,
-- 2) DFD 다이어그램 코드 만들어줘.
-- gist.github.com 사이트 접속,로그인 --> 
-- README.md 파일을 만들어서 위 코드를 복사할 예정.
-- 앞쪽에 `백틱 3개가 있고, 맨 마지막에도 1백틱 3개가 있음.
-- 여기서 마지막 백틱 3개는 삭제.
```mermaid
graph TD
    %% 외부 엔티티
    User[사용자]
    Admin[관리자]

    %% 프로세스
    P1[회원가입 및 로그인]
    P2[상품 조회 및 장바구니]
    P3[주문 및 결제]
    P4[게시판 글/댓글 작성]
    P5[배송 처리]

    %% 데이터 저장소
    D1[(USERS)]
    D2[(PRODUCTS)]
    D3[(CART & CART_ITEM)]
    D4[(ORDERS & ORDER_ITEM)]
    D5[(PAYMENT)]
    D6[(SHIPPING)]
    D7[(POSTS & COMMENTS)]

    %% 사용자 흐름
    User --> P1
    P1 --> D1

    User --> P2
    P2 --> D2
    P2 --> D3

    User --> P3
    P3 --> D4
    P3 --> D5

    User --> P4
    P4 --> D7

    P3 --> D1
    P3 --> D2

    Admin --> P5
    P5 --> D6
    P5 --> D4

    P3 --> D6

-- DFD 다이어그램 : https://gist.github.com/coko9437/262f0a911b80315cbce33f1a1d044401

-- 3) 시퀀스 다이어그램 코드 만들어줘.
-- gist.github.com 사이트 접속,로그인 --> 
-- README.md 파일을 만들어서 위 코드를 복사할 예정.
-- 앞쪽에 `백틱 3개가 있고, 맨 마지막에도 1백틱 3개가 있음.
-- 여기서 마지막 백틱 3개는 삭제.
```mermaid
sequenceDiagram
    participant U as 사용자
    participant UI as 웹사이트 UI
    participant P as ProductController
    participant C as CartController
    participant O as OrderController
    participant DB as 데이터베이스

    %% 상품 조회
    U->>UI: 상품 목록 페이지 요청
    UI->>P: 상품 목록 요청
    P->>DB: SELECT * FROM PRODUCTS
    DB-->>P: 상품 목록 반환
    P-->>UI: 상품 목록 전달
    UI-->>U: 상품 목록 표시

    %% 장바구니 담기
    U->>UI: "장바구니에 담기" 클릭
    UI->>C: addToCart(userId, productId, quantity)
    C->>DB: INSERT INTO CART_ITEM
    DB-->>C: 성공 응답
    C-->>UI: 장바구니 추가 완료
    UI-->>U: 장바구니 담기 완료 메시지

    %% 주문 생성
    U->>UI: "주문하기" 클릭
    UI->>O: createOrder(userId)
    O->>DB: INSERT INTO ORDERS
    O->>DB: INSERT INTO ORDER_ITEM (장바구니 기준)
    DB-->>O: 성공 응답
    O-->>UI: 주문 생성 완료
    UI-->>U: 주문 완료 페이지 표시

    %% 결제 처리
    U->>UI: 결제 정보 입력 및 제출
    UI->>O: processPayment(orderId, paymentInfo)
    O->>DB: INSERT INTO PAYMENT
    DB-->>O: 결제 성공
    O-->>UI: 결제 완료
    UI-->>U: 결제 완료 메시지 표시

-- 시퀀스 : https://gist.github.com/coko9437/c5699faa8754bfa752cc4e71ff682dc4
 <script src="https://gist.github.com/coko9437/c5699faa8754bfa752cc4e71ff682dc4.js"></script>