<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${detail.tenSP} - HA Badminton</title>
        <link rel="stylesheet" href="css/style.css?v=21">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>

        <div class="container product-detail-page">
            <div class="detail-top">
                <div class="detail-image-gallery">
                    <div class="main-image-box">
                        <img id="mainImage" src="${detail.hinhAnh}" alt="${detail.tenSP}">
                    </div>
                    <div class="thumbnail-list">
                        <img class="thumb active" src="${detail.hinhAnh}" onclick="changeImage(this)">
                        <img class="thumb" src="${detail.hinhAnh}" onclick="changeImage(this)">
                        <img class="thumb" src="${detail.hinhAnh}" onclick="changeImage(this)">
                    </div>
                </div>

                <div class="detail-info">
                    <h1 class="product-title">${detail.tenSP}</h1>
                    
                    <c:if test="${detail.banChay}">
                        <div class="badge-bestseller"><i class="fa-solid fa-trophy"></i> BÁN CHẠY</div>
                    </c:if>
                    
                    <div class="product-meta">
                        <span><i class="fa-solid fa-globe" style="color: #ff6600;"></i> Xuất xứ: <strong>Đang cập nhật</strong></span>
                        <span><i class="fa-solid fa-box-open" style="color: #ff6600;"></i> Tình trạng: <span class="status-instock"><i class="fa-regular fa-circle-check"></i> Còn hàng</span></span>
                    </div>

                    <div class="product-price-box">
                        <span class="current-price"><fmt:formatNumber value="${detail.giaBan}" pattern="#,###"/>đ</span>
                        <c:if test="${not empty discountPercent && discountPercent > 0}">
                            <span class="discount-percent">-${discountPercent}%</span>
                            <span class="old-price"><fmt:formatNumber value="${detail.giaGoc}" pattern="#,###"/>đ</span>
                        </c:if>
                    </div>

                    <div class="quantity-area">
                        <span class="qty-label">Số lượng:</span>
                        <div class="qty-selector">
                            <button type="button" onclick="decreaseQty()">-</button>
                            <input type="text" id="qtyInput" value="1" readonly>
                            <button type="button" onclick="increaseQty()">+</button>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <button type="button" class="btn-add-cart" 
                                onclick="addToCart('${detail.maSP}', '${detail.tenSP}', ${detail.giaBan}, '${detail.hinhAnh}', document.getElementById('qtyInput').value)">
                            Thêm vào giỏ
                        </button>
                        <button type="button" class="btn-buy-now">Mua ngay</button>
                    </div>

                    <div class="offer-box">
                        <h4>Ưu đãi</h4>
                        <ul>
                            <li><i class="fa-solid fa-truck-fast" style="color: #002347;"></i> Nhận hàng - kiểm tra - rồi mới thanh toán</li>
                            <li><i class="fa-solid fa-shield-halved" style="color: #0088ff;"></i> Bảo hành 1 đổi 1 trong 90 ngày</li>
                            <li><i class="fa-solid fa-coins" style="color: #ffcc00;"></i> Tích điểm đổi quà, tiền mặt từ các đơn hàng tiếp theo.</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="detail-tabs-section">
                <div class="tab-headers">
                    <button class="tab-link active" onclick="openTab(event, 'tab-desc')">Mô tả sản phẩm</button>
                    <button class="tab-link" onclick="openTab(event, 'tab-specs')">Thông số kỹ thuật</button>
                    <button class="tab-link" onclick="openTab(event, 'tab-reviews')">Đánh giá <span class="review-count">0 <i class="fa-solid fa-star"></i></span></button>
                </div>

                <div id="tab-desc" class="tab-content active">
                    <c:choose>
                        <c:when test="${not empty detail.moTa}">
                            <p>${detail.moTa}</p>
                        </c:when>
                        <c:otherwise>
                            <p>Đang cập nhật mô tả chi tiết cho sản phẩm này.</p>
                        </c:otherwise>
                    </c:choose>
                    <div style="text-align: center; margin: 20px 0;">
                        <img src="${detail.hinhAnh}" style="max-width: 600px; border-radius: 8px;">
                    </div>
                </div>

                <div id="tab-video" class="tab-content">
                    <p style="text-align:center; padding: 50px; color:#666;">Chưa có video review cho sản phẩm này.</p>
                </div>

                <div id="tab-specs" class="tab-content">
                    <div class="specs-layout">
                        <div class="specs-text">
                            <p><strong>Thông số kỹ thuật đang được cập nhật...</strong></p>
                        </div>
                        <div class="specs-image">
                            <img src="${detail.hinhAnh}" alt="Thông số">
                        </div>
                    </div>
                </div>

                <div id="tab-reviews" class="tab-content">
                    <div class="review-summary">
                        <div class="review-score">
                            <span class="score-number">0</span><span class="score-max">/5</span>
                        </div>
                        <div class="review-filters">
                            <button class="filter-btn active">Tất cả</button>
                            <button class="filter-btn">5 sao</button>
                            <button class="filter-btn">4 sao</button>
                            <button class="filter-btn">3 sao</button>
                            <button class="filter-btn">2 sao</button>
                            <button class="filter-btn">1 sao</button>
                        </div>
                        <div class="review-login-prompt">
                            Bạn đã mua sản phẩm này? <strong>Để lại đánh giá</strong>
                        </div>
                    </div>

                    <div class="review-empty">
                        <h4>Chưa có đánh giá</h4>
                        <p>Hiện chưa có đánh giá nào cho sản phẩm này.</p>
                        <i class="fa-solid fa-comment-slash" style="font-size: 50px; color: #ccc; margin-top: 15px;"></i>
                    </div>

                    <div class="review-form-area">
                        <h3>Đánh giá sản phẩm</h3>
                        <p>Hãy chia sẻ những điều bạn nghĩ về sản phẩm này với những người mua khác nhé.</p>
                        
                        <div class="form-rating">
                            <span>Chất lượng sản phẩm</span>
                            <div class="stars" id="rating-stars">
                                <i class="fa-solid fa-star" data-val="1"></i>
                                <i class="fa-solid fa-star" data-val="2"></i>
                                <i class="fa-solid fa-star" data-val="3"></i>
                                <i class="fa-solid fa-star" data-val="4"></i>
                                <i class="fa-solid fa-star" data-val="5"></i>
                            </div>
                        </div>

                        <div class="form-inputs">
                            <div class="input-group">
                                <label>Họ và tên *</label>
                                <input type="text" placeholder="Nhập họ tên của bạn">
                            </div>
                            <div class="input-group">
                                <label>Email *</label>
                                <input type="email" placeholder="Nhập email của bạn">
                            </div>
                        </div>

                        <div class="input-group" style="margin-top: 15px;">
                            <label>Đánh giá của bạn *</label>
                            <textarea rows="4" placeholder="Nhập nội dung đánh giá..."></textarea>
                        </div>

                        <div class="form-footer">
                            <label class="anonymous-toggle">
                                <input type="checkbox">
                                <span class="slider"></span>
                                Ẩn danh
                            </label>
                            <button type="button" class="btn-submit-review">Gửi ngay</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. KHỐI SẢN PHẨM TƯƠNG TỰ (TRƯỢT BẰNG THANH GẠCH NGANG) -->
            <div class="related-products">
                <h2>Sản phẩm tương tự</h2>
                
                <div class="related-slider-container">
                    <div class="related-slider-track" id="relatedTrack">
                        <c:forEach items="${relatedProducts}" var="rp">
                            <div class="product-card related-card">
                                <div class="product-img">
                                    <a href="detail?id=${rp.maSP}">
                                        <img src="${rp.hinhAnh}" alt="${rp.tenSP}">
                                    </a>
                                    <a href="detail?id=${rp.maSP}" class="btn-detail">XEM CHI TIẾT</a>
                                </div>
                                <div class="product-info">
                                    <h4>${rp.tenSP}</h4>
                                    <div class="price">
                                        <span class="current-price">
                                            <fmt:formatNumber value="${rp.giaBan}" pattern="#,###"/>đ
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Thanh gạch ngang hiển thị tiến trình cuộn -->
                <div class="related-dots" id="relatedDots"></div>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>

        <script>
            function changeImage(element) {
                document.getElementById('mainImage').src = element.src;
                document.querySelectorAll('.thumbnail-list .thumb').forEach(th => th.classList.remove('active'));
                element.classList.add('active');
            }

            function increaseQty() {
                let input = document.getElementById('qtyInput');
                input.value = parseInt(input.value) + 1;
            }
            function decreaseQty() {
                let input = document.getElementById('qtyInput');
                if (parseInt(input.value) > 1) {
                    input.value = parseInt(input.value) - 1;
                }
            }

            function openTab(evt, tabId) {
                let tabContents = document.querySelectorAll('.tab-content');
                tabContents.forEach(tab => tab.classList.remove('active'));
                
                let tabLinks = document.querySelectorAll('.tab-link');
                tabLinks.forEach(link => link.classList.remove('active'));
                
                document.getElementById(tabId).classList.add('active');
                evt.currentTarget.classList.add('active');
            }

            const stars = document.querySelectorAll('#rating-stars i');
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    let val = this.getAttribute('data-val');
                    stars.forEach(s => {
                        if(s.getAttribute('data-val') <= val) {
                            s.classList.add('active');
                        } else {
                            s.classList.remove('active');
                        }
                    });
                });
            });

            // ==========================================
            // LOGIC TRƯỢT NGANG VÀ THANH GẠCH CHO SẢN PHẨM TƯƠNG TỰ (CHẬM VÀ MƯỢT)
            // ==========================================
            const track = document.getElementById('relatedTrack');
            const dotsContainer = document.getElementById('relatedDots');
            let autoSlideInterval;

            // 1. Hàm trượt có thể điều chỉnh thời gian (Custom Smooth Scroll)
            function smoothScrollHorizontal(element, target, duration) {
                element.style.scrollSnapType = 'none'; // Tạm tắt snap để không bị khựng
                const start = element.scrollLeft;
                const change = target - start;
                let startTime = null;

                // Hàm gia tốc chuyển động mượt mà (Chậm ở 2 đầu, nhanh ở giữa)
                function easeInOutQuad(t, b, c, d) {
                    t /= d / 2;
                    if (t < 1) return c / 2 * t * t + b;
                    t--;
                    return -c / 2 * (t * (t - 2) - 1) + b;
                }

                function animateScroll(currentTime) {
                    if (startTime === null) startTime = currentTime;
                    const timeElapsed = currentTime - startTime;
                    const run = easeInOutQuad(timeElapsed, start, change, duration);
                    
                    element.scrollLeft = run;
                    
                    if (timeElapsed < duration) {
                        window.requestAnimationFrame(animateScroll);
                    } else {
                        element.scrollLeft = target; // Ép về đích chính xác
                        element.style.scrollSnapType = 'x mandatory'; // Bật lại snap
                    }
                }
                window.requestAnimationFrame(animateScroll);
            }

            // 2. Kéo thả bằng chuột (Mouse Dragging)
            let isDown = false;
            let startX;
            let scrollLeft;

            track.addEventListener('mousedown', (e) => {
                isDown = true;
                track.classList.add('dragging');
                startX = e.pageX - track.offsetLeft;
                scrollLeft = track.scrollLeft;
                track.style.scrollSnapType = 'none'; 
            });

            track.addEventListener('mouseleave', () => {
                isDown = false;
                track.classList.remove('dragging');
                track.style.scrollSnapType = 'x mandatory'; 
            });

            track.addEventListener('mouseup', () => {
                isDown = false;
                track.classList.remove('dragging');
                track.style.scrollSnapType = 'x mandatory'; 
            });

            track.addEventListener('mousemove', (e) => {
                if (!isDown) return;
                e.preventDefault();
                const x = e.pageX - track.offsetLeft;
                const walk = (x - startX) * 1.5; 
                track.scrollLeft = scrollLeft - walk;
            });

            // 3. Tạo thanh gạch ngang (dots)
            function setupDots() {
                const totalItems = track.children.length;
                if(totalItems <= 4) return; 

                for (let i = 0; i <= totalItems - 4; i++) {
                    let dot = document.createElement('span');
                    dot.classList.add('dot');
                    if (i === 0) dot.classList.add('active');
                    
                    dot.addEventListener('click', () => {
                        const cardWidth = track.querySelector('.related-card').offsetWidth + 20;
                        // Trượt trong 1000ms (1 giây) khi bấm vào gạch ngang
                        smoothScrollHorizontal(track, cardWidth * i, 1000); 
                    });
                    
                    dotsContainer.appendChild(dot);
                }
            }

            // 4. Đồng bộ màu thanh gạch khi trượt
            track.addEventListener('scroll', () => {
                const scrollPercentage = track.scrollLeft / (track.scrollWidth - track.clientWidth);
                const dots = document.querySelectorAll('.related-dots .dot');
                if(dots.length > 0) {
                    let activeIndex = Math.round(scrollPercentage * (dots.length - 1));
                    if (activeIndex < 0) activeIndex = 0;
                    if (activeIndex >= dots.length) activeIndex = dots.length - 1;
                    
                    dots.forEach((dot, index) => {
                        dot.classList.toggle('active', index === activeIndex);
                    });
                }
            });

            // 5. Trượt tự động êm ái
            function autoSlide() {
                if (!track) return;
                const card = track.querySelector('.related-card');
                if (!card) return;
                
                const scrollAmount = card.offsetWidth + 20;
                let targetScroll = track.scrollLeft + scrollAmount;

                // Nếu chạm tới cuối cùng thì cuộn mượt mà về đầu trang
                if (track.scrollLeft + track.clientWidth >= track.scrollWidth - 10) {
                    targetScroll = 0;
                }
                
                // Set thời gian trượt là 1200ms (1.2 giây) để tạo cảm giác chậm rãi lướt qua
                smoothScrollHorizontal(track, targetScroll, 1200); 
            }

            function startAutoSlide() {
                const totalItems = track.children.length;
                if (totalItems > 4) { 
                    autoSlideInterval = setInterval(autoSlide, 3500); // Đợi 3.5 giây rồi trượt tiếp
                }
            }

            // Khởi chạy
            setupDots();
            startAutoSlide();

            // Tạm dừng khi hover
            const relatedContainer = document.querySelector('.related-slider-container');
            if (relatedContainer) {
                relatedContainer.addEventListener('mouseenter', () => clearInterval(autoSlideInterval));
                relatedContainer.addEventListener('mouseleave', startAutoSlide);
            }
        </script>
    </body>
</html>