package com.kh.meetAgain.sgroup.model.vo;

import java.sql.Timestamp;
import java.io.Serializable;
import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor // 기본 생성자용
@AllArgsConstructor // 전체 매개변수 받는 생성자 자동 생성 어노테이션
public class Calendar implements Serializable {
	
	private static final long serialVersionUID = 9991999L;
	
	private String cdId;
	private String gId;
	private Date gDate;
	private Date gDateEnd;
	private String gInfo;
	private Timestamp gTime;	
	private String isCtn;
	
}
