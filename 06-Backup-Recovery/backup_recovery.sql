-- DAY 16 - BACKUP & RECOVERY

-- 백업 전 데이터 확인
SELECT *
FROM orders
WHERE order_id = 19;

SELECT product_id, product_name, stock
FROM product;


-- 데이터 변경 상황 구현
UPDATE orders
SET order_status = '취소'
WHERE order_id = 19;

SELECT *
FROM orders
WHERE order_id = 19;

COMMIT;


-- 백업 파일을 이용한 복구
-- CMD에서 실행
-- mysql -u root -p dba_portfolio < "C:\Users\user\dba_portfolio_backup.sql"