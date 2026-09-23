<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${empty sessionScope.user}">
    <c:redirect url="login.jsp" />
</c:if><!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - HA Badminton</title>
    <link rel="stylesheet" href="css/style.css?v=30">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<script>
    function prepareOrderData() {
        const urlParams = new URLSearchParams(window.location.search);
        const isBuyNow = urlParams.get('buynow') === 'true';
        let currentCart = [];
        if (isBuyNow) {
            currentCart = JSON.parse(sessionStorage.getItem('habadminton_buynow')) || [];
        } else {
            currentCart = JSON.parse(localStorage.getItem('habadminton_cart')) || [];
        }
        
        const form = document.getElementById('checkoutForm');
        
        // --- 1. Gửi mã Voucher ---
        let inputVoucher = document.createElement('input');
        inputVoucher.type = 'hidden';
        inputVoucher.name = 'voucherCode';
        inputVoucher.value = (typeof selectedVoucherTemp !== 'undefined' && selectedVoucherTemp) ? selectedVoucherTemp.code : '';
        form.appendChild(inputVoucher);

        // --- 2. Gửi thông tin Sản phẩm kèm Ảnh và Mã SP ---
        currentCart.forEach(item => {
            let inputId = document.createElement('input');
            inputId.type = 'hidden';
            inputId.name = 'productId';
            inputId.value = item.id;
            form.appendChild(inputId);

            let inputName = document.createElement('input');
            inputName.type = 'hidden';
            inputName.name = 'productName';
            inputName.value = item.name;
            form.appendChild(inputName);

            let inputQty = document.createElement('input');
            inputQty.type = 'hidden';
            inputQty.name = 'productQty';
            inputQty.value = item.quantity;
            form.appendChild(inputQty);

            let inputPrice = document.createElement('input');
            inputPrice.type = 'hidden';
            inputPrice.name = 'productPrice';
            inputPrice.value = item.price;
            form.appendChild(inputPrice);
            
            let inputImage = document.createElement('input');
            inputImage.type = 'hidden';
            inputImage.name = 'productImage';
            inputImage.value = item.image;
            form.appendChild(inputImage);
        });
        return true; 
    }
