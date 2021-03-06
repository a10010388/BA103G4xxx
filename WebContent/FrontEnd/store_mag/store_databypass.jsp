<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*"%>
<%@ page import="com.store.model.*"%>
<%@ page import="com.prod.model.*"%>
<%@ page import="com.ord.model.*"%>
<%@ page import="com.ord_list.model.*"%>
<%@ page import="com.mem.model.*"%>

<jsp:include page="/FrontEnd/include/head.jsp"/>
<c:set var="mem_ac" value="${sessionScope.mem_ac}" scope="page"/>
<%
	
	String store_no = (String) session.getAttribute("store_no");
	
%>

<jsp:useBean id="storeSvc" scope="page" class="com.store.model.StoreService" />
<jsp:useBean id="memSvc" scope="page" class="com.mem.model.MemService" />
<c:set var="memVO" value="${memSvc.findByPrimaryKeyNoImg(mem_ac)}"/>
<c:set var="storeVO" value="${storeSvc.getonestore(store_no)}"/>
<jsp:useBean id="prodSvc" scope="page"
	class="com.prod.model.ProdService" />
<jsp:useBean id="ordSvc" scope="page" class="com.ord.model.OrdService" />
<c:set var="ord_listVOs"
	value="${ordSvc.getOrd_listByOrd(ordVO.ord_no)}" />
	
<div class="content container mgt-depn-nav">

	<%-- 錯誤表列 --%>
	<c:if test="${not empty errorMsgs}">
		<font color='red'>請修正以下錯誤:
			<ul>
				<c:forEach var="message" items="${errorMsgs}">
					<li>${message}</li>
				</c:forEach>
			</ul>
		</font>
	</c:if>
	<div class="shop">
		<div class="shop col-sm-8">
		<FORM METHOD="POST"
		ACTION="<%=request.getContextPath()%>/store/ToStore.do" name="form1" enctype="multipart/form-data">
			<table class="table_shop">
				<caption>
					<big><b>修改店家資料</b></big><br>
					<ul class="data">
						<li>這是您的會員資料，請確認下列資料是否正確。</li>
						<li>星號 * 為必填欄位。</li>
					</ul>
				</caption>
				<tr>
					<th>帳號資訊</th>
					<th></th>
					<th></th>
				</tr>
				<tr>
					<td>會員帳號</td>
					<td>${mem_ac}</td>
					<td></td>
				</tr>
				<tr>
					<th>公司審核狀態：</th>
					<th>${storeVO.store_stat}</th>
					<th></th>
				</tr>
				<tr>
					<td>公司名稱</td>
					<td><input type="text" name="store_name" value="${storeVO.store_name}"></td>
					<td></td>
				</tr>
				<tr>
					<td>負責人姓名</td>
					<td>${memVO.mem_lname}${memVO.mem_fname}</td>
					<td></td>
				</tr>
				<tr>
					<td>公司統一編號</td>
					<td>${storeVO.tax_id_no}</td>
					<td></td>
				</tr>
				<tr>
					<td>免運費金額</td>
					<td><input type="text" name="store_free_ship" value="${storeVO.store_free_ship}"></td>
					<td></td>
				</tr>
				<tr>
					<td>公司電話</td>
					<td><input type="text" name="store_phone" value="${storeVO.store_phone}"></td>
					<td></td>
				</tr>
				<tr>
					<td>公司地址</td>
					<td><input type="text" name="store_add" value="${storeVO.store_add}" id="address"></td>
					<td></td>
				</tr>
				<tr>
					<td>公司介紹</td>
					<td><textarea rows="4" cols="50" name="store_cont">${storeVO.store_cont}</textarea></td>
					<td></td>
				</tr>
				
				<tr>
					<td>店家照片1</td>
					<td><output id="mylist1"><img src="<%=request.getContextPath()%>/store/storeImg.do?store_no=${storeVO.store_no}&index=1" width='100'></output></td>
					<td><input type="file" name="store_pic1" value="上傳" id="storepic1"></td>
				</tr>
				<tr>
					<td>店家照片2</td>
					<td><output id="mylist2"><img src="<%=request.getContextPath()%>/store/storeImg.do?store_no=${storeVO.store_no}&index=2" width='100'></output></td>
					<td><input type="file" name="store_pic2" value="上傳" id="storepic2"></td>
				</tr>
				<tr>
					<td>店家照片3</td>
					<td><output id="mylist3"><img src="<%=request.getContextPath()%>/store/storeImg.do?store_no=${storeVO.store_no}&index=3" width='100'></output></td>
					<td><input type="file" name="store_pic3" value="上傳" id="storepic3"></td>
				</tr>
			</table>
					<input type="hidden" name="action" value="update_data"> 
					<input	type="hidden" name="store_add_lat" id="lat" size="45" value="${storeVO.store_add_lat}" />
					<input	type="hidden" name="store_add_lon" id="lng" size="45" value="${storeVO.store_add_lon}" />
					<input	type="hidden" name="store_no"  size="45" value="${storeVO.store_no}" />
					<input	type="submit" value="確認修改" />
			</FORM>
		</div>
	</div>



