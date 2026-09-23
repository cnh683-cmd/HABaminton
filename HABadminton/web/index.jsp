<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HA Badminton - Cửa hàng vợt cầu lông</title>
        <link rel="stylesheet" href="css/style.css?v=22">
    </head>
    <body>
        <!-- 0. THANH ĐIỀU HƯỚNG -->
        <jsp:include page="header.jsp"></jsp:include>
        
        <!-- 1. SLIDER -->
        <section class="banner-slider">
            <div class="slider-track" id="slider-track">
                <img class="slide" src="images/bia1.png" alt="Banner 1">
                <img class="slide" src="images/bia2.png" alt="Banner 2">
                <img class="slide" src="images/bia3.png" alt="Banner 3">
            </div>
            
            <button class="slider-btn prev-btn" id="prevBtn"><i class="fa-solid fa-chevron-left"></i></button>
            <button class="slider-btn next-btn" id="nextBtn"><i class="fa-solid fa-chevron-right"></i></button>
            
            <div class="slider-dots" id="slider-dots">
                <span class="dot active" data-index="0"></span>
                <span class="dot" data-index="1"></span>
                <span class="dot" data-index="2"></span>
            </div>
        </section>

        <!-- 2. VỢT CẦU LÔNG  -->
        <section class="product-section container reveal">
            <div class="section-header">
                <h2 class="section-title">Vợt cầu lông</h2>
                <a href="category?id=1" class="view-all-btn">Xem tất cả</a>
            </div>
            <div class="section-content layout-left">
                <div class="category-banner">
                    <a href="category?id=1">
                        <img src="images/bannervot1.png" alt="Banner Vợt">
                    </a>
                </div>
                <div class="product-grid">
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=3"><img src="images/Vợt Cầu Lông Victor Auraspeed HS Plus.jpg" alt="Vợt"></a>
                            <a href="detail?id=3" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Vợt Cầu Lông Victor Auraspeed HS Plus</h4>
                            <div class="price"><span class="current-price">5.230.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=5"><img src="images/Vợt Cầu Lông Lining Axforce 100 Gen 2.jpg" alt="Vợt"></a>
                            <a href="detail?id=5" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Vợt Cầu Lông Lining Axforce 100 Gen 2</h4>
                            <div class="price"><span class="current-price">5.900.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=1"><img src="images/Vợt Cầu Lông Yonex Astrox 100ZZ.jpg" alt="Vợt"></a>
                            <a href="detail?id=1" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Vợt Cầu Lông Yonex Astrox 100ZZ</h4>
                            <div class="price"><span class="current-price">4.065.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=4"><img src="images/Vợt Cầu Lông Victor Thruster Ryuga II.jpg" alt="Vợt"></a>
                            <a href="detail?id=4" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Vợt Cầu Lông Victor Thruster Ryuga II</h4>
                            <div class="price"><span class="current-price">3.950.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=6"><img src="images/Vợt Cầu Lông Lining Halbertec 8000.jpg" alt="Vợt"></a>
                            <a href="detail?id=6" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Vợt Cầu Lông Lining Halbertec 8000</h4>
                            <div class="price"><span class="current-price">4.500.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=8"><img src="images/Vợt Cầu Lông VS Youlong.jpg" alt="Vợt"></a>
                            <a href="detail?id=8" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Vợt Cầu Lông VS Youlong</h4>
                            <div class="price"><span class="current-price">1.350.000đ</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 3. GIÀY CẦU LÔNG -->
        <section class="product-section container reveal">
            <div class="section-header">
                <h2 class="section-title">Giày cầu lông</h2>
                <a href="category?id=2" class="view-all-btn">Xem tất cả</a>
            </div>
            <div class="section-content layout-right">
                <div class="category-banner">
                    <a href="category?id=2">
                        <img src="images/bannergiay1.png" alt="Banner Giày"/>
                    </a>
                </div>
                <div class="product-grid">
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=11"><img src="images/Giày Cầu Lông Yonex 88 Dial 3 Wide 2025.jpg" alt="Giày"></a>
                            <a href="detail?id=11" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Giày Cầu Lông Yonex 88 Dial 3 Wide 2025</h4>
                            <div class="price"><span class="current-price">3.059.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=13"><img src="images/Giày Cầu Lông Victor S82 TD BO.jpg" alt="Giày"></a>
                            <a href="detail?id=13" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Giày Cầu Lông Victor S82 TD BO</h4>
                            <div class="price"><span class="current-price">1.200.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=15"><img src="images/Giày Cầu Lông Lining Cloud Ace.jpg" alt="Giày"></a>
                            <a href="detail?id=15" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Giày Cầu Lông Lining Cloud Ace</h4>
                            <div class="price"><span class="current-price">1.550.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=17"><img src="images/Giày Cầu Lông Kawasaki K086.jpg" alt="Giày"></a>
                            <a href="detail?id=17" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Giày Cầu Lông Kawasaki K086</h4>
                            <div class="price"><span class="current-price">750.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=19"><img src="images/Giày Cầu Lông Mizuno Wave Fang.jpg" alt="Giày"></a>
                            <a href="detail?id=19" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Giày Cầu Lông Mizuno Wave Fang</h4>
                            <div class="price"><span class="current-price">2.900.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=20"><img src="images/Giày Cầu Lông Mizuno Wave Claw 2.jpg" alt="Giày"></a>
                            <a href="detail?id=20" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Giày Cầu Lông Mizuno Wave Claw 2</h4>
                            <div class="price"><span class="current-price">2.750.000đ</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 4. BALO CẦU LÔNG -->
        <section class="product-section container reveal">
            <div class="section-header">
                <h2 class="section-title">Balo cầu lông</h2>
                <a href="category?id=7" class="view-all-btn">Xem tất cả</a>
            </div>
            <div class="section-content layout-left">
                <div class="category-banner">
                    <a href="category?id=7">
                        <img src="images/bannerbalo1.png" alt="Banner Balo">
                    </a>
                </div>
                <div class="product-grid">
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=57"><img src="images/Balo Cầu Lông Yonex BAG926B0212Z.jpg" alt="Balo"></a>
                            <a href="detail?id=57" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Balo Cầu Lông Yonex BAG926B0212Z</h4>
                            <div class="price"><span class="current-price">889.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=61"><img src="images/Balo Cầu Lông Victor BR5043.jpg" alt="Balo"></a>
                            <a href="detail?id=61" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Balo Cầu Lông Victor BR5043</h4>
                            <div class="price"><span class="current-price">1.050.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=59"><img src="images/Balo Cầu Lông VS BP01.jpg" alt="Balo"></a>
                            <a href="detail?id=59" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Balo Cầu Lông VS BP01</h4>
                            <div class="price"><span class="current-price">450.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=63"><img src="images/Balo Cầu Lông Kawasaki KBB-8301.jpg" alt="Balo"></a>
                            <a href="detail?id=63" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Balo Cầu Lông Kawasaki KBB-8301</h4>
                            <div class="price"><span class="current-price">600.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=65"><img src="images/Balo Cầu Lông Flypower Mutiara.jpg" alt="Balo"></a>
                            <a href="detail?id=65" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Balo Cầu Lông Flypower Mutiara</h4>
                            <div class="price"><span class="current-price">700.000đ</span></div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-img">
                            <a href="detail?id=58"><img src="images/Balo Cầu Lông Yonex BAG2218.jpg" alt="Balo"></a>
                            <a href="detail?id=58" class="btn-detail">XEM CHI TIẾT</a>
                        </div>
                        <div class="product-info">
                            <h4>Balo Cầu Lông Yonex BAG2218</h4>
                            <div class="price"><span class="current-price">1.200.000đ</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <jsp:include page="footer.jsp"></jsp:include>

        <script>
            // 1. Logic cho Slider Banner ngang
            const track = document.getElementById('slider-track');
            const slides = document.querySelectorAll('.slide');
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            const dots = document.querySelectorAll('.dot');
            
            let currentIndex = 0;
            let autoSlideInterval;

            function updateSlider(index) {
                if (index < 0) {
                    currentIndex = slides.length - 1;
                } else if (index >= slides.length) {
                    currentIndex = 0;
                } else {
                    currentIndex = index;
                }
                
                track.style.transform = 'translateX(-' + (currentIndex * 100) + '%)';
                
                dots.forEach(dot => dot.classList.remove('active'));
                if(dots[currentIndex]) {
                    dots[currentIndex].classList.add('active');
                }
            }

            nextBtn.addEventListener('click', () => {
                updateSlider(currentIndex + 1);
                resetAutoSlide();
            });

            prevBtn.addEventListener('click', () => {
                updateSlider(currentIndex - 1);
                resetAutoSlide();
            });

            dots.forEach((dot, index) => {
                dot.addEventListener('click', () => {
                    updateSlider(index);
                    resetAutoSlide();
                });
            });

            function startAutoSlide() {
                autoSlideInterval = setInterval(() => {
                    updateSlider(currentIndex + 1);
                }, 3000); 
            }

            function resetAutoSlide() {
                clearInterval(autoSlideInterval);
                startAutoSlide();
            }

            startAutoSlide();

            document.addEventListener("DOMContentLoaded", function() {
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('active');
                           
                        }
                    });
                }, { threshold: 0.15 }); 

                const hiddenElements = document.querySelectorAll('.reveal');
                hiddenElements.forEach((el) => observer.observe(el));
            });
        </script>
    </body>
</html>