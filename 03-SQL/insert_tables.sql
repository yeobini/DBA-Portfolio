INSERT INTO member (
    email,
    password,
    member_name,
    phone
)
VALUES
(
    'hong@test.com',
    'password123',
    '홍길동',
    '010-1111-1111'
),
(
    'kim@test.com',
    'password456',
    '김철수',
    '010-2222-2222'
),
(
    'lee@test.com',
    'password789',
    '이영희',
    '010-3333-3333'
);

INSERT INTO category (
	category_name
)
VALUES
(
	'노트북'
),
(
	'키보드'
),
(
	'마우스'
),
(
	'모니터'
);

INSERT INTO product (
    category_id,
    product_name,
    price,
    stock,
    description
)
VALUES
(
    1,
    'MacBook Air M4',
    1590000,
    10,
    'Apple MacBook Air M4 13-inch'
),
(
    2,
    'MX Keys S',
    149000,
    30,
    'Logitech wireless keyboard'
),
(
    3,
    'MX Master 3S',
    129000,
    25,
    'Logitech wireless mouse'
),
(
    4,
    'LG UltraFine 27',
    499000,
    15,
    'LG 27-inch 4K monitor'
);

INSERT INTO orders (
    member_id,
    total_price,
    order_status
)
VALUES
(
    1,
    1739000,
    '결제완료'
),
(
    2,
    129000,
    '배송중'
),
(
    3,
    499000,
    '주문완료'
);

INSERT INTO orderitem (
    order_id,
    product_id,
    quantity,
    order_price
)
VALUES
(
    1,
    1,
    1,
    1590000
),
(
    1,
    2,
    1,
    149000
),
(
    2,
    3,
    1,
    129000
),
(
    3,
    4,
    1,
    499000
);

INSERT INTO payment (
    order_id,
    payment_method,
    payment_amount,
    payment_status
)
VALUES
(
    1,
    '신용카드',
    1739000,
    '결제완료'
),
(
    2,
    '카카오페이',
    129000,
    '결제완료'
),
(
    3,
    '무통장입금',
    499000,
    '결제대기'
);

INSERT INTO delivery (
    order_id,
    recipient_name,
    recipient_phone,
    address,
    delivery_status
)
VALUES
(
    1,
    '홍길동',
    '010-1111-1111',
    '서울특별시 강남구 테헤란로 123',
    '배송완료'
),
(
    2,
    '김철수',
    '010-2222-2222',
    '경기도 수원시 영통구 광교로 456',
    '배송중'
),
(
    3,
    '이영희',
    '010-3333-3333',
    '부산광역시 해운대구 센텀로 789',
    '배송준비중'
);

INSERT INTO review (
    member_id,
    order_item_id,
    rating,
    content
)
VALUES
(
    1,
    1,
    5,
    '성능이 뛰어나고 매우 만족합니다.'
),
(
    1,
    2,
    4,
    '타건감이 좋고 사용하기 편리합니다.'
);