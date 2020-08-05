--------------------------------------
--------------------------------------
-- 관리자 계정에서 실행
--CREATE USER MEETAGAIN IDENTIFIED BY MEETAGAIN;
--GRANT CONNECT, RESOURCE, CREATE VIEW TO MEETAGAIN;
--------------------------------------
--------------------------------------

--------------사용자 테이블 생성
CREATE TABLE MEMBER (
USERID VARCHAR2(30) PRIMARY KEY,
USERNAME VARCHAR2(20) NOT NULL,
USERPWD VARCHAR2(30) NOT NULL,
ADDRESS1 VARCHAR2(100) NOT NULL,
ADDRESS2 VARCHAR2(100),
ADDRESS3 VARCHAR2(100),
NICKNAME VARCHAR2(30) NOT NULL,
BIRTHDAY DATE NOT NULL,
GENDER CHAR(1) NOT NULL,
EMAIL VARCHAR2(40) NOT NULL,
PHONE VARCHAR2(20) NOT NULL,
MLEVEL NUMBER NOT NULL, -- 일반/프리미엄 회원 (1,2 로 표시)
ENROLLDATE DATE DEFAULT SYSDATE,
WDDATE DATE,
WD_YN CHAR(1) DEFAULT 'N' CHECK(WD_YN IN('Y','N')),
OUT_YN CHAR(1) DEFAULT 'N' CHECK(OUT_YN IN('Y','N')),
WARN_CNT NUMBER DEFAULT 0,
STOP_YNA CHAR(1) DEFAULT 'N' CHECK(STOP_YNA IN('Y', 'N', 'A')),
STOP_TIME DATE 
);

COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."USERID" IS '사용자ID';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."USERNAME" IS '사용자이름';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."USERPWD" IS '사용자비밀번호';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."ADDRESS1" IS '주소(집)';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."ADDRESS2" IS '주소(직장)';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."ADDRESS3" IS '주소(선택)';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."NICKNAME" IS '닉네임';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."BIRTHDAY" IS '생년월일';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."GENDER" IS '성별';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."EMAIL" IS '이메일';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."PHONE" IS '전화번호';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."MLEVEL" IS '회원등급';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."ENROLLDATE" IS '가입일자';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."WDDATE" IS '탈퇴일자';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."WD_YN" IS '탈퇴여부';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."OUT_YN" IS '추방여부';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."WARN_CNT" IS '경고횟수';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."STOP_YNA" IS '정지여부';
COMMENT ON COLUMN "MEETAGAIN"."MEMBER"."STOP_TIME" IS '정지시간';

--------------사용자 부가정보 테이블 생성
CREATE TABLE USERTMI(
USERID VARCHAR2(30) PRIMARY KEY,
MBTI VARCHAR2(8),
BLOOD VARCHAR2(4),
KEYWORD VARCHAR2(1000),
USERIMG VARCHAR2(500 CHAR),
CONSTRAINT FK_ID FOREIGN KEY(USERID) REFERENCES MEMBER(USERID)
);

COMMENT ON COLUMN "MEETAGAIN"."USERTMI"."USERID" IS '사용자ID';
COMMENT ON COLUMN "MEETAGAIN"."USERTMI"."MBTI" IS 'MBTI';
COMMENT ON COLUMN "MEETAGAIN"."USERTMI"."BLOOD" IS '혈액형';
COMMENT ON COLUMN "MEETAGAIN"."USERTMI"."KEYWORD" IS '키워드';
COMMENT ON COLUMN "MEETAGAIN"."USERTMI"."USERIMG" IS '프로필이미지';


--------------게시판 테이블 생성
CREATE TABLE BOARD(
BID NUMBER PRIMARY KEY,
USERID VARCHAR2(30) NOT NULL,
BTYPE NUMBER NOT NULL,
BTITLE VARCHAR2(100) NOT NULL,
BCONTENT VARCHAR2(4000) NOT NULL,
BRATE NUMBER DEFAULT 0,
GDATE DATE DEFAULT SYSDATE,
BDEL CHAR(1) DEFAULT 'N' CHECK(BDEL IN('Y','N')),
CONSTRAINT FK_USERID FOREIGN KEY(USERID) REFERENCES MEMBER(USERID)
);

