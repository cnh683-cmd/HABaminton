<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="hasRange" value="${not empty from or not empty to}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
    <style>
        .dash-grid-3 { display: grid; grid-template-columns: 1fr 1fr 1.2fr; gap: 20px; margin-bottom: 20px; }
        .filter-bar label.fl { font-size: 12px; font-weight: 700; color: var(--text-silver); text-transform: uppercase; align-self: center; }
        .filter-bar input[type=date] { flex: 0 0 auto; }
        .range-note { font-size: 12px; color: var(--text-silver); margin: -12px 0 20px 4px; }
        #revenueTable { display: none; margin-top: 10px; }
        .stat-card .st-value.money { font-size: 22px; white-space: nowrap; }
        .pie-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 20px; margin-bottom: 20px; }
        .pie-wrap { display: flex; flex-direction: column; align-items: stretch; gap: 16px; }
        .pie-box { position: relative; width: 190px; height: 190px; margin: 0 auto; }
        .pie-legend { list-style: none; margin: 0; padding: 0; flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 8px; font-size: 13px; }
        .pie-legend li { display: flex; align-items: center; gap: 8px; }
        .pie-legend .sw { width: 10px; height: 10px; border-radius: 3px; flex-shrink: 0; }
        .pie-legend .lb { flex: 1; min-width: 0; color: var(--text-ivory); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .pie-legend .vl { color: var(--text-ivory); font-weight: 700; font-variant-numeric: tabular-nums; white-space: nowrap; }
        .pie-legend .pc { color: var(--text-silver); font-size: 12px; width: 44px; text-align: right; font-variant-numeric: tabular-nums; }
        @media (max-width: 1200px) { .dash-grid-3, .pie-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

    <jsp:include page="admin-sidebar.jsp">
        <jsp:param name="active" value="dashboard" />
    </jsp:include>

    <div class="admin-main">
        <h2 class="admin-page-title">Thống kê & Tổng quan</h2>

        <!-- BỘ LỌC: năm cho biểu đồ theo tháng, khoảng ngày cho các số liệu còn lại -->
        <form action="${ctx}/admin-dashboard" method="GET" class="filter-bar">
            <label class="fl">Năm</label>
            <select name="year" class="filter-select" style="min-width: 110px;">
                <c:forEach items="${years}" var="y">
                    <option value="${y}" ${y == year ? 'selected' : ''}>${y}</option>
                </c:forEach>
            </select>
            <label class="fl">Từ ngày</label>
            <input type="date" name="from" value="${from}" class="filter-input">
            <label class="fl">Đến ngày</label>
            <input type="date" name="to" value="${to}" class="filter-input">
            <button type="button" class="btn-reset" onclick="quickRange(7)">7 ngày</button>
            <button type="button" class="btn-reset" onclick="quickRange(30)">30 ngày</button>
            <button type="button" class="btn-reset" onclick="quickRange('month')">Tháng này</button>
            <button type="submit" class="btn-search"><i class="fa-solid fa-filter"></i> Lọc</button>
            <a href="${ctx}/admin-dashboard" class="btn-reset" title="Bỏ lọc"><i class="fa-solid fa-rotate-right"></i></a>
        </form>
        <p class="range-note">
            <i class="fa-solid fa-circle-info"></i>
            Số liệu kỳ:
            <strong>
                <c:choose>
                    <c:when test="${hasRange}">${empty from ? 'đầu' : from} → ${empty to ? 'nay' : to}</c:when>
                    <c:otherwise>toàn thời gian</c:otherwise>
                </c:choose>
            </strong>
            · Doanh thu không tính đơn đã hủy.
        </p>

        <!-- THẺ KPI -->
        <div class="stats-grid">
            <div class="stat-card st-all">
                <span class="st-title">Doanh thu tháng này</span>
                <span class="st-value money"><fmt:formatNumber value="${monthRevenue}" pattern="#,##0"/>đ</span>
                <span class="st-sub">
                    <c:choose>
                        <c:when test="${growth == null}">Chưa có dữ liệu tháng trước</c:when>
                        <c:when test="${growth >= 0}"><span class="up"><i class="fa-solid fa-arrow-trend-up"></i> +<fmt:formatNumber value="${growth}" pattern="0.#"/>%</span> so với tháng trước</c:when>
                        <c:otherwise><span class="down"><i class="fa-solid fa-arrow-trend-down"></i> <fmt:formatNumber value="${growth}" pattern="0.#"/>%</span> so với tháng trước</c:otherwise>
                    </c:choose>
                </span>
                <i class="fa-solid fa-sack-dollar st-icon"></i>
            </div>
            <div class="stat-card st-done">
                <span class="st-title">Doanh thu trong kỳ</span>
                <span class="st-value money"><fmt:formatNumber value="${rangeRevenue}" pattern="#,##0"/>đ</span>
                <span class="st-sub">${rangeOrders} đơn · ${soldQuantity} sản phẩm đã bán</span>
                <i class="fa-solid fa-chart-line st-icon"></i>
            </div>
            <a href="${ctx}/admin-orders" class="stat-card st-pending">
                <span class="st-title">Đơn chờ xử lý</span>
                <span class="st-value">${pendingOrders}</span>
                <span class="st-sub">Bấm để xử lý ngay</span>
                <i class="fa-solid fa-clock st-icon"></i>
            </a>
            <a href="${ctx}/admin-customers?role=0" class="stat-card st-accepted">
                <span class="st-title">Khách hàng</span>
                <span class="st-value">${totalUsers}</span>
                <span class="st-sub">+${newUsers} mới trong tháng</span>
                <i class="fa-solid fa-users st-icon"></i>
            </a>
            <a href="${ctx}/admin-products?stock=low" class="stat-card st-cancel">
                <span class="st-title">Sắp hết hàng</span>
                <span class="st-value">${lowStock}</span>
                <span class="st-sub">/ ${totalProducts} sản phẩm đang bán</span>
                <i class="fa-solid fa-triangle-exclamation st-icon"></i>
            </a>
            <a href="${ctx}/admin-vouchers?status=active" class="stat-card st-shipping">
                <span class="st-title">Voucher đang chạy</span>
                <span class="st-value">${activeVouchers}</span>
                <span class="st-sub">Quản lý giảm giá</span>
                <i class="fa-solid fa-ticket st-icon"></i>
            </a>
        </div>

        <!-- HÀNG 1: Doanh thu theo tháng + Trạng thái đơn -->
        <div class="dash-grid">
            <div class="dash-card">
                <div class="dc-head">
                    <div>
                        <h3>Doanh thu theo tháng — năm ${year}</h3>
                        <div class="dc-sub">Tổng cả năm: <strong style="color: var(--text-ivory);"><fmt:formatNumber value="${yearRevenue}" pattern="#,##0"/>đ</strong></div>
                    </div>
                    <button type="button" class="table-toggle" onclick="toggleRevenueTable(this)"><i class="fa-solid fa-table"></i> Xem bảng</button>
                </div>
                <div class="chart-box"><canvas id="revenueChart" aria-label="Biểu đồ doanh thu theo tháng" role="img"></canvas></div>
                <table class="mini-table" id="revenueTable">
                    <thead><tr><th>Tháng</th><th style="text-align:right;">Doanh thu</th><th style="text-align:right;">Số đơn</th></tr></thead>
                    <tbody id="revenueTableBody"></tbody>
                </table>
            </div>
            <div class="dash-card">
                <h3>Đơn hàng theo trạng thái</h3>
                <div class="dc-sub">Trong kỳ đã chọn · tổng ${rangeOrders} đơn</div>
                <div class="chart-box"><canvas id="statusChart" aria-label="Biểu đồ số đơn theo trạng thái" role="img"></canvas></div>
            </div>
        </div>

        <!-- HÀNG 2: Số đơn theo tháng + Doanh thu theo danh mục -->
        <div class="dash-grid">
            <div class="dash-card">
                <h3>Số đơn hàng theo tháng — năm ${year}</h3>
                <div class="dc-sub">Bao gồm cả đơn đã hủy</div>
                <div class="chart-box sm"><canvas id="ordersChart" aria-label="Biểu đồ số đơn theo tháng" role="img"></canvas></div>
            </div>
            <div class="dash-card">
                <h3>Doanh thu theo danh mục</h3>
                <div class="dc-sub">Trong kỳ đã chọn</div>
                <div class="chart-box sm"><canvas id="categoryChart" aria-label="Biểu đồ doanh thu theo danh mục" role="img"></canvas></div>
                <p id="categoryEmpty" class="empty-msg" style="display:none;">Chưa có dữ liệu.</p>
            </div>
        </div>

        <!-- HÀNG 3: Biểu đồ tròn -->
        <div class="pie-grid">
            <div class="dash-card">
                <h3>Tỉ lệ đơn theo trạng thái</h3>
                <div class="dc-sub">Trong kỳ đã chọn</div>
                <div class="pie-wrap">
                    <div class="pie-box"><canvas id="statusPie" role="img" aria-label="Biểu đồ tròn tỉ lệ đơn theo trạng thái"></canvas></div>
                    <ul class="pie-legend" id="statusPieLegend"></ul>
                </div>
            </div>
            <div class="dash-card">
                <h3>Cơ cấu doanh thu theo danh mục</h3>
                <div class="dc-sub">Trong kỳ đã chọn · không tính đơn hủy</div>
                <div class="pie-wrap">
                    <div class="pie-box"><canvas id="categoryPie" role="img" aria-label="Biểu đồ tròn doanh thu theo danh mục"></canvas></div>
                    <ul class="pie-legend" id="categoryPieLegend"></ul>
                </div>
            </div>
            <div class="dash-card">
                <h3>Phương thức thanh toán</h3>
                <div class="dc-sub">Số đơn trong kỳ · không tính đơn hủy</div>
                <div class="pie-wrap">
                    <div class="pie-box"><canvas id="paymentPie" role="img" aria-label="Biểu đồ tròn phương thức thanh toán"></canvas></div>
                    <ul class="pie-legend" id="paymentPieLegend"></ul>
                </div>
            </div>
        </div>

        <!-- HÀNG 4: Bảng xếp hạng -->
        <div class="dash-grid-3">
            <div class="dash-card">
                <div class="dc-head">
                    <h3>Top sản phẩm bán chạy</h3>
                    <a href="${ctx}/admin-products?sort=best" class="link-more">Xem tất cả →</a>
                </div>
                <c:choose>
                    <c:when test="${empty topProducts}"><p class="empty-msg">Chưa có dữ liệu.</p></c:when>
                    <c:otherwise>
                        <ul class="rank-list">
                            <c:forEach items="${topProducts}" var="p" varStatus="s">
                                <li>
                                    <span class="rank-no">${s.index + 1}</span>
                                    <img src="${ctx}/${p.hinhAnh}" onerror="this.onerror=null; this.src='${p.hinhAnh}'" alt="">
                                    <div class="rl-main">
                                        <strong title="${fn:escapeXml(p.tenSP)}">${fn:escapeXml(p.tenSP)}</strong>
                                        <span class="muted">Đã bán ${p.soLuong}</span>
                                    </div>
                                    <div class="rl-val"><fmt:formatNumber value="${p.doanhThu}" pattern="#,##0"/>đ</div>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="dash-card">
                <div class="dc-head">
                    <h3>Khách hàng thân thiết</h3>
                    <a href="${ctx}/admin-customers" class="link-more">Xem tất cả →</a>
                </div>
                <c:choose>
                    <c:when test="${empty topCustomers}"><p class="empty-msg">Chưa có dữ liệu.</p></c:when>
                    <c:otherwise>
                        <ul class="rank-list">
                            <c:forEach items="${topCustomers}" var="cu" varStatus="s">
                                <li>
                                    <span class="rank-no">${s.index + 1}</span>
                                    <c:choose>
                                        <c:when test="${not empty cu.avatar}"><img src="${ctx}/${cu.avatar}" style="border-radius:50%;" alt=""></c:when>
                                        <c:otherwise><div class="ra"><i class="fa-solid fa-user"></i></div></c:otherwise>
                                    </c:choose>
                                    <div class="rl-main">
                                        <strong>${fn:escapeXml(cu.hoTen)}</strong>
                                        <span class="muted">${cu.soDon} đơn hàng</span>
                                    </div>
                                    <div class="rl-val"><fmt:formatNumber value="${cu.tongTien}" pattern="#,##0"/>đ</div>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="dash-card">
                <div class="dc-head">
                    <h3>Đơn hàng mới nhất</h3>
                    <a href="${ctx}/admin-orders" class="link-more">Quản lý đơn →</a>
                </div>
                <c:choose>
                    <c:when test="${empty recentOrders}"><p class="empty-msg">Chưa có đơn hàng.</p></c:when>
                    <c:otherwise>
                        <table class="mini-table">
                            <thead><tr><th>Mã đơn</th><th>Khách</th><th style="text-align:right;">Tổng</th><th>Trạng thái</th></tr></thead>
                            <tbody>
                                <c:forEach items="${recentOrders}" var="o">
                                    <tr>
                                        <td style="font-weight: 700;">#${o.maDonHang}<br><span class="muted"><fmt:formatDate value="${o.ngayDat}" pattern="dd/MM HH:mm"/></span></td>
                                        <td>${fn:escapeXml(o.tenNguoiNhan)}</td>
                                        <td style="text-align:right; font-weight: 700;"><fmt:formatNumber value="${o.tongTien}" pattern="#,##0"/>đ</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o.trangThai == 1}"><span class="pill pill-warning">Chờ xử lý</span></c:when>
                                                <c:when test="${o.trangThai == 4}"><span class="pill pill-info">Đã tiếp nhận</span></c:when>
                                                <c:when test="${o.trangThai == 2}"><span class="pill pill-info">Đang giao</span></c:when>
                                                <c:when test="${o.trangThai == 3}"><span class="pill pill-success">Hoàn thành</span></c:when>
                                                <c:otherwise><span class="pill pill-danger">Đã hủy</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // ---------------- Dữ liệu từ server ----------------
        const MONTHS = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];
        const revenueData = ${revenueJson};
        const ordersData = ${ordersJson};
        const statusData = ${statusJson};           // [Chờ xử lý, Đã tiếp nhận, Đang giao, Hoàn thành, Đã hủy]
        const catLabels = ${catLabelsJson};
        const catValues = ${catValuesJson};
        const payLabels = ${payLabelsJson};
        const payValues = ${payValuesJson};

        // Năm hiện tại: các tháng chưa tới để trống (không vẽ thành 0)
        const now = new Date();
        if (${year} === now.getFullYear()) {
            for (let i = now.getMonth() + 1; i < 12; i++) { revenueData[i] = null; ordersData[i] = null; }
        }

        // ---------------- Cấu hình chung ----------------
        const INK = '#1C2434', INK_MUTED = '#64748B', GRID = '#EEF2F7', PRIMARY = '#353A5F';
        Chart.defaults.font.family = "'Be Vietnam Pro', 'Segoe UI', Arial, sans-serif";
        Chart.defaults.color = INK_MUTED;
        const vnd = v => new Intl.NumberFormat('vi-VN').format(Math.round(v)) + 'đ';
        const shortVnd = v => v >= 1e9 ? (v / 1e9).toFixed(1).replace('.0', '') + ' tỷ'
                              : v >= 1e6 ? (v / 1e6).toFixed(1).replace('.0', '') + ' tr'
                              : v >= 1e3 ? Math.round(v / 1e3) + 'k' : v;
        const tooltip = { backgroundColor: '#fff', titleColor: INK, bodyColor: INK, borderColor: '#E2E8F0', borderWidth: 1, padding: 10, displayColors: false };

        // 1. Doanh thu theo tháng (1 chuỗi, 1 trục)
        new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: { labels: MONTHS, datasets: [{ label: 'Doanh thu', data: revenueData, backgroundColor: PRIMARY,
                    hoverBackgroundColor: '#9EBAF3', borderRadius: 4, borderSkipped: 'start', maxBarThickness: 36 }] },
            options: {
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                plugins: { legend: { display: false },
                           tooltip: { ...tooltip, callbacks: { title: i => 'Tháng ' + (i[0].dataIndex + 1),
                                                                label: c => 'Doanh thu: ' + vnd(c.parsed.y) + ' · ' + ordersData[c.dataIndex] + ' đơn' } } },
                scales: { x: { grid: { display: false } },
                          y: { beginAtZero: true, grid: { color: GRID }, border: { display: false }, ticks: { callback: shortVnd } } }
            }
        });

        // Bảng dữ liệu thay thế cho biểu đồ doanh thu
        document.getElementById('revenueTableBody').innerHTML = MONTHS.map((m, i) =>
            '<tr><td>Tháng ' + (i + 1) + '</td><td style="text-align:right;">' + (revenueData[i] === null ? '—' : vnd(revenueData[i])) + '</td><td style="text-align:right;">' + (ordersData[i] === null ? '—' : ordersData[i]) + '</td></tr>'
        ).join('');
        function toggleRevenueTable(btn) {
            const t = document.getElementById('revenueTable');
            const box = document.getElementById('revenueChart').parentElement;
            const showTable = t.style.display !== 'table';
            t.style.display = showTable ? 'table' : 'none';
            box.style.display = showTable ? 'none' : 'block';
            btn.innerHTML = showTable ? '<i class="fa-solid fa-chart-column"></i> Xem biểu đồ' : '<i class="fa-solid fa-table"></i> Xem bảng';
        }

        // 2. Đơn theo trạng thái (thanh ngang, nhãn chữ trên trục => không phụ thuộc màu)
        new Chart(document.getElementById('statusChart'), {
            type: 'bar',
            data: { labels: ['Chờ xử lý', 'Đã tiếp nhận', 'Đang giao', 'Hoàn thành', 'Đã hủy'],
                    datasets: [{ data: statusData, backgroundColor: ['#F59E0B', '#14B8A6', '#8B5CF6', '#10B981', '#EF4444'],
                                 borderRadius: 4, borderSkipped: 'start', maxBarThickness: 26 }] },
            options: {
                indexAxis: 'y', maintainAspectRatio: false,
                plugins: { legend: { display: false }, tooltip: { ...tooltip, callbacks: { label: c => c.parsed.x + ' đơn' } } },
                scales: { x: { beginAtZero: true, grid: { color: GRID }, border: { display: false }, ticks: { precision: 0 } },
                          y: { grid: { display: false }, ticks: { color: INK, font: { weight: 600 } } } }
            }
        });

        // 3. Số đơn theo tháng (đường)
        new Chart(document.getElementById('ordersChart'), {
            type: 'line',
            data: { labels: MONTHS, datasets: [{ label: 'Số đơn', data: ordersData, borderColor: PRIMARY, borderWidth: 2,
                    backgroundColor: 'rgba(158,186,243,0.18)', fill: true, cubicInterpolationMode: 'monotone', spanGaps: false,
                    pointRadius: 4, pointHoverRadius: 6, pointBackgroundColor: PRIMARY, pointBorderColor: '#fff', pointBorderWidth: 2 }] },
            options: {
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                plugins: { legend: { display: false }, tooltip: { ...tooltip, callbacks: { title: i => 'Tháng ' + (i[0].dataIndex + 1), label: c => c.parsed.y + ' đơn' } } },
                scales: { x: { grid: { display: false } },
                          y: { beginAtZero: true, grid: { color: GRID }, border: { display: false }, ticks: { precision: 0 } } }
            }
        });

        // 4. Doanh thu theo danh mục (thanh ngang, 1 màu)
        if (catValues.length === 0) {
            document.getElementById('categoryChart').parentElement.style.display = 'none';
            document.getElementById('categoryEmpty').style.display = 'block';
        } else {
            new Chart(document.getElementById('categoryChart'), {
                type: 'bar',
                data: { labels: catLabels, datasets: [{ data: catValues, backgroundColor: '#5B6BA8', hoverBackgroundColor: PRIMARY,
                        borderRadius: 4, borderSkipped: 'start', maxBarThickness: 22 }] },
                options: {
                    indexAxis: 'y', maintainAspectRatio: false,
                    plugins: { legend: { display: false }, tooltip: { ...tooltip, callbacks: { label: c => vnd(c.parsed.x) } } },
                    scales: { x: { beginAtZero: true, grid: { color: GRID }, border: { display: false }, ticks: { callback: shortVnd } },
                              y: { grid: { display: false }, ticks: { color: INK } } }
                }
            });
        }

        // ---------------- Biểu đồ tròn (dạng vành khuyên) ----------------
        // Bảng màu nhóm theo thứ tự cố định (không đổi màu khi số nhóm thay đổi)
        const CAT_COLORS = ['#2a78d6', '#eb6834', '#1baf7a', '#eda100', '#e87ba4', '#008300', '#4a3aa7', '#e34948', '#64748B'];
        const STATUS_LABELS = ['Chờ xử lý', 'Đã tiếp nhận', 'Đang giao', 'Hoàn thành', 'Đã hủy'];
        const STATUS_COLORS = ['#F59E0B', '#14B8A6', '#8B5CF6', '#10B981', '#EF4444'];

        // Ghi tổng ở giữa vòng
        const centerText = {
            id: 'centerText',
            afterDraw(chart, args, opts) {
                const meta = chart.getDatasetMeta(0);
                if (!meta.data.length) return;
                const { x, y } = meta.data[0];
                const ctx = chart.ctx;
                ctx.save();
                ctx.textAlign = 'center';
                ctx.fillStyle = INK;
                ctx.font = "800 18px 'Be Vietnam Pro', 'Segoe UI', Arial, sans-serif";
                ctx.fillText(opts.value, x, y + 2);
                ctx.fillStyle = INK_MUTED;
                ctx.font = "500 11px 'Be Vietnam Pro', 'Segoe UI', Arial, sans-serif";
                ctx.fillText(opts.label, x, y + 18);
                ctx.restore();
            }
        };

        function makeDonut(canvasId, legendId, labels, values, colors, fmt, centerFmt, centerLabel) {
            const total = values.reduce((a, b) => a + (b || 0), 0);
            const legend = document.getElementById(legendId);
            const box = document.getElementById(canvasId).parentElement;
            if (total <= 0) {
                box.style.display = 'none';
                legend.innerHTML = '<li class="muted">Chưa có dữ liệu trong kỳ này.</li>';
                return;
            }
            const pct = v => (v * 100 / total).toFixed(1).replace('.0', '') + '%';
            new Chart(document.getElementById(canvasId), {
                type: 'doughnut',
                data: { labels: labels, datasets: [{ data: values, backgroundColor: colors,
                        borderColor: '#FFFFFF', borderWidth: 2, hoverOffset: 6 }] },
                options: {
                    cutout: '62%', maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: { ...tooltip, callbacks: { label: c => c.label + ': ' + fmt(c.parsed) + ' (' + pct(c.parsed) + ')' } },
                        centerText: { value: centerFmt(total), label: centerLabel }
                    }
                },
                plugins: [centerText]
            });
            // Chú thích: màu + tên + giá trị + % (không chỉ dựa vào màu)
            legend.innerHTML = labels.map((l, i) => values[i] > 0
                ? '<li><span class="sw" style="background:' + colors[i] + '"></span><span class="lb" title="' + l + '">' + l
                  + '</span><span class="vl">' + fmt(values[i]) + '</span><span class="pc">' + pct(values[i]) + '</span></li>'
                : '').join('');
        }

        makeDonut('statusPie', 'statusPieLegend', STATUS_LABELS, statusData, STATUS_COLORS,
                  v => v + ' đơn', v => v, 'đơn hàng');
        makeDonut('categoryPie', 'categoryPieLegend', catLabels, catValues,
                  catLabels.map((_, i) => CAT_COLORS[i % CAT_COLORS.length]), vnd, shortVnd, 'doanh thu');
        makeDonut('paymentPie', 'paymentPieLegend', payLabels, payValues,
                  payLabels.map(l => l.indexOf('MoMo') >= 0 ? '#e87ba4' : (l.indexOf('COD') >= 0 ? '#2a78d6' : '#eda100')),
                  v => v + ' đơn', v => v, 'đơn hàng');

        // ---------------- Chọn nhanh khoảng ngày ----------------
        function quickRange(kind) {
            const z = n => String(n).padStart(2, '0');
            const fmt = d => d.getFullYear() + '-' + z(d.getMonth() + 1) + '-' + z(d.getDate());
            const to = new Date();
            let from = new Date();
            if (kind === 'month') from = new Date(to.getFullYear(), to.getMonth(), 1);
            else from.setDate(to.getDate() - kind + 1);
            const form = document.querySelector('.filter-bar');
            form.from.value = fmt(from);
            form.to.value = fmt(to);
            form.submit();
        }
    </script>
</body>
</html>