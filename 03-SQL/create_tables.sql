-- Member
CREATE TABLE member(
	  member_id 	  BIGINT 			  AUTO_INCREMENT 	PRIMARY KEY,
    email 		    VARCHAR(100) 	NOT NULL UNIQUE,
    password 	    VARCHAR(255) 	NOT NULL,
    member_name   VARCHAR(50)   NOT NULL,
    phone 		    VARCHAR(20) 	NOT NULL,
    created_at   	DATETIME 		  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at 	  DATETIME 		  NOT NULL DEFAULT CURRENT_TIMESTAMP
								                ON UPDATE CURRENT_TIMESTAMP
);

-- Category
CREATE TABLE category(
	category_id 	  BIGINT 		    AUTO_INCREMENT PRIMARY KEY,
  category_name 	VARCHAR(50)   NOT NULL UNIQUE
);

-- Product
CREATE TABLE product(
	product_id 		  BIGINT 		    AUTO_INCREMENT 	PRIMARY KEY,
  category_id 	  BIGINT		    NOT NULL,
  product_name 	  VARCHAR(100)  NOT NULL,
  price			      INT			      NOT NULL,
  stock			      INT			      NOT NULL,
  description     TEXT,
	created_at 		  DATETIME 	    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at 		  DATETIME 	    NOT NULL DEFAULT CURRENT_TIMESTAMP
								                ON UPDATE CURRENT_TIMESTAMP,
                                
	FOREIGN KEY (category_id)
		REFERENCES category(category_id)
);

-- Orders
CREATE TABLE orders(
	order_id 		    BIGINT 		    AUTO_INCREMENT PRIMARY KEY,
  member_id 		  BIGINT 		    NOT NULL,
  order_date 		  DATETIME 	    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total_price		  INT			      NOT NULL,
	order_status	  VARCHAR(20)	  NOT NULL DEFAULT '주문완료',
    
  FOREIGN KEY(member_id)
		REFERENCES member(member_id)
);

-- OrderItem
CREATE TABLE orderitem(
	order_item_id 	BIGINT 	      AUTO_INCREMENT PRIMARY KEY,
	order_id 		    BIGINT 	      NOT NULL,
  product_id 		  BIGINT 	      NOT NULL,
  quantity		    INT		        NOT NULL,
  order_price		  INT		        NOT NULL,
    
  FOREIGN KEY(order_id)
		REFERENCES orders(order_id),
        
	FOREIGN KEY (product_id)
		REFERENCES product(product_id)
);

-- Payment
CREATE TABLE payment(
	payment_id 		  BIGINT 		    AUTO_INCREMENT PRIMARY KEY,
  order_id 		    BIGINT 		    NOT NULL UNIQUE,
  payment_method 	VARCHAR(20)   NOT NULL,
  payment_amount	INT 		      NOT NULL,
  payment_status 	VARCHAR(20)   NOT NULL DEFAULT '결제대기',
  payment_date 	  DATETIME	    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
  FOREIGN KEY(order_id)
		REFERENCES orders(order_id)
);

-- Delivery
CREATE TABLE delivery(
	delivery_id		  BIGINT 			  AUTO_INCREMENT PRIMARY KEY,
  order_id 		    BIGINT 			  NOT NULL	UNIQUE,
	recipient_name	VARCHAR(50) 	NOT NULL,
  recipient_phone	VARCHAR(20) 	NOT NULL,
	address			    VARCHAR(255)	NOT NULL,
	delivery_status	VARCHAR(20)		NOT NULL 	DEFAULT '배송준비중',
  shipped_at 		  DATETIME,
  delivered_at 	  DATETIME,
    
  FOREIGN KEY(order_id)
		REFERENCES orders(order_id)
);

-- Review
CREATE TABLE review(
	review_id		    BIGINT		  AUTO_INCREMENT	PRIMARY KEY,
	member_id		    BIGINT		  NOT NULL,
  order_item_id   BIGINT 		  NOT NULL UNIQUE,
  rating			    INT			    NOT NULL 	CHECK(rating BETWEEN 1 AND 5),
  content			    TEXT,
  created_at		  DATETIME	  NOT NULL	DEFAULT CURRENT_TIMESTAMP,
    
  FOREIGN KEY(member_id)
		REFERENCES member(member_id),
        
	FOREIGN KEY (order_item_id)
        REFERENCES orderitem(order_item_id)
    
);