# DAY 16 - Replication

## Objective

Docker 환경에서 MySQL Master-Replica 구조를 구성하고, 데이터 복제 및 장애 상황에서의 복구 과정을 실습한다.

* Master의 Binary Log를 Replica가 수신하는 구조 이해
* Replication 계정 및 복제 설정
* Master → Replica 데이터 복제 검증
* Master 장애 발생 시 Replica의 동작 확인
* Master 복구 후 Replica 자동 재연결 확인

---

## Environment

* Windows
* Docker 29.8.1
* MySQL 8.0
* MySQL Workbench

### Container

| 구분      | Container       |   Port | Server ID |
| ------- | --------------- | -----: | --------: |
| Master  | `mysql-master`  | `3307` |       `1` |
| Replica | `mysql-replica` | `3308` |       `2` |



| 부분                         | 의미                         |
| -------------------------- | -------------------------- |
| `-d`                       | 백그라운드에서 실행                 |
| `--name mysql-master`      | 컨테이너 이름                    |
| `MYSQL_ROOT_PASSWORD=1234` | MySQL root 비밀번호            |
| `-p 3307:3306`             | 윈도우 3307 → 컨테이너 MySQL 3306 |
| `mysql:8.0`                | MySQL 8.0 이미지              |



---

## 1. Master 구성

Master 컨테이너를 생성하고 Replication에 필요한 설정을 적용했다.

```ini
[mysqld]
server-id=1  // Master를 식별하는 번호
log-bin=mysql-bin // Binary Log 활성화
binlog-format=ROW // 변경된 데이터를 Row단위로 기록
```

### 설정 확인

```sql
SHOW VARIABLES LIKE 'server_id';
SHOW VARIABLES LIKE 'log_bin';
```

결과:

```text
server_id = 1
log_bin   = ON
```

---

## 2. Replication 계정 생성

Replica가 Master의 Binary Log에 접근할 수 있도록 별도의 Replication 계정을 생성했다.

```sql
CREATE USER 'repl'@'%' IDENTIFIED BY 'repl1234';

GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

FLUSH PRIVILEGES;
```

이후 Replica 연결 과정에서 발생한 인증 오류를 해결하기 위해 인증 방식을 변경했다.

```sql
ALTER USER 'repl'@'%'
IDENTIFIED WITH mysql_native_password
BY 'repl1234';
```

---

## 3. Master Binary Log 확인

Replica가 복제를 시작할 기준점을 확인했다.

```sql
SHOW MASTER STATUS;
```

확인한 위치:

```text
File     : binlog.000002
Position : 856
```

---

## 4. Replica 구성

Replica는 Master와 다른 `server-id`를 사용하도록 구성했다.

```text
server-id = 2
relay-log = relay-bin
```

Docker 실행 시 MySQL 옵션으로 설정을 적용했다.

```cmd
docker run -d --name mysql-replica ^
-e MYSQL_ROOT_PASSWORD=1234 ^
-p 3308:3306 ^
mysql:8.0 ^
--server-id=2 ^
--relay-log=relay-bin
```

### 설정 확인

```sql
SHOW VARIABLES LIKE 'server_id';
```

결과:

```text
server_id = 2
```

---

## 5. Master - Replica 연결

Replica에서 Master의 정보를 설정했다.

```sql
CHANGE REPLICATION SOURCE TO
SOURCE_HOST='host.docker.internal',
SOURCE_PORT=3307,
SOURCE_USER='repl',
SOURCE_PASSWORD='repl1234',
SOURCE_LOG_FILE='binlog.000002',
SOURCE_LOG_POS=856;
```

복제를 시작했다.

```sql
START REPLICA;
```

### 복제 상태 확인

```sql
SHOW REPLICA STATUS\G
```

정상 상태:

```text
Replica_IO_Running: Yes
Replica_SQL_Running: Yes
```

* `Replica_IO_Running` : Master의 Binary Log를 정상적으로 수신
* `Replica_SQL_Running` : 수신한 로그를 Replica에 정상적으로 적용

---

## 6. 데이터 복제 검증

실제 데이터가 Master에서 Replica로 복제되는지 확인했다.

### Master

```sql
CREATE DATABASE replication_test;

USE replication_test;

CREATE TABLE test_data (
    id INT PRIMARY KEY,
    message VARCHAR(100)
);

INSERT INTO test_data (id, message)
VALUES (1, 'Master에서 입력한 데이터');
```

### Replica

```sql
USE replication_test;

SELECT * FROM test_data;
```

결과:

```text
id | message
1  | Master에서 입력한 데이터
```

Master에서 입력한 데이터가 Replica에 정상적으로 반영되는 것을 확인했다.

---

## 7. Replication 장애 상황 테스트

Replication이 정상적으로 동작하는 상태에서 Master 컨테이너를 중지하여 장애 상황을 발생시켰다.

```cmd
docker stop mysql-master
```

### Replica 상태

```text
Replica_IO_Running: Connecting
Replica_SQL_Running: Yes
```

