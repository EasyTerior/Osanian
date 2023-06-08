<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%-- JSTL --%>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
	crossorigin="anonymous"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<!-- icons -->
<link
	href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css"
	rel="stylesheet" />
<!-- icons -->
<script	src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
	
	<!-- BX 슬라이더 관련 라이브러리 호출 시작 --> 
    <!-- jQuery library
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	 -->
	
	
    <!-- bxSlider Javascript file -->
    <script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>

    <!-- bxSlider CSS file -->
    <link href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css" rel="stylesheet" />
    <!-- BX 슬라이더 관련 라이브러리 호출 종료 --> 

<style>
body, main, section {
	position: relative;
}
 .pline{
 		font-size: 20px;  /* 글자 크기 설정 */
	    font-weight:bold;
	    text-align:center;
	    margin-top:20px;
	    margin-bottom:20px;
 
 } 
 
 
</style>
<script type="text/javascript">
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	var slider;
	
	$(document).ready(function(){
		// 회원가입 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "성공 메세지"}){ // MemberController.java에서 rttr.addFlashAttribute("msgType", "성공 메세지");로 보냄
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-success");
			}
			$("#myModal").modal("show");
		}
		
	});
	
	
	  $(document).ready(function() {
	    // 이미지 파일 선택 시
	    $("#imageFile").change(function() {
	      var formData = new FormData();
	      formData.append("file", $("#imageFile")[0].files[0]);

	      // Ajax 통신
	      $.ajax({
	        url: "http://localhost:5000/upload",
	        type: "POST",
	        data: formData,
	        contentType: false,
	        processData: false,
	        success: function(result) {
	          // 결과 처리
	          resultData = result;
	          displayResult(result);

	          // 쇼핑 API 호출
	          callShoppingAPI(result);
	          
	        },
	        error: function(error) {
	          console.log(error);
	        }
	      });
	    });

	    // 결과 표시 함수
	    function displayResult(result) {
	      // 결과 값을 표시하는 로직 작성
	      console.log(result);
	      var uploadedImage = document.getElementById("uploadedImage");
	      uploadedImage.src = URL.createObjectURL($("#imageFile")[0].files[0]);

	      $("#resultType").text(result[0].class);
	      callShoppingAPI(result);
	      $("#resultText1-class").text(result[0].class);
	      $("#resultText1-probability").text((result[0].probability * 100).toFixed(2) + "% 일치");
	      $("#resultText2-class").text(result[1].class);
	      $("#resultText2-probability").text((result[1].probability * 100).toFixed(2) + "% 일치");

	      $("#resultType-Explanation").text(result[0].explanation);
	      
	      $("#result").css("display", "block");
	      $("#base").css("display", "none");
	    }
	  });
	  
	// bxSlider 인스턴스를 가리킬 변수를 선언합니다.
/*	  var slider = $('#bxslider').bxSlider({
          minSlides: 5,
          maxSlides: 100,
          moveSlides: 3,
          slideWidth: 300,
          slideMargin: 5,
          mode: 'horizontal',
          auto: true,
          pause: 3000,
          speed: 1000
      }); */

	  function callShoppingAPI(result) {
	      var style = result[0].class;
          var image_urls = result[2].image_urls;
          console.log(image_urls);
          var image_src = result[2].image_src;
          console.log(image_src);
	      /*$.ajax({
	          url: 'http://localhost:5000/api/style_analysis',
	          type: 'POST',
	          data: JSON.stringify({ style: style }),
	          contentType: 'application/json',
	          dataType: 'json',
	          success: function(response) {
	              var image_urls = response.image_urls;
	              var image_src = response.image_src;
		             */
			$('#bxslider').empty();

	              for(var i = 0; i < image_urls.length; i++) {
	                  $('#bxslider').append('<a href="'+image_urls[i]+'"><img src="'+image_src[i]+'" width="220px" height="220px"></a>');
	              }
	              

					

	              // 이미지 로딩을 위해 약간의 시간을 기다립니다.
	              setTimeout(function() {
	            	    if (slider) {
	            	        slider.destroySlider(); // 기존 슬라이더가 존재하는 경우 파괴합니다.
	            	    }
	            	    // 새로운 슬라이더를 생성하고 인스턴스를 저장합니다.
	            	    slider = $('#bxslider').bxSlider({
	            	        minSlides: 2,
	            	        maxSlides: 100,
	            	        moveSlides: 2,
	            	        slideWidth: 300,
	            	        slideMargin: 2,
	            	        mode: 'horizontal',
	            	        auto: true,
	            	        pause: 3000,
	            	        speed: 1000
	            	    });
	            	    console.log(slider);
	            	}, 500);
	          }/*,
	          error: function(error) {
	              console.log(error);
	          }
	      });
	  }*/




	  
		// 결과 숨기고 다시 분석 테스트 div 열기
	    function showBase() {
	        $("#result").css("display", "none");
	        $("#base").css("display", "block");

	    }
		

	    function saveStyle() {
	        var resultClass1 = $("#resultText1-class").text();
	        //console.log(resultClass1);
	        var resultClass2 = $("#resultText2-class").text();
	        //console.log(resultClass2);
	        var resultClass1_probability = $("#resultText1-probability").text();
	        //console.log(resultClass1_probability);
	        var resultClass2_probability = $("#resultText2-probability").text();
	        //console.log(resultClass2_probability);
	        
	        var data = {
	            resultClass1: resultClass1,
	            resultClass2: resultClass2,
	            resultClass1_probability: resultClass1_probability,
	            resultClass2_probability: resultClass2_probability
	        };
	        //console.log(data);
	        
	        // ajax 비동기 통신
	        $.ajax({
	            url: "style/save",
	            type: "post",
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	            },
	            data: JSON.stringify(data),
	            contentType: "application/json",
	            dataType: "json",
	            success: function(response) {
	                //console.log(response); // 서버 응답 확인
	                alert("성공적으로 저장되었습니다.");
	                showBase();
	            },
	            error: function(xhr, status, error) {
	                console.log(xhr); // 에러 상세 정보 확인
	                console.log(status);
	                console.log(error);
	                alert("error...");
	            }
	        });
	    }



		