COMMENT ON COLUMN "MEETAGAIN"."BOARD"."BID" IS'글번호';
COMMENT ON COLUMN "MEETAGAIN"."BOARD"."USERID" IS'사용자번호';
COMMENT ON COLUMN "MEETAGAIN"."BOARD"."BTYPE" IS'게시판타입';
COMMENT ON COLUMN "MEETAGAIN"."BOARD"."BTITLE" IS'글제목';
COMMENT ON COLUMN "MEETAGAIN"."BOARD"."BCONTENT" IS'글내용';
COMMENT ON COLUMN "MEETAGAIN"."BOARD"."BRATE" IS'조회수';
COMMENT ON COLUMN "MEETAGAIN"."BOARD"."GDATE" IS'작성일';
COMMENT ON COLUMN "MEETAGAIN"."BOARD"."BDEL" IS'삭제여부';



--------------카테고리 테이블 생성
CREATE TABLE CATEGORY(
CATE_ID VARCHAR2(10) PRIMARY KEY,
CATE_NAME VARCHAR2(15)
);

COMMENT ON COLUMN "MEETAGAIN"."CATEGORY"."CATE_ID" IS '카테고리ID';
COMMENT ON COLUMN "MEETAGAIN"."CATEGORY"."CATE_NAME" IS '카테고리명';


--------------소모임 테이블 생성
CREATE TABLE SGROUP(
GID VARCHAR2(10) PRIMARY KEY,
CATE_ID VARCHAR2(10) NOT NULL,
GTITLE VARCHAR2(200) NOT NULL,
GIMG VARCHAR2(500 CHAR),
GINTRO VARCHAR2(500),
CREATEDATE DATE DEFAULT SYSDATE,
MAXNUM NUMBER NOT NULL,
CHARGE CHAR(1) DEFAULT 'N' CHECK(CHARGE IN('Y','N')),
GFEE NUMBER,
GPLACE VARCHAR2(200) NOT NULL,
GTYPE VARCHAR(2), -- 단기 / 장기 ( 1:단기 , 2:장기)
DURATE DATE,
ISFIN CHAR(1) DEFAULT 'N' CHECK(ISFIN IN ('Y','N')),
GPWD NUMBER,
JOINTYPE VARCHAR2(1) CHECK(JOINTYPE IN('F','C')),
CONSTRAINT FK_CATEID FOREIGN KEY(CATE_ID) REFERENCES CATEGORY(CATE_ID)
);

COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."GID" IS '소모임ID';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."CATE_ID" IS '카테고리ID';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."GTITLE" IS '모임명';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."GIMG" IS '대표이미지';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."GINTRO" IS '모임소개말';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."CREATEDATE" IS '설립일';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."MAXNUM" IS '최대인원';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."CHARGE" IS '회비여부';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."GFEE" IS '회비금액';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."GPLACE" IS '모임장소';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."GTYPE" IS '모임유형';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."DURATE" IS '모임종료일';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."ISFIN" IS '종료여부';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."GPWD" IS '소모임PWD';
COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."JOINTYPE" IS '가입유형(승인제/자유가입)';

--------------캘린더 테이블 생성
CREATE TABLE CALENDAR(
GID VARCHAR2(10) PRIMARY KEY,
GDATE DATE NOT NULL,
GINFO VARCHAR2(300),
GTIME DATE NOT NULL,
ISCTN CHAR(1) DEFAULT 'N' CHECK(ISCTN IN ('Y','N')),
CONSTRAINT FK_GID FOREIGN KEY(GID) REFERENCES SGROUP(GID)
);

COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GID" IS '소모임ID';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GDATE" IS '모임날짜';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GINFO" IS '일정설명';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GDATE" IS '모임시간';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."ISCTN" IS '정기여부';


