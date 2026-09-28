# DAY 16 - BACKUP & RECOVERY

### Objective

`mysqldump`를 활용하여 MySQL 데이터베이스를 백업하고, 백업 파일을 이용하여 데이터를 복구하는 과정을 실습한다.

### Tasks

- 현재 데이터베이스 상태 확인
- `mysqldump`를 이용한 데이터베이스 백업
- 백업 파일 생성 및 내용 확인
- 백업 이후 데이터 변경 상황 구현
- 백업 파일을 이용한 데이터 복구
- 복구 후 데이터 상태 확인

---

### Design Note

#### 1. 백업 전 데이터베이스 상태 확인

백업하기 전에 현재 데이터베이스의 테이블과 주요 데이터를 확인하였다.

```sql
USE dba_portfolio;

SHOW TABLES;
```

주문 데이터 확인:

```sql
SELECT *
FROM orders;
```

상품 재고 확인:

```sql
SELECT product_id, product_name, stock
FROM product;
```

백업 전 주요 상품의 재고는 다음과 같았다.

| product_id | product_name | stock |
|---:|---|---:|
| 1 | MacBook Air M4 | 9 |
| 2 | MX Keys S | 8 |
| 3 | MX Master 3S | 25 |
| 4 | LG UltraFine 27 | 15 |

---

#### 2. MySQL 데이터베이스 백업

`mysqldump`를 사용하여 `dba_portfolio` 데이터베이스를 SQL 파일 형태로 백업하였다.

```cmd
mysqldump -u root -p dba_portfolio > "C:\Users\user\dba_portfolio_backup.sql"
```

각 옵션의 의미는 다음과 같다.

| 명령어 | 의미 |
|---|---|
| `mysqldump` | MySQL 데이터베이스를 SQL 형태로 백업 |
| `-u root` | root 사용자로 접속 |
| `-p` | MySQL 비밀번호 입력 |
| `dba_portfolio` | 백업 대상 데이터베이스 |
| `>` | 명령어 결과를 파일로 저장 |
| `dba_portfolio_backup.sql` | 생성할 백업 파일 |

백업 결과 다음 파일이 생성되었다.

```text
C:\Users\user\dba_portfolio_backup.sql
```

백업 파일을 확인하여 테이블 생성문과 데이터 삽입문이 포함되어 있는 것을 확인하였다.

---

#### 3. 백업 이후 데이터 변경

백업이 완료된 이후 실제 운영 중 잘못된 데이터가 변경되는 상황을 가정하였다.

`order_id = 19`의 주문 상태를 확인하였다.

```sql
SELECT *
FROM orders
WHERE order_id = 19;
```

백업 당시 주문 상태는 `주문완료`였다.

이후 주문 상태가 잘못 변경된 상황을 만들기 위해 다음 쿼리를 실행하였다.

```sql
UPDATE orders
SET order_status = '취소'
WHERE order_id = 19;
```

변경된 데이터를 확인하였다.

```sql
SELECT *
FROM orders
WHERE order_id = 19;
```

이후 `COMMIT`하여 변경사항을 실제 데이터베이스에 확정하였다.

```sql
COMMIT;
```

이를 통해 백업 이후 데이터가 잘못 변경된 상황을 구현하였다.

---

#### 4. 백업 파일을 이용한 데이터 복구

백업 파일을 이용하여 `dba_portfolio` 데이터베이스를 복구하였다.

CMD에서 다음 명령어를 실행하였다.

```cmd
mysql -u root -p dba_portfolio < "C:\Users\user\dba_portfolio_backup.sql"
```

각 명령어의 의미는 다음과 같다.

| 명령어 | 의미 |
|---|---|
| `mysql` | MySQL 서버에 접속하여 SQL 실행 |
| `-u root` | root 사용자로 접속 |
| `-p` | MySQL 비밀번호 입력 |
| `dba_portfolio` | SQL을 실행할 대상 데이터베이스 |
| `<` | 백업 파일의 SQL 내용을 입력으로 전달 |
| `dba_portfolio_backup.sql` | 복구에 사용할 백업 파일 |

백업 파일에 저장된 SQL을 `dba_portfolio` 데이터베이스에 다시 실행하여 백업 당시의 상태로 복구하였다.

---

#### 5. 복구 결과 확인

복구 후 `order_id = 19`의 상태를 다시 확인하였다.

```sql
SELECT *
FROM orders
WHERE order_id = 19;
```

복구 전에는 주문 상태가 `취소`였지만, 백업 파일을 이용한 복구 이후 백업 당시의 `주문완료` 상태로 돌아온 것을 확인하였다.

```text
백업 시점
주문완료
   ↓
데이터 변경
   ↓
취소
   ↓
COMMIT
   ↓
백업 파일을 이용한 복구
   ↓
주문완료
```

이를 통해 `mysqldump`로 생성한 백업 파일을 이용하여 변경된 데이터를 백업 시점의 상태로 복구할 수 있음을 확인하였다.

---

### SQL

백업 및 복구 실습에 사용한 SQL은 아래 파일에서 확인할 수 있습니다.

- [backup_recovery.sql](./backup_recovery.sql)

---

### Result

- `mysqldump`를 이용하여 MySQL 데이터베이스를 SQL 파일로 백업
- 백업 파일에 테이블 구조와 데이터가 포함되어 있는 것을 확인
- 백업 이후 데이터가 잘못 변경되는 상황을 구현
- `COMMIT`을 통해 잘못된 변경사항을 실제 데이터베이스에 반영
- 백업 파일을 이용하여 데이터베이스 복구
- `order_id = 19`의 상태가 `취소`에서 백업 당시의 `주문완료` 상태로 복구되는 것을 확인
- MySQL 데이터베이스의 백업 및 복구 과정을 직접 수행
