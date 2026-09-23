<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh mục Sản phẩm - HA Badminton</title>
        <link rel="stylesheet" href="css/style.css?v=15">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        
        <section class="banner-slider category-mini-banner">
            <div class="slider-track" id="slider-track">
                <img class="slide" src="images/bia1.png" alt="Banner 1">
                <img class="slide" src="images/bia2.png" alt="Banner 2">
            </div>
        </section>

        <div class="container">
            <div class="category-classification" id="product-list-area">
                <h3>Phân loại sản phẩm</h3>
                <button class="class-btn"><i class="fa-solid fa-fire" style="color: #ff3300;"></i> Sản phẩm bán chạy</button>
                <button class="class-btn"><i class="fa-solid fa-tag" style="color: #ff6600;"></i> Sản phẩm mới</button>
                <button class="class-btn"><i class="fa-solid fa-percent" style="color: #cc0000;"></i> Sản phẩm giảm giá</button>
            </div>

            <form action="category" method="GET" id="mainFilterForm">
                <div class="category-layout">
                    
                    <aside class="sidebar-filter">
                        <h2>Bộ lọc</h2> 
                        <input type="hidden" name="id" value="${param.id}">
                        <input type="hidden" name="brandId" value="${param.brandId}">

                        <div class="filter-group">
                            <h4>Chọn mức giá</h4>
                            <label class="radio-item"><input type="radio" name="priceRange" value="0-500000" onchange="this.form.submit()" ${param.priceRange == '0-500000' ? 'checked' : ''}> Giá dưới 500.000đ</label>
                            <label class="radio-item"><input type="radio" name="priceRange" value="500000-1000000" onchange="this.form.submit()" ${param.priceRange == '500000-1000000' ? 'checked' : ''}> 500.000đ - 1 triệu</label>
                            <label class="radio-item"><input type="radio" name="priceRange" value="1000000-2000000" onchange="this.form.submit()" ${param.priceRange == '1000000-2000000' ? 'checked' : ''}> 1 - 2 triệu</label>
                            <label class="radio-item"><input type="radio" name="priceRange" value="2000000-3000000" onchange="this.form.submit()" ${param.priceRange == '2000000-3000000' ? 'checked' : ''}> 2 - 3 triệu</label>
                            <label class="radio-item"><input type="radio" name="priceRange" value="3000000-99999999" onchange="this.form.submit()" ${param.priceRange == '3000000-99999999' ? 'checked' : ''}> Giá trên 3 triệu</label>
                        </div>

                        <div class="filter-group" style="border-top: 1px dashed #ddd;">
                            <h4>Hoặc chọn khoảng giá:</h4>

                            <div class="range-slider-container">
                                <div class="range-progress"></div>
                            </div>

                            <div class="range-input">
                                <input type="range" class="range-min" name="minPrice" min="0" max="10000000" value="${not empty syncMinPrice ? syncMinPrice : '0'}" step="100000">
                                <input type="range" class="range-max" name="maxPrice" min="0" max="10000000" value="${not empty syncMaxPrice ? syncMaxPrice : '10000000'}" step="100000">
                            </div>

                            <div class="price-inputs">
                                <div class="input-wrapper">
                                    <input type="text" class="input-min" placeholder="Từ" readonly>
                                    <span class="currency">đ</span>
                                </div>
                                <span class="separator">-</span>
                                <div class="input-wrapper">
                                    <input type="text" class="input-max" placeholder="Đến" readonly>
                                    <span class="currency">đ</span>
                                </div>
                            </div>

                            <div class="filter-actions">
                                <button type="button" class="btn-reset" onclick="resetFilter()">Đặt lại</button>
                            </div>
                        </div>
                    </aside>

                    <main class="main-products">
                        
                        <!-- GIAO DIỆN MENU CÁC DÒNG SẢN PHẨM TRỰC QUAN -->
                        <c:if test="${empty param.brandId}">
                            <div class="brand-visual-menu">
                                <c:choose>
                                    <c:when test="${param.id == '1'}">
                                        <div class="brand-grid">
                                            <a href="category?id=1&brandId=1" class="brand-card">
                                                <div class="brand-img"><img src="images/Vợt Cầu Lông Yonex Astrox 100ZZ.jpg" onerror="this.src='images/bia1.png'" alt="Yonex"></div>
                                                <div class="brand-title bg-orange">Dòng vợt Yonex</div>
                                            </a>
                                            <a href="category?id=1&brandId=2" class="brand-card">
                                                <div class="brand-img"><img src="images/Vợt Cầu Lông Victor Auraspeed HS Plus.jpg" onerror="this.src='images/bia1.png'" alt="Victor"></div>
                                                <div class="brand-title bg-yellow">Dòng vợt Victor</div>
                                            </a>
                                            <a href="category?id=1&brandId=3" class="brand-card">
                                                <div class="brand-img"><img src="images/Vợt Cầu Lông Lining Axforce 100 Gen 2.jpg" onerror="this.src='images/bia1.png'" alt="Lining"></div>
                                                <div class="brand-title bg-green">Dòng vợt Lining</div>
                                            </a>
                                            <a href="category?id=1&brandId=4" class="brand-card">
                                                <div class="brand-img"><img src="images/vot_vs_icon.png" onerror="this.src='images/bia1.png'" alt="VS"></div>
                                                <div class="brand-title bg-blue">Dòng vợt VS</div>
                                            </a>
                                            <a href="category?id=1&brandId=5" class="brand-card">
                                                <div class="brand-img"><img src="images/vot_mizuno_icon.png" onerror="this.src='images/bia1.png'" alt="Mizuno"></div>
                                                <div class="brand-title bg-purple">Dòng vợt Mizuno</div>
                                            </a>
                                        </div>
                                    </c:when>

                                    <c:when test="${param.id == '2'}">
                                        <div class="brand-grid">
                                            <a href="category?id=2&brandId=1" class="brand-card">
                                                <div class="brand-img"><img src="images/Giày Cầu Lông Yonex 88 Dial 3 Wide 2025.jpg" onerror="this.src='images/bia1.png'" alt="Yonex"></div>
                                                <div class="brand-title bg-orange">Giày Yonex</div>
                                            </a>
                                            <a href="category?id=2&brandId=2" class="brand-card">
                                                <div class="brand-img"><img src="images/Giày Cầu Lông Victor S82 TD BO.jpg" onerror="this.src='images/bia1.png'" alt="Victor"></div>
                                                <div class="brand-title bg-yellow">Giày Victor</div>
                                            </a>
                                            <a href="category?id=2&brandId=3" class="brand-card">
                                                <div class="brand-img"><img src="images/giay_lining_icon.png" onerror="this.src='images/bia1.png'" alt="Lining"></div>
                                                <div class="brand-title bg-green">Giày Lining</div>
                                            </a>
                                            <a href="category?id=2&brandId=6" class="brand-card">
                                                <div class="brand-img"><img src="images/giay_kawasaki_icon.png" onerror="this.src='images/bia1.png'" alt="Kawasaki"></div>
                                                <div class="brand-title bg-blue">Giày Kawasaki</div>
                                            </a>
                                            <a href="category?id=2&brandId=5" class="brand-card">
                                                <div class="brand-img"><img src="images/giay_mizuno_icon.png" onerror="this.src='images/bia1.png'" alt="Mizuno"></div>
                                                <div class="brand-title bg-purple">Giày Mizuno</div>
                                            </a>
                                        </div>
                                    </c:when>

                                    <c:when test="${param.id == '3'}">
                                        <div class="brand-grid">
                                            <a href="category?id=3&brandId=1" class="brand-card">
                                                <div class="brand-img"><img src="images/ao_yonex.png" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-orange">Áo Yonex</div>
                                            </a>
                                            <a href="category?id=3&brandId=7" class="brand-card">
                                                <div class="brand-img"><img src="images/ao_vnb.png" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-yellow">Áo VNB</div>
                                            </a>
                                            <a href="category?id=3&brandId=8" class="brand-card">
                                                <div class="brand-img"><img src="images/ao_kamito.png" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-green">Áo Kamito</div>
                                            </a>
                                            <a href="category?id=3&brandId=4" class="brand-card">
                                                <div class="brand-img"><img src="images/ao_vs.png" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-blue">Áo VS</div>
                                            </a>
                                            <a href="category?id=3&brandId=2" class="brand-card">
                                                <div class="brand-img"><img src="images/ao_victor.png" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-purple">Áo Victor</div>
                                            </a>
                                        </div>
                                    </c:when>
                                    
                                    <c:when test="${param.id == '7'}">
                                        <div class="brand-grid">
                                            <a href="category?id=7&brandId=1" class="brand-card">
                                                <div class="brand-img"><img src="images/Balo C ng Yonex BAG2218.jpg" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-orange">Balo Yonex</div>
                                            </a>
                                            <a href="category?id=7&brandId=2" class="brand-card">
                                                <div class="brand-img"><img src="images/Balo C ng Victor BR3025.jpg" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-yellow">Balo Victor</div>
                                            </a>
                                            <a href="category?id=7&brandId=3" class="brand-card">
                                                <div class="brand-img"><img src="images/Balo c ng Lining Unisex P-ABSW235.jpg" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-green">Balo Lining</div>
                                            </a>
                                            <a href="category?id=7&brandId=4" class="brand-card">
                                                <div class="brand-img"><img src="images/Balo C ng VS BP01.jpg" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-blue">Balo VS</div>
                                            </a>
                                            <a href="category?id=7&brandId=6" class="brand-card">
                                                <div class="brand-img"><img src="images/Balo C ng Kawasaki KBB-8301.jpg" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-purple">Balo Kawasaki</div>
                                            </a>
                                            <a href="category?id=7&brandId=12" class="brand-card">
                                                <div class="brand-img"><img src="images/Balo C ng Flypower Kalasan.jpg" onerror="this.src='images/bia1.png'"></div>
                                                <div class="brand-title bg-pink">Balo Flypower</div>
                                            </a>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </div>
                        </c:if>
                        
                        <div class="product-topbar">
                            <h2>${not empty pageTitle ? pageTitle : 'Dòng sản phẩm'}</h2>
                            <div class="search-sort" style="width: 100%; display: flex; justify-content: space-between;">
                                
                                <div class="search-box">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                    <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm..." value="${param.keyword}">
                                    <button type="submit">Tìm kiếm</button>
                                </div>

                                <div class="sort-box">
                                    Sắp xếp: 
                                    <select name="sort" onchange="this.form.submit()">
                                        <option value="default" ${param.sort == 'default' ? 'selected' : ''}>Mặc định</option>
                                        <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                        <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                                        <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="product-grid">
                            <c:forEach items="${listSP}" var="p">
                                <div class="product-card">
                                    <div class="product-img">
                                        <a href="detail?id=${p.maSP}">
                                            <img src="${p.hinhAnh}" alt="${p.tenSP}">
                                        </a>
                                        <a href="detail?id=${p.maSP}" class="btn-detail">XEM CHI TIẾT</a>
                                    </div>
                                    <div class="product-info">
                                        <h4>${p.tenSP}</h4>
                                        <div class="price">
                                            <span class="current-price">
                                                <fmt:formatNumber value="${p.giaBan}" pattern="#,###"/>đ
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </main>
                    
                </div>
            </form>
        </div>

        <jsp:include page="footer.jsp"></jsp:include> 

        <script>
            // 1. Slider Ảnh 
            const track = document.getElementById('slider-track');
            const slides = document.querySelectorAll('.category-mini-banner .slide');
            let currentIndex = 0;
            setInterval(() => {
                currentIndex = (currentIndex + 1) % slides.length;
                track.style.transform = 'translateX(-' + (currentIndex * 100) + '%)';
            }, 3000);

            // 2. Logic thanh kéo (Slider Range)
            const rangeInput = document.querySelectorAll(".range-input input"),
                  priceInput = document.querySelectorAll(".price-inputs input"),
                  progress = document.querySelector(".range-slider-container .range-progress"),
                  mainForm = document.getElementById("mainFilterForm");
            let priceGap = 100000; 

            function updateProgress() {
                let minVal = parseInt(rangeInput[0].value),
                    maxVal = parseInt(rangeInput[1].value);
                
                progress.style.left = (minVal / rangeInput[0].max) * 100 + "%";
                progress.style.right = 100 - (maxVal / rangeInput[1].max) * 100 + "%";
                
                priceInput[0].value = minVal === 0 ? '' : minVal.toLocaleString('vi-VN');
                priceInput[1].value = maxVal === 10000000 ? '' : maxVal.toLocaleString('vi-VN');
            }

            rangeInput.forEach(input => {
                input.addEventListener("input", e => {
                    let minVal = parseInt(rangeInput[0].value),
                        maxVal = parseInt(rangeInput[1].value);

                    if((maxVal - minVal) < priceGap){
                        if(e.target.className === "range-min") {
                            rangeInput[0].value = maxVal - priceGap;
                        } else {
                            rangeInput[1].value = minVal + priceGap;
                        }
                    } else {
                        updateProgress();
                    }
                });

                input.addEventListener("change", () => {
                    document.querySelectorAll('input[name="priceRange"]').forEach(r => r.checked = false);
                    mainForm.submit();
                });
            });

            if ('scrollRestoration' in history) {
                history.scrollRestoration = 'manual'; 
            }

            function easeInOutQuad(t, b, c, d) {
                t /= d / 2;
                if (t < 1) return c / 2 * t * t + b;
                t--;
                return -c / 2 * (t * (t - 2) - 1) + b;
            }

            function slowScrollTo(targetPosition, duration) {
                const startPosition = window.scrollY;
                const distance = targetPosition - startPosition;
                let startTime = null;

                function animation(currentTime) {
                    if (startTime === null) startTime = currentTime;
                    const timeElapsed = currentTime - startTime;
                    const run = easeInOutQuad(timeElapsed, startPosition, distance, duration);
                    
                    window.scrollTo(0, run);
                    
                    if (timeElapsed < duration) {
                        window.requestAnimationFrame(animation);
                    }
                }
                window.requestAnimationFrame(animation);
            }

            document.addEventListener("DOMContentLoaded", function() {
                const searchParams = window.location.search;
                if (searchParams.includes('priceRange') || searchParams.includes('minPrice') || searchParams.includes('sort') || searchParams.includes('keyword')) {
                    const target = document.getElementById("product-list-area");
                    if (target) {
                        const offsetTop = target.getBoundingClientRect().top + window.scrollY - 90;
                        
                        setTimeout(() => {
                            slowScrollTo(offsetTop, 1500);
                        }, 100); 
                    }
                }
            });

            function resetFilter() {
                const urlParams = new URLSearchParams(window.location.search);
                const categoryId = urlParams.get('id') || '1';
                window.location.href = 'category?id=' + categoryId;
            }

            updateProgress();
        </script>
    </body>
</html>