---------------------가입 테이블 생성
CREATE TABLE JOING(
USERID VARCHAR2(30) NOT NULL,
GID VARCHAR2(10) NOT NULL,
ISCPT VARCHAR2(1) CHECK(ISCPT IN('Y', 'N')),
ISREADY NUMBER CHECK(ISREADY IN(1,2)),
ISOUT VARCHAR2(1) DEFAULT 'N' CHECK(ISOUT IN('Y','N')) ,
ISLEAVE VARCHAR2(1) DEFAULT 'N' CHECK(ISLEAVE IN('Y','N')) ,
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID),
FOREIGN KEY (GID) REFERENCES SGROUP (GID)
);
COMMENT ON COLUMN "MEETAGAIN"."JOING"."USERID" IS '유저ID';
COMMENT ON COLUMN "MEETAGAIN"."JOING"."GID" IS '소모임ID';
COMMENT ON COLUMN "MEETAGAIN"."JOING"."ISCPT" IS '모임장여부';
COMMENT ON COLUMN "MEETAGAIN"."JOING"."ISREADY" IS '가입대기';
COMMENT ON COLUMN "MEETAGAIN"."JOING"."ISOUT" IS '추방여부';
COMMENT ON COLUMN "MEETAGAIN"."JOING"."ISLEAVE" IS '도중탈퇴여부';


-------------팔로워팔로잉 테이블 생성
CREATE TABLE FOLLOW(
FOLLOWER VARCHAR2(30) NOT NULL,
FOLLOWIN VARCHAR2(30) NOT NULL,
FOREIGN KEY (FOLLOWER) REFERENCES MEMBER (USERID),
FOREIGN KEY (FOLLOWIN) REFERENCES MEMBER (USERID)
);
COMMENT ON COLUMN "MEETAGAIN"."FOLLOW"."FOLLOWER" IS '팔로워';
COMMENT ON COLUMN "MEETAGAIN"."FOLLOW"."FOLLOWIN" IS '팔로잉';


------------------선호카테고리 테이블 생성
CREATE TABLE CATEINFO(
USERID VARCHAR2(30) NOT NULL,
CATE_ID VARCHAR2(10),
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID),
FOREIGN KEY (CATE_ID) REFERENCES CATEGORY (CATE_ID)
);
COMMENT ON COLUMN "MEETAGAIN"."CATEINFO"."USERID" IS '유저ID';
COMMENT ON COLUMN "MEETAGAIN"."CATEINFO"."CATE_ID" IS '카테고리ID';


------------------소모임 게시판 테이블 생성
CREATE TABLE GBOARD(
GBID NUMBER PRIMARY KEY,
GID VARCHAR2(10) NOT NULL,
USERID VARCHAR2(30) NOT NULL,
GBTITLE VARCHAR2(100) NOT NULL,
GBCONTENT VARCHAR2(4000) NOT NULL,
GBRATE NUMBER DEFAULT 0,
GBDATE DATE DEFAULT SYSDATE,
GBDEL VARCHAR2(1) DEFAULT 'N' CHECK(GBDEL IN('Y','N')),
GBREC NUMBER DEFAULT 0,
ISNOTICE VARCHAR2(1) CHECK(ISNOTICE IN ('Y','N')),
FOREIGN KEY (GID) REFERENCES SGROUP (GID),
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID)
);

COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."GBID" IS'글번호';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."GID" IS'소모임ID';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."USERID" IS'사용자ID';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."GBTITLE" IS'글제목';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."GBCONTENT" IS'글내용';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."GBRATE" IS'조회수';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."GBDATE" IS'작성일';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."GBDEL" IS'삭제여부';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."GBREC" IS'신고횟수';
COMMENT ON COLUMN "MEETAGAIN"."GBOARD"."ISNOTICE" IS'공지여부';


----------------사진첩 테이블 생성
CREATE TABLE ATTACHMENT(
IMGID NUMBER PRIMARY KEY,
IMGADD VARCHAR2(200) NOT NULL,
GBID NUMBER NOT NULL,
IMGDEL VARCHAR2(1) CHECK(IMGDEL IN('Y','N')),
USERID VARCHAR2(30) NOT NULL,
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID),
FOREIGN KEY (GBID) REFERENCES GBOARD (GBID)
);

