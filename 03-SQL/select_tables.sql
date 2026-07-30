-- 모든 회원 조회
SELECT * 
FROM member;

-- 상품명과 가격 조회
SELECT 
	product_name, 
    price 
FROM product;

-- 가격이 100000원 이상인 상품만 조회
SELECT * 
FROM product 
WHERE price >= 100000;

-- 상품을 가격이 높은 순으로 조회
SELECT * 
FROM product 
ORDER BY price DESC;

-- 재고(stock)가 20개 이상인 상품을 가격이 높은 순으로 조회
SELECT * 
FROM product 
WHERE stock >= 20
ORDER BY price DESC;