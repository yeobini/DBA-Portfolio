-- 평균가격보다 비싼 상품 조회 (단일 행 쿼리)
SELECT *
FROM product
WHERE price > (
	SELECT AVG(price) 
    FROM product
);

-- 주문한 적 있는 회원 조회 (다중 행 쿼리)
SELECT member_name, email
FROM member
WHERE member_id IN(
	SELECT member_id
    FROM orders
);

-- 가장 비싼 상품 조회
SELECT product_name, price
FROM product
WHERE price = (
	SELECT MAX(price)
	FROM product
);

-- 주문하지 않은 회원 조회
SELECT *
FROM member
WHERE member_id NOT IN(
	SELECT member_id
    FROM orders
);

-- 주문한 적 있는 회원 조회(EXISTS)
SELECT *
FROM member m
WHERE EXISTS(
	SELECT 1
    FROM orders o
    WHERE o.member_id = m.member_id
);

-- 평균보다 비싼 상품 중 가장 비싼 상품
SELECT product_name, price
FROM product
WHERE price = (
    SELECT MAX(price)
    FROM product
    WHERE price > (
        SELECT AVG(price)
        FROM product
    )
);
