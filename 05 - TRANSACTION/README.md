# DAY 14 - TRANSACTION

### Objective

트랜잭션의 개념을 이해하고 COMMIT과 ROLLBACK을 활용하여 데이터 변경을 안전하게 처리

### Tasks

- 트랜잭션 시작 및 종료
- COMMIT과 ROLLBACK 실습
- 주문 생성과 재고 감소를 하나의 트랜잭션으로 처리
- 재고 부족 상황에서 주문 전체 ROLLBACK
- 동시 주문 상황에서 재고 정합성 확인

---

### Design Note

#### 1. Transaction이란?

트랜잭션은 여러 개의 SQL 작업을 하나의 작업 단위로 묶어 처리하는 것이다.

주문 처리와 같이 여러 작업이 함께 성공하거나 함께 취소되어야 하는 경우 사용한다.

```text
주문 생성
   ↓
주문 상품 등록
   ↓
재고 감소
   ↓
COMMIT

```
중간에 문제가 발생하면 ROLLBACK을 통해 트랜잭션 내의 변경사항을 취소할 수 있다.

#### 2. COMMIT과 ROLLBACK

##### ROLLBACK

트랜잭션 내에서 변경된 데이터를 변경 전 상태로 되돌린다.

```sql
START TRANSACTION;

UPDATE orders
SET order_status = '배송중'
WHERE order_id = 3;

ROLLBACK;
```
'order_status'가 변경되었지만 'ROLLBACK' 후 기존 상태인 '주문완료'로 복구되는 것을 확인하였다.

#### COMMIT

트랜잭션 내에서 변경된 내용을 최종적으로 저장한다.

```sql
START TRANSACTION;

UPDATE orders
SET order_status = '배송중'
WHERE order_id = 3;

COMMIT;
```

'COMMIT' 후에도 변경된 '배송중' 상태가 유지되는 것을 확인하였다.

---

#### 3. 정상적인 주문 처리

홍길동('member_id = 1')이 MacBook Air M4('product_id = 1') 1개를 주문하는 상황을 구현하였다.

```text
START TRANSACTION
      ↓
orders INSERT
      ↓
orderitem INSERT
      ↓
재고 감소
      ↓
COMMIT
```

주문 생성, 주문 상세 등록, 재고 감소를 하나의 트랜잭션으로 처리한 후 COMMIT하여 모든 변경사항을 확정하였다.

#### 4. 재고 부족 상황에서 ROLLBACK

MX Keys S의 재고가 8개인 상황에서 10개를 주문하는 상황을 테스트하였다.

재고가 충분한 경우에만 차감되도록 조건을 추가하였다.

``` sql
UPDATE product
SET stock = stock - 10
WHERE product_id = 2
  AND stock >= 10;
```

현재 재고가 8개이므로 조건을 만족하지 않아 다음과 같이 처리되었다.

```text
Rows matched: 0
Changed: 0
```

재고가 부족하여 재고 차감이 이루어지지 않은 것을 확인하였다.

이미 생성된 주문과 주문 상세까지 함께 취소하기 위해 'ROLLBACK'을 실행하였다.

```text
주문 생성
   ↓
주문 상품 등록
   ↓
재고 부족
   ↓
재고 차감 실패
   ↓
ROLLBACK
   ↓
주문 및 주문 상품 취소
```

'ROLLBACK' 후 주문과 주문 상세가 취소되고 재고는 기존 8개로 유지되는 것을 확인하였다.

#### 5. 동시 주문 상황
MX Keys S의 재고가 28개인 상황에서 두 세션이 동시에 주문하는 상황을 테스트하였다.

```text
Session A → 20개 주문
Session B → 10개 주문
```

Session A가 먼저 재고를 28개에서 8개로 감소시키고 'COMMIT'하였다.

Session B의 재고 차감 쿼리는 Session A의 트랜잭션이 종료될 때까지 대기한 후, 재고가 8개로 변경된 상태에서 'stock >= 10' 조건을 만족하지 않아 0 rows affected가 발생하였다.

이를 통해 동시에 주문이 발생하더라도 재고 조건과 트랜잭션을 활용하여 재고 부족 상황을 처리할 수 있음을 확인하였다.

---

### SQL

트랜잭션 실습에 사용한 SQL은 아래 파일에서 확인할 수 있습니다.

- [transaction.sql](./transaction.sql)

---

### Result
- COMMIT과 ROLLBACK의 차이를 확인
- 여러 SQL 작업을 하나의 트랜잭션으로 처리
- 정상적인 주문 처리 후 COMMIT을 통해 변경사항을 확정
- 재고 부족 상황에서 주문과 주문 상세를 ROLLBACK하여 전체 작업을 취소
- 두 세션에서 동시에 주문하는 상황을 통해 재고에 대한 동시성 문제를 확인
- 재고 차감 조건과 트랜잭션을 활용하여 재고 정합성을 유지하는 방법을 이해
