Use('test')//기본 데이터베이스는 test를 사용함. 생략시 기본 test 데이터베이스 사용


// SQL 사용하는 테이블 : NOSQL
//테이블 생성
// db.[테이블명].createCollection('test')//test라는 테이블을 생성함
// db.[테이블명].insertOne({
//     [컬럼명]: [값],
//     name: '홍길동',
//     age: 20,
//     favorite: ['apple', 'banana'],
//     })

//입력
// 한줄실행 : crtl + alt + s
// 전체실행 : crtl + alt + r
db.users.insertOne({
    name: '홍길동',
    age: 20,
    favorite: ['apple', 'banana'],
    })


//조회
// db.[테이블명].find({조건})//전체조회
db.users.find();

//수정
//조건에 맞는 첫번째 데이터 수정
//db.users.updateOne({조건}, {$set :{수정할값} }) //조건에 맞는 첫번째 데이터 수정
db.users.updateOne({name: '홍길동'},  //조건
    {$set: {age: 30 } })//수정할 값>

//삭제
//조건에 맞는 첫번째 데이터 삭제
//db.users.deleteOne({조건})//조건에 맞는 첫번째 데이터 삭제
db.users.deleteOne({name: '홍길동'})//이름이 홍길동인 사람을 삭제함

// capped collection : 컬렉션 = '테이블'
// 컬렉션의 용량이 초과하게되면, 오래된 데이터부터 차례대로 삭제하는기능
// db.createCollection('컬렉션명', {capped: true, size: [용량]})
db.createCollection('logs' ,{capped: true, size: 5000})//5KB 인 용량의 컬렉션을 생성, 
// 부가기능으로 용량 초과시 오래된 데이터 삭제
// 샘플데이터 추가, 반복문을 이용해서 샘플로 1000개 추가
for (let i = 2000; i < 3000; i++) {
    db.logs.insertOne({
        message : `로그메시지 ${i}`,
        timestamp : new Date(), //현재날짜 / 오라클로 표현하면 sysdate()
    })
}
db.logs.find()

db.createCollection('logs2' ,{capped: true, size: 5000})//5KB 인 용량의 컬렉션을 생성, 

for (let i = 2000; i < 3000; i++) {
    db.logs2.insertOne({
        message : `로그메시지 ${i}`,
        timestamp : new Date(), //현재날짜 / 오라클로 표현하면 sysdate()
    })
}