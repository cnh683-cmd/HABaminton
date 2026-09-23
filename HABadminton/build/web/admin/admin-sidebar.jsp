<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="admin-sidebar">
    <div class="sidebar-logo">HABaminton ADMIN</div>
    
    <ul class="sidebar-menu" style="display: flex; flex-direction: column; flex-grow: 1; padding-bottom: 20px;">
        <li>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="${param.active == 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin-orders" class="${param.active == 'orders' ? 'active' : ''}">
                <i class="fa-solid fa-file-invoice-dollar"></i> Quản lý đơn hàng
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin-products" class="${param.active == 'products' ? 'active' : ''}">
                <i class="fa-solid fa-box"></i> Quản lý sản phẩm
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin-customers" class="${param.active == 'customers' ? 'active' : ''}">
                <i class="fa-solid fa-users"></i> Khách hàng
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin-reviews" class="${param.active == 'reviews' ? 'active' : ''}">
                <i class="fa-solid fa-star-half-stroke"></i> Quản lý đánh giá
            </a>
        </li>
        
        <!-- NÚT ĐĂNG XUẤT -->
        <li style="margin-top: auto;">
            <a href="${pageContext.request.contextPath}/logoutServlet" style="color: #dc3545; border-top: 1px solid var(--border-dark);">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
            </a>
        </li>
    </ul>
</div>

<script>
    function showToast(type, title, message) {
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            document.body.appendChild(container);
        }
        const toast = document.createElement('div');
        toast.className = 'custom-toast ' + type;
        let iconClass = 'fa-circle-check';
        if (type === 'error') iconClass = 'fa-circle-exclamation';
        if (type === 'warning') iconClass = 'fa-triangle-exclamation';

        toast.innerHTML = 
            '<div class="toast-icon"><i class="fa-solid ' + iconClass + '"></i></div>' +
            '<div class="toast-content">' +
                '<div class="toast-title">' + title + '</div>' +
                '<div class="toast-msg">' + message + '</div>' +
            '</div>' +
            '<div class="toast-close" onclick="this.parentElement.remove()">&times;</div>';
            
        container.appendChild(toast);
        setTimeout(() => {
            toast.style.animation = 'fadeOutToast 0.4s ease forwards';
            setTimeout(() => toast.remove(), 400); 
        }, 3500);
    }
</script>

<c:if test="${not empty sessionScope.msgSuccess}">
    <script>document.addEventListener("DOMContentLoaded", function() { showToast('success', 'Thành công', '${sessionScope.msgSuccess}'); });</script>
    <c:remove var="msgSuccess" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.msgError}">
    <script>document.addEventListener("DOMContentLoaded", function() { showToast('error', 'Lỗi', '${sessionScope.msgError}'); });</script>
    <c:remove var="msgError" scope="session"/>
</c:if>