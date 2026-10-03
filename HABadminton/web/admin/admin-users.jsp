<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Tài khoản - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-style.css?v=11">
    <style>
        .data-thead, .data-row { grid-template-columns: 2.4fr 1.6fr 1.1fr 0.6fr 1.2fr 1.2fr 1.9fr; }
        .u-avatar { width: 42px; height: 42px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border-dark); flex-shrink: 0; }
        .u-avatar-empty { width: 42px; height: 42px; border-radius: 50%; background: var(--bg-admin); color: var(--text-silver); display: flex; align-items: center; justify-content: center; border: 1px solid var(--border-dark); flex-shrink: 0; }
        .role-select { padding: 6px 8px; border: 1px solid var(--border-dark); border-radius: 6px; background: var(--surface-input); font-family: inherit; font-weight: 600; font-size: 12px; cursor: pointer; }
    </style>
</head>
<body>

    <jsp:include page="admin-sidebar.jsp">
        <jsp:param name="active" value="customers" />
    </jsp:include>

    <div class="admin-main">
        <div class="page-head">
            <h2 class="admin-page-title">Quản lý Tài khoản</h2>
            <button class="btn-primary-add" onclick="openUserModal()"><i class="fa-solid fa-user-plus"></i> Thêm tài khoản</button>
        </div>

        <!-- 1. THẺ THỐNG KÊ -->
        <div class="stats-grid">
            <a href="${ctx}/admin-customers" class="stat-card st-all">
                <span class="st-title">Tất cả tài khoản</span>
                <span class="st-value">${countAll}</span>
                <i class="fa-solid fa-users st-icon"></i>
            </a>
            <a href="${ctx}/admin-customers?role=0" class="stat-card st-done">
                <span class="st-title">Khách hàng</span>
                <span class="st-value">${countCustomer}</span>
                <i class="fa-solid fa-user st-icon"></i>
            </a>
            <a href="${ctx}/admin-customers?role=1" class="stat-card st-accepted">
                <span class="st-title">Quản trị viên</span>
                <span class="st-value">${countAdmin}</span>
                <i class="fa-solid fa-user-shield st-icon"></i>
            </a>
            <a href="${ctx}/admin-customers?status=0" class="stat-card st-cancel">
                <span class="st-title">Đang bị khóa</span>
                <span class="st-value">${countLocked}</span>
                <i class="fa-solid fa-user-lock st-icon"></i>
            </a>
        </div>

        <!-- 2. BỘ LỌC -->
        <form action="${ctx}/admin-customers" method="GET" class="filter-bar">
            <input type="text" name="keyword" value="${fn:escapeXml(param.keyword)}" class="filter-input" placeholder="Tìm theo họ tên, email hoặc số điện thoại...">
            <select name="role" class="filter-select">
                <option value="all">Mọi vai trò</option>
                <option value="0" ${param.role == '0' ? 'selected' : ''}>Khách hàng</option>
                <option value="1" ${param.role == '1' ? 'selected' : ''}>Quản trị viên</option>
            </select>
            <select name="status" class="filter-select">
                <option value="all">Mọi trạng thái</option>
                <option value="1" ${param.status == '1' ? 'selected' : ''}>Hoạt động</option>
                <option value="0" ${param.status == '0' ? 'selected' : ''}>Bị khóa</option>
            </select>
            <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
            <a href="${ctx}/admin-customers" class="btn-reset" title="Làm mới bộ lọc"><i class="fa-solid fa-rotate-right"></i></a>
        </form>

        <!-- 3. DANH SÁCH -->
        <div class="data-table">
            <div class="data-thead">
                <div>Tài khoản</div>
                <div>Liên hệ</div>
                <div>Vai trò</div>
                <div>Số đơn</div>
                <div>Tổng chi tiêu</div>
                <div>Trạng thái</div>
                <div style="text-align: right;">Thao tác</div>
            </div>

            <c:forEach items="${listUsers}" var="u" varStatus="loop">
                <c:set var="isMe" value="${sessionScope.user.email == u.email}" />
                <div class="data-row ${u.trangThai == 0 ? 'row-muted' : ''}" id="user-${loop.index}" data-email="${fn:escapeXml(u.email)}">
                    <div class="cell-main">
                        <c:choose>
                            <c:when test="${not empty u.avatar}"><img class="u-avatar" src="${ctx}/${u.avatar}" alt=""></c:when>
                            <c:otherwise><div class="u-avatar-empty"><i class="fa-solid fa-user"></i></div></c:otherwise>
                        </c:choose>
                        <div class="cm-text">
                            <strong>${fn:escapeXml(u.hoTen)} <c:if test="${isMe}"><span class="pill pill-info">Bạn</span></c:if></strong>
                            <small>${fn:escapeXml(u.email)}</small>
                        </div>
                    </div>
                    <div style="font-size: 13px;">
                        <div>${not empty u.sdt ? fn:escapeXml(u.sdt) : '<span class="muted">Chưa có SĐT</span>'}</div>
                        <div class="muted" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${fn:escapeXml(u.diaChi)}">
                            ${not empty u.tinhThanh ? fn:escapeXml(u.tinhThanh) : (not empty u.diaChi ? fn:escapeXml(u.diaChi) : 'Chưa có địa chỉ')}
                        </div>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${isMe}"><span class="pill pill-admin"><i class="fa-solid fa-user-shield"></i> Admin</span></c:when>
                            <c:otherwise>
                                <select class="role-select" data-old="${u.role}" onchange="changeRole(${loop.index}, this)">
                                    <option value="0" ${u.role == 0 ? 'selected' : ''}>Khách hàng</option>
                                    <option value="1" ${u.role == 1 ? 'selected' : ''}>Admin</option>
                                </select>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="font-weight: 700;">${u.soDonHang}</div>
                    <div class="price-now"><fmt:formatNumber value="${u.tongChiTieu}" pattern="#,##0"/>đ</div>
                    <div id="status-${loop.index}">
                        <c:choose>
                            <c:when test="${u.trangThai == 1}"><span class="pill pill-success"><i class="fa-solid fa-circle-check"></i> Hoạt động</span></c:when>
                            <c:otherwise><span class="pill pill-danger"><i class="fa-solid fa-lock"></i> Bị khóa</span></c:otherwise>
                        </c:choose>
                        <c:if test="${not empty u.ngayTao}">
                            <div class="muted" style="margin-top: 4px;">Từ <fmt:formatDate value="${u.ngayTao}" pattern="dd/MM/yyyy"/></div>
                        </c:if>
                    </div>
                    <div class="cell-actions">
                        <button class="btn-action reply" title="Sửa thông tin" onclick="editUser(${loop.index})">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </button>
                        <button class="btn-action" title="Đặt lại mật khẩu" onclick="resetPassword(${loop.index})">
                            <i class="fa-solid fa-key"></i>
                        </button>
                        <c:if test="${not isMe}">
                            <button class="btn-action" id="lock-btn-${loop.index}" data-status="${u.trangThai}"
                                    title="${u.trangThai == 1 ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}" onclick="toggleLock(${loop.index})">
                                <i class="fa-solid ${u.trangThai == 1 ? 'fa-lock' : 'fa-lock-open'}"></i>
                            </button>
                            <button class="btn-action delete" title="Xóa tài khoản" onclick="deleteUser(${loop.index})">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </c:if>
                    </div>

                    <div id="data-${loop.index}" style="display:none;"
                         data-email="${fn:escapeXml(u.email)}" data-ten="${fn:escapeXml(u.hoTen)}"
                         data-sdt="${fn:escapeXml(u.sdt)}" data-diachi="${fn:escapeXml(u.diaChi)}"
                         data-quan="${fn:escapeXml(u.quanHuyen)}" data-tinh="${fn:escapeXml(u.tinhThanh)}"
                         data-role="${u.role}" data-me="${isMe}"></div>
                </div>
            </c:forEach>

            <c:if test="${empty listUsers}">
                <p class="empty-msg">Không tìm thấy tài khoản nào.</p>
            </c:if>
        </div>
    </div>

    <!-- MODAL THÊM / SỬA TÀI KHOẢN -->
    <div class="order-modal-overlay" id="userModal">
        <div class="order-modal" style="width: 680px;">
            <form action="${ctx}/admin-customers" method="POST" id="userForm" style="display: contents;">
                <div class="om-header">
                    <h3 id="um-title">Thêm tài khoản</h3>
                    <button type="button" class="rm-close" onclick="closeUserModal()"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <div class="om-body">
                    <input type="hidden" name="action" id="um-action" value="add">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Họ và tên <span class="req">*</span></label>
                            <input type="text" name="hoTen" id="um-ten" class="form-control" required maxlength="100">
                        </div>
                        <div class="form-group">
                            <label>Email <span class="req">*</span></label>
                            <input type="email" name="email" id="um-email" class="form-control" required maxlength="100">
                        </div>
                        <div class="form-group" id="um-pass-group">
                            <label>Mật khẩu <span class="req">*</span></label>
                            <input type="text" name="matKhau" id="um-pass" class="form-control" minlength="6" value="${defaultPassword}">
                            <span class="form-hint">Tối thiểu 6 ký tự. Khách nên đổi sau khi đăng nhập.</span>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="tel" name="sdt" id="um-sdt" class="form-control" pattern="0[0-9]{9,10}" placeholder="VD: 0912345678">
                        </div>
                        <div class="form-group">
                            <label>Vai trò</label>
                            <select name="role" id="um-role" class="form-control">
                                <option value="0">Khách hàng</option>
                                <option value="1">Quản trị viên (Admin)</option>
                            </select>
                        </div>
                        <div class="form-group full">
                            <label>Địa chỉ</label>
                            <input type="text" name="diaChi" id="um-diachi" class="form-control" maxlength="255" placeholder="Số nhà, tên đường...">
                        </div>
                        <div class="form-group edit-only">
                            <label>Quận / Huyện</label>
                            <input type="text" name="quanHuyen" id="um-quan" class="form-control" maxlength="100">
                        </div>
                        <div class="form-group edit-only">
                            <label>Tỉnh / Thành phố</label>
                            <input type="text" name="tinhThanh" id="um-tinh" class="form-control" maxlength="100">
                        </div>
                    </div>
                </div>
                <div class="om-footer" style="display: flex; justify-content: flex-end; gap: 12px;">
                    <button type="button" class="btn-cancel" onclick="closeUserModal()">Hủy bỏ</button>
                    <button type="submit" class="btn-submit-reply"><i class="fa-solid fa-floppy-disk"></i> Lưu tài khoản</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const CTX = '${ctx}';
        const DEFAULT_PASS = '${defaultPassword}';

        function postAction(params) {
            return fetch(CTX + '/admin-customers', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: new URLSearchParams(params).toString()
            }).then(r => r.text());
        }

        function dataOf(idx) { return document.getElementById('data-' + idx).dataset; }

        function openUserModal() {
            document.getElementById('userForm').reset();
            document.getElementById('um-title').innerText = 'Thêm tài khoản';
            document.getElementById('um-action').value = 'add';
            document.getElementById('um-email').readOnly = false;
            document.getElementById('um-pass-group').style.display = 'flex';
            document.getElementById('um-pass').required = true;
            document.getElementById('um-pass').value = DEFAULT_PASS;
            document.getElementById('um-role').disabled = false;
            document.querySelectorAll('.edit-only').forEach(el => el.style.display = 'none');
            document.getElementById('userModal').style.display = 'flex';
        }

        function editUser(idx) {
            const d = dataOf(idx);
            openUserModal();
            document.getElementById('um-title').innerText = 'Sửa tài khoản';
            document.getElementById('um-action').value = 'update';
            document.getElementById('um-email').value = d.email;
            document.getElementById('um-email').readOnly = true;
            document.getElementById('um-pass-group').style.display = 'none';
            document.getElementById('um-pass').required = false;
            document.getElementById('um-ten').value = d.ten || '';
            document.getElementById('um-sdt').value = d.sdt || '';
            document.getElementById('um-diachi').value = d.diachi || '';
            document.getElementById('um-quan').value = d.quan || '';
            document.getElementById('um-tinh').value = d.tinh || '';
            document.getElementById('um-role').value = d.role;
            // Không cho tự đổi vai trò của chính mình
            document.getElementById('um-role').disabled = d.me === 'true';
            document.querySelectorAll('.edit-only').forEach(el => el.style.display = 'flex');
        }

        function closeUserModal() {
            document.getElementById('userModal').style.display = 'none';
        }

        document.getElementById('userForm').addEventListener('submit', function() {
            // select bị disabled sẽ không được gửi -> bật lại trước khi submit
            document.getElementById('um-role').disabled = false;
        });

        function handleCommon(res) {
            if (res === 'self') { showToast('error', 'Không hợp lệ', 'Bạn không thể thao tác trên chính tài khoản đang đăng nhập!'); return true; }
            if (res === 'forbidden') { location.href = CTX + '/login.jsp'; return true; }
            return false;
        }

        function toggleLock(idx) {
            const d = dataOf(idx);
            const btn = document.getElementById('lock-btn-' + idx);
            const newStatus = btn.dataset.status === '1' ? 0 : 1;
            if (newStatus === 0 && !confirm('Khóa tài khoản ' + d.email + '?\nNgười dùng sẽ không thể đăng nhập cho đến khi được mở khóa.')) return;
            postAction({ action: 'toggle', email: d.email, status: newStatus }).then(res => {
                if (handleCommon(res)) return;
                if (res === 'success') {
                    btn.dataset.status = String(newStatus);
                    btn.title = newStatus === 1 ? 'Khóa tài khoản' : 'Mở khóa tài khoản';
                    btn.innerHTML = '<i class="fa-solid ' + (newStatus === 1 ? 'fa-lock' : 'fa-lock-open') + '"></i>';
                    document.getElementById('user-' + idx).classList.toggle('row-muted', newStatus === 0);
                    const pill = document.querySelector('#status-' + idx + ' .pill');
                    pill.className = 'pill ' + (newStatus === 1 ? 'pill-success' : 'pill-danger');
                    pill.innerHTML = newStatus === 1 ? '<i class="fa-solid fa-circle-check"></i> Hoạt động' : '<i class="fa-solid fa-lock"></i> Bị khóa';
                    showToast(newStatus === 1 ? 'success' : 'warning', newStatus === 1 ? 'Đã mở khóa' : 'Đã khóa', 'Tài khoản ' + d.email);
                } else showToast('error', 'Lỗi', 'Không thể cập nhật trạng thái! Hãy chạy file database/update_admin.sql.');
            });
        }

        function changeRole(idx, select) {
            const d = dataOf(idx);
            const role = select.value;
            const label = role === '1' ? 'QUẢN TRỊ VIÊN' : 'KHÁCH HÀNG';
            if (!confirm('Đổi vai trò của ' + d.email + ' thành ' + label + '?')) { select.value = select.dataset.old; return; }
            postAction({ action: 'role', email: d.email, role: role }).then(res => {
                if (handleCommon(res)) { select.value = select.dataset.old; return; }
                if (res === 'success') {
                    select.dataset.old = role;
                    d.role = role;
                    showToast('success', 'Đã cập nhật', d.email + ' giờ là ' + label.toLowerCase());
                } else { select.value = select.dataset.old; showToast('error', 'Lỗi', 'Không thể đổi vai trò!'); }
            });
        }

        function resetPassword(idx) {
            const d = dataOf(idx);
            if (!confirm('Đặt lại mật khẩu của ' + d.email + ' về "' + DEFAULT_PASS + '"?')) return;
            postAction({ action: 'reset', email: d.email }).then(res => {
                if (handleCommon(res)) return;
                if (res === 'success') showToast('success', 'Đã đặt lại', 'Mật khẩu mới: ' + DEFAULT_PASS);
                else showToast('error', 'Lỗi', 'Không thể đặt lại mật khẩu!');
            });
        }

        function deleteUser(idx) {
            const d = dataOf(idx);
            if (!confirm('Xóa vĩnh viễn tài khoản ' + d.email + '?\nNếu tài khoản đã có đánh giá/dữ liệu liên quan, hệ thống sẽ KHÓA thay vì xóa.')) return;
            postAction({ action: 'delete', email: d.email }).then(res => {
                if (handleCommon(res)) return;
                if (res === 'success') {
                    document.getElementById('user-' + idx).remove();
                    showToast('success', 'Đã xóa', 'Đã xóa tài khoản ' + d.email);
                } else if (res === 'locked') {
                    showToast('warning', 'Đã khóa', 'Tài khoản có dữ liệu liên quan nên đã được khóa thay vì xóa.');
                    setTimeout(() => location.reload(), 1000);
                } else showToast('error', 'Lỗi', 'Không thể xóa tài khoản!');
            });
        }

        document.getElementById('userModal').addEventListener('click', function(e) {
            if (e.target === this) closeUserModal();
        });
    </script>
</body>
</html>