<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="dal.OrderDAO" %>
<%@ page import="model.User" %>
<%@ page import="model.Order" %>
<%@ page import="java.util.List" %>

<%
    // Tự động đếm số lượng đơn hàng của User đang đăng nhập
    int countOrders = 0;
    User u = (User) session.getAttribute("user");
    if (u != null) {
        OrderDAO oDao = new OrderDAO();
        List<Order> listO = oDao.getOrdersByEmail(u.getEmail());
        if (listO != null) {
            countOrders = listO.size();
        }
    }
    pageContext.setAttribute("countOrders", countOrders);
%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<header class="main-header">
    <div class="container header-container">
        <div class="logo">
            <a href="index.jsp"><h2>HA BADMINTON</h2></a>
        </div>
        <nav class="main-nav">
            <ul>
                <li><a href="#">SẢN PHẨM MỚI</a></li>
                <!-- VỢT CẦU LÔNG -->
                <li class="has-mega-menu">
                    <a href="category?id=1">VỢT CẦU LÔNG</a>
                    <div class="mega-menu">
                        <div class="mega-content">
                            <div class="mega-column">
                                <h3 class="orange-heading">VỢT CẦU LÔNG</h3>
                                <hr class="grey-line">
                                <a href="category?id=1&brandId=1">Vợt cầu lông Yonex</a>
                                <a href="category?id=1&brandId=2">Vợt cầu lông Victor</a>
                                <a href="category?id=1&brandId=3">Vợt cầu lông Lining</a>
                                <a href="category?id=1&brandId=4">Vợt cầu lông VS</a>
                                <a href="category?id=1&brandId=5">Vợt cầu lông Mizuno</a>
                                <a href="category?id=1" class="view-more">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </li>
                <!-- GIÀY CẦU LÔNG -->
                <li class="has-mega-menu">
                    <a href="category?id=2">GIÀY CẦU LÔNG</a>
                    <div class="mega-menu">
                        <div class="mega-content ">
                            <div class="mega-column">
                                <h3 class="orange-heading">GIÀY CẦU LÔNG</h3>
                                <hr class="grey-line">
                                <a href="category?id=2&brandId=1">Giày cầu lông Yonex</a>
                                <a href="category?id=2&brandId=2">Giày cầu lông Victor</a>
                                <a href="category?id=2&brandId=3">Giày cầu lông Lining</a>
                                <a href="category?id=2&brandId=6">Giày cầu lông Kawasaki</a>
                                <a href="category?id=2&brandId=5">Giày cầu lông Mizuno</a>
                                <a href="category?id=2" class="view-more">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </li>
                <!-- QUẦN ÁO -->
                <li class="has-mega-menu">
                    <a href="category?id=3">QUẦN ÁO</a>
                    <div class="mega-menu">
                        <div class="mega-content ">
                            <div class="mega-column">
                                <h3 class="orange-heading">ÁO CẦU LÔNG</h3>
                                <hr class="grey-line">
                                <a href="category?id=3&brandId=1">Áo cầu lông Yonex</a>
                                <a href="category?id=3&brandId=7">Áo cầu lông VNB</a>
                                <a href="category?id=3&brandId=8">Áo cầu lông Kamito</a>
                                <a href="category?id=3&brandId=4">Áo cầu lông VS</a>
                                <a href="category?id=3&brandId=2">Áo cầu lông Victor</a>
                                <a href="category?id=3" class="view-more">Xem thêm</a>
                            </div>
                            <div class="mega-column">
                                <h3 class="orange-heading">VÁY CẦU LÔNG</h3>
                                <hr class="grey-line">
                                <a href="category?id=5&brandId=1">Váy cầu lông Yonex</a>
                                <a href="category?id=5&brandId=9">Váy cầu lông Victec</a>
                                <a href="category?id=5&brandId=3">Váy cầu lông Lining</a>
                                <a href="category?id=5&brandId=10">Váy cầu lông Donex Pro</a>
                            </div>
                            <div class="mega-column">
                                <h3 class="orange-heading">QUẦN CẦU LÔNG</h3>
                                <hr class="grey-line">
                                <a href="category?id=4&brandId=1">Quần cầu lông Yonex</a>
                                <a href="category?id=4&brandId=2">Quần cầu lông Victor</a>
                                <a href="category?id=4&brandId=3">Quần cầu lông Lining</a>
                                <a href="category?id=4&brandId=7">Quần cầu lông VNB</a>
                                <a href="category?id=4&brandId=11">Quần cầu lông SFD</a>
                                <a href="category?id=4" class="view-more">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </li>
                <!-- TÚI & BALO -->
                <li class="has-mega-menu">
                    <a href="category?id=6">TÚI VỢT</a>
                    <div class="mega-menu">
                        <div class="mega-content ">
                            <div class="mega-column">
                                <h3 class="orange-heading">TÚI VỢT CẦU LÔNG</h3>
                                <hr class="grey-line">
                                <a href="category?id=6&brandId=1">Túi vợt cầu lông Yonex</a>
                                <a href="category?id=8">Túi đựng giày</a>
                                <a href="category?id=6&brandId=4">Túi vợt cầu lông VS</a>
                                <a href="category?id=6&brandId=2">Túi vợt cầu lông Victor</a>
                                <a href="category?id=6&brandId=3">Túi vợt cầu lông Lining</a>
                                <a href="category?id=6" class="view-more">Xem thêm</a>
                            </div>
                            <div class="mega-column">
                                <h3 class="orange-heading">BALO CẦU LÔNG</h3>
                                <hr class="grey-line">
                                <a href="category?id=7&brandId=1">Balo cầu lông Yonex</a>
                                <a href="category?id=7&brandId=4">Balo cầu lông VS</a>
                                <a href="category?id=7&brandId=2">Balo cầu lông Victor</a>
                                <a href="category?id=7&brandId=6">Balo cầu lông Kawasaki</a>
                                <a href="category?id=7&brandId=12">Balo cầu lông Flypower</a>
                                <a href="category?id=7" class="view-more">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </li>
                <!-- PHỤ KIỆN -->
                <li class="has-mega-menu">
                    <a href="category?id=9">PHỤ KIỆN</a>
                    <div class="mega-menu">
                        <div class="mega-content ">
                            <div class="mega-column">
                                <h3 class="orange-heading">PHỤ KIỆN CẦU LÔNG</h3>
                                <hr class="grey-line">
                                <a href="category?id=9">Vớ cầu lông</a>
                                <a href="category?id=9">Cước đan vợt cầu lông</a>
                                <a href="category?id=9">Quả cầu lông (Ống cầu)</a>
                                <a href="category?id=9">Quấn cán cầu lông</a>
                                <a href="category?id=9">Băng chặn mồ hôi</a>
                                <a href="category?id=9" class="view-more">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </nav>
        
        <!-- Nút Đăng nhập, Hồ sơ & Giỏ hàng -->
        <div class="user-actions" style="display: flex; align-items: center; gap: 20px;">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="user-menu-wrap" style="padding: 10px 0;">
                        <a href="#" class="login-btn">
                            <i class="fa-regular fa-user" style="font-size: 20px; color: #ff6600; border: 1px solid #ff6600; border-radius: 50%; padding: 8px;"></i>
                        </a>
                        
                        <div class="user-dropdown">
                            <h3 class="orange-heading">TÀI KHOẢN</h3>
                            <hr class="grey-line">
                            <a href="profile.jsp"><i class="fa-regular fa-address-card"></i> Hồ sơ cá nhân</a>
                            <a href="logoutServlet"><i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp" class="login-btn">
                        <i class="fa-regular fa-user" style="font-size: 20px; color: #555; border: 1px solid #ddd; border-radius: 50%; padding: 8px;"></i>
                    </a>
                </c:otherwise>
            </c:choose>
            
            <!-- Đã sửa href thành "orders" và thêm hiển thị chấm đỏ -->
            <div class="order-icon-wrapper" onclick="window.location.href='orders'" style="position: relative; cursor: pointer;">
                <i class="fa-solid fa-clipboard-list" style="font-size: 20px; color: #ff6600; border: 1px solid #ff6600; border-radius: 50%; padding: 8px;"></i>
                <c:if test="${countOrders > 0}">
                    <span class="cart-badge">${countOrders}</span>
                </c:if>
            </div>
            
            <div class="cart-icon-wrapper" onclick="toggleCartSidebar()" style="position: relative; cursor: pointer;">
                <i class="fa-solid fa-cart-shopping" style="font-size: 20px; color: #ff6600; border: 1px solid #ff6600; border-radius: 50%; padding: 8px;"></i>
                <span class="cart-badge" id="cartBadge"></span>
            </div>
        </div>

        <div class="cart-toast" id="cartToast">
            <div class="toast-icon"><i class="fa-solid fa-circle-check"></i></div>
            <div class="toast-content">
                <span class="toast-title">Thành công</span>
                <span class="toast-desc">Sản phẩm được thêm thành công vào giỏ hàng</span>
            </div>
            <button class="toast-close" onclick="closeToast()"><i class="fa-solid fa-xmark"></i></button>
        </div>

        <div class="cart-overlay" id="cartOverlay" onclick="toggleCartSidebar()"></div>
        <div class="cart-sidebar" id="cartSidebar">
            <div class="cart-sidebar-header">
                <h2>Giỏ hàng</h2>
                <button class="close-sidebar" onclick="toggleCartSidebar()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            
            <div class="cart-sidebar-body" id="cartItemsList">
            </div>
            
            <div class="cart-sidebar-footer">
                <div class="cart-total">
                    <span>Tổng cộng</span>
                    <span class="total-price" id="cartTotalAmount">0đ</span>
                </div>
                <div class="cart-buttons">
                    <a href="cart.jsp" class="btn-outline">Xem giỏ hàng</a>
                    <a href="checkout.jsp" class="btn-solid">Đặt mua</a>
                </div>
            </div>
        </div>

        <script>
            function toggleCartSidebar() {
                document.getElementById('cartSidebar').classList.toggle('active');
                document.getElementById('cartOverlay').classList.toggle('active');
            }

            function closeToast() {
                document.getElementById('cartToast').classList.remove('show');
            }

            let cart = JSON.parse(localStorage.getItem('habadminton_cart')) || [];

            const formatCurrency = (amount) => {
                return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
            };

            function renderCart() {
                const cartList = document.getElementById('cartItemsList');
                const cartBadge = document.getElementById('cartBadge');
                const cartTotal = document.getElementById('cartTotalAmount');
                
                cartList.innerHTML = '';
                let totalAmount = 0;
                let totalQuantity = 0;

                if(cart.length === 0) {
                    cartList.innerHTML = '<p style="text-align:center; padding: 20px; color:#999;">Giỏ hàng của bạn đang trống.</p>';
                } else {
                    cart.forEach((item, index) => {
                        totalAmount += item.price * item.quantity;
                        totalQuantity += item.quantity;

                        cartList.innerHTML += `
                            <div class="cart-item">
                                <div class="product-img-wrap">
                                    <img src="\${item.image}" alt="\${item.name}">
                                    <button class="btn-remove-red" onclick="removeFromCart(\${index})">
                                        <i class="fa-solid fa-xmark"></i>
                                    </button>
                                </div>
                                <div class="cart-item-info">
                                    <h4>\${item.name}</h4>
                                    <div class="cart-item-controls">
                                        <div class="qty-control">
                                            <button onclick="updateCartQty(\${index}, -1)">-</button>
                                            <input type="text" value="\${item.quantity}" readonly>
                                            <button onclick="updateCartQty(\${index}, 1)">+</button>
                                        </div>
                                        <span class="item-price">\${formatCurrency(item.price)}</span>
                                    </div>
                                </div>
                            </div>
                        `;
                    });
                }

                cartBadge.innerText = totalQuantity;
                cartTotal.innerText = formatCurrency(totalAmount);
                localStorage.setItem('habadminton_cart', JSON.stringify(cart));
            }

            function updateCartQty(index, change) {
                if (cart[index].quantity + change > 0) {
                    cart[index].quantity += change;
                    renderCart();
                }
            }

            function removeFromCart(index) {
                cart.splice(index, 1);
                renderCart();
            }

            function addToCart(id, name, price, image, qty) {
                const existingItem = cart.find(item => item.id === id);
                
                if (existingItem) {
                    existingItem.quantity += parseInt(qty);
                } else {
                    cart.push({ id: id, name: name, price: price, image: image, quantity: parseInt(qty) });
                }
                
                renderCart();
                
                const toast = document.getElementById('cartToast');
                toast.classList.add('show');
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 3000);
            }

            document.addEventListener('DOMContentLoaded', renderCart);
        </script>
    </div>
</header>