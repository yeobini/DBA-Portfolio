-- 카테고리별 상품 개수 조회 (COUNT)
SELECT
    category_id,
    COUNT(*) AS 상품개수
FROM product
GROUP BY category_id;

-- 상품별 총 판매 수량 조회 (SUM)
SELECT p.product_name, SUM(oi.quantity)
FROM orderitem oi
JOIN product p
	ON p.product_id = oi.product_id
GROUP BY p.product_name;

-- 카테고리별 평균 상품 가격 조회 (AVG)
SELECT 
	c.category_name AS '카테고리',
	AVG(p.price) AS '평균 가격'
FROM product p
JOIN category c
	ON c.category_id = p.category_id
GROUP BY category_name;

-- 상품이 2개 이상 등록된 카테고리만 조회 (HAVING)
SELECT
	c.category_name AS 카테고리,
    COUNT(*) AS 상품개수
FROM product p
JOIN category c
	ON p.category_id = c.category_id
GROUP BY c.category_name
HAVING count(*)>=2;

-- 회원별 총 주문 금액 조회 
SELECT 
	m.member_name AS '회원 이름',
    SUM(o.total_price) AS '총 주문 금액'
FROM member m
JOIN orders o
	ON m.member_id = o.member_id
GROUP BY m.member_name;
