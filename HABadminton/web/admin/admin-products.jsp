<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Sản phẩm - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-style.css?v=11">
    <style>
        .data-thead, .data-row { grid-template-columns: 3fr 1.4fr 1.4fr 0.9fr 0.7fr 1.1fr 1.4fr; }
    </style>
</head>
<body>

    <jsp:include page="admin-sidebar.jsp">
        <jsp:param name="active" value="products" />
    </jsp:include>

    <div class="admin-main">
        <div class="page-head">
            <h2 class="admin-page-title">Quản lý Sản phẩm</h2>
            <button class="btn-primary-add" onclick="openProductModal()"><i class="fa-solid fa-plus"></i> Thêm sản phẩm</button>
        </div>

        <!-- 1. THẺ THỐNG KÊ (bấm để lọc nhanh) -->
        <div class="stats-grid">
            <a href="${ctx}/admin-products" class="stat-card st-all">
                <span class="st-title">Tất cả sản phẩm</span>
                <span class="st-value">${countAll}</span>
                <i class="fa-solid fa-boxes-stacked st-icon"></i>
            </a>
            <a href="${ctx}/admin-products?status=1" class="stat-card st-done">
                <span class="st-title">Đang bán</span>
                <span class="st-value">${countActive}</span>
                <i class="fa-solid fa-store st-icon"></i>
            </a>
            <a href="${ctx}/admin-products?status=0" class="stat-card st-cancel">
                <span class="st-title">Ngừng bán</span>
                <span class="st-value">${countHidden}</span>
                <i class="fa-solid fa-eye-slash st-icon"></i>
            </a>
            <a href="${ctx}/admin-products?stock=low" class="stat-card st-pending">
                <span class="st-title">Sắp hết hàng (&lt; 5)</span>
                <span class="st-value">${countLow}</span>
                <i class="fa-solid fa-triangle-exclamation st-icon"></i>
            </a>
            <a href="${ctx}/admin-products?stock=out" class="stat-card st-cancel">
                <span class="st-title">Hết hàng</span>
                <span class="st-value">${countOut}</span>
                <i class="fa-solid fa-box-open st-icon"></i>
            </a>
        </div>

        <!-- 2. BỘ LỌC -->
        <form action="${ctx}/admin-products" method="GET" class="filter-bar">
            <input type="text" name="keyword" value="${fn:escapeXml(param.keyword)}" class="filter-input" placeholder="Tìm theo tên hoặc mã sản phẩm...">
            <select name="category" class="filter-select">
                <option value="all">Tất cả danh mục</option>
                <c:forEach items="${catMap}" var="cat">
                    <option value="${cat.key}" ${param.category == cat.key ? 'selected' : ''}>${cat.value}</option>
                </c:forEach>
            </select>
            <select name="brand" class="filter-select">
                <option value="all">Tất cả thương hiệu</option>
                <c:forEach items="${brandMap}" var="br">
                    <option value="${br.key}" ${param.brand == br.key ? 'selected' : ''}>${br.value}</option>
                </c:forEach>
            </select>
            <select name="status" class="filter-select">
                <option value="all">Mọi trạng thái</option>
                <option value="1" ${param.status == '1' ? 'selected' : ''}>Đang bán</option>
                <option value="0" ${param.status == '0' ? 'selected' : ''}>Ngừng bán</option>
            </select>
            <select name="sort" class="filter-select">
                <option value="">Mới nhất</option>
                <option value="oldest" ${param.sort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                <option value="stock_asc" ${param.sort == 'stock_asc' ? 'selected' : ''}>Tồn kho ít nhất</option>
                <option value="best" ${param.sort == 'best' ? 'selected' : ''}>Bán chạy nhất</option>
            </select>
            <c:if test="${not empty param.stock}"><input type="hidden" name="stock" value="${fn:escapeXml(param.stock)}"></c:if>
            <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
            <a href="${ctx}/admin-products" class="btn-reset" title="Làm mới bộ lọc"><i class="fa-solid fa-rotate-right"></i></a>
        </form>

        <p class="muted" style="margin: -10px 0 15px 5px;">Hiển thị <strong>${fn:length(listProducts)}</strong> sản phẩm</p>

        <!-- 3. DANH SÁCH -->
        <div class="data-table">
            <div class="data-thead">
                <div>Sản phẩm</div>
                <div>Danh mục / Hãng</div>
                <div>Giá bán</div>
                <div>Tồn kho</div>
                <div>Đã bán</div>
                <div>Đang bán</div>
                <div style="text-align: right;">Thao tác</div>
            </div>

            <c:forEach items="${listProducts}" var="sp">
                <div class="data-row ${sp.trangThai == 0 ? 'row-muted' : ''}" id="prod-${sp.maSP}">
                    <div class="cell-main">
                        <img src="${ctx}/${sp.hinhAnh}" onerror="this.onerror=null; this.src='${sp.hinhAnh}'" alt="">
                        <div class="cm-text">
                            <strong title="${fn:escapeXml(sp.tenSP)}">${fn:escapeXml(sp.tenSP)}</strong>
                            <small>#${sp.maSP}</small>
                            <c:if test="${sp.sanPhamMoi}"> <span class="pill pill-info">Mới</span></c:if>
                            <c:if test="${sp.banChay}"> <span class="pill pill-warning">Bán chạy</span></c:if>
                        </div>
                    </div>
                    <div>
                        <div style="font-weight: 600;">${not empty catMap[sp.maDM] ? catMap[sp.maDM] : sp.maDM}</div>
                        <div class="muted">${not empty brandMap[sp.maTH] ? brandMap[sp.maTH] : sp.maTH}</div>
                    </div>
                    <div>
                        <div class="price-now"><fmt:formatNumber value="${sp.giaBan}" pattern="#,##0"/>đ</div>
                        <c:if test="${sp.phanTramGiam > 0}">
                            <span class="price-old"><fmt:formatNumber value="${sp.giaGoc}" pattern="#,##0"/>đ</span>
                            <span class="pill pill-danger" style="padding: 1px 6px;">-${sp.phanTramGiam}%</span>
                        </c:if>
                    </div>
                    <div>
                        <input type="number" min="0" class="stock-input ${sp.soLuong <= 0 ? 'out' : (sp.soLuong < 5 ? 'low' : '')}"
                               value="${sp.soLuong}" data-old="${sp.soLuong}" title="Sửa rồi nhấn Enter để lưu"
                               onkeydown="if(event.key==='Enter'){event.preventDefault(); this.blur();}"
                               onchange="updateStock(${sp.maSP}, this)">
                    </div>
                    <div style="font-weight: 600;">${sp.daBan}</div>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <label class="switch" title="Bật/tắt hiển thị trên cửa hàng">
                            <input type="checkbox" ${sp.trangThai == 1 ? 'checked' : ''} onchange="toggleProduct(${sp.maSP}, this)">
                            <span class="slider"></span>
                        </label>
                        <span class="muted" id="status-text-${sp.maSP}">${sp.trangThai == 1 ? 'Đang bán' : 'Đã ẩn'}</span>
                    </div>
                    <div class="cell-actions">
                        <a class="btn-action" title="Xem trên cửa hàng" href="${ctx}/detail?id=${sp.maSP}" target="_blank" style="text-decoration:none;">
                            <i class="fa-solid fa-arrow-up-right-from-square"></i>
                        </a>
                        <button class="btn-action reply" title="Sửa sản phẩm" onclick="editProduct(${sp.maSP})">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </button>
                        <button class="btn-action delete" title="Xóa sản phẩm" onclick="deleteProduct(${sp.maSP})">
                            <i class="fa-solid fa-trash-can"></i>
                        </button>
                    </div>

                    <!-- Dữ liệu ẩn cho form sửa -->
                    <div id="data-${sp.maSP}" style="display:none;"
                         data-ten="${fn:escapeXml(sp.tenSP)}"
                         data-giagoc="<fmt:formatNumber value='${sp.giaGoc}' pattern='0'/>"
                         data-giaban="<fmt:formatNumber value='${sp.giaBan}' pattern='0'/>"
                         data-madm="${sp.maDM}" data-math="${sp.maTH}"
                         data-soluong="${sp.soLuong}" data-trangthai="${sp.trangThai}"
                         data-moi="${sp.sanPhamMoi}" data-banchay="${sp.banChay}"
                         data-hinhanh="${fn:escapeXml(sp.hinhAnh)}"
                         data-xuatxu="${fn:escapeXml(sp.xuatXu)}"
                         data-mota="${fn:escapeXml(sp.moTa)}"
                         data-thongso="${fn:escapeXml(sp.thongSo)}"></div>
                </div>
            </c:forEach>

            <c:if test="${empty listProducts}">
                <p class="empty-msg">Không tìm thấy sản phẩm nào.</p>
            </c:if>
        </div>
    </div>

    <!-- MODAL THÊM / SỬA SẢN PHẨM -->
    <div class="order-modal-overlay" id="productModal">
        <div class="order-modal form-modal">
            <form action="${ctx}/admin-product-action" method="POST" enctype="multipart/form-data" id="productForm" style="display: contents;">
                <div class="om-header">
                    <h3 id="pm-title">Thêm sản phẩm mới</h3>
                    <button type="button" class="rm-close" onclick="closeProductModal()"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <div class="om-body">
                    <input type="hidden" name="action" id="pm-action" value="add">
                    <input type="hidden" name="maSP" id="pm-id">
                    <input type="hidden" name="back" value="${fn:escapeXml(pageContext.request.queryString)}">

                    <div class="form-grid">
                        <div class="form-group full">
                            <label>Tên sản phẩm <span class="req">*</span></label>
                            <input type="text" name="tenSP" id="pm-ten" class="form-control" required maxlength="255" placeholder="VD: Vợt Cầu Lông Yonex Astrox 100ZZ">
                        </div>
                        <div class="form-group">
                            <label>Danh mục <span class="req">*</span></label>
                            <select name="maDM" id="pm-dm" class="form-control" required>
                                <c:forEach items="${catMap}" var="cat"><option value="${cat.key}">${cat.value}</option></c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Thương hiệu <span class="req">*</span></label>
                            <select name="maTH" id="pm-th" class="form-control" required>
                                <c:forEach items="${brandMap}" var="br"><option value="${br.key}">${br.value}</option></c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Giá gốc (đ)</label>
                            <input type="number" name="giaGoc" id="pm-giagoc" class="form-control" min="0" step="1000" placeholder="Để trống = bằng giá bán">
                        </div>
                        <div class="form-group">
                            <label>Giá bán (đ) <span class="req">*</span></label>
                            <input type="number" name="giaBan" id="pm-giaban" class="form-control" min="1000" step="1000" required>
                            <span class="form-hint" id="pm-discount-hint"></span>
                        </div>
                        <div class="form-group">
                            <label>Số lượng tồn kho <span class="req">*</span></label>
                            <input type="number" name="soLuong" id="pm-soluong" class="form-control" min="0" value="10" required>
                        </div>
                        <div class="form-group">
                            <label>Xuất xứ</label>
                            <input type="text" name="xuatXu" id="pm-xuatxu" class="form-control" maxlength="100" placeholder="VD: Nhật Bản">
                        </div>
                        <div class="form-group full">
                            <label>Hình ảnh</label>
                            <div class="img-preview-box">
                                <img id="pm-preview" src="${ctx}/images/bia1.png" alt="Xem trước">
                                <div style="flex: 1; display: flex; flex-direction: column; gap: 8px;">
                                    <input type="file" name="imageFile" id="pm-file" accept="image/*" class="form-control" onchange="previewImage(this)">
                                    <input type="text" name="hinhAnh" id="pm-hinhanh" class="form-control" placeholder="Hoặc nhập đường dẫn ảnh, VD: images/ten-anh.jpg" oninput="previewPath(this.value)">
                                    <span class="form-hint">Ảnh tải lên tối đa 5MB. Khi sửa, để trống cả 2 ô sẽ giữ ảnh cũ.</span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group full">
                            <label>Mô tả</label>
                            <textarea name="moTa" id="pm-mota" class="form-control" rows="3" placeholder="Mô tả ngắn về sản phẩm..."></textarea>
                        </div>
                        <div class="form-group full">
                            <label>Thông số kỹ thuật</label>
                            <textarea name="thongSo" id="pm-thongso" class="form-control" rows="3" placeholder="VD: Trọng lượng: 4U | Chiều dài: 675mm | Độ cứng: Cứng"></textarea>
                        </div>
                        <div class="form-group full">
                            <div class="check-row">
                                <label><input type="checkbox" name="trangThai" value="1" id="pm-trangthai" checked> Đang bán (hiển thị trên cửa hàng)</label>
                                <label><input type="checkbox" name="sanPhamMoi" id="pm-moi"> Sản phẩm mới</label>
                                <label><input type="checkbox" name="banChay" id="pm-banchay"> Bán chạy</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="om-footer" style="display: flex; justify-content: flex-end; gap: 12px;">
                    <button type="button" class="btn-cancel" onclick="closeProductModal()">Hủy bỏ</button>
                    <button type="submit" class="btn-submit-reply" id="pm-submit"><i class="fa-solid fa-floppy-disk"></i> Lưu sản phẩm</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const CTX = '${ctx}';

        function postAction(params) {
            return fetch(CTX + '/admin-product-action', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: new URLSearchParams(params).toString()
            }).then(r => r.text());
        }

        // ---------- MODAL ----------
        function openProductModal() {
            const f = document.getElementById('productForm');
            f.reset();
            document.getElementById('pm-title').innerText = 'Thêm sản phẩm mới';
            document.getElementById('pm-action').value = 'add';
            document.getElementById('pm-id').value = '';
            document.getElementById('pm-preview').src = CTX + '/images/bia1.png';
            document.getElementById('pm-discount-hint').innerText = '';
            document.getElementById('productModal').style.display = 'flex';
        }

        function editProduct(id) {
            const d = document.getElementById('data-' + id).dataset;
            openProductModal();
            document.getElementById('pm-title').innerText = 'Sửa sản phẩm #' + id;
            document.getElementById('pm-action').value = 'update';
            document.getElementById('pm-id').value = id;
            document.getElementById('pm-ten').value = d.ten || '';
            document.getElementById('pm-giagoc').value = d.giagoc || '';
            document.getElementById('pm-giaban').value = d.giaban || '';
            document.getElementById('pm-dm').value = d.madm;
            document.getElementById('pm-th').value = d.math;
            document.getElementById('pm-soluong').value = d.soluong;
            document.getElementById('pm-xuatxu').value = d.xuatxu || '';
            document.getElementById('pm-mota').value = d.mota || '';
            document.getElementById('pm-thongso').value = d.thongso || '';
            document.getElementById('pm-hinhanh').value = d.hinhanh || '';
            document.getElementById('pm-trangthai').checked = d.trangthai === '1';
            document.getElementById('pm-moi').checked = d.moi === 'true';
            document.getElementById('pm-banchay').checked = d.banchay === 'true';
            previewPath(d.hinhanh || '');
            updateDiscountHint();
        }

        function closeProductModal() {
            document.getElementById('productModal').style.display = 'none';
        }

        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = e => document.getElementById('pm-preview').src = e.target.result;
                reader.readAsDataURL(input.files[0]);
            }
        }

        function previewPath(path) {
            if (!path) return;
            const img = document.getElementById('pm-preview');
            img.onerror = function() { this.onerror = null; this.src = path; };
            img.src = /^https?:\/\//.test(path) ? path : CTX + '/' + path;
        }

        function updateDiscountHint() {
            const goc = parseFloat(document.getElementById('pm-giagoc').value) || 0;
            const ban = parseFloat(document.getElementById('pm-giaban').value) || 0;
            const hint = document.getElementById('pm-discount-hint');
            if (goc > 0 && ban > 0 && ban < goc) {
                hint.innerText = 'Giảm ' + Math.round((goc - ban) * 100 / goc) + '% so với giá gốc';
                hint.style.color = 'var(--success)';
            } else {
                hint.innerText = '';
            }
        }
        document.getElementById('pm-giagoc').addEventListener('input', updateDiscountHint);
        document.getElementById('pm-giaban').addEventListener('input', updateDiscountHint);

                document.getElementById('productForm').addEventListener('submit', function() {
            document.getElementById('pm-submit').disabled = true;
        });

        // ---------- THAO TÁC NHANH ----------
        function toggleProduct(id, checkbox) {
            const status = checkbox.checked ? 1 : 0;
            postAction({ action: 'toggle', id: id, status: status }).then(res => {
                if (res === 'success') {
                    document.getElementById('prod-' + id).classList.toggle('row-muted', status === 0);
                    document.getElementById('status-text-' + id).innerText = status === 1 ? 'Đang bán' : 'Đã ẩn';
                    document.getElementById('data-' + id).dataset.trangthai = String(status);
                    showToast(status === 1 ? 'success' : 'warning', status === 1 ? 'Đã mở bán' : 'Đã ẩn',
                              status === 1 ? 'Sản phẩm đã hiển thị trên cửa hàng.' : 'Sản phẩm đã bị ẩn khỏi cửa hàng.');
                } else {
                    checkbox.checked = !checkbox.checked;
                    showToast('error', 'Lỗi', 'Không thể đổi trạng thái!');
                }
            }).catch(() => { checkbox.checked = !checkbox.checked; showToast('error', 'Lỗi', 'Lỗi kết nối máy chủ!'); });
        }

        function updateStock(id, input) {
            const qty = parseInt(input.value);
            if (isNaN(qty) || qty < 0) {
                input.value = input.dataset.old;
                showToast('error', 'Lỗi', 'Số lượng tồn kho không hợp lệ!');
                return;
            }
            postAction({ action: 'stock', id: id, qty: qty }).then(res => {
                if (res === 'success') {
                    input.dataset.old = qty;
                    input.classList.toggle('out', qty <= 0);
                    input.classList.toggle('low', qty > 0 && qty < 5);
                    document.getElementById('data-' + id).dataset.soluong = String(qty);
                    showToast('success', 'Đã lưu', 'Tồn kho sản phẩm #' + id + ': ' + qty);
                } else {
                    input.value = input.dataset.old;
                    showToast('error', 'Lỗi', 'Không thể cập nhật tồn kho!');
                }
            });
        }

        function deleteProduct(id) {
            const name = document.getElementById('data-' + id).dataset.ten;
            if (!confirm('Xóa sản phẩm "' + name + '"?\n\nNếu sản phẩm đã có đánh giá, hệ thống sẽ chuyển sang "Ngừng bán" thay vì xóa.')) return;
            postAction({ action: 'delete', id: id }).then(res => {
                if (res === 'success') {
                    document.getElementById('prod-' + id).remove();
                    showToast('success', 'Đã xóa', 'Đã xóa sản phẩm #' + id);
                } else if (res === 'hidden') {
                    const row = document.getElementById('prod-' + id);
                    row.classList.add('row-muted');
                    row.querySelector('.switch input').checked = false;
                    document.getElementById('status-text-' + id).innerText = 'Đã ẩn';
                    showToast('warning', 'Đã ngừng bán', 'Sản phẩm có dữ liệu liên quan nên được chuyển sang Ngừng bán.');
                } else {
                    showToast('error', 'Lỗi', 'Không thể xóa sản phẩm!');
                }
            });
        }

        document.getElementById('productModal').addEventListener('click', function(e) {
            if (e.target === this) closeProductModal();
        });
    </script>
</body>
</html>