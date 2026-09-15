<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="admin-sidebar">
    <div class="sidebar-logo">HABaminton ADMIN</div>
    
    <ul class="sidebar-menu" style="display: flex; flex-direction: column; flex-grow: 1; padding-bottom: 20px;">
        <li>
            <a href="#" class="${param.active == 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin-orders" class="${param.active == 'orders' ? 'active' : ''}">
                <i class="fa-solid fa-file-invoice-dollar"></i> Quản lý đơn hàng
            </a>
        </li>
        <li>
            <a href="#" class="${param.active == 'products' ? 'active' : ''}">
                <i class="fa-solid fa-box"></i> Quản lý sản phẩm
            </a>
        </li>
        <li>
            <a href="#" class="${param.active == 'customers' ? 'active' : ''}">
                <i class="fa-solid fa-users"></i> Khách hàng
            </a>
        </li>
        
        <!-- NÚT ĐĂNG XUẤT -->
        <li style="margin-top: auto;">
            <a href="${pageContext.request.contextPath}/logoutServlet" style="color: #dc3545; border-top: 1px solid #333;">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
            </a>
        </li>
    </ul>
</div>