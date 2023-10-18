--bbs.sql
--답변형 및 댓글형 게시판

--테이블 삭제
drop table tb_bbs;

--테이블 생성
create table tb_bbs(
  bbsno    number(5)       not null -- 일련번호 -99999~99999
 ,wname    varchar2(20)    not null -- 작성자
 ,subject  varchar2(100)   not null -- 글제목
 ,content  varchar2(2000)  not null -- 글내용
 ,passwd   varchar2(10)    not null -- 글비밀번호
 ,readcnt  number(5)       default 0 not null -- 글조회수
,regdt    date            default  sysdate   -- 글작성일
 ,grpno    number(5)       not null  -- 글 그룹번호
 ,indent   number(5)       default 0 -- 들여쓰기
 ,ansnum   number(5)       default 0 -- 글순서
 ,ip       varchar2(15)    not null  -- 사용자 요청 PC의 IP
 ,primary key(bbsno)                 --bbsno 기본키 
);

--시퀀스 생성
create sequence bbs_seq;

--시퀀스 삭제
drop sequence bbs_seq;
///////////////////////////////


--새글쓰기
bbsno : 시퀀스를 이용해서 일련번호
wname, subject, content, passwd : 사용자가 입력
readcnt, regdt, indent, amsnum  : default 값
ip								: 요청 PC의 IP 저장
grpno							: max(bbsno) +1

--그룹번호(grpno) 만들기
select max(bbsno) from tb_bbs;
--null값이면 계산안됨
select max(bbsno)+1 from tb_bbs;
--nvl()함수를 이용해서 max(bbsno)값이 비어있을떄(null) 0으로 바꿈
select nvl(max(bbsno), 0) from tb_bbs;
--nvl()함수를 이용해서 max(bbsno)값이 비어있을떄(null) 0으로 바꾼 후 +1
select nvl(max(bbsno), 0)+1 from tb_bbs;

--행추가
insert into tb_bbs(bbsno,wname, subject, content, passwd, ip, grpno)
values(bbs_seq.nextval, ?, ?, ?, ?, ?, (select nvl(max(bbsno), 0)+1 from tb_bbs));

-- 전체목록
select bbsno, wname, subject,readcnt, regdt, indent
from  tb_bbs
order by grpno DESC, anssnum ASC;

--전체행갯수
select count(*) as cnt from tb_bbs;

--상세보기

select * from tb_bbs where bbsno=?;

--조회수 증가
update tb_bbs
set readcnt = readcnt+1
where bbsno = ?

--조회수 삭제
--비밀번호가 일치하면 삭제
delete from tb_bbs
where bbsno=? and passwd=?

--행수정 bbsUpdate.jsp
update tb_bbs set wname=?, subject=?, content=?, ip=?
where bbsno=? and passwd=?
///////////////////////////////////

● 답변쓰기 알고리즘

- 새글 쓰기 : 부모글
- 답변 쓰기 : 자식글

- 그룹번호 (grpno)	  : 부모글 그룹번호와 동일하게 
- 들여쓰기 (indent)  :	부모글 들여쓰기 +1
- 글순서	(ansnum)  : 부모글 글순서+1 한 후, 글순서 재조정

번호	 제목		 그룹번호	 들여쓰기	 글순서
1	서울시		   1		0	  0
	▶마포구	   1		1	  1
	 ▶▶이대	   1		2	  2	
	  ▶▶▶삼원타워 1			3	  3
	   ▶▶▶▶4강의 1		4	  4
	 ▶▶신촌	   1		2	  5
	  ▶▶▶아이티윌 1			3	  6
	▶강남구	   1		1	  6 -> 7 재조정
	
2	제주도		   2		0	  0
	▶애월읍	   2		1	  1
	▶서귀포	   2		1	  2
	
3	부산시		   3		0	  0


--글순서 (ansnum) 재조정
update tb_bbs 
set ansnum = ansnum+1
where grpno = ? and ansnum>=?

//////////////////////////////////////////////////////////

● [검색]

-- 제목+내용에서 '파스타'가 있는지 검색
where subject like '%파스타%' or content like '%파스타%'

-- 제목에서 '파스타'가 있는지 검색
where subject like '%파스타%'

-- 내용에서 '파스타'가 있는지 검색
where content like '%파스타%'

-- 작성자에서 '파스타'가 있는지 검색
where wname like '%파스타%'

///////////////////////////////////////


--출력 줄수
set pagesize 100;
--한줄 출력 글자갯수
set linesize 100;
--칼럼길이 10칸 임시 조정
col wname for a10;
col subject for a30;

● [페이징] - rownum 줄번호 활용

1)
select bbsno, subject, wname, readcnt, indent, regdt
from tb_bbs
order by grpno desc, ansnum asc;

2) rownum추가 - 
select bbsno, subject, wname, readcnt, indent, regdt, rownum
from tb_bbs
order by grpno desc, ansnum asc;

3) 1)의 SQL문을 셀프조인하고, rownum 추가
select bbsno, subject, wname, readcnt, indent, regdt, rownum
from (
		select bbsno, subject, wname, readcnt, indent, regdt
		from tb_bbs
		order by grpno desc, ansnum asc
	  );

4) 줄번호 1~10조회 (1페이지)
select bbsno, subject, wname, readcnt, indent, regdt, rownum
from (
		select bbsno, subject, wname, readcnt, indent, regdt
		from tb_bbs
		order by grpno desc, ansnum asc
	  )
where rownum>=1 and rownum<=10;



5) 줄번호 11~20조회 (2페이지) ->조회안됨, 선택된 레코드가 없습니다
select bbsno, subject, wname, readcnt, indent, regdt, rownum
from (
		select bbsno, subject, wname, readcnt, indent, regdt
		from tb_bbs
		order by grpno desc, ansnum asc
	  )
where rownum>=11 and rownum<=20;


6) 줄번호가 있는 3)의 테이블을 한번 더 셀프조인하고, rownum칼럼명을 r로 바꾼다
select * 
from (
	select bbsno, subject, wname, readcnt, indent, regdt, rownum as r
	from (
			select bbsno, subject, wname, readcnt, indent, regdt
			from tb_bbs
			order by grpno desc, ansnum asc
			)
	 )
where r>=11 and r<=20;

7) 페이징 + 검색
	예) 제목에서 '파스타'가 있는 행을 검색해서 2페이지(11행~20행) 조회하시오
select * 
from (
	select bbsno, subject, wname, readcnt, indent, regdt, rownum as r
	from (
			select bbsno, subject, wname, readcnt, indent, regdt
			from tb_bbs
			where subject like '%파스타%'
			order by grpno desc, ansnum asc
			)
	 )
where r>=11 and r<=20;


//////////////////////////////////////////////
● [과제] 제목과 댓글(자식글)의 갯수를 조회하시오

	제목
	-------------
	대한민국 (3)
	서울특별시 (5)
	오필승코리아
	무궁화 꽃이 피었습니다(2)
	
	
	
	
	










