<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=47">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <div class="container od-page-wrapper">
        <!-- 1. HEADER CHI TIẾT -->
        <div class="od-top-header">
            <h2>Chi tiết đơn hàng</h2>
            <span class="od-id">Mã đơn hàng: #${order.maDonHang}</span>
        </div>

        <div class="od-main-layout">
            <!-- CỘT TRÁI: THÔNG TIN HÓA ĐƠN CỦA BẠN -->
            <div class="od-left-col">
                <h3 class="od-box-title">Hóa đơn của bạn</h3>
                
                <c:set var="subTotal" value="0" />
                <div class="od-products">
                    <c:forEach items="${order.chiTietList}" var="item">
                        <c:set var="subTotal" value="${subTotal + (item.giaMua * item.soLuong)}" />
                        <div class="od-item">
                            <img src="${item.hinhAnh}" alt="${item.tenSP}">
                            <div class="od-item-info">
                                <h4>${item.tenSP}</h4>
                                <p>SL: ${item.soLuong}</p>
                            </div>
                            <div class="od-item-price">
                                <fmt:formatNumber value="${item.giaMua}" pattern="#,###"/>đ<br>
                                <del style="color: #999; font-size: 12px;"></del>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="od-summary">
                    <div class="od-sum-row">
                        <span>Tạm tính</span>
                        <span><fmt:formatNumber value="${subTotal}" pattern="#,###"/>đ</span>
                    </div>
                    <div class="od-sum-row">
                        <span>Phí vận chuyển</span>
                        <span>Miễn phí</span>
                    </div>
                    
                    <!-- BẮT BUỘC ĐẶT BIẾN TÍNH TOÁN Ở ĐÂY -->
                    <c:set var="discountAmount" value="${subTotal - order.tongTien}" />
                    
                    <!-- RỒI MỚI KIỂM TRA ĐIỀU KIỆN ĐỂ HIỂN THỊ -->
                    <c:if test="${not empty order.maVoucher and discountAmount > 0}">
                        <div class="od-sum-row od-discount">
                            <span>Voucher áp dụng (${order.maVoucher})</span>
                            <span>-<fmt:formatNumber value="${discountAmount}" pattern="#,###"/>đ</span>
                        </div>
                    </c:if>
                    
                    <div class="od-sum-row od-total-row">
                        <span>Tổng hóa đơn</span>
                        <span><fmt:formatNumber value="${order.tongTien}" pattern="#,###"/>đ</span>
                    </div>
                </div>

                <div class="od-note-section">
                    <p class="od-note-title">Ghi chú đơn hàng:</p>
                    <p class="od-note-text">${empty order.ghiChu ? 'Không có ghi chú nào cho đơn hàng này.' : order.ghiChu}</p>
                </div>

                <div class="od-payment-info">
                    <p class="od-pay-title">Thông tin thanh toán</p>
                    <p class="od-pay-method">${order.phuongThucThanhToan == 'MOMO' ? 'Ví MoMo' : 'Tiền mặt (COD)'}</p>
                    
                    <c:choose>
                        <%-- Nếu là MOMO: Mặc định luôn là Đã thanh toán --%>
                        <c:when test="${order.phuongThucThanhToan == 'MOMO'}">
                            <p class="od-pay-status text-green">✔ Đã thanh toán (MoMo)</p>
                        </c:when>
                        
                        <%-- Nếu là COD và Trạng thái = 4 (Đã giao): Đã thu tiền --%>
                        <c:when test="${order.phuongThucThanhToan == 'COD' and order.trangThai == 4}">
                            <p class="od-pay-status text-green">✔ Đã thu tiền mặt (COD)</p>
                        </c:when>
                        
                        <%-- Các trường hợp còn lại của COD: Chưa thanh toán --%>
                        <c:otherwise>
                            <p class="od-pay-status text-red">x Chưa thanh toán</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- CỘT PHẢI: TRẠNG THÁI VÀ GIAO HÀNG -->
            <div class="od-right-col">
                <!-- Thanh Tiến Trình Ngang -->
                <div class="od-progress-track">
                    <div class="od-step active">
                        <div class="od-icon"><i class="fa-solid fa-receipt"></i></div>
                        <p>Chờ xác nhận</p>
                        <span><fmt:formatDate value="${order.ngayDat}" pattern="dd-MM-yyyy HH:mm" /></span>
                    </div>
                    <div class="od-step ${order.trangThai >= 2 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-wallet"></i></div>
                        <p>Đã tiếp nhận</p>
                    </div>
                    <div class="od-step ${order.trangThai >= 3 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-truck-fast"></i></div>
                        <p>Đang giao hàng</p>
                    </div>
                    <div class="od-step ${order.trangThai >= 4 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-box-open"></i></div>
                        <p>Đã giao hàng</p>
                    </div>
                </div>

                <!-- Lời nhắc & Nút -->
                <div class="od-action-box">
                    <c:choose>
                        <%-- CHỈ HIỂN THỊ NÚT HỦY KHI TRẠNG THÁI = 1 (Chờ xác nhận) --%>
                        <c:when test="${order.trangThai == 1}">
                            <button class="btn-outline" style="color: #dc3545; border-color: #dc3545; padding: 10px 30px; font-weight: 600; border-radius: 6px; cursor: pointer;" onclick="cancelOrderUser('${order.maDonHang}')">
                                <i class="fa-solid fa-ban"></i> Hủy đơn hàng
                            </button>
                            <p class="od-confirm-text" style="margin-top: 10px;">Bạn chỉ có thể hủy khi đơn hàng ở trạng thái Chờ xác nhận.</p>
                        </c:when>
                        
                        <%-- KHI ĐƠN BỊ HỦY (TRẠNG THÁI = 0), HIỂN THỊ LÝ DO --%>
                        <c:when test="${order.trangThai == 0}">
                            <div style="padding: 15px; background: #fff5f5; border: 1px dashed #dc3545; border-radius: 8px; color: #dc3545; text-align: left;">
                                <h4 style="margin: 0 0 5px 0;"><i class="fa-solid fa-circle-exclamation"></i> Đơn hàng đã bị hủy</h4>
                                <p style="margin: 0; font-size: 14px;"><strong>Lý do:</strong> ${not empty order.lyDoHuy ? order.lyDoHuy : 'Không có lý do cụ thể'}</p>
                            </div>
                        </c:when>

                        <%-- ĐÃ FIX: KHI ĐƠN HÀNG ĐÃ GIAO (TRẠNG THÁI = 4), HIỂN THỊ KHU VỰC ĐÁNH GIÁ --%>
                        <c:when test="${order.trangThai == 4}">
                            <div class="review-section" style="margin-top: 20px; padding: 15px; border: 1px solid #eee; border-radius: 8px; background-color: #f9f9f9;">
                                <h3 style="margin-top: 0; margin-bottom: 15px; font-size: 16px; border-bottom: 1px solid #ddd; padding-bottom: 10px; color: #002347;">
                                    <i class="fa-solid fa-star" style="color: #ffcc00;"></i> Đánh giá sản phẩm đã mua
                                </h3>
                                
                                <c:forEach items="${order.chiTietList}" var="item">
                                    <div class="review-item" style="display: flex; align-items: center; justify-content: space-between; padding: 12px 0; border-bottom: 1px dashed #ddd;">
                                        <div style="display: flex; align-items: center; gap: 12px; flex: 1;">
                                            <img src="${item.hinhAnh}" alt="${item.tenSP}" style="width: 50px; height: 50px; object-fit: contain; border-radius: 6px; border: 1px solid #eee; background: #fff;">
                                            <div style="flex: 1; padding-right: 15px;">
                                                <p style="margin: 0; font-weight: 500; font-size: 14px; color: #333; line-height: 1.4;">${item.tenSP}</p>
                                            </div>
                                        </div>
                                        
                                        <%-- Nút mở Modal đánh giá, truyền mã SP, Tên SP và Ảnh --%>
                                        <button class="btn-review" style="background-color: #ff6600; color: white; border: none; padding: 8px 18px; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 600; white-space: nowrap; transition: background 0.3s;" 
                                                onclick="openReviewModal('${item.maSP}', '${item.tenSP}', '${item.hinhAnh}')"
                                                onmouseover="this.style.backgroundColor='#e65c00'" 
                                                onmouseout="this.style.backgroundColor='#ff6600'">
                                            Đánh giá
                                        </button>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                    </c:choose>
                </div>
                
                <!-- JS Xử lý nhập lý do Hủy đơn cho User -->
                <script>
                    function cancelOrderUser(id) {
                        let reason = prompt("Nhập lý do bạn muốn hủy đơn hàng này:");
                        
                        if (reason != null && reason.trim() !== "") {
                            window.location.href = "cancel-order?id=" + id + "&reason=" + encodeURIComponent(reason) + "&from=user";
                        } else if (reason != null) {
                            alert("Bạn phải nhập lý do mới có thể hủy đơn!");
                        }
                    }
                </script>
                
                <!-- Dải viền màu -->
                <div class="od-mail-border" style="margin-top: 30px;"></div>

                <!-- Thông tin & Timeline -->
                <div class="od-bottom-split">
                    <!-- Trái: Địa chỉ -->
                    <div class="od-address">
                        <h3>Địa chỉ nhận hàng</h3>
                        <strong>${order.tenNguoiNhan}</strong>
                        <p>${order.sdt}</p>
                        <p>${order.diaChi}</p>
                    </div>
                    
                    <!-- Phải: Timeline dọc -->
                    <div class="od-timeline">
                        <c:if test="${order.trangThai >= 4}">
                            <div class="tl-row active">
                                <span class="tl-time"><fmt:formatDate value="${order.ngayNhanHang}" pattern="dd-MM-yyyy HH:mm" /></span>
                                <div class="tl-dot"><i class="fa-solid fa-check"></i></div>
                                <span class="tl-desc">Đơn hàng đã giao thành công</span>
                            </div>
                        </c:if>
                        <c:if test="${order.trangThai >= 3}">
                            <div class="tl-row">
                                <span class="tl-time"><fmt:formatDate value="${order.ngayGiaoVan}" pattern="dd-MM-yyyy HH:mm" /></span>
                                <div class="tl-dot"><i class="fa-solid fa-truck"></i></div>
                                <span class="tl-desc">Đơn hàng đã được giao cho Đơn vị vận chuyển</span>
                            </div>
                        </c:if>
                        <c:if test="${order.trangThai >= 2}">
                            <div class="tl-row">
                                <span class="tl-time"><fmt:formatDate value="${order.ngayTiepNhan}" pattern="dd-MM-yyyy HH:mm" /></span>
                                <div class="tl-dot"><i class="fa-solid fa-box"></i></div>
                                <span class="tl-desc">Cửa hàng đang chuẩn bị đơn hàng</span>
                            </div>
                        </c:if>
                        <div class="tl-row">
                            <span class="tl-time"><fmt:formatDate value="${order.ngayDat}" pattern="dd-MM-yyyy HH:mm" /></span>
                            <div class="tl-dot"><i class="fa-solid fa-receipt"></i></div>
                            <span class="tl-desc">Đơn hàng đã được đặt</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ĐÃ FIX: MODAL ĐÁNH GIÁ (POPUP) -->
    <div id="reviewModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center;">
        <div style="background: white; padding: 25px; border-radius: 10px; width: 450px; max-width: 90%; box-shadow: 0 10px 25px rgba(0,0,0,0.2); animation: fadeIn 0.3s ease;">
            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 12px; margin-bottom: 18px;">
                <h3 style="margin: 0; font-size: 18px; color: #002347;">Đánh giá sản phẩm</h3>
                <span onclick="closeReviewModal()" style="cursor: pointer; font-size: 24px; color: #999; line-height: 1;">&times;</span>
            </div>
            
            <form id="reviewForm" action="submitReview" method="POST">
                <!-- Gửi ngầm thông tin về server -->
                <input type="hidden" name="maDonHang" value="${order.maDonHang}">
                <input type="hidden" name="maSP" id="modalMaSP" value="">
                
                <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px; background: #f9f9f9; padding: 10px; border-radius: 6px;">
                    <img id="modalImgSP" src="" alt="Hình sản phẩm" style="width: 60px; height: 60px; object-fit: contain; border-radius: 4px; border: 1px solid #ddd; background: #fff;">
                    <strong id="modalTenSP" style="font-size: 14px; color: #333; line-height: 1.4;"></strong>
                </div>

                <div style="margin-bottom: 20px; text-align: center;">
                    <label style="display: block; margin-bottom: 10px; font-weight: 600; color: #333;">Chất lượng sản phẩm:</label>
                    <div id="starRating" style="color: #ffcc00; font-size: 28px; cursor: pointer; display: flex; justify-content: center; gap: 8px;">
                        <i class="fa-regular fa-star" data-value="1"></i>
                        <i class="fa-regular fa-star" data-value="2"></i>
                        <i class="fa-regular fa-star" data-value="3"></i>
                        <i class="fa-regular fa-star" data-value="4"></i>
                        <i class="fa-regular fa-star" data-value="5"></i>
                    </div>
                    <!-- Bắt buộc chọn sao -->
                    <input type="hidden" name="soSao" id="modalSoSao" value="0" required>
                </div>

                <div style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">Nhận xét chi tiết:</label>
                    <textarea name="noiDung" rows="4" style="width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; font-family: inherit; font-size: 14px; resize: vertical;" placeholder="Hãy chia sẻ nhận xét của bạn về sản phẩm này nhé..." required></textarea>
                </div>

                <div style="text-align: right; border-top: 1px solid #eee; padding-top: 15px;">
                    <button type="button" onclick="closeReviewModal()" style="padding: 10px 20px; background: #f1f1f1; color: #333; border: none; border-radius: 6px; cursor: pointer; margin-right: 10px; font-weight: 500;">Trở lại</button>
                    <button type="submit" style="padding: 10px 20px; background: #ff6600; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600;">Gửi đánh giá</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Script điều khiển Modal Đánh giá -->
    <script>
        function openReviewModal(maSP, tenSP, hinhAnh) {
            // Gán dữ liệu vào Modal
            document.getElementById('modalMaSP').value = maSP;
            document.getElementById('modalTenSP').innerText = tenSP;
            document.getElementById('modalImgSP').src = hinhAnh;
            
            // Reset sao và textbox mỗi lần mở
            document.getElementById('modalSoSao').value = "";
            document.querySelector('#reviewForm textarea').value = "";
            const stars = document.querySelectorAll('#starRating i');
            stars.forEach(s => {
                s.classList.remove('fa-solid');
                s.classList.add('fa-regular');
            });

            // Hiển thị Modal
            document.getElementById('reviewModal').style.display = 'flex';
        }

        function closeReviewModal() {
            document.getElementById('reviewModal').style.display = 'none';
        }

        // Logic click chọn số sao
        const stars = document.querySelectorAll('#starRating i');
        stars.forEach(star => {
            star.addEventListener('click', function() {
                const value = parseInt(this.getAttribute('data-value'));
                document.getElementById('modalSoSao').value = value;
                
                stars.forEach(s => {
                    const sValue = parseInt(s.getAttribute('data-value'));
                    if (sValue <= value) {
                        s.classList.remove('fa-regular');
                        s.classList.add('fa-solid');
                    } else {
                        s.classList.remove('fa-solid');
                        s.classList.add('fa-regular');
                    }
                });
            });
        });

        // Chặn submit nếu chưa chọn sao
        document.getElementById('reviewForm').addEventListener('submit', function(e) {
            const soSao = document.getElementById('modalSoSao').value;
            if (soSao == "0" || soSao == "") {
                e.preventDefault();
                alert("Vui lòng chọn số sao đánh giá trước khi gửi!");
            }
        });
    </script>
    
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>

    <jsp:include page="footer.jsp"></jsp:include>
</body>
</html>