COMMENT ON COLUMN "MEETAGAIN"."ATTACHMENT"."IMGID" IS'이미지번호';
COMMENT ON COLUMN "MEETAGAIN"."ATTACHMENT"."IMGADD" IS'이미지주소';
COMMENT ON COLUMN "MEETAGAIN"."ATTACHMENT"."GBID" IS'게시글ID';
COMMENT ON COLUMN "MEETAGAIN"."ATTACHMENT"."IMGDEL" IS'삭제여부';
COMMENT ON COLUMN "MEETAGAIN"."ATTACHMENT"."USERID" IS'글쓴이';


---------------------댓글 테이블 생성
CREATE TABLE GB_COMMENT(
CID NUMBER PRIMARY KEY,
GBID NUMBER NOT NULL,
USERID VARCHAR2(30) NOT NULL,
CDATE DATE DEFAULT SYSDATE,
CCONTENT VARCHAR2(300),
CREF NUMBER,
CLEVEL NUMBER,
CREC NUMBER DEFAULT 0,
CDEL VARCHAR2(1) CHECK(CDEL IN('Y','N')),
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID),
FOREIGN KEY (GBID) REFERENCES GBOARD (GBID)
);

COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."CID" IS '댓글번호';
COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."GBID" IS '원글번호';
COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."USERID" IS '글쓴이ID';
COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."CDATE" IS '작성일';
COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."CCONTENT" IS '작성내용';
COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."CREF" IS '대댓글-원댓글';
COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."CLEVEL" IS '댓글레벨';
COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."CREC" IS '신고횟수';
COMMENT ON COLUMN "MEETAGAIN"."GB_COMMENT"."CDEL" IS '삭제여부';

---------------------신고관리 테이블 생성
CREATE TABLE REPORT(
RCID NUMBER PRIMARY KEY,
USERID VARCHAR2(30) NOT NULL,
RCINFO  VARCHAR2(100),
TARGETID VARCHAR2(30),
STMT VARCHAR2(1) CHECK(STMT IN ('Y','N')),
RCTYPE NUMBER CHECK(RCTYPE IN(1,2)),
RCCONTENT VARCHAR2(200),
CID NUMBER,
GBID NUMBER NOT NULL,
RCTIME DATE DEFAULT SYSDATE,
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID),
FOREIGN KEY (TARGETID) REFERENCES MEMBER (USERID),
FOREIGN KEY (GBID) REFERENCES GBOARD (GBID),
FOREIGN KEY (CID) REFERENCES GB_COMMENT (CID)
);

COMMENT ON COLUMN "MEETAGAIN"."REPORT"."RCID" IS '신고번호';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."USERID" IS '신고자ID';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."RCINFO" IS '신고사유';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."TARGETID" IS '피신고자';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."STMT" IS '처리상태';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."RCTYPE" IS '신고타입';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."RCCONTENT" IS '상세사유';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."CID" IS '댓글번호';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."GBID" IS '글번호';
COMMENT ON COLUMN "MEETAGAIN"."REPORT"."RCTIME" IS '신고시간';
COMMIT;


------------------------------------리뷰 테이블 생성
CREATE TABLE REVIEW(
RVID NUMBER PRIMARY KEY,
USERID VARCHAR2(30) NOT NULL,
GID VARCHAR2(10) NOT NULL,
RVCONTENT VARCHAR2(500),
RVIMAGE VARCHAR2(500),
RVSTAR NUMBER,
RVLIKE NUMBER,
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID),
FOREIGN KEY (GID) REFERENCES SGROUP (GID)
);

COMMENT ON COLUMN "MEETAGAIN"."REVIEW"."RVID" IS '리뷰ID';
COMMENT ON COLUMN "MEETAGAIN"."REVIEW"."USERID" IS '유저ID';
COMMENT ON COLUMN "MEETAGAIN"."REVIEW"."GID" IS '소모임ID';
COMMENT ON COLUMN "MEETAGAIN"."REVIEW"."RVCONTENT" IS '리뷰내용';
COMMENT ON COLUMN "MEETAGAIN"."REVIEW"."RVIMAGE" IS '리뷰이미지';
COMMENT ON COLUMN "MEETAGAIN"."REVIEW"."RVSTAR" IS '별점';
COMMENT ON COLUMN "MEETAGAIN"."REVIEW"."RVLIKE" IS '도움수';

