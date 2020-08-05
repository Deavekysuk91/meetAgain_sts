
package com.kh.meetAgain.sgroup.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;

import com.kh.meetAgain.common.util.Utils;
import com.kh.meetAgain.sgroup.model.exception.SgroupException;
import com.kh.meetAgain.member.model.vo.CateInfo;
import com.kh.meetAgain.member.model.vo.Member;
import com.kh.meetAgain.sgroup.model.service.SgroupService;
import com.kh.meetAgain.sgroup.model.vo.GB_comment;
import com.kh.meetAgain.sgroup.model.vo.Gboard;
import com.kh.meetAgain.sgroup.model.vo.Joing;
import com.kh.meetAgain.sgroup.model.vo.Sgroup;


@SessionAttributes(value= {"sgroup","member"})
@Controller
public class SgroupController {

	@Autowired
	SgroupService sgroupService;

	// 모입 생성 페이지로 이동
	@RequestMapping("/sgroup/create.do")
	public String create() {
		return "sgroup/create";
	}

	@RequestMapping("/sgroup/sgroupCreateEnd.do")
	public String sgroupCreateEnd(Sgroup sgroup, Model model, HttpSession session,
			@RequestParam(value = "sgroupImg", required = false) MultipartFile[] sgroupImg,
			@RequestParam String userId) {

		System.out.println("sgroup : " + sgroup);
		String saveDir = session.getServletContext().getRealPath("/resources/upload/groupImg");

		File dir = new File(saveDir);

		System.out.println("폴더가 있나요? " + dir.exists());

		if (dir.exists() == false)
			dir.mkdirs();

		for (MultipartFile f : sgroupImg) {
			if (!f.isEmpty()) {

				String originName = f.getOriginalFilename();
				String ext = originName.substring(originName.lastIndexOf(".") + 1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");

				int rndNum = (int) (Math.random() * 1000);

				String renamedName = sdf.format(new java.util.Date()) + "_" + rndNum + "." + ext;

				try {
					f.transferTo(new File(saveDir + "/" + renamedName));
				} catch (IllegalStateException | IOException e) {
					e.printStackTrace();
				}

				sgroup.setGImg(renamedName);

			}
		}

		int result = sgroupService.insertSgroup(sgroup);
		String msg = "";

		if (result > 0) {
			msg = "모임 생성 완료";
			System.out.println("모임생성완료");
		} else {
			msg = "모임 생성 실패";
			System.out.println("모임생성완료");
		}

		return "redirect:/sgroup/group.do";

	}

	// 소모임 전체 리스트 출력
	@RequestMapping("/sgroup/group.do")
	public String group(@ModelAttribute("member") Member m, Model model) {
		
		List<Sgroup> list = sgroupService.selectSgroupList();
		List<CateInfo> cateInfo = sgroupService.selectCateInfo(m.getUserId());
		List<Joing> joUser = sgroupService.selectJoingUser(m.getUserId());
		int groupCount = sgroupService.selectGroupCount(m.getUserId());
		
		model.addAttribute("list", list);
		model.addAttribute("cateInfo", cateInfo);
		model.addAttribute("joUser", joUser);
		model.addAttribute("groupCount", groupCount);

		System.out.println("groupCount(group.do) : " + groupCount);
		System.out.println("cateInfo : " + cateInfo);

		return "sgroup/group";
	}

	// 소모임 한개 출력

	@RequestMapping("/sgroup/groupInfo.do")

	public String groupInfo(@ModelAttribute("member") Member m, @RequestParam String gId, Model model) {
		
		Sgroup sr = sgroupService.selectOneSgroup(gId);

		List<Joing> joing = sgroupService.selectJoing(gId);
		
		int groupCount = sgroupService.selectGroupCount(m.getUserId());

		model.addAttribute("sgroup", sr);
		model.addAttribute("joing", joing);
		model.addAttribute("groupCount", groupCount);

		System.out.println("groupCount : " + groupCount);

		return "sgroup/groupInfo";
	}

	@RequestMapping("/sgroup/groupJoin.do")
	public String groupJoin(Joing joing, Model model) {

		int result = sgroupService.insertGroupJoin(joing);

		System.out.println("result : " + result);

		 String loc = "/sgroup/group.do"; 
		 String msg = "";

		 if(result > 0) msg = "모임 가입 성공!"; 
		 else msg = "모임 가입 실패!";

		  model.addAttribute("loc", loc); 
		  model.addAttribute("msg", msg);

		return "common/msg";
	}
	
	@RequestMapping("/sgroup/groupAlbum.do")
	public String groupAlbum(@RequestParam String gid, Model model) {
		model.addAttribute("gid", gid);
		return "sgroup/groupAlbum";
	}

	@RequestMapping("/sgroup/memberList.do")
	public String memberList(@RequestParam String gid, Model model) {
		List<Joing> joing = sgroupService.selectJoing(gid);
		
		model.addAttribute("joing", joing);
		return "sgroup/memberList";
	}


	@RequestMapping("/sgroup/groupLeave.do")
	public String groupLeave(@ModelAttribute("member") Member m, @RequestParam String gid, Model model) {
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("userId", m.getUserId());
		map.put("gid", gid);
		
		int result = sgroupService.groupLeave(map);
		
		 String loc = "/sgroup/group.do"; 
		 String msg = "";

		 if(result > 0) msg = "모임 탈퇴 성공!"; 
		 else msg = "모임 탈퇴 실패!";

		  model.addAttribute("loc", loc); 
		  model.addAttribute("msg", msg);

		return "common/msg";
	}
	

	@RequestMapping("/sgroup/groupBoard.do")
	public String groupBoard(@RequestParam("gid") String gId,
			@RequestParam(value = "cPage", required = false, defaultValue = "1") int cPage, Model model) {

		// 한 페이지 당 게시글 수
		int numPerPage = 10; // limit 역할

		// 1. 현재 페이지 게시글 목록 가져오기
		// 실제 데이터베이스의 데이터에서
		// 머릿글 : 키(key) , 실제 값 : 값(value) => 여러 개니까 List에 담기
		List<Map<String, String>> list = sgroupService.selectgBoardList(gId, cPage, numPerPage);

		// 2. 페이지 계산을 위한 총 페이지 개수
		int totalContents = sgroupService.selectgBoardTotalContents();

		// 3. 패아자 HTML 생성
		String pageBar = Utils.getPageBar(totalContents, cPage, numPerPage, "groupBoard.do");


		String loc = "/sgroup/groupBoard.do";
		String msg = "";
		
			loc = "/sgroup/groupBoard.do?gId=" + gId;

		
		model.addAttribute("loc", loc).addAttribute("msg", msg);
		model.addAttribute("list", list);
		model.addAttribute("totalContents", totalContents);
		model.addAttribute("numPerPage", numPerPage);
		model.addAttribute("pageBar", pageBar);

		
		System.out.println("list : " + list);
		System.out.println("Controller gId : " + gId);

		model.addAttribute("gid", gId);

		return "/sgroup/groupBoard";

	}
	
	@RequestMapping("/sgroup/groupBoardDetail.do")
	public String groupBoardDetail(@RequestParam int gbId, Model model) {

		Gboard gb = sgroupService.SelectOnegBoard(gbId);
		List<GB_comment> list = sgroupService.selectCommentList(gbId);

		int gbRate = sgroupService.updateReadCount(gbId);
		model.addAttribute("gbRate", gbRate);
		model.addAttribute("list", list);
		model.addAttribute("Gboard", gb);
		System.out.println("Detail controller list : " + list);

		return "/sgroup/groupBoardDetail";
	}

	@RequestMapping("sgroup/gboardInsert.do")
	public String gboardInsert() {

		return "/sgroup/gboardInsert";

	}

	@RequestMapping("/sgroup/gbInsert.do")
	public String gbInsert(@ModelAttribute("member") Member m, @RequestParam("gId") String gId, Gboard Gboard, Model model) {
		System.out.println("gid:"+gId+"userid:"+m.getUserId());
		Gboard.setGId(gId);
		Gboard.setUserId(m.getUserId());
		int result = sgroupService.insertgBoard(Gboard);
		
		String loc = "/sgroup/groupBoardDetail.do";
		String msg = "";
		if (result > 0) {
			msg = "게시글 등록 성공!";
			loc = "/sgroup/groupBoardDetail.do?gbId=" + Gboard.getGbId();

		} else {
			msg = "게시글 등록 실패!";
		}

		model.addAttribute("loc", loc).addAttribute("msg", msg);
		System.out.println("Gboardcontroller : " + Gboard);
		System.out.println(msg);
		return "common/msg";

	}

	@RequestMapping("sgroup/groupBoardUpdate.do")
	public String noticeUpdate(int gbId, Model model) {
		model.addAttribute("Gboard", sgroupService.SelectOnegBoard(gbId));
		return "/sgroup/groupBoardUpdateForm";
	}

	@RequestMapping("/sgroup/gbUpdate.do")
	public String gbUpdate(Gboard Gboard, Model model) {
		int result = sgroupService.updategBoard(Gboard);

		String loc = "sgroup/groupBoard.do";
		String msg = "";

		if (result > 0) {
			msg = "게시글 수정이 완료되었습니다";
			loc = "/sgroup/groupBoardDetail.do?gbId=" + Gboard.getGbId();
		} else {
			msg = "게시글 수정 실패. 다시 시도해주세요";
		}

		model.addAttribute("loc", loc).addAttribute("msg", msg);
		System.out.println("updateController : " + Gboard);

		return "common/msg";
	}

	@RequestMapping("/sgroup/groupBoardDelete.do")
	public String groupBoardDelete(@RequestParam int gbId, HttpSession session, Model model) {
		int result = sgroupService.deletegBoard(gbId);

		String loc = "sgroup/groupBoard.do";
		String msg = "";

		if (result > 0) {
			msg = "게시글 삭제 성공!";

		} else {
			msg = "게시글 삭제 실패!";
		}

		model.addAttribute("loc", loc).addAttribute("msg", msg);
		System.out.println("deleteController session : " + session);
		System.out.println("deleteController model : " + model);
		return "common/msg";
	}

	@RequestMapping("/sgroup/selectGboardComment.do")
	public String listComment(Model model) {

		/*
		 * List<GB_comment> list = sgroupService.selectCommentList();
		 * 
		 * model.addAttribute("list", list);
		 */
		return "/sgroup/groupBoardDetail.do";

	}

	@RequestMapping("sgroup/gotoGroup.do")
	public String gotoGroup(@RequestParam String gid, Model model) {

		String loc = "/sgroup/groupBoard.do?gid=" + gid;
		String msg = "";

		model.addAttribute("gid", gid);
		model.addAttribute("loc", loc);

		return "common/msg";
	}
	
	@RequestMapping("/sgroup/insertComment.do")
	public String insertComment(@RequestParam("gbId") int gbId, GB_comment GB_comment, Model model) {

		GB_comment.setGbId(gbId);
		int result = sgroupService.insertComment(GB_comment);
		

		String loc = "/sgroup/insertComment.do";
		String msg = "";
		if (result > 0) {
			msg = "댓글 등록 성공!";
			loc = "/sgroup/groupBoardDetail.do?gbId=" + gbId;

		} else {
			msg = "댓글 등록 실패!";
		}

		model.addAttribute("loc", loc).addAttribute("msg", msg);
		System.out.println("controller GB" + GB_comment);
		return "common/msg";

	}
	@RequestMapping("/sgroup/commentUpdate.do")
	public String commentUpdate(@RequestParam("cId") int cId, GB_comment GB_comment, Model model) {
		
		GB_comment.setCId(cId);
		int result = sgroupService.commentUpdate(GB_comment);

		String loc = "/sgroup/insertComment.do";
		String msg = "";
		if (result > 0) {
			msg = "댓글 등록 성공!";
			loc = "/sgroup/groupBoardDetail.do?gbId=" + GB_comment.getGbId();

		} else {
			msg = "댓글 등록 실패!";
		}

		model.addAttribute("GB_comment", sgroupService.commentUpdate(GB_comment));
		model.addAttribute("loc", loc).addAttribute("msg", msg);
		System.out.println("controller GB" + GB_comment);
		return "common/msg";
		
	}
	


	@RequestMapping("/sgroup/commentDelete.do")
	public String commentDelete(int cId, SessionStatus status, Model model, GB_comment gB_commnet) {
			
		try { 
			int result = sgroupService.commentDelete(cId);
			
			String loc = "/sgroup/groupBoardDetail.do";
			String msg = "";
			
			if(result > 0) {
				loc ="/sgroup/groupBoardDetail.do?gbId=" + gB_commnet.getGbId();
				msg = "댓글!";
				status.setComplete(); // 세션 완료(만료) 처리
			}
			else msg = "회원 탈퇴 실패!";
			
			model.addAttribute("loc", loc);
			model.addAttribute("msg", msg);		
					
		} catch(Exception e) {
			
			// 받은 에러를 서버 개발자가 의도한 형식으로 보내기
			throw new SgroupException(e.getMessage());
		}
		
		return "common/msg";
	}

	@RequestMapping("/sgroup/groupDetail.do")
	public String groupDetail(@RequestParam String gid, Model model) {
		Sgroup s = sgroupService.selectOneSgroup(gid);
		List<Joing> joing = sgroupService.selectJoing(gid);
		model.addAttribute("sgroup", s);
		model.addAttribute("joing", joing);
		model.addAttribute("gid", gid);
		
		System.out.println("joing-groupDetail : " + joing);

		return "sgroup/groupDetail";
	}

}
