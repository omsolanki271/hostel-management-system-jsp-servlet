<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession sess = request.getSession(false);
    boolean isLogged = (sess != null && (sess.getAttribute("user") != null || sess.getAttribute("admin") != null));
    String role = "";
    if (sess != null) {
        role = (String) sess.getAttribute("role");
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <title>Hostel Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- Your main stylesheet (kept for structure) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Inline animation CSS (augments your main stylesheet) -->
    <style>
        :root{
            --primary:#F97316;
            --primary-hover:#EA580C;
            --yellow:#FACC15;
            --navy:#0F172A;
            --muted:#475569;
            --cream:#FFF7ED;
            --white:#ffffff;
            --glass: rgba(255,255,255,0.6);
        }

        /* Basic reset & typography */
        *{box-sizing:border-box;margin:0;padding:0}
        html,body{height:100%}
        body{
            font-family: "Poppins", "Segoe UI", Arial, sans-serif;
            background: linear-gradient(180deg, var(--cream), #fff 60%);
            color:var(--navy);
            -webkit-font-smoothing:antialiased;
            -moz-osx-font-smoothing:grayscale;
        }
        a{color:inherit;text-decoration:none}
        img{display:block;max-width:100%}

        /* ---------- NAVBAR (enhanced) ---------- */
        .navbar{
            background: rgba(255,255,255,0.86);
            position: sticky;
            top:0;
            z-index:1100;
            box-shadow: 0 6px 20px rgba(15,23,42,0.06);
            backdrop-filter: blur(6px);
            padding:12px 0;
            transition: all .35s ease;
        }
        .navbar.scrolled{backdrop-filter: blur(10px); box-shadow:0 10px 30px rgba(15,23,42,0.08)}
        .nav-wrapper{display:flex;align-items:center;justify-content:space-between}
        .logo{width:44px;height:44px;border-radius:10px;object-fit:cover;box-shadow:0 6px 18px rgba(249,115,22,0.08)}
        .brand-link{display:flex;align-items:center;gap:12px}
        .brand-name{font-size:1.4rem;font-weight:800;color:var(--primary);letter-spacing:.4px}

        /* nav links */
        .nav-links{display:flex;gap:28px;align-items:center}
        .nav-links a{font-weight:600;color:var(--navy);position:relative;padding:6px 0;transition:.25s}
        .nav-links a::after{content:"";position:absolute;left:0;bottom:-6px;height:3px;width:0;background:linear-gradient(90deg,var(--primary),#ff8b3d);border-radius:6px;transition:width .3s}
        .nav-links a:hover::after{width:100%}
        .menu-toggle{display:none;background:none;border:0;font-size:1.3rem;color:var(--navy);cursor:pointer}

        /* auth buttons */
        .auth-buttons{display:flex;gap:10px;align-items:center}
        .btn-primary{background:var(--primary);color:#fff;padding:9px 18px;border-radius:10px;font-weight:700;box-shadow:0 8px 18px rgba(249,115,22,0.12);transition:transform .18s ease,box-shadow .18s}
        .btn-primary:hover{transform:translateY(-3px);box-shadow:0 14px 30px rgba(249,115,22,0.18)}
        .btn-secondary{border:2px solid var(--primary);color:var(--primary);padding:8px 16px;border-radius:10px;font-weight:700;background:transparent}
        .btn-secondary:hover{background:var(--primary);color:#fff}

        /* responsive nav */
        @media (max-width:900px){
            .nav-links{display:none;position:absolute;top:74px;right:20px;background:#fff;padding:18px;border-radius:12px;box-shadow:0 12px 40px rgba(2,6,23,0.12);flex-direction:column;gap:14px;width:220px}
            .nav-links.open{display:flex}
            .menu-toggle{display:block}
            .auth-buttons{display:none}
        }

        /* ---------- HERO (animated) ---------- */
        .hero{position:relative;height:520px;overflow:hidden}
        .hero-image img{width:100%;height:520px;object-fit:cover;transform:scale(1.06);transition:transform 12s linear}
        .hero:hover .hero-image img{transform:scale(1.02)}
        .hero-overlay{position:absolute;inset:0;background:linear-gradient(90deg,rgba(2,6,23,0.55),rgba(2,6,23,0.18));mix-blend-mode:multiply;pointer-events:none}
        .hero-content{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);text-align:center;color:#fff;padding:0 18px;max-width:920px}

        .hero-content h1{
            font-size:2.8rem;line-height:1.02;margin-bottom:12px;font-weight:800;
            opacity:0;transform:translateY(18px) scale(.98);
            animation:heroIn .9s cubic-bezier(.2,.9,.2,1) .2s forwards;
        }
        .hero-content p{
            font-size:1.08rem;color:rgba(255,255,255,0.92);max-width:780px;margin:0 auto 18px;
            opacity:0;transform:translateY(12px);
            animation:heroIn .9s cubic-bezier(.2,.9,.2,1) .35s forwards;
        }
        .hero-buttons{display:flex;gap:12px;justify-content:center;opacity:0;transform:translateY(10px);animation:heroIn .9s cubic-bezier(.2,.9,.2,1) .5s forwards}
        @keyframes heroIn{
            to{opacity:1;transform:translateY(0) scale(1)}
        }

        /* floating shapes */
        .hero .float-shape{position:absolute;border-radius:50%;filter:blur(20px);opacity:.35;pointer-events:none;animation:float 6s ease-in-out infinite}
        .hero .shape-1{width:160px;height:160px;right:6%;top:12%;background:linear-gradient(180deg,var(--primary),#FF9A4D)}
        .hero .shape-2{width:120px;height:120px;left:5%;bottom:12%;background:linear-gradient(180deg,var(--yellow),#FFD86B);animation-duration:7s}
        @keyframes float{0%{transform:translateY(0)}50%{transform:translateY(-18px)}100%{transform:translateY(0)}}

        /* ---------- SECTIONS: reveal (on scroll) ---------- */
        .reveal{opacity:0;transform:translateY(18px) scale(.995);transition:all .8s cubic-bezier(.2,.9,.2,1)}
        .reveal.in{opacity:1;transform:translateY(0) scale(1)}

        .section-title{font-size:1.6rem;color:var(--navy);font-weight:800;margin-bottom:10px}
        .section-desc{color:var(--muted);margin-bottom:18px}

        /* about */
        .about{padding:70px 0}
        .about-flex{display:flex;gap:36px;align-items:center;flex-wrap:wrap}
        .about-image img{border-radius:12px;box-shadow:0 16px 36px rgba(2,6,23,0.06)}
        .about-content .about-text{color:var(--muted);line-height:1.7;margin-bottom:18px}
        .about-points{display:grid;grid-template-columns:repeat(2,1fr);gap:14px}
        .about-points .point{background:#fff;padding:12px 16px;border-radius:12px;display:flex;align-items:center;gap:12px;box-shadow:0 10px 26px rgba(2,6,23,0.04)}
        .about-points .point i{color:var(--primary);font-size:20px}

        /* facilities */
        .facilities{padding:60px 0}
        .facilities-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:22px}
        .facility{background:#fff;padding:22px;border-radius:14px;text-align:center;transition:transform .28s,box-shadow .28s;box-shadow:0 10px 28px rgba(2,6,23,0.04)}
        .facility:hover{transform:translateY(-8px);box-shadow:0 20px 48px rgba(2,6,23,0.08)}
        .facility i{font-size:32px;color:var(--primary);margin-bottom:8px;display:block}

        /* features */
        .features{padding:70px 0}
        .features-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:24px}
        .feature-card{background:#fff;padding:26px;border-radius:16px;box-shadow:0 16px 40px rgba(2,6,23,0.04);transition:transform .28s,box-shadow .28s}
        .feature-card:hover{transform:translateY(-10px);box-shadow:0 28px 64px rgba(2,6,23,0.08)}
        .icon-box{width:64px;height:64px;border-radius:12px;display:flex;align-items:center;justify-content:center;margin-bottom:14px;background:linear-gradient(135deg,var(--yellow),var(--primary));color:var(--navy);font-size:1.5rem}

        /* rooms */
        .rooms{padding:70px 0}
        .rooms-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:22px}
        .room-card{background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 16px 36px rgba(2,6,23,0.06);transition:transform .28s,box-shadow .28s}
        .room-card:hover{transform:translateY(-10px);box-shadow:0 36px 80px rgba(2,6,23,0.10)}
        .room-card img{height:220px;object-fit:cover;transition:transform .6s}
        .room-card:hover img{transform:scale(1.06)}
        .room-body{padding:16px}

        /* gallery */
        .gallery{padding:70px 0}
        .gallery-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px}
        .gallery-item{height:170px;object-fit:cover;border-radius:10px;transition:transform .45s,filter .45s}
        .gallery-item:hover{transform:scale(1.06);filter:brightness(.95);z-index:2}

        /* stats */
        .stats{padding:60px 0;background:transparent}
        .stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:22px}
        .stat-box{background:linear-gradient(180deg,var(--white),#fff);padding:26px;border-radius:14px;box-shadow:0 14px 40px rgba(2,6,23,0.04);text-align:center}
        .stat-number{font-size:2.4rem;font-weight:800;color:var(--navy)}
        .stat-label{color:var(--muted);margin-top:10px}

        /* how it works */
        .how-it-works{padding:70px 0}
        .how-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:22px}
        .how-card{background:#fff;padding:28px;border-radius:16px;text-align:center;box-shadow:0 16px 40px rgba(2,6,23,0.04);transition:transform .28s}
        .how-card:hover{transform:translateY(-10px)}
        .step-circle{width:70px;height:70px;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;background:linear-gradient(135deg,var(--yellow),var(--primary));color:var(--navy);font-weight:800;margin-bottom:12px}

        /* testimonials (auto slider) */
        .testimonials{padding:70px 0}
        .testimonials-grid{position:relative;height:320px;overflow:hidden}
        .testimonial-card{position:absolute;inset:0;padding:30px 26px;border-radius:14px;background:#fff;box-shadow:0 18px 46px rgba(2,6,23,0.06);opacity:0;transform:translateY(18px);transition:all .6s ease}
        .testimonial-card.active{opacity:1;transform:translateY(0)}
        .testimonial-card .stars{color:#F59E0B;margin-bottom:12px}
        .testimonial-card hr{margin:16px 0;border-color:rgba(15,23,42,0.06)}

        .student-info{display:flex;align-items:center;gap:12px}
        .student-photo{width:55px;height:55px;border-radius:50%;object-fit:cover;border:3px solid var(--primary)}

        /* footer */
        .premium-footer{background:var(--navy);color:#fff;padding:60px 0 28px}
        .footer-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:30px}
        .premium-footer h3{color:var(--primary);margin-bottom:8px}
        .premium-footer a{color:#E6EEF8;display:block;margin-bottom:8px}
        .footer-bottom{margin-top:18px;text-align:center;color:#94A3B8}

        /* utility */
        .container{max-width:1200px;margin:0 auto;padding:0 20px}

        /* responsive */
        @media (max-width:1000px){
            .features-grid{grid-template-columns:repeat(2,1fr)}
            .facilities-grid{grid-template-columns:repeat(2,1fr)}
            .rooms-grid{grid-template-columns:repeat(2,1fr)}
            .gallery-grid{grid-template-columns:repeat(2,1fr)}
            .how-grid{grid-template-columns:repeat(1,1fr)}
            .nav-wrapper{gap:12px}
        }
        @media (max-width:700px){
            .features-grid{grid-template-columns:repeat(1,1fr)}
            .hero{height:480px}
            .hero-image img{height:480px;object-position:center}
            .nav-links{right:12px;top:68px}
            .testimonial-card{position:relative;height:auto;opacity:1;transform:none}
            .testimonials-grid{height:auto}
            .footer-grid{grid-template-columns:repeat(1,1fr)}
            .auth-buttons{display:none}
        }

        /* small helper */
        .mt-12{margin-top:12px}
        .mb-8{margin-bottom:8px}
    </style>
</head>

<body>
    <!-- NAV -->
    <header class="navbar" id="siteNavbar">
        <div class="container nav-wrapper">
            <div>
                <a href="#home" class="brand-link">
                    <img src="${pageContext.request.contextPath}/images/logo.jpg" class="logo" alt="Logo" />
                    <span class="brand-name">Hostel</span>
                </a>
            </div>

            <nav class="nav-links" id="navMenu">
                <a href="#home">Home</a>
                <a href="#about">About Us</a>
                <a href="#features">Features</a>
                <a href="#rooms">Rooms</a>
                <a href="#review">Reviews</a>
                <a href="#contact">Contact</a>
            </nav>

            <div class="auth-buttons">
                <% if (isLogged) { %>
                    <a href="<%= "admin".equals(role) ? "admin/dashboard.jsp" : "student/dashboard.jsp" %>"
                        class="btn-primary">Dashboard</a>
                    <a href="<%= "admin".equals(role) ? "admin/logout" : "student/logout" %>" class="btn-secondary">Logout</a>
                <% } else { %>
                    <a href="student/login.jsp" class="btn-primary">Login</a>
                    <a href="student/register.jsp" class="btn-primary">Register</a>
                <% } %>
            </div>

            <button class="menu-toggle" id="menuToggle">
                <i class="fa fa-bars"></i>
            </button>
        </div>
    </header>

    <!-- HERO -->
    <section id="home" class="hero">
        <div class="hero-image">
            <img src="${pageContext.request.contextPath}/images/building.jpg" alt="Hostel Building">
        </div>

        <div class="hero-overlay"></div>

        <!-- decorative floating shapes -->
        <div class="float-shape shape-1" aria-hidden="true"></div>
        <div class="float-shape shape-2" aria-hidden="true"></div>

        <div class="hero-content container">
            <h1>Welcome to Our Hostel</h1>
            <p>Comfortable rooms, secure environment, and a peaceful study atmosphere.</p>

            <div class="hero-buttons">
                <% if (isLogged) { %>
                    <a href="<%= "admin".equals(role) ? "admin/dashboard.jsp" : "student/dashboard.jsp" %>"
                        class="btn-primary">Go to Dashboard</a>
                    <a href="<%= "admin".equals(role) ? "admin/logout" : "student/logout" %>" class="btn-secondary">Logout</a>
                <% } else { %>
                    <a href="student/register.jsp" class="btn-primary">Apply Now</a>
                    <a href="student/login.jsp" class="btn-secondary">Login</a>
                <% } %>
            </div>
        </div>
    </section>

    <!-- ABOUT -->
    <section id="about" class="about reveal">
        <div class="container about-flex">
            <div class="about-content">
                <h2 class="section-title">About Our Hostel</h2>
                <p class="about-text">Our hostel offers a clean, secure, and peaceful living environment ideal for
                    students. With nutritious meals, 24/7 security, study-friendly spaces, and comfortable rooms, we
                    aim to make your stay productive and enjoyable.</p>

                <div class="about-points">
                    <div class="point"><i class="fa-solid fa-bed"></i> Clean & Comfortable Rooms</div>
                    <div class="point"><i class="fa-solid fa-shield-halved"></i> 24/7 Security</div>
                    <div class="point"><i class="fa-solid fa-utensils"></i> Healthy Food</div>
                    <div class="point"><i class="fa-solid fa-book"></i> Study Environment</div>
                </div>
            </div>
        </div>
    </section>

    <!-- FEATURES -->
    <section class="features reveal" id="features">
        <div class="container">
            <h2 class="section-title center">Powerful Features</h2>
            <p class="section-desc center">Everything you need to manage hostel operations efficiently</p>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="icon-box"><i class="fa-solid fa-book-open"></i></div>
                    <h3>Room Booking</h3>
                    <p>Easy and convenient room booking system with real-time availability.</p>
                </div>

                <div class="feature-card">
                    <div class="icon-box"><i class="fa-solid fa-file-lines"></i></div>
                    <h3>Leave Application</h3>
                    <p>Quick leave approval process with instant notifications.</p>
                </div>

                <div class="feature-card">
                    <div class="icon-box"><i class="fa-solid fa-circle-exclamation"></i></div>
                    <h3>Complaint Management</h3>
                    <p>Track and manage complaints with real-time status updates.</p>
                </div>

                <div class="feature-card">
                    <div class="icon-box"><i class="fa-solid fa-chart-line"></i></div>
                    <h3>Attendance & Notices</h3>
                    <p>Monitor attendance records and stay updated with notices.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- FACILITIES -->
    <section id="facilities" class="section facilities reveal">
        <div class="container">
            <h2 class="section-title">Facilities</h2>

            <div class="facilities-grid">
                <div class="facility"><i class="fa-solid fa-wifi"></i>
                    <h4>WiFi</h4>
                </div>
                <div class="facility"><i class="fa-solid fa-shield-halved"></i>
                    <h4>Security</h4>
                </div>
                <div class="facility"><i class="fa-solid fa-utensils"></i>
                    <h4>Mess</h4>
                </div>
                <div class="facility"><i class="fa-solid fa-shirt"></i>
                    <h4>Laundry</h4>
                </div>
                <div class="facility"><i class="fa-solid fa-book"></i>
                    <h4>Study Room</h4>
                </div>
                <div class="facility"><i class="fa-solid fa-car"></i>
                    <h4>Parking</h4>
                </div>
                <div class="facility"><i class="fa-solid fa-water"></i>
                    <h4>Hot Water</h4>
                </div>
                <div class="facility"><i class="fa-solid fa-bed"></i>
                    <h4>Clean Beds</h4>
                </div>
            </div>
        </div>
    </section>

    <!-- HOW IT WORKS -->
    <section class="how-it-works reveal">
        <div class="container">
            <h2 class="section-title center">How It Works</h2>
            <p class="section-desc center">Simple steps to get started with our hostel system</p>

            <div class="how-grid">
                <div class="how-card">
                    <div class="step-circle">1</div>
                    <i class="fa-solid fa-right-to-bracket step-icon"></i>
                    <h3>Register / Login</h3>
                    <p>Create your account or log in with your credentials to get started.</p>
                </div>

                <div class="how-card">
                    <div class="step-circle">2</div>
                    <i class="fa-solid fa-border-all step-icon"></i>
                    <h3>Use Dashboard</h3>
                    <p>Access the dashboard to manage all your hostel activities.</p>
                </div>

                <div class="how-card">
                    <div class="step-circle">3</div>
                    <i class="fa-solid fa-eye step-icon"></i>
                    <h3>Track Everything</h3>
                    <p>Monitor bookings, complaints, leaves, and attendance in real-time.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ROOMS -->
    <section id="rooms" class="section rooms reveal">
        <div class="container">
            <h2 class="section-title">Room Types</h2>

            <div class="rooms-grid">
                <article class="room-card">
                    <img src="${pageContext.request.contextPath}/images/rooms/room-single.jpg" alt="">
                    <div class="room-body">
                        <h3>Single Bed Room</h3>
                        <p>Private room ideal for focused study.</p>
                    </div>
                </article>

                <article class="room-card">
                    <img src="${pageContext.request.contextPath}/images/rooms/room-double.jpg" alt="">
                    <div class="room-body">
                        <h3>Double Bed Room</h3>
                        <p>Spacious shared room with comfortable beds.</p>
                    </div>
                </article>

                <article class="room-card">
                    <img src="${pageContext.request.contextPath}/images/rooms/room-triple.jpg" alt="">
                    <div class="room-body">
                        <h3>Triple Bed Room</h3>
                        <p>Budget-friendly room for three students.</p>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <!-- GALLERY -->
    <section id="gallery" class="section gallery reveal">
        <div class="container">
            <h2 class="section-title">Gallery</h2>

            <div class="gallery-grid">
                <img src="${pageContext.request.contextPath}/images/library.jpg" class="gallery-item" alt="">
                <img src="${pageContext.request.contextPath}/images/building2.jpg" class="gallery-item" alt="">
                <img src="${pageContext.request.contextPath}/images/library2.jpg" class="gallery-item" alt="">
                <img src="${pageContext.request.contextPath}/images/food/eat_time.png" class="gallery-item" alt="">
            </div>
        </div>
    </section>

    <!-- STATISTICS -->
    <section id="stats" class="stats reveal">
        <div class="container stats-grid">
            <div class="stat-box">
                <h3 class="stat-number" data-target="120">0</h3>
                <p class="stat-label">Rooms Available</p>
            </div>

            <div class="stat-box">
                <h3 class="stat-number" data-target="350">0</h3>
                <p class="stat-label">Happy Students</p>
            </div>

            <div class="stat-box">
                <h3 class="stat-number" data-target="10">0</h3>
                <p class="stat-label">Years of Service</p>
            </div>

            <div class="stat-box">
                <h3 class="stat-number" data-target="24">0</h3>
                <p class="stat-label">24/7 Security</p>
            </div>
        </div>
    </section>

    <!-- TESTIMONIALS -->
    <section class="testimonials reveal" id="review">
        <div class="container">
            <h2 class="section-title center">What Students Say</h2>
            <p class="section-desc center">Real feedback from our happy students</p>

            <div class="testimonials-grid">
                <div class="testimonial-card active">
                    <div class="stars">★★★★★</div>
                    <p class="review">"The hostel booking system made everything so easy! Applying for leaves is now
                        super simple."</p>
                    <hr>
                    <div class="student-info">
                        <img src="${pageContext.request.contextPath}/images/review_img/student1.jpg" class="student-photo" alt="">
                        <div>
                            <h4>Rahul Sharma</h4>
                            <small>Student</small>
                        </div>
                    </div>
                </div>

                <div class="testimonial-card">
                    <div class="stars">★★★★★</div>
                    <p class="review">"Complaint tracking is accurate and fast. I always know the status of my
                        submissions!"</p>
                    <hr>
                    <div class="student-info">
                        <img src="${pageContext.request.contextPath}/images/review_img/student2.jpg" class="student-photo" alt="">
                        <div>
                            <h4>Priya Singh</h4>
                            <small>Student</small>
                        </div>
                    </div>
                </div>

                <div class="testimonial-card">
                    <div class="stars">★★★★☆</div>
                    <p class="review">"Attendance and notices are always updated. Very helpful system!"</p>
                    <hr>
                    <div class="student-info">
                        <img src="${pageContext.request.contextPath}/images/review_img/student3.jpg" class="student-photo" alt="">
                        <div>
                            <h4>Arjun Kumar</h4>
                            <small>Student</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer id="contact" class="premium-footer">
        <div class="container footer-grid">
            <div>
                <h3>Hostel</h3>
                <p>Simplifying hostel management for students and administrators worldwide.</p>
            </div>

            <div>
                <h4>Quick Links</h4>
                <a href="#home">Home</a>
                <a href="#about">About</a>
                <a href="#features">Features</a>
                <a href="#contact">Contact</a>
            </div>

            <div>
                <h4>Contact Us</h4>
                <p>📞 +91 98765 54321</p>
                <p>✉ support@hostelease.com</p>
                <p>📍 India</p>
            </div>

            <div>
                <h4>Follow Us</h4>
                <div class="social-links">
                    <i class="fa-brands fa-facebook"></i>
                    <i class="fa-brands fa-twitter"></i>
                    <i class="fa-brands fa-linkedin"></i>
                </div>
            </div>
        </div>

        <hr style="margin: 20px 0; border: 0; border-top: 1px solid rgba(255,255,255,0.1);">

        <p class="footer-bottom">© 2025 HostelEase. All rights reserved.</p>
    </footer>

    <!-- SCRIPTS: menu, reveal, counters, testimonials -->
    <script>
        // MENU TOGGLE
        const menuToggle = document.getElementById("menuToggle");
        const navMenu = document.getElementById("navMenu");
        menuToggle && menuToggle.addEventListener("click", () => navMenu.classList.toggle("open"));

        // NAVBAR SCROLL SHADOW
        const siteNavbar = document.getElementById("siteNavbar");
        window.addEventListener('scroll', () => {
            if (window.scrollY > 30) siteNavbar.classList.add('scrolled');
            else siteNavbar.classList.remove('scrolled');
        });

        // SCROLL REVEAL (IntersectionObserver)
        const reveals = document.querySelectorAll('.reveal');
        const observerOptions = { root: null, rootMargin: '0px', threshold: 0.12 };
        const revealObs = new IntersectionObserver((entries, obs) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('in');
                    obs.unobserve(entry.target);
                }
            });
        }, observerOptions);
        reveals.forEach(r => revealObs.observe(r));

        // COUNTER ANIMATION
        const counters = document.querySelectorAll('.stat-number');
        const counterObserver = new IntersectionObserver((entries, obs) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const el = entry.target;
                    const target = +el.getAttribute('data-target') || 0;
                    const duration = 1600;
                    let start = 0;
                    const step = (timestamp) => {
                        if (!el._startTS) el._startTS = timestamp;
                        const progress = Math.min((timestamp - el._startTS) / duration, 1);
                        el.textContent = Math.floor(progress * target + (target % 1 !== 0 ? 0 : 0));
                        if (progress < 1) window.requestAnimationFrame(step);
                        else el.textContent = target + (el.getAttribute('data-suffix') || '');
                    };
                    window.requestAnimationFrame(step);
                    obs.unobserve(el);
                }
            });
        }, { threshold: 0.2 });
        counters.forEach(c => counterObserver.observe(c));

        // TESTIMONIALS SLIDER (simple fade)
        (function () {
            const slides = document.querySelectorAll('.testimonial-card');
            if (!slides.length) return;
            let idx = 0;
            const show = (i) => {
                slides.forEach((s, j) => s.classList.toggle('active', j === i));
            };
            show(idx);
            setInterval(() => {
                idx = (idx + 1) % slides.length;
                show(idx);
            }, 4500);
        })();

        // PARALLAX HERO IMAGE (subtle)
        const heroImg = document.querySelector('.hero-image img');
        window.addEventListener('scroll', () => {
            if (!heroImg) return;
            const sc = window.scrollY;
            heroImg.style.transform = `translateY(${sc * 0.08}px) scale(1.03)`;
        });

        // Simple accessibility: close nav when clicking outside on mobile
        document.addEventListener('click', (e) => {
            if (!navMenu || !menuToggle) return;
            if (!navMenu.contains(e.target) && !menuToggle.contains(e.target)) {
                navMenu.classList.remove('open');
            }
        });
    </script>
</body>

</html>