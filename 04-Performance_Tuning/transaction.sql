-- =========================================
-- DAY 15 - TRANSACTION
-- =========================================

-- 1. ROLLBACK 실습
-- 주문 상태 변경 후 ROLLBACK

START TRANSACTION;

UPDATE orders
SET order_status = '배송중'
WHERE order_id = 1;

SELECT *
FROM orders
WHERE order_id = 1;

ROLLBACK;


-- 2. COMMIT 실습
-- 주문 상태 변경 후 COMMIT

START TRANSACTION;

UPDATE orders
SET order_status = '배송중'
WHERE order_id = 1;

SELECT *
FROM orders
WHERE order_id = 1;

COMMIT;


-- 3. 정상적인 주문 처리
-- 홍길동(member_id = 1)이 상품 2번 MX Keys S를 2개 주문

START TRANSACTION;

-- 1. 주문 생성
INSERT INTO orders(member_id, total_price, order_status)
VALUES (1, 298000, '주문완료');

-- 2. 생성된 order_id 확인 후 실제 실습에서는 9번 사용
INSERT INTO orderitem (order_id, product_id, quantity, order_price)
VALUES (9, 2, 2, 149000);

-- 3. 재고 감소
UPDATE product
SET stock = stock - 2
WHERE product_id = 2;

-- 4. 결제 등록
INSERT INTO payment (order_id, payment_method, payment_amount, payment_status)
VALUES (9, '카드', 298000, '결제완료');

COMMIT;


-- 4. 동시 주문 상황에서 재고 부족 처리
-- MX Keys S 초기 재고: 28

-- =========================================
-- Session A
-- 20개 주문
-- =========================================

START TRANSACTION;

UPDATE product
SET stock = stock - 20
WHERE product_id = 2
  AND stock >= 20;

SELECT product_id, product_name, stock
FROM product
WHERE product_id = 2;

-- Session B에서 10개 차감 시도
-- B의 UPDATE가 Running 상태로 대기

-- Session A에서 COMMIT
COMMIT;


-- =========================================
-- Session B
-- 10개 주문
-- =========================================

START TRANSACTION;

UPDATE product
SET stock = stock - 10
WHERE product_id = 2
  AND stock >= 10;

-- Session A의 COMMIT 이후 실행 결과
-- 0 row(s) affected
-- Rows matched: 0
-- Changed: 0


-- 재고 부족으로 주문 처리 실패
ROLLBACK;


-- 5. 재고 부족으로 주문 전체 ROLLBACK
-- MX Keys S 재고가 8개인 상태에서 10개 주문

START TRANSACTION;

-- 주문 생성
INSERT INTO orders (member_id, total_price, order_status)
VALUES (1, 1490000, '주문완료');

-- 실제 실습에서 생성된 order_id = 20
INSERT INTO orderitem (order_id, product_id, quantity, order_price)
VALUES (20, 2, 10, 149000);

-- 재고가 충분할 때만 차감
UPDATE product
SET stock = stock - 10
WHERE product_id = 2
  AND stock >= 10;

-- 0 rows affected 확인
-- 재고 부족으로 주문 처리 실패

ROLLBACK;

