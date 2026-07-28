# Commit Convention

## Type

| Type | Description | Example |
|------|-------------|---------|
| feat | 새로운 기능, SQL 파일 추가 | feat: add insert_data.sql |
| docs | README 및 문서 수정 | docs: update Day 4 README |
| refactor | 코드 및 SQL 리팩토링 | refactor: rename ddl.sql to create_table.sql |
| fix | 오류 수정 | fix: correct foreign key reference |
| chore | 폴더명 변경, 파일 정리 | chore: rename database_desing to database_design |

---

## Examples

### SQL 파일 추가

```text
feat: add create_table.sql
feat: add insert_data.sql
feat: add select_queries.sql
```

### README 수정

```text
docs: add Day 3 documentation
docs: update Day 4 README
```

### SQL 수정

```text
fix: correct review table foreign key
fix: update product table schema
```

### 리팩토링

```text
refactor: rename ddl.sql to create_table.sql
refactor: improve table naming
```

### 폴더 및 파일 정리

```text
chore: rename SQL directory
chore: reorganize project structure
```
