-- 회원 이름과 주문번호를 조회 (INNER JOIN)
SELECT m.member_name AS 회원명, o.order_id AS 주문번호
FROM member m
JOIN orders o
	ON m.member_id = o.member_id;
    
-- 모든 회원과 주문 정보를 조회 (LEFT JOIN)
SELECT 
	m.member_name AS 회원명,
    o.order_id AS 주문번호
FROM member m
LEFT JOIN orders o
	ON m.member_id = o.member_id;
    
-- 주문하지 않은 회원
SELECT *
FROM member m
LEFT JOIN orders o
	ON m.member_id = o.member_id
WHERE o.member_id IS NULL;

-- 회원 이름, 상품명, 주문수량 조회 (다중 JOIN)
SELECT 
	m.member_name AS 회원명, 
    p.product_name AS 상품명, 
    oi.quantity AS 주문수량
FROM member m
JOIN orders o
	ON m.member_id = o.member_id
JOIN orderitem oi
	ON o.order_id = oi.order_id
JOIN product p
	ON p.product_id = oi.product_id;
    
-- 회원 이름, 상품명, 주문수량, 주문 당시 가격(order_price)을 조회 
SELECT
	m.member_name AS'회원 이름',
    p.product_name AS 상품명,
    oi.quantity AS 주문수량,
    oi.order_price AS '주문 당시 가격'
FROM member m
JOIN orders o
	ON m.member_id = o.member_id
JOIN orderitem oi
	ON o.order_id = oi.order_id
JOIN product p
	ON p.product_id = oi.product_id;

-- 상품명과 판매 수량 조회
SELECT 
	p.product_name AS '상품명',
	SUM(quantity) AS '판매 수량'
FROM product p
JOIN orderitem oi
    ON p.product_id = oi.product_id
GROUP BY product_name;

	