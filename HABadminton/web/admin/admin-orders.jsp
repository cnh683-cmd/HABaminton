<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css?v=10">
    
    <style>
        .order-stats-wrapper { display: grid; grid-template-columns: repeat(6, 1fr); gap: 15px; margin-bottom: 25px; }
        .ord-thead, .ord-row { 
            grid-template-columns: 1fr 1.8fr 3.2fr 1.5fr 1.8fr 0.7fr !important; 
            gap: 20px !important; 
            align-items: center;
        }
        .ord-products { max-height: 120px; overflow-y: auto; padding-right: 10px; }
        .ord-products::-webkit-scrollbar { width: 4px; }
        .ord-products::-webkit-scrollbar-track { background: transparent; }
        .ord-products::-webkit-scrollbar-thumb { background: var(--border-dark); border-radius: 4px; }
        
        /* Hiệu ứng viền đỏ cho đơn hàng đã hủy */
        .canceled-row {
            border: 1px dashed var(--danger) !important;
            background-color: rgba(220, 53, 69, 0.08) !important; 
            border-radius: 8px;
        }
    </style>
</head>
<body>

    <jsp:include page="admin-sidebar.jsp">
        <jsp:param name="active" value="orders" />
    </jsp:include>

    <div class="admin-main">
        <h2 class="admin-page-title">Quản lý Đơn hàng</h2>

        <!-- TÍNH TOÁN THỐNG KÊ LÚC LOAD TRANG -->
        <c:set var="countAll" value="0"/>
        <c:set var="countPending" value="0"/>
        <c:set var="countAccepted" value="0"/>
        <c:set var="countShipping" value="0"/>
        <c:set var="countDone" value="0"/>
        <c:set var="countCancel" value="0"/>
        <c:forEach items="${listOrders}" var="o">
            <c:set var="countAll" value="${countAll + 1}"/>
            <c:if test="${o.trangThai == 1}"><c:set var="countPending" value="${countPending + 1}"/></c:if>
            <c:if test="${o.trangThai == 4}"><c:set var="countAccepted" value="${countAccepted + 1}"/></c:if>
            <c:if test="${o.trangThai == 2}"><c:set var="countShipping" value="${countShipping + 1}"/></c:if>
            <c:if test="${o.trangThai == 3}"><c:set var="countDone" value="${countDone + 1}"/></c:if>
            <c:if test="${o.trangThai == 0}"><c:set var="countCancel" value="${countCancel + 1}"/></c:if>
        </c:forEach>

        <!-- 1. THẺ THỐNG KÊ -->
        <div class="order-stats-wrapper">
            <div class="stat-card st-all" style="border-left: 4px solid #3B82F6;">
                <span class="st-title">Tất cả đơn</span>
                <span class="st-value">${countAll}</span>
                <i class="fa-solid fa-boxes-stacked st-icon"></i>
            </div>
            <div class="stat-card st-pending" style="border-left: 4px solid var(--warning);">
                <span class="st-title">Chờ xử lý</span>
                <span class="st-value">${countPending}</span>
                <i class="fa-solid fa-clock st-icon"></i>
            </div>
            <div class="stat-card st-accepted" style="border-left: 4px solid #14B8A6;">
                <span class="st-title">Đã tiếp nhận</span>
                <span class="st-value">${countAccepted}</span>
                <i class="fa-solid fa-clipboard-check st-icon"></i>
            </div>
            <div class="stat-card st-shipping" style="border-left: 4px solid #8B5CF6;">
                <span class="st-title">Đang giao</span>
                <span class="st-value">${countShipping}</span>
                <i class="fa-solid fa-truck-fast st-icon"></i>
            </div>
            <div class="stat-card st-done" style="border-left: 4px solid var(--success);">
                <span class="st-title">Hoàn thành</span>
                <span class="st-value">${countDone}</span>
                <i class="fa-solid fa-check-circle st-icon"></i>
            </div>
            <div class="stat-card st-cancel" style="border-left: 4px solid var(--danger);">
                <span class="st-title">Đã hủy</span>
                <span class="st-value">${countCancel}</span>
                <i class="fa-solid fa-ban st-icon"></i>
            </div>
        </div>

        <!-- 2. THANH LỌC TỐC ĐỘ CAO -->
        <div class="filter-bar" style="margin-bottom: 20px; align-items: center;">
            <!-- Xóa onkeyup -->
            <input type="text" id="searchBox" class="filter-input" placeholder="Nhập mã đơn, tên khách hàng...">
            
            <!-- Xóa onchange -->
            <select id="statusBox" class="filter-select">
                <option value="all">Tất cả trạng thái</option>
                <option value="1">Chờ xử lý</option>
                <option value="4">Đã tiếp nhận</option>
                <option value="2">Đang giao hàng</option>
                <option value="3">Đã giao thành công</option>
                <option value="0">Đã hủy</option>
            </select>
            
            <!-- Nút gọi hàm lọc -->
            <button class="btn-search" onclick="filterTable()">
                <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
            </button>
            <button class="btn-reset" onclick="resetFilter()" title="Làm mới bộ lọc">
                <i class="fa-solid fa-arrow-rotate-right" style="margin: 0;"></i>
            </button>
        </div>

        <!-- 3. DANH SÁCH ĐƠN HÀNG -->
        <div class="ord-table">
            <div class="ord-thead">
                <div>Mã Đơn</div>
                <div>Khách Hàng</div>
                <div>Sản Phẩm</div>
                <div>Tổng Hóa Đơn</div>
                <div>Trạng Thái</div>
                <div style="text-align: right;">Thao Tác</div>
            </div>

            <c:forEach items="${listOrders}" var="o">
                <div class="ord-row ${o.trangThai == 0 ? 'canceled-row' : ''}" data-status="${o.trangThai}">
                    <!-- Mã đơn -->
                    <div class="ord-col ord-id" style="${o.trangThai == 0 ? 'color: var(--danger); font-weight: bold;' : ''}">#${o.maDonHang}</div>
                    
                    <!-- Khách hàng -->
                    <div class="ord-col ord-customer" style="display: flex; align-items: center; gap: 12px;">
                        <c:choose>
                            <c:when test="${not empty o.avatar}">
                                <img src="${pageContext.request.contextPath}/${o.avatar}" style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border-dark); flex-shrink: 0;">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--surface-dark); color: var(--text-silver); display: flex; align-items: center; justify-content: center; flex-shrink: 0; border: 1px solid var(--border-dark);">
                                    <i class="fa-solid fa-user"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <div style="min-width: 0;">
                            <span style="font-weight: 700; color: var(--text-ivory); display: block; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${o.tenNguoiNhan}</span>
                            <small style="color: var(--text-silver);">${o.sdt}</small>
                        </div>
                    </div>
                    
                    <!-- Sản phẩm -->
                    <div class="ord-col ord-products">
                        <c:choose>
                            <c:when test="${not empty o.chiTietList}">
                                <c:forEach items="${o.chiTietList}" var="ct">
                                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 12px; border-bottom: 1px dashed rgba(255,255,255,0.1); padding-bottom: 8px;">
                                        <img src="${pageContext.request.contextPath}/${ct.hinhAnh}" onerror="this.src='${ct.hinhAnh}'" style="width: 40px; height: 40px; border-radius: 6px; object-fit: cover; background: #fff;">
                                        <div style="flex: 1; min-width: 0;">
                                            <div style="font-weight: 600; font-size: 13px; color: var(--text-ivory); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${ct.tenSP}">${ct.tenSP}</div>
                                            <div style="color: var(--text-silver); font-size: 12px;">x${ct.soLuong} <span style="margin-left: 8px; color: var(--danger);"><fmt:formatNumber value="${ct.giaMua}" pattern="#,###"/>đ</span></div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span style="color:var(--text-muted); font-style: italic;">Không có dữ liệu</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Tổng hóa đơn -->
                    <div class="ord-col ord-total" style="font-size: 15px; color: var(--warning);">
                        <fmt:formatNumber value="${o.tongTien}" pattern="#,###"/>đ
                    </div>
                    
                    <!-- Trạng thái -->
                    <div class="ord-col">
                        <select onchange="updateOrderStatus('${o.maDonHang}', this)" style="width: 100%; padding: 8px 10px; font-size: 13px; font-weight: 600; background: var(--surface-dark); border: 1px solid var(--border-dark); border-radius: 6px; outline: none; cursor: pointer; color: <c:choose><c:when test='${o.trangThai == 1}'>var(--warning)</c:when><c:when test='${o.trangThai == 4}'>#14B8A6</c:when><c:when test='${o.trangThai == 2}'>#8B5CF6</c:when><c:when test='${o.trangThai == 3}'>var(--success)</c:when><c:otherwise>var(--danger)</c:otherwise></c:choose>;">
                            <option value="1" ${o.trangThai == 1 ? 'selected' : ''} style="color: var(--warning);">⏳ Chờ xử lý</option>
                            <option value="4" ${o.trangThai == 4 ? 'selected' : ''} style="color: #14B8A6;">📋 Đã tiếp nhận</option>
                            <option value="2" ${o.trangThai == 2 ? 'selected' : ''} style="color: #8B5CF6;">🚚 Đang giao</option>
                            <option value="3" ${o.trangThai == 3 ? 'selected' : ''} style="color: var(--success);">✅ Hoàn thành</option>
                            <option value="0" ${o.trangThai == 0 ? 'selected' : ''} style="color: var(--danger);">❌ Đã hủy</option>
                        </select>
                    </div>

                    <!-- Thao tác -->
                    <div class="ord-col ord-actions">
                        <button class="btn-action reply" title="Xem chi tiết" onclick="openOrderDetail('${o.maDonHang}')">
                            <i class="fa-solid fa-bars"></i> 
                        </button>
                        <button class="btn-action delete" title="Xóa đơn hàng" onclick="deleteOrder('${o.maDonHang}')">
                            <i class="fa-solid fa-trash-can"></i>
                        </button>
                    </div>
                </div>

                <!-- DỮ LIỆU ẨN CHO MODAL -->
                <div id="data-order-${o.maDonHang}" style="display: none;">
                    <div data-field="ma">#${o.maDonHang}</div>
                    <div data-field="kh">${o.tenNguoiNhan}</div>
                    <div data-field="sdt">${o.sdt}</div>
                    <div data-field="diachi">${o.diaChi}</div>
                    <div data-field="pttt">${o.phuongThucThanhToan}</div>
                    <div data-field="tttt">
                        <c:choose>
                            <c:when test="${o.phuongThucThanhToan == 'MOMO'}">
                                <span style="color: var(--success); font-weight: 600;">Đã thanh toán (Ví MoMo)</span>
                            </c:when>
                            <c:when test="${o.phuongThucThanhToan == 'COD' && (o.trangThai == 3 || o.trangThai == 4)}">
                                <span style="color: var(--success); font-weight: 600;">Đã thanh toán (Tiền mặt)</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: var(--danger); font-weight: 600;">Chưa thanh toán (COD)</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div data-field="ghichu">${not empty o.ghiChu ? o.ghiChu : 'Không có ghi chú'}</div>
                    <!-- Dữ liệu Lý do hủy -->
                    <div data-field="lydohuy">${o.trangThai == 0 ? (not empty o.lyDoHuy ? o.lyDoHuy : 'Không có lý do cụ thể') : ''}</div>
                    <div data-field="tong"><fmt:formatNumber value="${o.tongTien}" pattern="#,###"/>đ</div>
                    <div data-field="voucher">
                        <c:choose>
                            <c:when test="${not empty o.maVoucher}">
                                <div style="display: flex; justify-content: space-between; padding: 10px 0; border-top: 1px dashed var(--border-dark); color: var(--success); font-size: 14px;">
                                    <span><i class="fa-solid fa-ticket"></i> Voucher (${o.maVoucher}):</span>
                                    <c:set var="tongGiaTriSP" value="0" />
                                    <c:forEach items="${o.chiTietList}" var="item">
                                        <c:set var="tongGiaTriSP" value="${tongGiaTriSP + (item.giaMua * item.soLuong)}" />
                                    </c:forEach>
                                    <span style="font-weight: 600;">-<fmt:formatNumber value="${tongGiaTriSP - o.tongTien}" pattern="#,###"/>đ</span>
                                </div>
                            </c:when>
                            <c:otherwise><span style="display:none;"></span></c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div data-field="sanpham">
                        <c:choose>
                            <c:when test="${not empty o.chiTietList}">
                                <c:forEach items="${o.chiTietList}" var="ct">
                                    <div class="om-prod-item" style="display: flex; align-items: center; gap: 15px; padding: 12px 0; border-bottom: 1px dashed var(--border-dark);">
                                        <img src="${pageContext.request.contextPath}/${ct.hinhAnh}" onerror="this.src='${ct.hinhAnh}'" style="width: 50px; height: 50px; border-radius: 6px; object-fit: cover; border: 1px solid var(--border-dark);">
                                        <div style="flex: 1;">
                                            <div style="font-weight: 600; font-size: 14px; margin-bottom: 4px; color: var(--text-ivory);">${ct.tenSP}</div>
                                            <div style="color: var(--text-silver); font-size: 12px;">Số lượng: x${ct.soLuong}</div>
                                        </div>
                                        <div style="font-weight: 700; color: var(--text-ivory);">
                                            <fmt:formatNumber value="${ct.giaMua * ct.soLuong}" pattern="#,###"/>đ
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="om-prod-item">
                                    <span style="color:var(--text-muted); font-style: italic;">Không có thông tin sản phẩm...</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
            
            <p id="emptyMessage" style="display: none; text-align:center; color:var(--text-silver); padding: 30px;">Không tìm thấy đơn hàng nào khớp với tìm kiếm.</p>
            <c:if test="${empty listOrders}">
                <p style="text-align:center; color:var(--text-silver); padding: 30px;">Chưa có đơn hàng nào trong hệ thống.</p>
            </c:if>
        </div>
    </div>

    <!-- MODAL CHI TIẾT ĐƠN HÀNG -->
    <div class="order-modal-overlay" id="orderDetailModal">
        <div class="order-modal">
            <div class="om-header">
                <h3 id="md-title">Chi tiết đơn hàng</h3>
                <button class="rm-close" onclick="closeOrderDetail()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            
            <div class="om-body">
                <div class="om-section">
                    <h4>Thông tin khách hàng</h4>
                    <div class="om-row-detail"><span>Họ tên:</span> <span id="md-kh">...</span></div>
                    <div class="om-row-detail"><span>Số điện thoại:</span> <span id="md-sdt">...</span></div>
                    <div class="om-row-detail"><span>Địa chỉ:</span> <span id="md-diachi">...</span></div>
                </div>

                <div class="om-section">
                    <h4>Thanh toán & Ghi chú</h4>
                    <div class="om-row-detail"><span>Phương thức TT:</span> <span id="md-pttt">...</span></div>
                    <div class="om-row-detail"><span>Tình trạng TT:</span> <span id="md-tttt">...</span></div>
                    <div class="om-row-detail" style="flex-direction: column; text-align: left;">
                        <span style="margin-bottom: 5px;">Ghi chú của khách:</span> 
                        <span id="md-ghichu" style="font-style: italic; color: var(--warning); text-align: left; font-weight: normal;">...</span>
                    </div>
                    <!-- KHỐI HIỂN THỊ LÝ DO HỦY (MẶC ĐỊNH ẨN) -->
                    <div class="om-row-detail" id="md-lydohuy-box" style="display: none; flex-direction: column; text-align: left; margin-top: 10px; padding: 12px; background: rgba(220, 53, 69, 0.1); border-left: 4px solid var(--danger); border-radius: 4px;">
                        <span style="margin-bottom: 5px; color: var(--danger); font-weight: bold;"><i class="fa-solid fa-circle-exclamation"></i> Đơn hàng đã bị hủy. Lý do:</span> 
                        <span id="md-lydohuy" style="color: var(--danger); text-align: left; font-weight: normal;">...</span>
                    </div>
                </div>

                <div class="om-section">
                    <h4>Sản phẩm đã đặt</h4>
                    <div class="om-products-list" id="md-sanpham" style="max-height: 250px; overflow-y: auto; padding-right: 10px;"></div>
                    <div id="md-voucher"></div>
                    <div class="om-row-detail" style="margin-top: 15px; font-size: 16px; border-top: 1px solid var(--border-dark); padding-top: 15px;">
                        <span>TỔNG THANH TOÁN:</span> <span id="md-tong" style="color: var(--brand-primary); font-size: 18px; font-weight: bold;">...</span>
                    </div>
                </div>
            </div>
            <div class="om-footer">
                <button class="btn-cancel" onclick="closeOrderDetail()" style="padding: 10px 20px; background: var(--surface-input); color: white; border: none; border-radius: 6px; cursor: pointer;">Đóng lại</button>
            </div>
        </div>
    </div>

    <script>
        const statusMap = {
            '1': 'st-pending',
            '4': 'st-accepted',
            '2': 'st-shipping',
            '3': 'st-done',
            '0': 'st-cancel'
        };

        function filterTable() {
            let keyword = document.getElementById("searchBox").value.toLowerCase();
            let status = document.getElementById("statusBox").value;
            let rows = document.querySelectorAll(".ord-row");
            let hasVisible = false;

            rows.forEach(row => {
                let text = row.innerText.toLowerCase();
                let rowStatus = row.getAttribute("data-status");
                
                let matchKeyword = text.includes(keyword);
                let matchStatus = (status === "all" || status === rowStatus);
                
                if (matchKeyword && matchStatus) {
                    row.style.display = "grid";
                    hasVisible = true;
                } else {
                    row.style.display = "none";
                }
            });
            
            let emptyMsg = document.getElementById("emptyMessage");
            if(emptyMsg) emptyMsg.style.display = hasVisible ? "none" : "block";
        }
        
        function resetFilter() {
            // Xóa rỗng ô tìm kiếm
            document.getElementById("searchBox").value = "";
            // Đưa trạng thái về Tất cả
            document.getElementById("statusBox").value = "all";
            // Gọi lại hàm lọc để tải lại toàn bộ danh sách ban đầu
            filterTable();
        }
        
        document.getElementById("searchBox").addEventListener("keypress", function(event) {
            // Nếu phím được nhấn là phím Enter
            if (event.key === "Enter") {
                event.preventDefault(); // Ngăn chặn hành vi mặc định
                filterTable();          // Thực hiện tìm kiếm
            }
        });

        function updateOrderStatus(maDon, selectElement) {
            let newStatus = selectElement.value;
            let row = selectElement.closest('.ord-row');
            let oldStatus = row.getAttribute('data-status');
            
            if(oldStatus === newStatus) return;

            let reason = "";
            if (newStatus === '0') {
                reason = prompt("Nhập lý do hủy đơn hàng này:");
                if (reason === null || reason.trim() === "") {
                    alert("Thao tác thất bại: Bạn phải nhập lý do hủy đơn!");
                    selectElement.value = oldStatus; 
                    return;
                }
            }

            selectElement.disabled = true;
            let timestamp = new Date().getTime();
            let url = '${pageContext.request.contextPath}/admin-orders?action=updateStatus&id=' + maDon + '&status=' + newStatus + '&t=' + timestamp;
            
            if (newStatus === '0') {
                url += '&reason=' + encodeURIComponent(reason);
            }

            fetch(url, { method: 'GET', cache: 'no-store' })
            .then(response => {
                selectElement.disabled = false;
                if(response.ok) {
                    if(newStatus == '1') selectElement.style.color = 'var(--warning)';
                    else if(newStatus == '4') selectElement.style.color = '#14B8A6';
                    else if(newStatus == '2') selectElement.style.color = '#8B5CF6';
                    else if(newStatus == '3') selectElement.style.color = 'var(--success)';
                    else if(newStatus == '0') selectElement.style.color = 'var(--danger)';

                    let idCol = row.querySelector('.ord-id');
                    if (newStatus === '0') {
                        idCol.style.color = 'var(--danger)';
                        idCol.style.fontWeight = 'bold';
                        row.classList.add('canceled-row'); 
                    } else {
                        idCol.style.color = ''; 
                        idCol.style.fontWeight = '';
                        row.classList.remove('canceled-row'); 
                    }

                    row.setAttribute('data-status', newStatus);
                    let oldCard = document.querySelector('.' + statusMap[oldStatus] + ' .st-value');
                    let newCard = document.querySelector('.' + statusMap[newStatus] + ' .st-value');
                    if(oldCard) oldCard.innerText = Math.max(0, parseInt(oldCard.innerText) - 1);
                    if(newCard) newCard.innerText = parseInt(newCard.innerText) + 1;
                    
                    filterTable();

                    let dataDiv = document.getElementById('data-order-' + maDon);
                    if (dataDiv) {
                        let pttt = dataDiv.querySelector('[data-field="pttt"]').innerText.trim().toUpperCase();
                        let ttttField = dataDiv.querySelector('[data-field="tttt"]');
                        if (pttt.includes('MOMO')) {
                            ttttField.innerHTML = '<span style="color: var(--success); font-weight: 600;">Đã thanh toán (Ví MoMo)</span>';
                        } else {
                            if (newStatus == '3') {
                                ttttField.innerHTML = '<span style="color: var(--success); font-weight: 600;">Đã thanh toán (Tiền mặt)</span>';
                            } else {
                                ttttField.innerHTML = '<span style="color: var(--danger); font-weight: 600;">Chưa thanh toán (COD)</span>';
                            }
                        }
                        
                        // Đẩy lý do hủy mới vào trường dữ liệu ẩn
                        if (newStatus === '0') {
                            dataDiv.querySelector('[data-field="lydohuy"]').innerText = reason;
                        } else {
                            dataDiv.querySelector('[data-field="lydohuy"]').innerText = '';
                        }
                    }
                } else {
                    alert("Cập nhật thất bại từ phía Server!");
                    selectElement.value = oldStatus;
                }
            })
            .catch(error => {
                selectElement.disabled = false;
                alert("Lỗi mạng! Vui lòng kiểm tra lại đường truyền.");
                selectElement.value = oldStatus;
            });
        }

        function openOrderDetail(maDon) {
            let dataDiv = document.getElementById('data-order-' + maDon);
            if (!dataDiv) return;
            
            document.getElementById('md-title').innerText = "Chi tiết đơn hàng " + dataDiv.querySelector('[data-field="ma"]').innerText;
            document.getElementById('md-kh').innerText = dataDiv.querySelector('[data-field="kh"]').innerText;
            document.getElementById('md-sdt').innerText = dataDiv.querySelector('[data-field="sdt"]').innerText;
            document.getElementById('md-diachi').innerText = dataDiv.querySelector('[data-field="diachi"]').innerText;
            document.getElementById('md-pttt').innerText = dataDiv.querySelector('[data-field="pttt"]').innerText;
            document.getElementById('md-tttt').innerHTML = dataDiv.querySelector('[data-field="tttt"]').innerHTML;
            document.getElementById('md-ghichu').innerHTML = dataDiv.querySelector('[data-field="ghichu"]').innerHTML;
            
            // Bật/tắt khối lý do hủy dựa trên dữ liệu ẩn
            let lyDoHuy = dataDiv.querySelector('[data-field="lydohuy"]').innerText.trim();
            let lyDoHuyBox = document.getElementById('md-lydohuy-box');
            if (lyDoHuy !== '') {
                lyDoHuyBox.style.display = 'flex';
                document.getElementById('md-lydohuy').innerText = lyDoHuy;
            } else {
                lyDoHuyBox.style.display = 'none';
            }
            
            document.getElementById('md-tong').innerText = dataDiv.querySelector('[data-field="tong"]').innerText;
            document.getElementById('md-sanpham').innerHTML = dataDiv.querySelector('[data-field="sanpham"]').innerHTML;
            document.getElementById('md-voucher').innerHTML = dataDiv.querySelector('[data-field="voucher"]').innerHTML;

            document.getElementById('orderDetailModal').style.display = 'flex';
        }

        function closeOrderDetail() {
            document.getElementById('orderDetailModal').style.display = 'none';
        }

        function deleteOrder(maDon) {
            if(confirm("Xóa vĩnh viễn đơn hàng này?")) {
                window.location.href = '${pageContext.request.contextPath}/admin-orders?action=delete&id=' + maDon;
            }
        }
    </script>
</body>
</html>