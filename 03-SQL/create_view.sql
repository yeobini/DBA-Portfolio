-- 회원의 이름, 이메일, 주문번호, 주문상태, 주문금액을 조회하는 View
CREATE VIEW member_order_view AS
SELECT 
	m.member_name, 
    m.email, 
    o.order_id, 
    o.order_status,
    o.total_price
FROM member m
JOIN orders o
	ON m.member_id=o.member_id;
    
SELECT * 
FROM member_order_view;

SELECT member_name, order_id, total_price
FROM member_order_view;

SELECT *
FROM member_order_view
WHERE order_status = '결제완료';

-- 회원별 총 구매 금액을 조회하는 VIEW
CREATE VIEW member_total_purchase AS
SELECT 
	m.member_name, 
    m.email, 
    SUM(total_price) AS '총 구매 금액'
FROM member m
JOIN orders o
ON m.member_id=o.member_id
GROUP BY m.member_id, m.member_name;

SELECT * 
FROM member_total_purchase;

-- 상품별 판매량 VIEW
CREATE VIEW product_sales_summary AS
SELECT 
	p.product_name, 
    SUM(oi.quantity) AS '총 판매 수량'
FROM product p
JOIN orderitem oi
	ON oi.product_id=p.product_id
GROUP BY p.product_id, p.product_name;

SELECT *
FROM product_sales_summary;