</script>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <c:if test="${empty sessionScope.user}">
        <c:redirect url="login.jsp" />
    </c:if>

    <div class="container checkout-page">
        <h1 class="checkout-main-title">Thanh toán</h1>

        <form id="checkoutForm" action="processCheckout" method="POST" class="checkout-layout" onsubmit="return prepareOrderData()">
            
            <div class="checkout-shipping">
                <h2 class="centered-title">Thông tin giao hàng</h2>
                <div class="shipping-form">
                    
                    <input type="hidden" id="hiddenCheckoutName" value="${sessionScope.user.hoTen}">

                    <div class="form-row form-col-2" style="display: flex; gap: 15px; margin-bottom: 15px;">
                        <input type="text" id="chkLastName" name="lastName" placeholder="Họ" style="flex: 1;">
                        <input type="text" id="chkFirstName" name="firstName" placeholder="Tên" required style="flex: 1;">
                    </div>
                    
                    <script>
                        (function() {
                            let fullName = "${sessionScope.user.hoTen}";
                            if (fullName && fullName.trim() !== "") {
                                fullName = fullName.trim();
                                let lastSpace = fullName.lastIndexOf(" ");
                                if (lastSpace !== -1) {
                                    document.getElementById("chkLastName").value = fullName.substring(0, lastSpace);
                                    document.getElementById("chkFirstName").value = fullName.substring(lastSpace + 1);
                                } else {
                                    document.getElementById("chkFirstName").value = fullName;
                                }
                            }
                        })();
                    </script>

                    <div class="form-row" style="margin-bottom: 15px;">
                        <input type="email" id="email" name="email" value="${sessionScope.user.email}" readonly style="background-color: #f5f5f5; cursor: not-allowed; width: 100%; color: #888; border: 1px solid #ddd; padding: 10px; border-radius: 4px;">
                    </div>

                    <div class="form-row" style="margin-bottom: 15px;">
                        <input type="text" name="phone" value="${sessionScope.user.sdt}" placeholder="Số điện thoại" required style="width: 100%;">
                    </div>

                    <div class="form-row" style="margin-bottom: 15px;">
                        <input type="text" name="address" value="${sessionScope.user.diaChi}" placeholder="Địa chỉ nhà (Số nhà, tên đường...)" required style="width: 100%;">
                    </div>

                    <div class="form-row form-col-2" style="display: flex; gap: 15px; margin-bottom: 15px;">
                        <input type="text" name="district" value="${sessionScope.user.quanHuyen}" placeholder="Quận / Huyện" required style="flex: 1;">
                        <input type="text" name="city" value="${sessionScope.user.tinhThanh}" placeholder="Tỉnh / Thành phố" required style="flex: 1;">
                    </div>
                    
                    <div class="form-row" style="margin-top: 15px;">
                        <textarea name="note" placeholder="Ghi chú thêm về đơn hàng..." rows="3" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 4px; font-family: inherit; resize: vertical;"></textarea>
                    </div>
                </div>
            </div>

            <div class="checkout-summary-box">
                
                <div class="summary-header">
                    <h3 class="centered-title">Đơn hàng của bạn</h3>
                </div>
                
                <div class="summary-count-left">
                    <span class="count-text">Sản phẩm</span>
                    <span class="item-count-circle" id="chkItemCount">0</span>
                </div>

                <div class="summary-items" id="chkItemsList">
                </div>

                <div class="summary-divider"></div>

                <div class="voucher-trigger" onclick="openVoucherModal()">
                    <i class="fa-solid fa-ticket"></i>
                    <span id="selectedVoucherText">Chọn HA Voucher</span>
                    <i class="fa-solid fa-chevron-right arrow"></i>
                </div>

                <div class="summary-totals">
                    <div class="total-row">
                        <span>Tạm tính</span>
                        <span id="chkSubTotal">0đ</span>
                    </div>
                    <div class="total-row discount-row" id="chkDiscountRow" style="display: none;">
                        <span>Khuyến mãi</span>
                        <span id="chkDiscountAmount">-0đ</span>
                    </div>
                    <div class="total-row final-total">
                        <span>Tổng tiền</span>
                        <span id="chkFinalTotal">0đ</span>
                    </div>
                </div>

                <div class="summary-divider"></div>

                <h3 style="margin-bottom: 15px; font-size: 16px; color: #fff;">Phương thức thanh toán</h3>
                <div class="payment-methods-row">
                    <label class="payment-btn-item">
                        <input type="radio" name="paymentMethod" value="MOMO">
                        <div class="payment-btn-card">
                            <img src="images/logoMOMO.jpg" alt="MoMo">
                            <span class="momo-label">Ví MoMo</span>
                        </div>
                    </label>

                    <label class="payment-btn-item">
                        <input type="radio" name="paymentMethod" value="COD" checked>
                        <div class="payment-btn-card">
                            <img src="images/logoCOD.jpg" alt="COD">
                            <span class="cod-label">Tiền mặt (COD)</span>
                        </div>
                    </label>
                </div>
                
                <input type="hidden" name="totalAmount" id="hiddenTotalAmount" value="0">

                <button type="button" class="btn-place-order" onclick="submitOrder()">
                    <i class="fa-solid fa-cart-shopping"></i> Đặt hàng
                </button>
            </div>
        </form>
    </div>

    <!-- MODAL CHỌN VOUCHER -->
    <div class="voucher-modal-overlay" id="voucherOverlay" onclick="closeVoucherModal()"></div>
    <div class="voucher-modal" id="voucherModal">
        <div class="vm-header">
            <h3>Chọn HA Voucher</h3>
            <button class="vm-close" onclick="closeVoucherModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="vm-body">
            <div class="vm-input-group">
                <input type="text" placeholder="Nhập mã voucher" id="manualVoucherCode">
                <button type="button" onclick="applyManualVoucher()">Áp dụng</button>
            </div>
            <p class="vm-subtitle">Mã giảm giá có sẵn</p>
            
            <div class="vm-list" id="voucherListContainer">
            </div>
        </div>
        <div class="vm-footer">
            <button type="button" class="btn-confirm-voucher" onclick="confirmVoucher()">ĐỒNG Ý</button>
        </div>
    </div>

    <jsp:include page="footer.jsp"></jsp:include>

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const isBuyNow = urlParams.get('buynow') === 'true';

        let checkoutCart = [];
        if (isBuyNow) {
            checkoutCart = JSON.parse(sessionStorage.getItem('habadminton_buynow')) || [];
        } else {
            checkoutCart = JSON.parse(localStorage.getItem('habadminton_cart')) || [];
        }
        
        let subTotal = 0;
        let appliedDiscount = 0;

        const formatMoney = (amount) => new Intl.NumberFormat('vi-VN').format(amount) + 'đ';

        function loadCheckoutItems() {
            const listEl = document.getElementById('chkItemsList');
            const countEl = document.getElementById('chkItemCount');
            
            listEl.innerHTML = '';
            subTotal = 0;
            let totalQty = 0;

            if(checkoutCart.length === 0) {
                listEl.innerHTML = '<p style="color:#aaa; text-align:center;">Giỏ hàng trống.</p>';
                return;
            }

            checkoutCart.forEach((item, index) => {
                subTotal += item.price * item.quantity;
                totalQty += item.quantity;

                listEl.innerHTML += `
                    <div class="chk-item">
                        <div class="product-img-wrap">
                            <img src="\${item.image}" alt="\${item.name}">
                            <button type="button" class="btn-remove-red" onclick="removeCheckoutItem(\${index})">
                                <i class="fa-solid fa-xmark"></i>
                            </button>
                        </div>
                        <div class="chk-info">
                            <h4>\${item.name}</h4>
                            <p>\${item.quantity} x \${formatMoney(item.price)}</p>
                        </div>
                    </div>
                `;
            });

            countEl.innerText = totalQty;
            updateTotals();
        }

        function removeCheckoutItem(index) {
            checkoutCart.splice(index, 1);
            if (isBuyNow) {
                sessionStorage.setItem('habadminton_buynow', JSON.stringify(checkoutCart));
            } else {
                localStorage.setItem('habadminton_cart', JSON.stringify(checkoutCart));
                if (typeof renderCart === 'function') {
                    cart = checkoutCart;
                    renderCart();
                }
            }
            loadCheckoutItems();
        }

        function updateTotals() {
            document.getElementById('chkSubTotal').innerText = formatMoney(subTotal);
            
            let finalTotal = subTotal - appliedDiscount;
            if(finalTotal < 0) finalTotal = 0;

            if(appliedDiscount > 0) {
                document.getElementById('chkDiscountRow').style.display = 'flex';
                document.getElementById('chkDiscountAmount').innerText = "-" + formatMoney(appliedDiscount);
            } else {
                document.getElementById('chkDiscountRow').style.display = 'none';
            }

            document.getElementById('chkFinalTotal').innerText = formatMoney(finalTotal);
        }

        const availableVouchers = [
            { id: 'V1', code: 'HA200K', title: 'Giảm 200.000đ', minOrder: 0, discount: 200000, date: '31/12/2026' },
            { id: 'V2', code: 'FREESHIP', title: 'Giảm 30.000đ (Phí Ship)', minOrder: 500000, discount: 30000, date: '15/10/2026' },
            { id: 'V3', code: 'VIP500', title: 'Giảm 500.000đ', minOrder: 5000000, discount: 500000, date: '01/11/2026' }
        ];

        let selectedVoucherTemp = null;

        function openVoucherModal() {
            document.getElementById('voucherOverlay').classList.add('active');
            document.getElementById('voucherModal').classList.add('active');
            renderVoucherList();
        }

        function closeVoucherModal() {
            document.getElementById('voucherOverlay').classList.remove('active');
            document.getElementById('voucherModal').classList.remove('active');
        }

        function renderVoucherList() {
            const container = document.getElementById('voucherListContainer');
            container.innerHTML = '';

            availableVouchers.forEach(v => {
                const isEligible = subTotal >= v.minOrder;
                const opacity = isEligible ? '1' : '0.5';
                const warning = isEligible ? '' : `<span class="v-warning">Mua thêm \${formatMoney(v.minOrder - subTotal)} để dùng</span>`;

                container.innerHTML += `
                    <label class="voucher-card" style="opacity: \${opacity}; cursor: \${isEligible ? 'pointer' : 'not-allowed'};">
                        <div class="v-icon">
                            <i class="fa-solid fa-ticket"></i>
                            <span>HA Shop</span>
                        </div>
                        <div class="v-info">
                            <h4>\${v.title}</h4>
                            <p>Đơn tối thiểu \${formatMoney(v.minOrder)}</p>
                            <p>HSD: \${v.date}</p>
                            \${warning}
                        </div>
                        <div class="v-radio">
                            <input type="radio" name="voucherRadio" value="\${v.id}" \${!isEligible ? 'disabled' : ''} onchange="selectTempVoucher('\${v.id}')">
                        </div>
                    </label>
                `;
            });
        }

        function selectTempVoucher(id) {
            selectedVoucherTemp = availableVouchers.find(v => v.id === id);
        }

        function confirmVoucher() {
            if(selectedVoucherTemp) {
                appliedDiscount = selectedVoucherTemp.discount;
                document.getElementById('selectedVoucherText').innerText = `Đã áp dụng: \${selectedVoucherTemp.code}`;
                document.getElementById('selectedVoucherText').style.color = '#ff6600';
            }
            updateTotals();
            closeVoucherModal();
        }

        function applyManualVoucher() {
            alert("Tính năng nhập mã thủ công đang phát triển. Vui lòng chọn mã có sẵn!");
        }

        function submitOrder() {
            if(checkoutCart.length === 0) {
                alert("Giỏ hàng của bạn đang trống!");
                return;
            }

            const form = document.getElementById('checkoutForm');
            
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            prepareOrderData();

            let finalTotal = subTotal - appliedDiscount;
            if(finalTotal < 0) finalTotal = 0;

            document.getElementById('hiddenTotalAmount').value = finalTotal;

            form.action = "processCheckout";
            form.submit();
        }

        document.addEventListener('DOMContentLoaded', loadCheckoutItems);
    </script>
</body>
</html>