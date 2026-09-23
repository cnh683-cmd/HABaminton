<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=51">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <div class="container od-page-wrapper">
        <div class="od-top-header">
            <h2>Chi tiết đơn hàng</h2>
            <span class="od-id">Mã đơn hàng: #${order.maDonHang}</span>
        </div>

        <div class="od-main-layout">
            <!-- CỘT TRÁI: THÔNG TIN HÓA ĐƠN -->
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
                                <fmt:formatNumber value="${item.giaMua}" pattern="#,###"/>đ
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
                    
                    <c:set var="discountAmount" value="${subTotal - order.tongTien}" />
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
                        <c:when test="${order.phuongThucThanhToan == 'MOMO'}">
                            <p class="od-pay-status text-green" style="color: #00a152; font-weight: 600;">✔ Đã thanh toán (MoMo)</p>
                        </c:when>
                        <c:when test="${order.phuongThucThanhToan == 'COD' and (order.trangThai == 3 or order.trangThai == 4)}">
                            <p class="od-pay-status text-green" style="color: #00a152; font-weight: 600;">✔ Đã thu tiền mặt (COD)</p>
                        </c:when>
                        <c:otherwise>
                            <p class="od-pay-status text-red" style="color: #dc3545; font-weight: 600;">x Chưa thanh toán</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div> <!-- KẾT THÚC CỘT TRÁI (.od-left-col) -->

            <!-- MỞ LẠI CỘT PHẢI BỊ THIẾU (.od-right-col) -->
            <div class="od-right-col">
                <div class="od-progress-track">
                    <!-- Bước 1: Chờ xác nhận -->
                    <div class="od-step ${order.trangThai != 0 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-receipt"></i></div>
                        <p>Chờ xác nhận</p>
                    </div>
                    
                    <!-- Bước 2: Đã tiếp nhận (Chạy khi trạng thái là 4, 2 hoặc 3) -->
                    <div class="od-step ${order.trangThai == 4 || order.trangThai == 2 || order.trangThai == 3 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-wallet"></i></div>
                        <p>Đã tiếp nhận</p>
                    </div>
                    
                    <!-- Bước 3: Đang giao hàng (Chạy khi trạng thái là 2 hoặc 3) -->
                    <div class="od-step ${order.trangThai == 2 || order.trangThai == 3 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-truck-fast"></i></div>
                        <p>Đang giao hàng</p>
                    </div>
                    
                    <!-- Bước 4: Đã giao hàng (Chạy khi trạng thái là 3) -->
                    <div class="od-step ${order.trangThai == 3 ? 'active' : ''}">
                        <div class="od-icon"><i class="fa-solid fa-box-open"></i></div>
                        <p>Đã giao hàng</p>
                    </div>
                </div>

                <div class="od-action-box">
                    <c:choose>
                        <c:when test="${order.trangThai == 1}">
                            <button class="btn-outline" style="color: #dc3545; border-color: #dc3545; padding: 10px 30px; font-weight: 600; border-radius: 6px; cursor: pointer;" onclick="cancelOrderUser('${order.maDonHang}')">
                                <i class="fa-solid fa-ban"></i> Hủy đơn hàng
                            </button>
                            <p class="od-confirm-text" style="margin-top: 10px;">Bạn chỉ có thể hủy khi đơn hàng ở trạng thái Chờ xác nhận.</p>
                        </c:when>
                        
                        <c:when test="${order.trangThai == 0}">
                            <div style="padding: 15px; background: #fff5f5; border: 1px dashed #dc3545; border-radius: 8px; color: #dc3545; text-align: left;">
                                <h4 style="margin: 0 0 5px 0;"><i class="fa-solid fa-circle-exclamation"></i> Đơn hàng đã bị hủy</h4>
                                <p style="margin: 0; font-size: 14px;"><strong>Lý do:</strong> ${not empty order.lyDoHuy ? order.lyDoHuy : 'Không có lý do cụ thể'}</p>
                            </div>
                        </c:when>

                        <c:when test="${order.trangThai == 3}">
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
                                        
                                        <button class="btn-review" style="background-color: #ff6600; color: white; border: none; padding: 8px 18px; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 600; white-space: nowrap; transition: background 0.3s;" 
                                                data-masp="${item.maSP}" 
                                                data-tensp="${item.tenSP}" 
                                                data-img="${item.hinhAnh}"
                                                onclick="openReviewModal(this)"
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
                
                <div class="od-mail-border" style="margin-top: 30px;"></div>

                <div class="od-bottom-split">
                    <div class="od-address">
                        <h3>Địa chỉ nhận hàng</h3>
                        <strong>${order.tenNguoiNhan}</strong>
                        <p>${order.sdt}</p>
                        <p>${order.diaChi}</p>
                    </div>
                    
                    <div class="od-timeline">
                        <c:if test="${order.trangThai == 3}">
                            <div class="tl-row active">
                                <span class="tl-time">
                                    <c:choose><c:when test="${not empty order.ngayNhanHang}"><fmt:formatDate value="${order.ngayNhanHang}" pattern="dd-MM-yyyy HH:mm" /></c:when><c:otherwise>Vừa xong</c:otherwise></c:choose>
                                </span>
                                <div class="tl-dot"><i class="fa-solid fa-check"></i></div>
                                <span class="tl-desc">Đơn hàng đã giao thành công</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${order.trangThai == 2 || order.trangThai == 3}">
                            <div class="tl-row">
                                <span class="tl-time">
                                    <c:choose><c:when test="${not empty order.ngayGiaoVan}"><fmt:formatDate value="${order.ngayGiaoVan}" pattern="dd-MM-yyyy HH:mm" /></c:when><c:otherwise>Đang cập nhật</c:otherwise></c:choose>
                                </span>
                                <div class="tl-dot"><i class="fa-solid fa-truck"></i></div>
                                <span class="tl-desc">Đơn hàng đã được giao cho Đơn vị vận chuyển</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${order.trangThai == 4 || order.trangThai == 2 || order.trangThai == 3}">
                            <div class="tl-row">
                                <span class="tl-time">
                                    <c:choose><c:when test="${not empty order.ngayTiepNhan}"><fmt:formatDate value="${order.ngayTiepNhan}" pattern="dd-MM-yyyy HH:mm" /></c:when><c:otherwise>Đang cập nhật</c:otherwise></c:choose>
                                </span>
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

    <!-- MODAL ĐÁNH GIÁ -->
    <div id="reviewModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center;">
        <div style="background: white; padding: 25px; border-radius: 10px; width: 450px; max-width: 90%; box-shadow: 0 10px 25px rgba(0,0,0,0.2); animation: fadeIn 0.3s ease;">
            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 12px; margin-bottom: 18px;">
                <h3 style="margin: 0; font-size: 18px; color: #002347;">Đánh giá sản phẩm</h3>
                <span onclick="closeReviewModal()" style="cursor: pointer; font-size: 24px; color: #999; line-height: 1;">&times;</span>
            </div>
            
            <form id="reviewForm" action="submitReview" method="POST" enctype="multipart/form-data">
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
                    <input type="hidden" name="soSao" id="modalSoSao" value="0" required>
                </div>

                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">Nhận xét chi tiết:</label>
                    <textarea name="noiDung" rows="4" style="width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; font-family: inherit; font-size: 14px; resize: vertical;" placeholder="Hãy chia sẻ nhận xét của bạn về sản phẩm này nhé..." required></textarea>
                </div>

                <div style="margin-bottom: 15px; display: flex; gap: 10px;">
                    <label style="cursor: pointer; padding: 8px 15px; border: 1px solid #ccc; border-radius: 4px; background: #fff; font-size: 13px; color: #333; display: inline-flex; align-items: center; gap: 5px; flex: 1; justify-content: center;">
                        <i class="fa-solid fa-camera" style="color: #ff6600;"></i> Thêm hình ảnh
                        <input type="file" name="imageFile" accept="image/*" style="display: none;" onchange="previewMedia(this, 'image')">
                    </label>
                    <label style="cursor: pointer; padding: 8px 15px; border: 1px solid #ccc; border-radius: 4px; background: #fff; font-size: 13px; color: #333; display: inline-flex; align-items: center; gap: 5px; flex: 1; justify-content: center;">
                        <i class="fa-solid fa-video" style="color: #0088ff;"></i> Thêm video
                        <input type="file" name="videoFile" accept="video/*" style="display: none;" onchange="previewMedia(this, 'video')">
                    </label>
                </div>
                
                <!-- GIAO DIỆN HIỂN THỊ THUMBNAIL -->
                <div id="previewContainerLabel" style="display: none; margin-bottom: 5px; font-size: 13px; font-weight: 600; color: #333;"><i class="fa-solid fa-check" style="color: #00a152;"></i> Đã chọn:</div>
                <div style="display: flex; gap: 15px; margin-bottom: 15px;">
                    <div id="imgPreviewBox"></div>
                    <div id="vidPreviewBox"></div>
                </div>

                <div style="margin-bottom: 20px; text-align: left; background: #f0f8ff; padding: 10px 12px; border-radius: 6px; border: 1px dashed #b3d4fc;">
                    <label style="cursor: pointer; font-size: 13.5px; color: #002347; display: flex; align-items: center; gap: 8px; margin: 0;">
                        <input type="checkbox" name="anDanh" value="1" style="width: 16px; height: 16px; cursor: pointer;">
                        <strong>Đánh giá ẩn danh</strong>
                    </label>
                </div>

                <div style="text-align: right; border-top: 1px solid #eee; padding-top: 15px;">
                    <button type="button" onclick="closeReviewModal()" style="padding: 10px 20px; background: #f1f1f1; color: #333; border: none; border-radius: 6px; cursor: pointer; margin-right: 10px; font-weight: 500;">Trở lại</button>
                    <button type="submit" style="padding: 10px 20px; background: #ff6600; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600;">Gửi đánh giá</button>
                </div>
            </form>
        </div>
    </div>

    <div id="mediaLightbox" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10000; background: rgba(0, 0, 0, 0.85); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); justify-content: center; align-items: center; flex-direction: column;">
        <span onclick="closeLightbox()" style="position: absolute; top: 25px; right: 40px; color: white; font-size: 40px; cursor: pointer; z-index: 10001; text-shadow: 0 2px 4px rgba(0,0,0,0.5); transition: color 0.3s;" onmouseover="this.style.color='#ff6600'" onmouseout="this.style.color='white'">&times;</span>
        <div id="lightboxContent" style="max-width: 90%; max-height: 85vh; display: flex; justify-content: center; align-items: center; box-shadow: 0 10px 40px rgba(0,0,0,0.5); border-radius: 8px; overflow: hidden; background: transparent;">
        </div>
    </div>

    <script>
        function openReviewModal(btnElement) {
            const maSP = btnElement.getAttribute('data-masp');
            const tenSP = btnElement.getAttribute('data-tensp');
            const hinhAnh = btnElement.getAttribute('data-img');

            document.getElementById('modalMaSP').value = maSP;
            document.getElementById('modalTenSP').innerText = tenSP;
            document.getElementById('modalImgSP').src = hinhAnh;
            
            document.getElementById('modalSoSao').value = "";
            document.querySelector('#reviewForm textarea').value = "";
            document.querySelector('#reviewForm input[type="checkbox"]').checked = false;
            
            const stars = document.querySelectorAll('#starRating i');
            stars.forEach(s => {
                s.classList.remove('fa-solid');
                s.classList.add('fa-regular');
            });

            document.querySelector('input[name="imageFile"]').value = '';
            document.querySelector('input[name="videoFile"]').value = '';
            document.getElementById('imgPreviewBox').innerHTML = '';
            document.getElementById('vidPreviewBox').innerHTML = '';
            document.getElementById('previewContainerLabel').style.display = 'none';

            document.getElementById('reviewModal').style.display = 'flex';
        }

        function closeReviewModal() {
            document.getElementById('reviewModal').style.display = 'none';
        }

        function previewMedia(input, type) {
            const previewBox = document.getElementById(type === 'image' ? 'imgPreviewBox' : 'vidPreviewBox');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                const fileURL = URL.createObjectURL(file);
                
                let mediaHtml = '';
                if (type === 'image') {
                    mediaHtml = '<img src="' + fileURL + '" style="width: 70px; height: 70px; object-fit: cover; border-radius: 6px; cursor: pointer; border: 1px solid #ccc; transition: transform 0.2s;" onmouseover="this.style.transform=\'scale(1.05)\'" onmouseout="this.style.transform=\'scale(1)\'" onclick="openLightbox(\'' + fileURL + '\', \'image\')">';
                } else {
                    mediaHtml = '<div style="position: relative; width: 70px; height: 70px; cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform=\'scale(1.05)\'" onmouseout="this.style.transform=\'scale(1)\'" onclick="openLightbox(\'' + fileURL + '\', \'video\')">' +
                                    '<video src="' + fileURL + '" style="width: 100%; height: 100%; object-fit: cover; border-radius: 6px; border: 1px solid #ccc; background: #000;"></video>' +
                                    '<div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: rgba(0,0,0,0.3); border-radius: 6px;">' +
                                        '<i class="fa-solid fa-play" style="color: white; font-size: 20px; opacity: 0.9;"></i>' +
                                    '</div>' +
                                '</div>';
                }

                previewBox.innerHTML = '<div style="position: relative; display: inline-block;">' +
                                            mediaHtml +
                                            '<span onclick="removeMedia(\'' + type + '\', event)" style="position: absolute; top: -6px; right: -6px; background: #ff4d4f; color: white; border-radius: 50%; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 14px; line-height: 1; box-shadow: 0 2px 4px rgba(0,0,0,0.2); z-index: 10;">&times;</span>' +
                                        '</div>';
                document.getElementById('previewContainerLabel').style.display = 'block';
            }
        }

        function removeMedia(type, event) {
            event.stopPropagation();
            if (type === 'image') {
                document.querySelector('input[name="imageFile"]').value = '';
                document.getElementById('imgPreviewBox').innerHTML = '';
            } else {
                document.querySelector('input[name="videoFile"]').value = '';
                document.getElementById('vidPreviewBox').innerHTML = '';
            }
            
            if (document.getElementById('imgPreviewBox').innerHTML === '' && document.getElementById('vidPreviewBox').innerHTML === '') {
                document.getElementById('previewContainerLabel').style.display = 'none';
            }
        }

        function openLightbox(src, type) {
            const lightbox = document.getElementById('mediaLightbox');
            const content = document.getElementById('lightboxContent');
            
            if (type === 'image') {
                content.innerHTML = '<img src="' + src + '" style="max-width: 100%; max-height: 85vh; object-fit: contain; display: block;">';
            } else if (type === 'video') {
                content.innerHTML = '<video src="' + src + '" style="max-width: 100%; max-height: 85vh; display: block;" controls autoplay></video>';
            }
            lightbox.style.display = 'flex';
        }

        function closeLightbox() {
            const lightbox = document.getElementById('mediaLightbox');
            const content = document.getElementById('lightboxContent');
            lightbox.style.display = 'none';
            content.innerHTML = '';
        }

        document.getElementById('mediaLightbox').addEventListener('click', function(e) {
            if (e.target === this) closeLightbox();
        });

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
    
    <c:if test="${not empty sessionScope.msgSuccess}">
        <script>
            alert("${sessionScope.msgSuccess}");
        </script>
        <c:remove var="msgSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.msgError}">
        <script>
            alert("${sessionScope.msgError}");
        </script>
        <c:remove var="msgError" scope="session"/>
    </c:if>
</body>
</html>