-- 가격이 가장 높은 상품 2개를 조회
SELECT *
FROM product
ORDER BY price DESC
LIMIT 2;

-- product 테이블에서 중복 없이 category_id만 조회
SELECT DISTINCT category_id
FROM product;

-- 상품명이 MX로 시작하는 상품만 조회
SELECT *
FROM product
WHERE product_name LIKE 'MX%';

-- 상품명이 S로 끝나는 상품만 조회
SELECT *
FROM product
WHERE product_name LIKE '%S';

-- 상품명에 Air가 포함된 상품만 조회
SELECT *
FROM product
WHERE product_name LIKE '%Air%';

-- 가격이 100,000원 이상이고 2,000,000원 이하인 상품을 조회
SELECT *
FROM product
WHERE price BETWEEN 100000 AND 200000;

-- 카테고리가 1번, 2번, 3번인 상품 조회
SELECT *
FROM product
WHERE category_id IN (1, 2, 3);

-- 상품 테이블에서 가격이 100000, 200000, 300000원인 상품 조회
SELECT *
FROM product
WHERE price IN (100000, 200000, 300000);

-- 주문 상태가 '결제완료' 또는 '배송중'인 주문 조회
SELECT *
FROM orders
WHERE order_status IN ('결제완료', '배송중');

-- 회원 테이블에서 전화번호가 없는 회원 조회
SELECT *
FROM member
WHERE phone IS NULL;

-- 상품 테이블에서 상품명과 가격을 조회, 이때 컬럼명을 product_name -> 상품명, price -> 가격으로 표시되도록
SELECT product_name AS '상품명', price AS '가격'
FROM product;