</script>
<title>EasyTerior</title>
</head>
<body>
	<main class="main">
		<jsp:include page="../common/header.jsp"></jsp:include>
		<jsp:include page="../common/submenu.jsp"></jsp:include>
		<section class="fixed-top container-fluid overflow-auto h-100"
			style="margin: 137px 0 56px 0; padding: 0 0 56px 100px;">
		<div class="container-fluid" style="min-height:100vh;margin-bottom:200px;">
		<div class="container-fluid" id="base" style="min-height:100vh;margin-bottom:200px;display:block;">
			<div class="row m-auto" style="width:80%">
				<h1 class="text-center mt-4 mb-3">스타일 분석하기</h1>
			    <div class="col-sm-6">
			        <div class="card border-0">
			            <div class="card-body">
			                <h5 class="card-title text-center fw-bold">예시 이미지</h5>
			            </div>
			            <img class="card-img-bottom" src="${ contextPath }/resources/images/common/styleRoom.jpg" alt="styleRoom">
			        </div>
			    </div>
			    <div class="col-sm-6">
			        <div class="card border-0">
			            <div class="card-body">
			                <h5 class="card-title text-center mb-4 fw-bold">이미지 가이드라인</h5>
			                <p class="card-text text-center" style="padding:5% 0 0 0;">예시 이미지처럼 방 전체가 다 보이도록 찍은 사진을 업로드해주세요.<br/> <br/>다음은 적절하지 않은 사진 예시 입니다.<br/>소품만 보이는 사진은 인식이 어려워요!<br/><br/></p>
			                <div class="card-text d-sm-flex flex-sm-row flex-column justify-content-center">
			                <img class="card-img-bottom img-fluid" src="${ contextPath }/resources/images/common/bad_exam01.jpg" alt="bad_exam01" style="width:50%;">
			                <img class="card-img-bottom img-fluid" src="${ contextPath }/resources/images/common/bad_exam02.jpg" alt="bad_exam02" style="width:50%;">
			                </div>
			            </div>
			        </div>
			    </div>
			</div>
			<div class="row text-center" style="padding-top:50px;">
				<input type="file" id="imageFile" accept="image/*" class="btn btn-primary d-block m-auto ps-2 fw-bold" style="width: 260px; opacity: 0; position: absolute;">
				<label for="imageFile" class="btn btn-primary d-block m-auto ps-2 fw-bold" style="width: 260px;">사진 업로드</label>

			</div>
		
</div>
			<!-- 결과 값 출력 할 div단 -->
			<div class="container-fluid" id="result" style="display: none;">
				<div class="row text-center" style="padding-top:2%;" id="result-title">
					<h3>스타일 분석 결과</h3>
					<p>당신의 대표 인테리어는?</p>
					<h3 id="resultType"></h3>


				</div>
				
				<div class="container-fluid d-flex justify-content-center text-center align-items-center" style="">
				    <div class="text-center">
				        <img alt="yourimage" class="card-img-bottom img-fluid" id="uploadedImage" src="">
				    </div>
				    <div style="padding-left:50px;">
				        <h5>&lt;대표 스타일&gt;</h5>
				        <h4 id="resultText1-class" style=""></h4>
				        <h4 id="resultText1-probability" style=""></h4>
				        <br/>
				        <h5 id="resultText2-class" style=""></h5>
				        <h5 id="resultText2-probability" style=""></h5>
				    </div>
				</div>
				<div class="text" style="padding-top:5%; width:60%; margin:auto;">
					<p id="resultType-Explanation"></p>
				</div>

				<div class="row d-flex justify-content-center text-center" style="padding-top:50px;">
					<div class="btn-group">
						<button onclick="showBase()" class="btn btn-success ps-2 fw-bold" style="width: 130px;">다시 해보기</button>
						<button onclick="saveStyle()" class="btn btn-primary ps-2 fw-bold" style="width: 200px;">스타일 저장하기</button>
					</div>
				</div>
				<br>
				<p class="pline">이 스타일과 관련된 인테리어 소품을 추천해드릴게요!</p>
				<br>
				<div>
				<div id="bxslider">
				</div>
				</div>

			</div>
</div>
		</section>
		<jsp:include page="../common/footer.jsp"></jsp:include>
	</main>

	<!-- The Modal -->
	<div class="modal fade" id="myModal">
		<!-- animation : fade -->
		<div class="modal-dialog">
			<div id="checkType" class="card modal-content">
				<!-- Modal Header -->
				<div class="modal-header card-header">
					<h4 class="modal-title text-center">${ msgType }</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<!-- Modal body -->
				<div class="modal-body">
					<p id="checkMessage" class="text-center">${ msg }</p>
				</div>
				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-danger"
						data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">

</script>
</body>
</html>