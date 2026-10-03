<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Giảm giá - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-main.css?v=2">
    <style>
        .data-thead, .data-row { grid-template-columns: 2.1fr 1.6fr 1.1fr 1.3fr 1.5fr 1.2fr 1.4fr; }
    </style>
</head>
<body>

    <jsp:include page="admin-sidebar.jsp">
        <jsp:param name="active" value="vouchers" />
    </jsp:include>

    <div class="admin-main">
        <div class="page-head">
            <h2 class="admin-page-title">Quản lý Giảm giá (Voucher)</h2>
            <button class="btn-primary-add" onclick="openVoucherModal()"><i class="fa-solid fa-plus"></i> Tạo voucher</button>
        </div>

        <!-- 1. THẺ THỐNG KÊ -->
        <div class="stats-grid">
            <a href="${ctx}/admin-vouchers" class="stat-card st-all">
                <span class="st-title">Tổng voucher</span>
                <span class="st-value">${countAll}</span>
                <i class="fa-solid fa-ticket st-icon"></i>
            </a>
            <a href="${ctx}/admin-vouchers?status=active" class="stat-card st-done">
                <span class="st-title">Đang áp dụng</span>
                <span class="st-value">${countActive}</span>
                <i class="fa-solid fa-circle-check st-icon"></i>
            </a>
            <a href="${ctx}/admin-vouchers?status=upcoming" class="stat-card st-accepted">
                <span class="st-title">Sắp diễn ra</span>
                <span class="st-value">${countUpcoming}</span>
                <i class="fa-solid fa-hourglass-half st-icon"></i>
            </a>
            <a href="${ctx}/admin-vouchers?status=expired" class="stat-card st-cancel">
                <span class="st-title">Hết hạn / Hết lượt</span>
                <span class="st-value">${countExpired}</span>
                <i class="fa-solid fa-calendar-xmark st-icon"></i>
            </a>
            <div class="stat-card st-pending">
                <span class="st-title">Tổng lượt đã dùng</span>
                <span class="st-value">${totalUsed}</span>
                <i class="fa-solid fa-receipt st-icon"></i>
            </div>
        </div>

        <!-- 2. BỘ LỌC -->
        <form action="${ctx}/admin-vouchers" method="GET" class="filter-bar">
            <input type="text" name="keyword" value="${fn:escapeXml(param.keyword)}" class="filter-input" placeholder="Tìm theo mã hoặc tên voucher...">
            <select name="type" class="filter-select">
                <option value="all">Mọi loại giảm</option>
                <option value="0" ${param.type == '0' ? 'selected' : ''}>Giảm tiền cố định</option>
                <option value="1" ${param.type == '1' ? 'selected' : ''}>Giảm theo %</option>
            </select>
            <select name="status" class="filter-select">
                <option value="all">Mọi tình trạng</option>
                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Đang áp dụng</option>
                <option value="upcoming" ${param.status == 'upcoming' ? 'selected' : ''}>Sắp diễn ra</option>
                <option value="expired" ${param.status == 'expired' ? 'selected' : ''}>Hết hạn</option>
                <option value="soldout" ${param.status == 'soldout' ? 'selected' : ''}>Hết lượt</option>
                <option value="off" ${param.status == 'off' ? 'selected' : ''}>Đang tắt</option>
            </select>
            <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
            <a href="${ctx}/admin-vouchers" class="btn-reset" title="Làm mới bộ lọc"><i class="fa-solid fa-rotate-right"></i></a>
        </form>

        <c:if test="${not empty dbError}">
            <div class="pill pill-danger" style="display:block; white-space:normal; padding:12px 16px; margin-bottom:15px; font-size:13px;">
                <i class="fa-solid fa-triangle-exclamation"></i> Lỗi đọc bảng VOUCHER: ${fn:escapeXml(dbError)}
            </div>
        </c:if>

        <!-- 3. DANH SÁCH -->
        <div class="data-table">
            <div class="data-thead">
                <div>Mã / Tên voucher</div>
                <div>Mức giảm</div>
                <div>Đơn tối thiểu</div>
                <div>Thời gian</div>
                <div>Lượt dùng</div>
                <div>Tình trạng</div>
                <div style="text-align: right;">Thao tác</div>
            </div>

            <c:forEach items="${listVouchers}" var="v">
                <c:set var="tt" value="${v.tinhTrang}" />
                <div class="data-row ${tt == 'off' || tt == 'expired' ? 'row-muted' : ''}" id="vc-${v.maVoucher}">
                    <div>
                        <span class="vc-code">${v.maVoucher}</span>
                        <div style="margin-top: 6px; font-weight: 600;">${fn:escapeXml(v.tenVoucher)}</div>
                    </div>
                    <div>
                        <div class="price-now">${v.moTaGiam}</div>
                        <span class="muted">${v.loaiGiam == 1 ? 'Theo phần trăm' : 'Tiền cố định'}</span>
                    </div>
                    <div><fmt:formatNumber value="${v.donToiThieu}" pattern="#,##0"/>đ</div>
                    <div class="muted" style="font-size: 13px;">
                        <fmt:formatDate value="${v.ngayBatDau}" pattern="dd/MM/yyyy"/><br>
                        → <fmt:formatDate value="${v.ngayKetThuc}" pattern="dd/MM/yyyy"/>
                    </div>
                    <div>
                        <strong>${v.daSuDung}</strong> <span class="muted">/ ${v.soLuong}</span>
                        <div class="usage-bar"><span style="width: ${v.soLuong > 0 ? (v.daSuDung * 100 / v.soLuong) : 0}%;"></span></div>
                        <span class="muted">Còn ${v.conLai} lượt</span>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${tt == 'active'}"><span class="pill pill-success"><i class="fa-solid fa-circle-check"></i> Đang áp dụng</span></c:when>
                            <c:when test="${tt == 'upcoming'}"><span class="pill pill-info"><i class="fa-solid fa-hourglass-half"></i> Sắp diễn ra</span></c:when>
                            <c:when test="${tt == 'expired'}"><span class="pill pill-danger"><i class="fa-solid fa-calendar-xmark"></i> Hết hạn</span></c:when>
                            <c:when test="${tt == 'soldout'}"><span class="pill pill-warning"><i class="fa-solid fa-ban"></i> Hết lượt</span></c:when>
                            <c:otherwise><span class="pill pill-muted"><i class="fa-solid fa-power-off"></i> Đang tắt</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="cell-actions" style="align-items: center;">
                        <label class="switch" title="Bật/tắt voucher">
                            <input type="checkbox" ${v.trangThai == 1 ? 'checked' : ''} onchange="toggleVoucher('${v.maVoucher}', this)">
                            <span class="slider"></span>
                        </label>
                        <button class="btn-action reply" title="Sửa voucher" onclick="editVoucher('${v.maVoucher}')">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </button>
                        <button class="btn-action delete" title="Xóa voucher" onclick="deleteVoucher('${v.maVoucher}')">
                            <i class="fa-solid fa-trash-can"></i>
                        </button>
                    </div>

                    <div id="data-${v.maVoucher}" style="display:none;"
                         data-ten="${fn:escapeXml(v.tenVoucher)}" data-loai="${v.loaiGiam}"
                         data-giatri="${v.giaTriGiam}" data-toida="${v.giamToiDa}"
                         data-toithieu="${v.donToiThieu}" data-soluong="${v.soLuong}" data-dadung="${v.daSuDung}"
                         data-batdau="<fmt:formatDate value='${v.ngayBatDau}' pattern='yyyy-MM-dd'/>"
                         data-ketthuc="<fmt:formatDate value='${v.ngayKetThuc}' pattern='yyyy-MM-dd'/>"
                         data-trangthai="${v.trangThai}"></div>
                </div>
            </c:forEach>

            <c:if test="${empty listVouchers}">
                <p class="empty-msg">Không có voucher nào.</p>
            </c:if>
        </div>
    </div>

    <!-- MODAL THÊM / SỬA VOUCHER -->
    <div class="order-modal-overlay" id="voucherModal">
        <div class="order-modal" style="width: 700px;">
            <form action="${ctx}/admin-voucher-action" method="POST" id="voucherForm" style="display: contents;">
                <div class="om-header">
                    <h3 id="vm-title">Tạo voucher mới</h3>
                    <button type="button" class="rm-close" onclick="closeVoucherModal()"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <div class="om-body">
                    <input type="hidden" name="action" id="vm-action" value="add">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Mã voucher <span class="req">*</span></label>
                            <input type="text" name="maVoucher" id="vm-ma" class="form-control" required maxlength="50"
                                   pattern="[A-Za-z0-9_\-]{3,50}" style="text-transform: uppercase; font-weight: 700;" placeholder="VD: SALE50K">
                            <span class="form-hint">Chữ, số, dấu - hoặc _. Không sửa được sau khi tạo.</span>
                        </div>
                        <div class="form-group">
                            <label>Tên hiển thị</label>
                            <input type="text" name="tenVoucher" id="vm-ten" class="form-control" maxlength="200" placeholder="Để trống sẽ tự tạo">
                        </div>
                        <div class="form-group">
                            <label>Loại giảm giá</label>
                            <div class="seg-control">
                                <label><input type="radio" name="loaiGiam" value="0" id="vm-loai-0" checked onchange="onTypeChange()"><span>Số tiền (đ)</span></label>
                                <label><input type="radio" name="loaiGiam" value="1" id="vm-loai-1" onchange="onTypeChange()"><span>Phần trăm (%)</span></label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label id="vm-giatri-label">Số tiền giảm (đ) <span class="req">*</span></label>
                            <input type="number" name="giaTriGiam" id="vm-giatri" class="form-control" min="1" required>
                        </div>
                        <div class="form-group" id="vm-toida-group" style="display: none;">
                            <label>Giảm tối đa (đ)</label>
                            <input type="number" name="giamToiDa" id="vm-toida" class="form-control" min="0" step="1000" placeholder="Để trống = không giới hạn">
                        </div>
                        <div class="form-group">
                            <label>Đơn tối thiểu (đ)</label>
                            <input type="number" name="donToiThieu" id="vm-toithieu" class="form-control" min="0" step="1000" value="0">
                        </div>
                        <div class="form-group">
                            <label>Số lượt phát hành <span class="req">*</span></label>
                            <input type="number" name="soLuong" id="vm-soluong" class="form-control" min="1" value="100" required>
                            <span class="form-hint" id="vm-dadung-hint"></span>
                        </div>
                        <div class="form-group">
                            <label>Ngày bắt đầu <span class="req">*</span></label>
                            <input type="date" name="ngayBatDau" id="vm-batdau" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Ngày kết thúc <span class="req">*</span></label>
                            <input type="date" name="ngayKetThuc" id="vm-ketthuc" class="form-control" required>
                        </div>
                        <div class="form-group full">
                            <div class="check-row">
                                <label><input type="checkbox" name="trangThai" value="1" id="vm-trangthai" checked> Kích hoạt voucher (khách hàng có thể thấy & sử dụng)</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="om-footer" style="display: flex; justify-content: flex-end; gap: 12px;">
                    <button type="button" class="btn-cancel" onclick="closeVoucherModal()">Hủy bỏ</button>
                    <button type="submit" class="btn-submit-reply"><i class="fa-solid fa-floppy-disk"></i> Lưu voucher</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const CTX = '${ctx}';

        function postAction(params) {
            return fetch(CTX + '/admin-voucher-action', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: new URLSearchParams(params).toString()
            }).then(r => r.text());
        }

        function toISO(d) {
            const z = n => String(n).padStart(2, '0');
            return d.getFullYear() + '-' + z(d.getMonth() + 1) + '-' + z(d.getDate());
        }

        function onTypeChange() {
            const isPercent = document.getElementById('vm-loai-1').checked;
            const input = document.getElementById('vm-giatri');
            document.getElementById('vm-giatri-label').innerHTML = (isPercent ? 'Phần trăm giảm (%)' : 'Số tiền giảm (đ)') + ' <span class="req">*</span>';
            document.getElementById('vm-toida-group').style.display = isPercent ? 'flex' : 'none';
            input.max = isPercent ? 100 : '';
            input.step = isPercent ? 1 : 1000;
        }

        function openVoucherModal() {
            document.getElementById('voucherForm').reset();
            document.getElementById('vm-title').innerText = 'Tạo voucher mới';
            document.getElementById('vm-action').value = 'add';
            document.getElementById('vm-ma').readOnly = false;
            document.getElementById('vm-dadung-hint').innerText = '';
            const today = new Date();
            const next = new Date(); next.setDate(today.getDate() + 30);
            document.getElementById('vm-batdau').value = toISO(today);
            document.getElementById('vm-ketthuc').value = toISO(next);
            onTypeChange();
            document.getElementById('voucherModal').style.display = 'flex';
        }

        function editVoucher(code) {
            const d = document.getElementById('data-' + code).dataset;
            openVoucherModal();
            document.getElementById('vm-title').innerText = 'Sửa voucher ' + code;
            document.getElementById('vm-action').value = 'update';
            document.getElementById('vm-ma').value = code;
            document.getElementById('vm-ma').readOnly = true;
            document.getElementById('vm-ten').value = d.ten || '';
            document.getElementById('vm-loai-' + d.loai).checked = true;
            document.getElementById('vm-giatri').value = d.giatri;
            document.getElementById('vm-toida').value = d.toida || '';
            document.getElementById('vm-toithieu').value = d.toithieu;
            document.getElementById('vm-soluong').value = d.soluong;
            document.getElementById('vm-soluong').min = Math.max(1, parseInt(d.dadung));
            document.getElementById('vm-dadung-hint').innerText = 'Đã dùng ' + d.dadung + ' lượt';
            document.getElementById('vm-batdau').value = d.batdau;
            document.getElementById('vm-ketthuc').value = d.ketthuc;
            document.getElementById('vm-trangthai').checked = d.trangthai === '1';
            onTypeChange();
        }

        function closeVoucherModal() {
            document.getElementById('voucherModal').style.display = 'none';
            document.getElementById('vm-soluong').min = 1;
        }

        document.getElementById('voucherForm').addEventListener('submit', function(e) {
            const start = document.getElementById('vm-batdau').value;
            const end = document.getElementById('vm-ketthuc').value;
            if (end < start) {
                e.preventDefault();
                showToast('error', 'Lỗi', 'Ngày kết thúc phải sau ngày bắt đầu!');
            }
        });

        function toggleVoucher(code, checkbox) {
            const status = checkbox.checked ? 1 : 0;
            postAction({ action: 'toggle', code: code, status: status }).then(res => {
                if (res === 'success') {
                    showToast(status ? 'success' : 'warning', status ? 'Đã bật' : 'Đã tắt', 'Voucher ' + code + (status ? ' đã được kích hoạt.' : ' đã bị tắt.'));
                    setTimeout(() => location.reload(), 900);
                } else {
                    checkbox.checked = !checkbox.checked;
                    showToast('error', 'Lỗi', 'Không thể đổi trạng thái voucher!');
                }
            });
        }

        function deleteVoucher(code) {
            if (!confirm('Xóa vĩnh viễn voucher ' + code + '?\nCác đơn hàng đã dùng mã này vẫn được giữ nguyên.')) return;
            postAction({ action: 'delete', code: code }).then(res => {
                if (res === 'success') {
                    document.getElementById('vc-' + code).remove();
                    showToast('success', 'Đã xóa', 'Đã xóa voucher ' + code);
                } else {
                    showToast('error', 'Lỗi', 'Không thể xóa voucher!');
                }
            });
        }

        document.getElementById('voucherModal').addEventListener('click', function(e) {
            if (e.target === this) closeVoucherModal();
        });
    </script>
</body>
</html>
