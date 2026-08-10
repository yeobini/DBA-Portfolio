-- 인덱스 생성 전 실행 계획 확인
EXPLAIN
SELECT *
FROM member
WHERE member_name = '홍길동';

-- member_name 인덱스 생성
CREATE INDEX idx_member_name
ON member(member_name);

-- 인덱스 생성 후 실행 계획 확인
EXPLAIN
SELECT *
FROM member
WHERE member_name = '홍길동';

-- 실습 종료 후 인덱스 삭제
DROP INDEX idx_member_name ON member;