-------------------------------정기결제 테이블 생성
CREATE TABLE MEMBERSHIP(
USERID VARCHAR2(30) NOT NULL,
JOINDATE DATE NOT NULL,
QUITDATE DATE,
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID)
);

COMMENT ON COLUMN "MEETAGAIN"."MEMBERSHIP"."USERID" IS '유저ID';
COMMENT ON COLUMN "MEETAGAIN"."MEMBERSHIP"."JOINDATE" IS '가입일자';
COMMENT ON COLUMN "MEETAGAIN"."MEMBERSHIP"."QUITDATE" IS '해지일자';


-------------------결제내역 테이블 생성
CREATE TABLE MSHISTORY(
USERID VARCHAR2(30) NOT NULL,
PAYMENT NUMBER NOT NULL,
PAYDATE DATE NOT NULL,
DISCOUNT NUMBER,
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID)
);
COMMENT ON COLUMN "MEETAGAIN"."MSHISTORY"."USERID" IS '유저ID';
COMMENT ON COLUMN "MEETAGAIN"."MSHISTORY"."PAYMENT" IS '납부금액';
COMMENT ON COLUMN "MEETAGAIN"."MSHISTORY"."PAYDATE" IS '납부일자';
COMMENT ON COLUMN "MEETAGAIN"."MSHISTORY"."DISCOUNT" IS '할인율';

-------------------------------시퀀스 생성
CREATE SEQUENCE SEQ_BID
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE SEQ_GID
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE SEQ_GBID
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE SEQ_RCID
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;


CREATE SEQUENCE SEQ_RVID
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;



--------------------------카테고리 데이터 삽입
INSERT INTO CATEGORY VALUES('C01','운동');
INSERT INTO CATEGORY VALUES('C02','친목');
INSERT INTO CATEGORY VALUES('C03','공부');
INSERT INTO CATEGORY VALUES('C04','취미생활');
INSERT INTO CATEGORY VALUES('C05','문화생활');
INSERT INTO CATEGORY VALUES('C06','여행');
INSERT INTO CATEGORY VALUES('C07','봉사');
INSERT INTO CATEGORY VALUES('C08','기타');

COMMIT;

ALTER TABLE BOARD RENAME COLUMN GDATE TO BDATE;


CREATE OR REPLACE PROCEDURE NN_DUP_CHK
    ( V_NN IN MEMBER.NICKNAME%TYPE, PR_RESULT OUT NUMBER) 
IS
BEGIN

    SELECT COUNT(*)
    INTO PR_RESULT
    FROM MEMBER
    WHERE NICKNAME = V_NN;
END;
/
SET SERVEROUTPUT ON;

-- 실행 확인
DECLARE
     RESULT NUMBER;
BEGIN
    NN_DUP_CHK('&닉네임', RESULT);
     DBMS_OUTPUT.PUT_LINE('RESULT :: ' || RESULT);
END;
/

ALTER TABLE MEMBER DROP COLUMN USERPWD;
COMMIT;


ALTER TABLE MEMBER MODIFY (MLEVEL DEFAULT 0);

select * from member;

ALTER TABLE SGROUP ADD LIMITGROUP VARCHAR2(100);

COMMENT ON COLUMN "MEETAGAIN"."SGROUP"."LIMITGROUP" IS '가입제한';

COMMIT;
-----------------------------관리자 계정 추가-------------------------------------
INSERT INTO MEMBER VALUES(
'meetAgainAdmin', '관리자', '서울시 강남구', NULL, NULL, '관리자','97/01/13','M',
'admin@naver.com', '010-2020-0810',0, DEFAULT, NULL, DEFAULT, DEFAULT, 0, DEFAULT, NULL
);

COMMIT;

