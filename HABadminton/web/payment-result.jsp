<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả thanh toán - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=45">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <div class="result-page">
        <div class="invoice-box" style="border-top: 5px solid ${(order.phuongThucThanhToan == 'MOMO' and isSuccess == false) ? '#dc3545' : '#28a745'};">
            
            <c:choose>
                <c:when test="${order.phuongThucThanhToan == 'MOMO' and isSuccess == true}">
                    <div style="background-color: #28a745; color: #fff; width: 64px; height: 64px; border-radius: 50%; text-align: center; line-height: 64px; margin: 0 auto 20px auto; font-size: 32px; padding: 0;">
                        <i class="fa-solid fa-check" style="margin: 0;"></i>
                    </div>
                    <h2>Thanh toán thành công!</h2>
                    <p class="thank-you">Cảm ơn bạn đã mua sắm tại HA Badminton. Đơn hàng của bạn đang được xử lý.</p>
                </c:when>
                
                <c:when test="${order.phuongThucThanhToan == 'MOMO' and isSuccess == false}">
                    <div style="background-color: #dc3545; color: #fff; width: 64px; height: 64px; border-radius: 50%; text-align: center; line-height: 64px; margin: 0 auto 20px auto; font-size: 32px; padding: 0;">
                        <i class="fa-solid fa-xmark" style="margin: 0;"></i>
                    </div>
                    <h2 style="color: #dc3545;">Giao dịch bị từ chối!</h2>
                    <p class="thank-you" style="color: #dc3545;">Bạn đã hủy thanh toán MoMo. Đơn hàng đã bị hủy và vui lòng chọn phương thức thanh toán khác.</p>
                </c:when>
                
                <c:otherwise>
                    <div style="background-color: #28a745; color: #fff; width: 64px; height: 64px; border-radius: 50%; text-align: center; line-height: 64px; margin: 0 auto 20px auto; font-size: 32px; padding: 0;">
                        <i class="fa-solid fa-check" style="margin: 0;"></i>
                    </div>
                    <h2>Đặt hàng thành công!</h2>
                    <p class="thank-you">Cảm ơn bạn đã mua sắm tại HA Badminton. Đơn hàng của bạn đang được xử lý.</p>
                </c:otherwise>
            </c:choose>
            
            <div class="invoice-details">
                <div class="invoice-row">
                    <span>Mã đơn hàng:</span>
                    <strong>${order.maDonHang}</strong>
                </div>
                <div class="invoice-row">
                    <span>Người nhận:</span>
                    <strong>${order.tenNguoiNhan}</strong>
                </div>
                <div class="invoice-row">
                    <span>Số điện thoại:</span>
                    <strong>${order.sdt}</strong>
                </div>
                <div class="invoice-row">
                    <span>Địa chỉ giao hàng:</span>
                    <strong>${order.diaChi}</strong>
                </div>
                
                <div class="invoice-row" style="flex-direction: column; align-items: flex-start; gap: 5px;">
                    <div style="width: 100%; display: flex; justify-content: space-between;">
                        <span>Phương thức:</span>
                        <strong>${order.phuongThucThanhToan == 'MOMO' ? 'Ví MoMo' : 'Tiền mặt (COD)'}</strong>
                    </div>
                    
                    <div style="width: 100%; text-align: right; font-size: 13px; font-weight: bold;">
                        <c:choose>
                            <c:when test="${order.phuongThucThanhToan == 'MOMO' and isSuccess == true}">
                                <span style="color: #28a745;">✔ đã thanh toán</span>
                            </c:when>
                            <c:when test="${order.phuongThucThanhToan == 'MOMO' and isSuccess == false}">
                                <span style="color: #dc3545;">x thanh toán thất bại</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #dc3545;">x chưa thanh toán</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="invoice-divider"></div>
                
                <h4 style="color: #002347; margin-bottom: 15px; font-size: 15px;">
                    <i class="fa-solid fa-box-open"></i> Sản phẩm đã mua
                </h4>
                
                <c:set var="subTotal" value="0" />
                
                <div class="order-products-list" style="margin-top: 0; padding-top: 0; border: none;">
                    <c:forEach items="${order.chiTietList}" var="item">
                        <c:set var="subTotal" value="${subTotal + (item.giaMua * item.soLuong)}" />
                        
                        <div class="product-item-row" style="padding: 10px 0; background: transparent; border-bottom: 1px dashed #eee; border-radius: 0; display: flex; align-items: center;">
                            <img src="${item.hinhAnh}" style="width: 60px; height: 60px; object-fit: contain; border-radius: 6px; border: 1px solid #ddd; background: #fff;">
                            <div class="pi-info" style="flex-grow: 1; padding: 0 15px;">
                                <h5 style="font-size: 14px; margin: 0 0 5px 0; color: #333;">${item.tenSP}</h5>
                                <p style="font-size: 13px; color: #777; margin: 0;">Số lượng: ${item.soLuong}</p>
                            </div>
                            <div class="pi-price" style="font-size: 15px; font-weight: bold; color: #ff6600;">
                                <fmt:formatNumber value="${item.giaMua}" pattern="#,###"/>đ
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${not empty order.maVoucher}">
                    <c:set var="discountAmount" value="${subTotal - order.tongTien}" />
                    
                    <div class="invoice-divider"></div>
                    <div class="invoice-row">
                        <span>Mã Voucher áp dụng:</span>
                        <strong style="color: #28a745; border: 1px dashed #28a745; padding: 4px 10px; border-radius: 4px; display: inline-flex; align-items: center; gap: 5px;">
                            <i class="fa-solid fa-ticket"></i> ${order.maVoucher}
                            <c:if test="${discountAmount > 0}">
                                <span style="font-size: 13px;">(-<fmt:formatNumber value="${discountAmount}" pattern="#,###"/>đ)</span>
                            </c:if>
                        </strong>
                    </div>
                </c:if>

                <div class="invoice-divider"></div>

                <div class="invoice-row total-row">
                    <span>Tổng thanh toán:</span>
                    <strong style="font-size: 22px;"><fmt:formatNumber value="${order.tongTien}" pattern="#,###"/>đ</strong>
                </div>
            </div>

            <div class="action-links">
                <c:if test="${not (order.phuongThucThanhToan == 'MOMO' and isSuccess == false)}">
                    <a href="order-detail?id=${order.maDonHang}" style="border: 1px solid #ff6600; color: #ff6600; background: #fff;">THEO DÕI ĐƠN HÀNG</a>
                </c:if>
                <a href="index.jsp" style="background: #ff6600; color: #fff; border: 1px solid #ff6600;">TIẾP TỤC MUA SẮM</a>
            </div>
        </div>
    </div>
    
    <script>
        if (sessionStorage.getItem('habadminton_buynow')) {
            sessionStorage.removeItem('habadminton_buynow');
        } else {
            localStorage.removeItem('habadminton_cart');
            if (typeof renderCart === 'function') {
                cart = [];
                renderCart(); 
            }
        }
    </script>
    <jsp:include page="footer.jsp"></jsp:include>
</body>
</html>