Master와의 연결이 끊어지면서 IO Thread가 재연결을 시도하는 것을 확인했다.

```text
Last_IO_Errno: 2013
Lost connection to MySQL server
```

Replica는 Master가 복구될 때까지 재연결을 시도했다.

---

## 8. Master 복구 및 자동 재연결

Master 컨테이너를 다시 시작했다.

```cmd
docker start mysql-master
```

잠시 후 Replica의 상태를 다시 확인했다.

```sql
SHOW REPLICA STATUS\G
```

결과:

```text
Replica_IO_Running: Yes
Replica_SQL_Running: Yes
```

Master가 복구된 후 Replica가 자동으로 다시 연결되어 Replication이 정상적으로 재개되는 것을 확인했다.

---

## Troubleshooting

### 1. `Replica_IO_Running: Connecting`

초기 연결 과정에서 다음 오류가 발생했다.

```text
Authentication plugin 'caching_sha2_password'
reported error: Authentication requires secure connection
```

Replication 계정의 인증 방식을 `mysql_native_password`로 변경하여 해결했다.

---

### 2. `Replica_SQL_Running: No`

다음 오류가 발생했다.

```text
Error 1396:
Operation ALTER USER failed for 'repl'@'%'
```

Master에서 실행한 `ALTER USER`가 Binary Log를 통해 Replica로 전달되었으나 Replica에 동일한 사용자가 존재하지 않아 SQL Thread가 중단되었다.

Replica에 동일한 `repl` 계정을 생성한 후 Replication을 다시 시작하여 해결했다.

```sql
CREATE USER 'repl'@'%'
IDENTIFIED WITH mysql_native_password
BY 'repl1234';

START REPLICA;
```

최종적으로:

```text
Replica_IO_Running: Yes
Replica_SQL_Running: Yes
```

상태를 확인했다.

---

## Result

Docker 기반 MySQL Master-Replica 환경을 직접 구성하고 다음 과정을 검증했다.

* Master / Replica 서버 식별 설정
* Binary Log / Relay Log 구성
* Replication 전용 계정 생성
* Master → Replica 연결
* 실제 데이터 복제 검증
* Replication 오류 원인 분석 및 해결
* Master 장애 상황 재현
* Master 복구 후 Replica 자동 재연결 확인

이를 통해 MySQL Replication의 기본적인 구성 및 동작 방식과 장애 상황에서의 복구 과정을 실습했다.



# DAY 17 - Replication 2

## Objective

Docker 기반 MySQL Master-Replica 환경을 구성하고,
`dba_portfolio` 데이터베이스를 대상으로 데이터 복제 및
UPDATE / DELETE 복제 동작을 검증한다.


## Tasks

- `dba_portfolio` 데이터베이스 복구 및 복제 확인
- UPDATE / DELETE 작업의 자동 복제 검증

### 1. dba_portfolio 데이터베이스 연결

기존에 구축한 Master-Replica 환경에
실제 DBA 포트폴리오 데이터베이스인 `dba_portfolio`를 연결했다.

Master의 빈 `dba_portfolio` 데이터베이스에 기존 백업 파일을 복구하고,
Replica에서 테이블 및 데이터가 자동으로 생성되는 것을 확인했다.

### 2. UPDATE 복제 테스트

Master에서 상품 재고를 변경했다.

```sql
UPDATE product
SET stock = stock - 1
WHERE product_id = 2;
```

Master에서 재고가 6 → 5로 변경된 후
Replica에서 별도의 UPDATE를 실행하지 않았음에도 동일하게 5로 변경되는 것을 확인했다.

### 3. DELETE 복제 테스트

삭제 작업을 검증하기 위해 테스트용 상품을 생성했다.

```sql
INSERT INTO product
(category_id, product_name, price, stock)
VALUES
(1, 'Replication DELETE Test', 1000, 1);
```

테스트 상품 product_id = 5를 Master에서 삭제했다.

```sql
DELETE FROM product
WHERE product_id = 5;
```

Master에서 삭제 후 Replica에서 동일한 데이터를 조회하여
product_id = 5가 자동으로 삭제된 것을 확인했다.

## Design Note

MySQL Replication은 Master에서 발생한 변경 작업을 Binary Log에 기록하고,
Replica가 해당 로그를 전달받아 Relay Log에 저장한 후 SQL 스레드를 통해 실행하는 방식으로 동작한다.

따라서 Replica에서 직접 INSERT, UPDATE, DELETE를 수행하지 않아도
Master에서 발생한 데이터 변경이 Replica에 자동으로 반영된다.

## RESULT

- dba_portfolio 데이터베이스 Master → Replica 복제 확인
- INSERT 복제를 통한 초기 데이터 구성 확인
- UPDATE 작업 자동 복제 확인
- DELETE 작업 자동 복제 확인
- Master에서 발생한 변경 사항이 Replica에 자동 반영되는 과정 검증
- Docker 기반 MySQL Replication 운영 및 장애 상황 대응 경험 확보

