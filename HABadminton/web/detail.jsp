<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${detail.tenSP} - HA Badminton</title>
        <link rel="stylesheet" href="css/style.css?v=25">
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
                        <span><i class="fa-solid fa-globe" style="color: #ff6600;"></i> Xuất xứ: <strong>${not empty detail.xuatXu ? detail.xuatXu : 'Đang cập nhật'}</strong></span>
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
                        <button type="button" class="btn-buy-now" 
                                onclick="buyNowAction('${detail.maSP}', '${detail.tenSP}', ${detail.giaBan}, '${detail.hinhAnh}')">
                            Mua ngay
                        </button>
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
                    <button class="tab-link" onclick="openTab(event, 'tab-reviews')">Đánh giá (${empty tongSoDanhGia ? '0' : tongSoDanhGia})</button>
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
                            <c:choose>
                                <c:when test="${not empty detail.thongSo}">
                                    ${detail.thongSo}
                                </c:when>
                                <c:otherwise>
                                    <p><strong>Thông số kỹ thuật đang được cập nhật...</strong></p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="specs-image">
                            <img src="${detail.hinhAnh}" alt="Thông số">
                        </div>
                    </div>
                </div>

                <div id="tab-reviews" class="tab-content">
                    <div class="product-reviews-section" style="padding: 20px; background: #fff; border-radius: 8px;">
                        <div class="reviews-header" style="display: flex; align-items: center; gap: 30px; padding: 20px; background: #fff9f5; border: 1px solid #fbe6d6; border-radius: 8px; margin-bottom: 30px;">
                            <div class="reviews-score" style="text-align: center;">
                                <div style="color: #ff6600; font-size: 32px; font-weight: bold;">
                                    <span style="font-size: 48px;">${not empty diemTrungBinh ? diemTrungBinh : '0.0'}</span>/5
                                </div>
                                <div style="color: #ffcc00; font-size: 20px; margin-top: 5px;">
                                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-regular fa-star"></i>
                                </div>
                            </div>

                            <div class="reviews-filters" style="display: flex; flex-wrap: wrap; gap: 10px; flex: 1;">
                                <button class="filter-btn active" style="padding: 8px 20px; border: 1px solid #ff6600; background: #ff6600; color: #fff; border-radius: 4px; cursor: pointer;">Tất cả (${empty tongSoDanhGia ? '0' : tongSoDanhGia})</button>
                                <button class="filter-btn" style="padding: 8px 20px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer;">5 Sao (${empty sao5 ? '0' : sao5})</button>
                                <button class="filter-btn" style="padding: 8px 20px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer;">4 Sao (${empty sao4 ? '0' : sao4})</button>
                                <button class="filter-btn" style="padding: 8px 20px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer;">3 Sao (${empty sao3 ? '0' : sao3})</button>
                                <button class="filter-btn" style="padding: 8px 20px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer;">2 Sao (${empty sao2 ? '0' : sao2})</button>
                                <button class="filter-btn" style="padding: 8px 20px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer;">1 Sao (${empty sao1 ? '0' : sao1})</button>
                            </div>
                        </div>

                        <div class="reviews-list">
                            <c:choose>
                                <c:when test="${empty listReview}">
                                    <div style="text-align: center; padding: 50px 0; color: #999;">
                                        <i class="fa-solid fa-comment-slash" style="font-size: 40px; margin-bottom: 15px; color: #ccc;"></i>
                                        <p>Hiện chưa có đánh giá nào cho sản phẩm này.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${listReview}" var="rv">
                                <div class="review-card" data-star="${rv.soSao}" style="padding: 25px 0; border-bottom: 1px solid #eee; display: flex; gap: 20px;">
                                    
                                    <!-- AVATAR (HIỂN THỊ ẢNH THẬT, NẾU LỖI TỰ QUAY VỀ ICON) -->
                                    <div class="rv-avatar" style="width: 45px; height: 45px; background: #f1f1f1; border-radius: 50%; overflow: hidden; display: flex; align-items: center; justify-content: center; color: #888; font-size: 18px; flex-shrink: 0;">
                                        <c:choose>
                                            <c:when test="${not empty rv.avatar}">
                                                <img src="${pageContext.request.contextPath}/${rv.avatar}" 
                                                     style="width: 100%; height: 100%; object-fit: cover;" 
                                                     alt="Avatar"
                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                                <i class="fa-solid fa-user" style="display: none;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-user"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="rv-content" style="flex: 1;">
                                        <!-- TÊN KHÁCH HÀNG & ẨN DANH -->
                                        <div class="rv-name" style="font-size: 14px; font-weight: 700; color: #333; margin-bottom: 4px;">
                                            <c:choose>
                                                <c:when test="${rv.anDanh}">
                                                    <span class="user-masked-name" data-full="${rv.tenKhachHang}">Đang tải...</span>
                                                </c:when>
                                                <c:otherwise>${rv.tenKhachHang}</c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="rv-stars" style="color: #ffcc00; font-size: 13px; margin-bottom: 8px;">
                                            <c:forEach begin="1" end="${rv.soSao}"><i class="fa-solid fa-star"></i></c:forEach>
                                            <c:forEach begin="${rv.soSao + 1}" end="5"><i class="fa-regular fa-star"></i></c:forEach>
                                        </div>
                                        
                                        <div class="rv-meta" style="font-size: 13px; color: #999; margin-bottom: 15px;">
                                            <fmt:formatDate value="${rv.ngayDG}" pattern="dd-MM-yyyy HH:mm" /> 
                                            <span style="color: #00a152; margin-left: 10px; font-weight: 500;"><i class="fa-solid fa-circle-check"></i> Đã mua hàng</span>
                                        </div>
                                        
                                        <!-- NỘI DUNG ĐÁNH GIÁ -->
                                        <div class="rv-text" style="font-size: 15px; color: #333; line-height: 1.6; margin-bottom: 15px;">
                                            ${rv.noiDung}
                                        </div>
                                        
                                        <!-- HIỂN THỊ ẢNH VÀ VIDEO -->
                                        <div class="rv-media" style="display: flex; gap: 10px; margin-bottom: 15px; flex-wrap: wrap;">
                                            <c:if test="${not empty rv.hinhAnh}">
                                                <img src="${pageContext.request.contextPath}/${rv.hinhAnh}" onerror="this.src='${rv.hinhAnh}'" style="width: 90px; height: 90px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'" onclick="openLightbox(this.src, 'image')" alt="Ảnh đánh giá">
                                            </c:if>
                                            <c:if test="${not empty rv.video}">
                                                <div style="position: relative; cursor: pointer; width: 90px; height: 90px; transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'" onclick="openLightbox('${pageContext.request.contextPath}/${rv.video}', 'video')">
                                                    <video src="${pageContext.request.contextPath}/${rv.video}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; background: #000;"></video>
                                                    <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: rgba(0,0,0,0.4); border-radius: 6px;">
                                                        <i class="fa-solid fa-play" style="color: white; font-size: 24px; opacity: 0.9;"></i>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                        
                                        <!-- NÚT HỮU ÍCH -->
                                        <div class="rv-actions" style="display: flex; gap: 15px;">
                                            <button class="btn-like" data-liked="false" data-base-count="${rv.soLuotThich}" onclick="likeReview(this, ${rv.maDG})" style="background: none; border: none; color: #888; cursor: pointer; font-size: 14px; padding: 0; display: inline-flex; align-items: center; gap: 6px; transition: 0.2s; font-weight: 500;">
                                                <i class="fa-regular fa-thumbs-up"></i> Hữu ích (${rv.soLuotThich})
                                            </button>
                                        </div>

                                        <!-- KHỐI PHẢN HỒI TỪ ADMIN-->
                                        <c:if test="${not empty rv.phanHoiAdmin}">
                                            <div class="rv-admin-reply" style="background: #f8f9fa; padding: 15px 20px; border-radius: 8px; border-left: 3px solid #ff6600; margin-top: 15px; position: relative;">
                                                <strong style="font-size: 13px; color: #ff6600; display: block; margin-bottom: 5px;">Phản hồi từ Cửa hàng:</strong>
                                                <p style="margin: 0; font-size: 14px; color: #333; line-height: 1.5;">${rv.phanHoiAdmin}</p>
                                            </div>
                                        </c:if>

                                    </div>
                                </div>
                            </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div class="related-products">
                <h2>Sản phẩm tương tự</h2>
                <div class="related-slider-container">
                    <div class="related-slider-track" id="relatedTrack">
                        <c:forEach items="${relatedProducts}" var="rp">
                            <div class="product-card related-card">
                                <div class="product-img">
                                    <a href="detail?id=${rp.maSP}"><img src="${rp.hinhAnh}" alt="${rp.tenSP}"></a>
                                    <a href="detail?id=${rp.maSP}" class="btn-detail">XEM CHI TIẾT</a>
                                </div>
                                <div class="product-info">
                                    <h4>${rp.tenSP}</h4>
                                    <div class="price">
                                        <span class="current-price"><fmt:formatNumber value="${rp.giaBan}" pattern="#,###"/>đ</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <div class="related-dots" id="relatedDots"></div>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>

        <!-- LIGHTBOX MODAL -->
        <div id="mediaLightbox" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10000; background: rgba(0, 0, 0, 0.85); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); justify-content: center; align-items: center; flex-direction: column;">
            <span onclick="closeLightbox()" style="position: absolute; top: 25px; right: 40px; color: white; font-size: 40px; cursor: pointer; z-index: 10001; text-shadow: 0 2px 4px rgba(0,0,0,0.5); transition: color 0.3s;" onmouseover="this.style.color='#ff6600'" onmouseout="this.style.color='white'">&times;</span>
            <div id="lightboxContent" style="max-width: 90%; max-height: 85vh; display: flex; justify-content: center; align-items: center; box-shadow: 0 10px 40px rgba(0,0,0,0.5); border-radius: 8px; overflow: hidden; background: transparent;">
            </div>
        </div>

        <script>
            function buyNowAction(id, name, price, image) {
                let qtyElement = document.getElementById('qtyInput');
                let qty = qtyElement ? qtyElement.value : 1;
                let buyNowItem = [{ id: id, name: name, price: price, image: image, quantity: parseInt(qty) }];
                sessionStorage.setItem('habadminton_buynow', JSON.stringify(buyNowItem));
                window.location.href = "checkout.jsp?buynow=true";
            }

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

            // ĐIỀU KHIỂN NÚT LIKE
            function likeReview(btnElement, reviewId) {
                let isLiked = btnElement.getAttribute('data-liked') === 'true';
                
                let baseCount = parseInt(btnElement.getAttribute('data-base-count'));
                if (isNaN(baseCount)) baseCount = 0;

                if (!isLiked) {
                    btnElement.setAttribute('data-liked', 'true');
                    btnElement.style.color = '#ff6600'; 
                    btnElement.innerHTML = '<i class="fa-solid fa-thumbs-up"></i> Hữu ích (' + (baseCount + 1) + ')';
                } else {
                    btnElement.setAttribute('data-liked', 'false');
                    btnElement.style.color = '#888'; 
                    btnElement.innerHTML = '<i class="fa-regular fa-thumbs-up"></i> Hữu ích (' + baseCount + ')';
                }
            }

            function openLightbox(src, type) {
                const lightbox = document.getElementById('mediaLightbox');
                const content = document.getElementById('lightboxContent');
                
                if (type === 'image') {
                    content.innerHTML = '<img src="' + src + '" style="max-width: 100%; max-height: 85vh; object-fit: contain; display: block;">';
                } else if (type === 'video') {
                    content.innerHTML = '<video src="' + src + '" style="max-width: 100%; max-height: 85vh; display: block;" controls autoplay></video>';
                }
                lightbox.style.display = 'flex';
            }

            function closeLightbox() {
                const lightbox = document.getElementById('mediaLightbox');
                const content = document.getElementById('lightboxContent');
                lightbox.style.display = 'none';
                content.innerHTML = '';
            }

            document.getElementById('mediaLightbox').addEventListener('click', function(e) {
                if (e.target === this) closeLightbox();
            });

            // BỘ LỌC ĐÁNH GIÁ SAO
            document.addEventListener("DOMContentLoaded", function() {
                const filterBtns = document.querySelectorAll('.reviews-filters .filter-btn');
                const reviewCards = document.querySelectorAll('.review-card');

                filterBtns.forEach(btn => {
                    btn.addEventListener('click', function() {
                        filterBtns.forEach(b => {
                            b.classList.remove('active');
                            b.style.background = '#fff';
                            b.style.color = '#333';
                            b.style.borderColor = '#ddd';
                        });
                        this.classList.add('active');
                        this.style.background = '#ff6600';
                        this.style.color = '#fff';
                        this.style.borderColor = '#ff6600';

                        let filterText = this.innerText;
                        let targetStar = "all";
                        if (filterText.includes("5 Sao")) targetStar = "5";
                        else if (filterText.includes("4 Sao")) targetStar = "4";
                        else if (filterText.includes("3 Sao")) targetStar = "3";
                        else if (filterText.includes("2 Sao")) targetStar = "2";
                        else if (filterText.includes("1 Sao")) targetStar = "1";

                        reviewCards.forEach(card => {
                            if (targetStar === "all" || card.getAttribute('data-star') === targetStar) {
                                card.style.display = "flex";
                            } else {
                                card.style.display = "none";
                            }
                        });
                    });
                });
            });
            
            // XỬ LÝ TRƯỢT NGANG RELATED PRODUCTS
            const track = document.getElementById('relatedTrack');
            const dotsContainer = document.getElementById('relatedDots');
            let autoSlideInterval;

            function smoothScrollHorizontal(element, target, duration) {
                element.style.scrollSnapType = 'none'; 
                const start = element.scrollLeft;
                const change = target - start;
                let startTime = null;
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
                        element.scrollLeft = target; 
                        element.style.scrollSnapType = 'x mandatory'; 
                    }
                }
                window.requestAnimationFrame(animateScroll);
            }

            if(track) {
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
            }

            function setupDots() {
                if(!track) return;
                const totalItems = track.children.length;
                if(totalItems <= 4) return; 
                for (let i = 0; i <= totalItems - 4; i++) {
                    let dot = document.createElement('span');
                    dot.classList.add('dot');
                    if (i === 0) dot.classList.add('active');
                    dot.addEventListener('click', () => {
                        const cardWidth = track.querySelector('.related-card').offsetWidth + 20;
                        smoothScrollHorizontal(track, cardWidth * i, 1000); 
                    });
                    dotsContainer.appendChild(dot);
                }
            }

            function autoSlide() {
                if (!track) return;
                const card = track.querySelector('.related-card');
                if (!card) return;
                const scrollAmount = card.offsetWidth + 20;
                let targetScroll = track.scrollLeft + scrollAmount;
                if (track.scrollLeft + track.clientWidth >= track.scrollWidth - 10) {
                    targetScroll = 0;
                }
                smoothScrollHorizontal(track, targetScroll, 1200); 
            }

            function startAutoSlide() {
                if(!track) return;
                const totalItems = track.children.length;
                if (totalItems > 4) { 
                    autoSlideInterval = setInterval(autoSlide, 3500); 
                }
            }

            setupDots();
            startAutoSlide();

            const relatedContainer = document.querySelector('.related-slider-container');
            if (relatedContainer) {
                relatedContainer.addEventListener('mouseenter', () => clearInterval(autoSlideInterval));
                relatedContainer.addEventListener('mouseleave', startAutoSlide);
            }
            
            // TỰ ĐỘNG XỬ LÝ ẨN DANH TÊN NGƯỜI DÙNG KHI LOAD TRANG
            document.addEventListener("DOMContentLoaded", function() {
                document.querySelectorAll('.user-masked-name').forEach(function(span) {
                    let fullName = span.getAttribute('data-full').trim();
                    if(fullName.length > 0) {
                        let firstChar = fullName.charAt(0).toUpperCase();
                        let lastChar = fullName.charAt(fullName.length - 1).toUpperCase();
                        span.innerText = firstChar + "***" + lastChar + " (Ẩn danh)";
                    }
                });
            });
        </script>
    </body>
</html>