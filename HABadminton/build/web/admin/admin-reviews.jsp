<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đánh giá - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>

    <jsp:include page="admin-sidebar.jsp">
        <jsp:param name="active" value="reviews" />
    </jsp:include>

    <div class="admin-main">
        <h2 class="admin-page-title">Quản lý Đánh giá Khách hàng</h2>

        <!-- THANH TÌM KIẾM VÀ LỌC -->
        <form action="${pageContext.request.contextPath}/admin-reviews" method="GET" class="filter-bar">
            <input type="text" name="keyword" value="${param.keyword}" class="filter-input" placeholder="Tìm tên KH, tên SP hoặc nội dung đánh giá...">
            <select name="star" class="filter-select">
                <option value="all">Tất cả số sao</option>
                <option value="5" ${param.star == '5' ? 'selected' : ''}>5 Sao</option>
                <option value="4" ${param.star == '4' ? 'selected' : ''}>4 Sao</option>
                <option value="3" ${param.star == '3' ? 'selected' : ''}>3 Sao</option>
                <option value="2" ${param.star == '2' ? 'selected' : ''}>2 Sao</option>
                <option value="1" ${param.star == '1' ? 'selected' : ''}>1 Sao</option>
            </select>
            <select name="status" class="filter-select">
                <option value="all">Trạng thái phản hồi</option>
                <option value="unreplied" ${param.status == 'unreplied' ? 'selected' : ''}>Chưa phản hồi</option>
                <option value="replied" ${param.status == 'replied' ? 'selected' : ''}>Đã phản hồi</option>
            </select>
            <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
            <a href="${pageContext.request.contextPath}/admin-reviews" class="btn-reset"><i class="fa-solid fa-rotate-right"></i></a>
        </form>

        <!-- DANH SÁCH ĐÁNH GIÁ (DẠNG LIST) -->
        <div class="rv-table">
            <div class="rv-thead">
                <div>Sản phẩm</div>
                <div>Khách hàng & Đánh giá</div>
                <div>Thời gian</div>
                <div>Trạng thái</div>
                <div style="text-align: right;">Thao tác</div>
            </div>

            <c:forEach items="${listReviews}" var="rv">
                <div class="rv-row" id="review-${rv.maDG}">
                    
                    <!-- Cột 1: Sản phẩm -->
                    <div class="rv-col-prod">
                        <img src="${pageContext.request.contextPath}/${rv.hinhAnhSP}" onerror="this.src='${rv.hinhAnhSP}'" alt="SP">
                        <h4>${rv.tenSP}</h4>
                    </div>

                    <!-- Cột 2: Khách hàng và nội dung -->
                    <div class="rv-col-review"> 
                        <div class="rv-cust">
                            <div class="avatar" style="overflow: hidden; padding: 0; display: flex; align-items: center; justify-content: center;">
                                <c:choose>
                                    <c:when test="${not empty rv.avatar}">
                                        <img src="${pageContext.request.contextPath}/${rv.avatar}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-solid fa-user"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:choose>
                                <c:when test="${rv.anDanh}">
                                    <span id="name-mask-${rv.maDG}" data-full="${rv.tenKhachHang}" data-is-masked="true" style="font-weight: 600; color: var(--text-ivory); font-size: 14px;"></span>
                                    <i class="fa-solid fa-eye" id="icon-name-${rv.maDG}" 
                                       style="cursor: pointer; color: var(--text-muted); font-size: 14px; margin-left: 6px; transition: 0.2s;" 
                                       onclick="toggleNameReveal('${rv.maDG}')" title="Xem tên thật"></i>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-weight: 600; color: var(--text-ivory); font-size: 14px;">${rv.tenKhachHang}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="rv-stars">
                            <c:forEach begin="1" end="${rv.soSao}"><i class="fa-solid fa-star"></i></c:forEach>
                            <c:forEach begin="${rv.soSao + 1}" end="5"><i class="fa-regular fa-star"></i></c:forEach>
                        </div>
                        <div class="rv-text">"${rv.noiDung}"</div>
                        
                        <!-- Media Sửa Lỗi Path -->
                        <div class="rv-media">
                            <c:if test="${not empty rv.hinhAnh}">
                                <img src="${pageContext.request.contextPath}/${rv.hinhAnh}" onerror="this.src='${rv.hinhAnh}'" onclick="openLightbox(this.src, 'image')">
                            </c:if>
                            <c:if test="${not empty rv.video}">
                                <div onclick="openLightbox('${pageContext.request.contextPath}/${rv.video}', 'video')">
                                    <video src="${pageContext.request.contextPath}/${rv.video}"></video>
                                </div>
                            </c:if>
                        </div>

                        <!-- Hộp phản hồi (Admin) -->
                        <div class="rv-admin-reply-box" id="reply-box-${rv.maDG}" style="display: ${empty rv.phanHoiAdmin ? 'none' : 'block'};">
                            <strong>Phản hồi của Cửa hàng:</strong>
                            <p id="reply-text-${rv.maDG}">${rv.phanHoiAdmin}</p>
                        </div>
                    </div> <!-- KẾT THÚC CỘT 2 -->

                    <!-- Cột 3: Thời gian -->
                    <div class="rv-col-date">
                        <fmt:formatDate value="${rv.ngayDG}" pattern="dd 'thg' MM, yyyy" /><br>
                        <small style="color:var(--text-muted);"><fmt:formatDate value="${rv.ngayDG}" pattern="hh:mm a" /></small>
                    </div>

                    <!-- Cột 4: Trạng thái (CHỈ GIỮ LẠI TRẠNG THÁI PHẢN HỒI) -->
                    <div class="rv-badges">
                        <span class="rv-badge ${not empty rv.phanHoiAdmin ? 'badge-replied' : 'badge-pending'}" id="badge-reply-${rv.maDG}">
                            ${not empty rv.phanHoiAdmin ? 'Đã phản hồi' : 'Chưa phản hồi'}
                        </span>
                    </div>

                    <!-- Cột 5: Thao tác (3 icon) -->
                    <div class="rv-col-actions">
                        <!-- Icon Con Mắt Ẩn/Hiện -->
                        <button class="btn-action ${rv.trangThai == 1 ? 'eye-open' : 'eye-closed'}" id="btn-eye-${rv.maDG}" title="Ẩn/Hiện trên Web" onclick="toggleVisibility('${rv.maDG}',${rv.trangThai})">
                            <i class="fa-solid ${rv.trangThai == 1 ? 'fa-eye' : 'fa-eye-slash'}"></i>
                        </button>
                        
                        <!-- Icon Reply -->
                        <button class="btn-action reply" title="Trả lời khách hàng" 
                                onclick="openReplyModal('${rv.maDG}', '${rv.anDanh ? '@khach_an_danh' : rv.tenKhachHang}', ${rv.soSao}, '<fmt:formatDate value="${rv.ngayDG}" pattern="dd/MM/yyyy HH:mm:ss a" />', '${rv.tenSP}', '${pageContext.request.contextPath}/${rv.hinhAnhSP}')">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </button>

                        <!-- Icon Xóa -->
                        <button class="btn-action delete" title="Xóa vĩnh viễn" onclick="deleteReview('${rv.maDG}')">
                            <i class="fa-solid fa-trash-can"></i>
                        </button>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty listReviews}">
                <p style="text-align:center; color:var(--text-silver); margin-top:30px;">Không tìm thấy đánh giá nào.</p>
            </c:if>
        </div>
    </div>

    <!-- MODAL PHẢN HỒI -->
    <div class="reply-modal-overlay" id="replyModalOverlay">
        <div class="reply-modal">
            <div class="rm-header">
                <h3>Chi tiết đánh giá</h3>
                <button class="rm-close" onclick="closeReplyModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            
            <div class="rm-body">
                <div class="rm-review-info">
                    <div class="rm-user-stars">
                        <strong id="modalUserName">@username</strong>
                        <div class="rv-stars" id="modalStars"></div>
                    </div>
                    <div class="rm-date" id="modalDate">04/12/2024 3:04:03 PM</div>
                </div>

                <div class="rm-product-preview">
                    <img id="modalProdImg" src="" onerror="this.src=this.src.replace('${pageContext.request.contextPath}/', '')" alt="SP">
                    <p id="modalProdName">Tên sản phẩm</p>
                </div>
                
                <div class="rm-original-text" id="modalOriginalText">"Nội dung khách đánh giá..."</div>

                <div class="rm-textarea-wrapper">
                    <label>Nội dung phản hồi của Cửa hàng</label>
                    <input type="hidden" id="modalReviewId">
                    <textarea class="reply-textarea" id="adminReplyText" placeholder="Nhập câu trả lời của bạn..."></textarea>
                    <span class="rm-note"><i class="fa-solid fa-circle-info"></i> Bạn có thể cập nhật lại hoặc xóa nội dung phản hồi này bất cứ lúc nào.</span>
                </div>
            </div>

            <div class="rm-footer">
                <button class="btn-cancel" onclick="closeReplyModal()">Hủy bỏ</button>
                <button class="btn-submit-reply" onclick="submitReply()">Gửi phản hồi</button>
            </div>
        </div>
    </div>

    <!-- LIGHTBOX XEM ẢNH/VIDEO -->
    <div id="mediaLightbox" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10000; background: rgba(0, 0, 0, 0.85); backdrop-filter: blur(10px); justify-content: center; align-items: center; flex-direction: column;">
        <span onclick="closeLightbox()" style="position: absolute; top: 25px; right: 40px; color: white; font-size: 40px; cursor: pointer; z-index: 10001; transition: 0.3s;" onmouseover="this.style.color='var(--brand-primary)'" onmouseout="this.style.color='white'">&times;</span>
        <div id="lightboxContent" style="max-width: 90%; max-height: 85vh; display: flex; justify-content: center; align-items: center; border-radius: 8px; overflow: hidden;"></div>
    </div>

    <script>
        function toggleVisibility(id, currentStatus) {
            let newStatus = currentStatus === 1 ? 0 : 1;
            fetch('${pageContext.request.contextPath}/admin-reviews', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=toggle&id=' + id + '&status=' + newStatus
            })
            .then(response => response.text())
            .then(data => {
                if(data === 'success') {
                    let btnEye = document.getElementById('btn-eye-' + id);
                    if(newStatus === 1) {
                        btnEye.className = "btn-action eye-open";
                        btnEye.innerHTML = '<i class="fa-solid fa-eye"></i>';
                        btnEye.setAttribute("onclick", `toggleVisibility('\${id}', 1)`);
                        showToast('success', 'Thành công', 'Đã HIỆN đánh giá này cho khách hàng thấy.');
                    } else {
                        btnEye.className = "btn-action eye-closed";
                        btnEye.innerHTML = '<i class="fa-solid fa-eye-slash"></i>';
                        btnEye.setAttribute("onclick", `toggleVisibility('\${id}', 0)`);
                        showToast('warning', 'Đã ẩn', 'Đánh giá đã bị ẨN khỏi trang sản phẩm.');
                    }
                } else showToast('error', 'Lỗi', 'Không thể đổi trạng thái!');
            });
        }

        function openReplyModal(id, userName, stars, date, prodName, prodImg) {
            document.getElementById('modalReviewId').value = id;
            document.getElementById('modalUserName').innerText = userName;
            document.getElementById('modalDate').innerText = date;
            document.getElementById('modalProdName').innerText = prodName;
            document.getElementById('modalProdImg').src = prodImg;
            
            let starHtml = '';
            for(let i=1; i<=stars; i++) starHtml += '<i class="fa-solid fa-star"></i>';
            for(let i=stars+1; i<=5; i++) starHtml += '<i class="fa-regular fa-star"></i>';
            document.getElementById('modalStars').innerHTML = starHtml;

            let originalText = document.querySelector('#review-' + id + ' .rv-text').innerText;
            document.getElementById('modalOriginalText').innerText = originalText;

            let existingReply = document.getElementById('reply-text-' + id);
            document.getElementById('adminReplyText').value = existingReply ? existingReply.innerText : "";
            document.getElementById('replyModalOverlay').style.display = 'flex';
        }

        function closeReplyModal() { document.getElementById('replyModalOverlay').style.display = 'none'; }

        // AJAX Gửi / Xóa phản hồi
        function submitReply() {
            let id = document.getElementById('modalReviewId').value;
            let text = document.getElementById('adminReplyText').value;

            fetch('${pageContext.request.contextPath}/admin-reviews', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=reply&id=' + id + '&text=' + encodeURIComponent(text)
            })
            .then(response => response.text())
            .then(data => {
                if(data === 'success') {
                    let replyBox = document.getElementById('reply-box-' + id);
                    let badgeReply = document.getElementById('badge-reply-' + id);

                    if (text.trim() === "") {
                        // Trường hợp Admin xóa trắng ô nhập -> Xóa phản hồi
                        replyBox.style.display = 'none';
                        document.getElementById('reply-text-' + id).innerText = "";
                        badgeReply.className = "rv-badge badge-pending";
                        badgeReply.innerText = "Chưa phản hồi";
                        showToast('success', 'Đã thu hồi', 'Đã xóa câu phản hồi của Cửa hàng!');
                    } else {
                        // Trường hợp Sửa/Thêm mới phản hồi
                        replyBox.style.display = 'block';
                        document.getElementById('reply-text-' + id).innerText = text;
                        badgeReply.className = "rv-badge badge-replied";
                        badgeReply.innerText = "Đã phản hồi";
                        showToast('success', 'Thành công', 'Đã lưu phản hồi!');
                    }
                    closeReplyModal();
                } else showToast('error', 'Lỗi', 'Thao tác thất bại!');
            });
        }

        function deleteReview(id) {
            if(confirm("Bạn có chắc chắn muốn xóa vĩnh viễn đánh giá này?")) {
                fetch('${pageContext.request.contextPath}/admin-reviews', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=delete&id=' + id
                })
                .then(response => response.text())
                .then(data => {
                    if(data === 'success') {
                        document.getElementById('review-' + id).remove();
                        showToast('success', 'Đã xóa', 'Xóa thành công!');
                    } else showToast('error', 'Lỗi', 'Không thể xóa!');
                });
            }
        }

        function openLightbox(src, type) {
            const lightbox = document.getElementById('mediaLightbox');
            const content = document.getElementById('lightboxContent');
            if (type === 'image') content.innerHTML = '<img src="' + src + '" style="max-width: 100%; max-height: 85vh; object-fit: contain; display: block;">';
            else if (type === 'video') content.innerHTML = '<video src="' + src + '" style="max-width: 100%; max-height: 85vh; display: block;" controls autoplay></video>';
            lightbox.style.display = 'flex';
        }
        function closeLightbox() {
            document.getElementById('mediaLightbox').style.display = 'none';
            document.getElementById('lightboxContent').innerHTML = '';
        }
        
        // TỰ ĐỘNG MÃ HÓA TÊN KHI TRANG VỪA TẢI XONG
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll('span[data-is-masked="true"]').forEach(function(span) {
                let fullName = span.getAttribute('data-full').trim();
                if(fullName.length > 0) {
                    let firstChar = fullName.charAt(0).toUpperCase();
                    let lastChar = fullName.charAt(fullName.length - 1).toUpperCase();
                    let maskedName = firstChar + "***" + lastChar + " (Ẩn danh)";
                    span.setAttribute('data-masked', maskedName);
                    span.innerText = maskedName;
                }
            });
        });

        // HÀM BẬT/TẮT CON MẮT XEM TÊN THẬT
        function toggleNameReveal(id) {
            let nameSpan = document.getElementById('name-mask-' + id);
            let icon = document.getElementById('icon-name-' + id);
            let isMasked = nameSpan.getAttribute('data-is-masked') === 'true';

            if (isMasked) {
                nameSpan.innerText = nameSpan.getAttribute('data-full');
                nameSpan.setAttribute('data-is-masked', 'false');
                icon.className = 'fa-solid fa-eye-slash';
                icon.style.color = 'var(--brand-primary)'; 
                icon.title = 'Ẩn tên thật';
            } else {
                nameSpan.innerText = nameSpan.getAttribute('data-masked');
                nameSpan.setAttribute('data-is-masked', 'true');
                icon.className = 'fa-solid fa-eye';
                icon.style.color = 'var(--text-muted)';
                icon.title = 'Xem tên thật';
            }
        }
    </script>
</body>
</html>