------------------회원탈퇴 프로시저 생성------------------------------
create or replace PROCEDURE DEL_USERINFO
(
    UID IN MEMBER.USERID%TYPE,
    UPD_RESULT OUT NUMBER
)
IS
BEGIN
        UPDATE MEMBER SET WD_YN='Y' WHERE USERID = UID;
        UPDATE MEMBER SET WDDATE= SYSDATE WHERE USERID = UID;
		UPDATE MEMBERSHIP SET QUITDATE=SYSDATE WHERE USERID = UID;
        UPDATE JOING SET ISLEAVE='Y' WHERE USERID = UID;
		UPDATE GBOARD SET GBDEL='Y' WHERE USERID =UID;
		UPDATE GB_COMMENT SET CDEL='Y' WHERE USERID = UID;
        UPDATE SGROUP SET ISFIN='Y' WHERE GID IN  (
        SELECT GID FROM SGROUP JOIN JOING USING(GID) WHERE USERID= UID AND ISCPT='Y');
        UPD_RESULT := 1;
        COMMIT;
END;
/


create or replace PROCEDURE DEL_USER
(
    UID IN MEMBER.USERID%TYPE,
    DEL_RESULT OUT NUMBER
)
IS
BEGIN
        DELETE FROM USERTMI WHERE USERID= UID;
		DELETE FROM CATEINFO WHERE USERID= UID;
		DELETE FROM FOLLOW WHERE (FOLLOWER =  UID OR FOLLOWIN = UID);
        DEL_RESULT := 1;
        COMMIT;
END;
/

DROP TABLE CALENDAR;

CREATE TABLE CALENDAR(
CDID NUMBER PRIMARY KEY,
GID VARCHAR2(10) NOT NULL,
GDATE DATE NOT NULL,
GDATEEND DATE NOT NULL,
GINFO VARCHAR2(300),
GTIME DATE NOT NULL,
ISCTN CHAR(1) DEFAULT 'N' CHECK(ISCTN IN ('Y','N')),
CONSTRAINT FK_GID FOREIGN KEY(GID) REFERENCES SGROUP(GID)
);
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."CDID" IS '일정ID';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GID" IS '소모임ID';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GDATE" IS '모임시작날짜';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GDATEEND" IS '모임끝날짜';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GINFO" IS '일정설명';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."GDATE" IS '모임시간';
COMMENT ON COLUMN "MEETAGAIN"."CALENDAR"."ISCTN" IS '정기여부';

CREATE SEQUENCE SEQ_CDID
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;
				
-----------------------------------------------좋아요 테이블 생성
CREATE TABLE RVHELP(
RVID NUMBER NOT NULL,
USERID VARCHAR2(30) NOT NULL,
FOREIGN KEY (USERID) REFERENCES MEMBER (USERID),
FOREIGN KEY (RVID) REFERENCES REVIEW (RVID)
);
COMMENT ON COLUMN "MEETAGAIN"."RVHELP"."RVID" IS '리뷰아이디';
COMMENT ON COLUMN "MEETAGAIN"."RVHELP"."USERID" IS '유저아이디';
				
commit;                  
				
--------------------------------------
-- 관리자 계정에서 실행
GRANT CREATE ANY JOB TO MEETAGAIN;
--------------------------------------

-- 종료날짜되면 ISFIN 컬럼 'Y'로 변경하는 프로시저 --
CREATE OR REPLACE PROCEDURE PR_SGROUP_ISFIN
IS
BEGIN
    UPDATE SGROUP SET ISFIN = 'Y' WHERE DURATE < SYSDATE;
END;
/

-- 스케쥴 등록
BEGIN 
DBMS_SCHEDULER.CREATE_JOB(
    JOB_NAME => 'SCHEDULER_SGROUP_ISFIN'
    , JOB_TYPE => 'STORED_PROCEDURE'
    , JOB_ACTION => 'PR_SGROUP_ISFIN'
    , START_DATE => TRUNC(SYSDATE) +24/24
    , REPEAT_INTERVAL => 'FREQ=DAILY; INTERVAL=1');
END;

-- 스케줄러 등록
BEGIN DBMS_SCHEDULER.ENABLE('SCHEDULER_SGROUP_ISFIN'); END;

-- 스케줄러 확인
SELECT * FROM USER_SCHEDULER_JOBS;

				
