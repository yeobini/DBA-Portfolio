-- 테이블에서 가격이 100,000원 이상인 상품 중 가격이 높은 순서대로 3개를 조회
SELECT 
	product_name, 
    price
FROM product
WHERE price >= 100000
ORDER BY price DESC
LIMIT 3;

-- product 테이블에서 중복되지 않는 category_id 목록을 조회
SELECT 
	DISTINCT category_id 
FROM product;

-- product 테이블에서 상품명에 'Pro'가 포함된 상품을 조회
SELECT 
	product_name, 
    price
FROM product
WHERE product_name LIKE '%Pro%';

-- 카테고리명이 '전자제품'인 상품 조회
SELECT 
	category_name, 
    product_name, 
    price
FROM category c
JOIN product p
	ON c.category_id = p.category_id
WHERE category_name = '전자제품';

-- 주문 상태가 '결제완료' 또는 '배송중'인 주문 조회
SELECT 
	order_id, 
    member_name, 
    order_status
FROM orders o
JOIN member m
	ON o.member_id = m.member_id
WHERE o.order_status IN ('결제완료', '배송중');

-- 주문하지 않은 회원 조회
SELECT
    m.member_name,
    m.email
FROM member m
LEFT JOIN orders o
    ON m.member_id = o.member_id
WHERE o.order_id IS NULL;

-- 카테고리별 재고 수량 조회
SELECT 
	category_name, 
    SUM(stock) AS '총 재고 수량'
FROM product p
JOIN category c
	ON p.category_id=c.category_id
GROUP BY c.category_name;

-- 카테고리별 상품 개수 조회
SELECT 
	category_name, 
    COUNT(*) AS '상품 개수'
FROM product p
JOIN category c
	ON p.category_id=c.category_id
GROUP BY c.category_name;

-- 상품별 총 판매 수량 조회
SELECT 
	product_name,
    SUM(quantity) AS '총 판매 수량'
FROM product p
JOIN orderitem oi
	ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- 카테고리별 평균 가격이 100,000원 이상인 카테고리를 조회
SELECT 
	category_name, 
    AVG(price) AS '평균 가격'
FROM category c
JOIN product p
	ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
HAVING AVG(price)>=100000;

-- 회원별 총 구매 금액 조회
SELECT
	m.member_name,
    m.email,
    SUM(o.total_price) AS '총 구매 금액'
FROM member m
JOIN orders o
	ON m.member_id = o.member_id
GROUP BY m.member_id, m.member_name;

-- 회원별 총 구매 금액 조회(주문 상세 상품 가격 * 수량 기준)
SELECT
	m.member_name,
    m.email,
    SUM(oi.order_price*oi.quantity) AS '총 구매 금액'
FROM member m
JOIN orders o
	ON m.member_id = o.member_id
JOIN orderitem oi
	ON oi.order_id = o.order_id
GROUP BY m.member_id, m.member_name;

-- 판매량 TOP 3 상품 조회
SELECT 
	product_name AS '상품명',
    SUM(quantity) AS '총 판매 수량'
FROM product p
JOIN orderitem oi
	ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY SUM(quantity) DESC
LIMIT 3;

-- 총 판매 수량이 10개 이상인 상품 조회
SELECT
	p.product_name AS '상품명',
    SUM(oi.quantity) AS '총 판매 수량'
FROM product p
JOIN orderitem oi
	ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10;