</div>

	<script>
	
	$(function() {
		function getLatLngByAddr($address) {
			var geocoder = new google.maps.Geocoder(); //定義一個Geocoder物件
			geocoder.geocode({
				address : $address
			}, //設定地址的字串
			function(results, status) { //callback function
				if (status == google.maps.GeocoderStatus.OK) { //判斷狀態
					$lat = results[0].geometry.location.lat();
					var lat = $lat;
					var lat1 = lat.toFixed(12);
					$("#lat").val(lat1);
					$lng = results[0].geometry.location.lng();
					var lng = $lng;
					var lng1 = lng.toFixed(12);
					$("#lng").val(lng1);

				}
			});
		}
		$("#address").focusout(function() { //地址查詢經緯度
			$address = $("#address").val();
			getLatLngByAddr($address);

		});
	});
		
	
	function handleFileSelect1(evt) {
		$("#mylist1").empty();

		var files = evt.target.files; // FileList object

		// Loop through the FileList and render image files as thumbnails.
		for (var i = 0, f; f = files[i]; i++) {

			// Only process image files.
			if (!f.type.match('image.*')) {
				continue;
			}

			var reader = new FileReader();

			// Closure to capture the file information.
			reader.onload = (function(theFile) {
				return function(e) {
					// Render thumbnail.
					var span = document.createElement('span');
					span.innerHTML = [ '<img class="thumb" src="',
							e.target.result, '" title="', escape(theFile.name),
							'"/>' ].join('');
					document.getElementById('mylist1').insertBefore(span, null);
					$(".thumb").width(150);

				};
			})(f);

			// Read in the image file as a data URL.
			reader.readAsDataURL(f);
		}
	}
	document.getElementById('storepic1').addEventListener('change',
			handleFileSelect1, false);
	
	function handleFileSelect2(evt) {
		$("#mylist2").empty();

		var files = evt.target.files; // FileList object

		// Loop through the FileList and render image files as thumbnails.
		for (var i = 0, f; f = files[i]; i++) {

			// Only process image files.
			if (!f.type.match('image.*')) {
				continue;
			}

			var reader = new FileReader();

			// Closure to capture the file information.
			reader.onload = (function(theFile) {
				return function(e) {
					// Render thumbnail.
					var span = document.createElement('span');
					span.innerHTML = [ '<img class="thumb" src="',
							e.target.result, '" title="', escape(theFile.name),
							'"/>' ].join('');
					document.getElementById('mylist2').insertBefore(span, null);
					$(".thumb").width(150);

				};
			})(f);

			// Read in the image file as a data URL.
			reader.readAsDataURL(f);
		}
	}
	document.getElementById('storepic2').addEventListener('change',
			handleFileSelect2, false);
	
	function handleFileSelect3(evt) {
		$("#mylist3").empty();

		var files = evt.target.files; // FileList object

		// Loop through the FileList and render image files as thumbnails.
		for (var i = 0, f; f = files[i]; i++) {

			// Only process image files.
			if (!f.type.match('image.*')) {
				continue;
			}

			var reader = new FileReader();

			// Closure to capture the file information.
			reader.onload = (function(theFile) {
				return function(e) {
					// Render thumbnail.
					var span = document.createElement('span');
					span.innerHTML = [ '<img class="thumb" src="',
							e.target.result, '" title="', escape(theFile.name),
							'"/>' ].join('');
					document.getElementById('mylist3').insertBefore(span, null);
					$(".thumb").width(150);

				};
			})(f);

			// Read in the image file as a data URL.
			reader.readAsDataURL(f);
		}
	}
	document.getElementById('storepic3').addEventListener('change',
			handleFileSelect3, false);
	</script>
<style>
.verticnav {
	list-style: none;
	font-size: 25px;
}
.data{
	list-style: none;
}

caption {
	text-align: center;
}
.table_shop{
 width:750px;
 
}
</style>

<jsp:include page="/FrontEnd/include/footer.jsp"/>