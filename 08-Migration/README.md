# DAY 18 - Migratgion

## Objective
`mysqldump`를 활용해 기존 데이터베이스를 별도의 대상 데이터베이스로 이전하고, 데이터 건수 비교를 통해 마이그레이션 결과를 검증한다.

## Environment
- MySQL 8.0
- Docker
- MySQL Workbench
- Source DB: `dba_portfolio`
- Target DB: `dba_portfolio_migration`

## Tasks
- 원본 데이터베이스의 테이블 및 데이터 건수 확인
- 마이그레이션 대상 데이터베이스 생성
- `mysqldump`를 이용한 SQL 파일 생성
- SQL 파일을 대상 데이터베이스에 적용
- 원본과 대상의 데이터 건수 비교 및 검증

## Migration Process

### 1. 원본 데이터 확인

마이그레이션 전 원본 테이블의 데이터 건수를 확인했다.

| Table | Row Count |
|---|---:|
| category | 4 |
| delivery | 3 |
| member | 4 |
| orderitem | 7 |
| orders | 6 |
| payment | 3 |
| product | 5 |
| review | 2 |
| **Total** | **34** |

### 2. 대상 데이터베이스 생성

```sql
CREATE DATABASE dba_portfolio_migration;
```

### 3. 원본 데이터 내보내기

Windows CMD에서 `mysqldump`를 실행해 원본 데이터베이스의 테이블 구조와 데이터를 SQL 파일로 내보냈다.

```cmd
docker exec -i mysql-master mysqldump -u root -p1234 --no-create-db dba_portfolio > "C:\Users\user\dba_portfolio_migration.sql"
```

### 4. 대상 데이터베이스로 가져오기

생성한 SQL 파일을 대상 데이터베이스에 적용했다.

```cmd
docker exec -i mysql-master mysql -u root -p1234 dba_portfolio_migration < "C:\Users\user\dba_portfolio_migration.sql"
```

### 5. 마이그레이션 결과 검증

대상 데이터베이스에서 테이블 목록과 각 테이블의 데이터 건수를 확인했다.

- 원본과 대상의 8개 테이블 데이터 건수 일치
- 총 데이터 건수 34건 일치
- 대상 데이터베이스에 테이블 및 데이터 생성 확인

## Design Note
`mysqldump`는 데이터베이스의 테이블 구조와 데이터를 SQL 문으로 내보내는 논리적 백업 도구다. 생성된 SQL 파일을 대상 데이터베이스에서 실행하면 테이블 구조와 데이터를 이전할 수 있다.

Replication과 달리 이번 실습은 SQL 파일을 이용한 일회성 데이터 이전 방식이며, 이후 원본 데이터의 변경 사항이 자동으로 반영되지는 않는다.

## Result
- SQL 파일을 이용한 논리적 마이그레이션 수행
- 원본과 대상의 데이터 건수 비교를 통한 기본 검증 완료
- MySQL 데이터 내보내기 및 가져오기 과정 실습 완료

