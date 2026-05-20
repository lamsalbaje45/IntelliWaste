<% String footerCtx = request.getContextPath(); %>
<style>
  @import url("https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Space+Grotesk:wght@400;500;600;700&display=swap");

  :root {
    --foot-ink: #0b2b22;
    --foot-deep: #0f2f26;
    --foot-leaf: #1f7a5c;
    --foot-river: #1e6aa8;
    --foot-sun: #f7c948;
    --foot-mist: #e6f4ef;
    --foot-white: #ffffff;
  }

  .site-footer {
    font-family: "Space Grotesk", "Segoe UI", sans-serif;
    color: var(--foot-white);
    margin-top: 48px;
    position: relative;
  }
  .site-footer::before {
    content: "";
    position: absolute;
    inset: 0;
    background:
      radial-gradient(
        circle at 15% 15%,
        rgba(247, 201, 72, 0.2) 0%,
        transparent 45%
      ),
      radial-gradient(
        circle at 85% 10%,
        rgba(30, 106, 168, 0.25) 0%,
        transparent 45%
      ),
      linear-gradient(135deg, #0f3d2e 0%, #0b2b22 100%);
    z-index: 0;
  }
  .footer-wrap {
    position: relative;
    z-index: 1;
    padding: 48px 6vw 22px;
    display: grid;
    gap: 28px;
  }
  .footer-top {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 24px;
  }
  .footer-brand h3 {
    font-family: "DM Serif Display", "Space Grotesk", serif;
    font-size: 26px;
    margin: 0 0 10px;
    display: inline-flex;
    align-items: center;
    gap: 10px;
  }
  .footer-logo {
    height: 36px;
    width: 36px;
    object-fit: contain;
    display: block;
  }
  .footer-brand p {
    margin: 0 0 14px;
    color: #d6efe6;
    line-height: 1.6;
  }
  .footer-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.18);
    padding: 6px 12px;
    border-radius: 999px;
    font-weight: 600;
    font-size: 13px;
  }
  .footer-title {
    font-size: 14px;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin: 0 0 12px;
    color: #b6e6d6;
  }
  .footer-links {
    display: grid;
    gap: 8px;
  }
  .footer-links a {
    color: #f5fffb;
    text-decoration: none;
    font-weight: 500;
  }
  .footer-links a:hover {
    color: var(--foot-sun);
  }
  .footer-card {
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid rgba(255, 255, 255, 0.16);
    border-radius: 16px;
    padding: 16px;
    display: grid;
    gap: 10px;
  }
  .footer-card span {
    font-weight: 600;
    color: #f0fff7;
  }
  .footer-card p {
    margin: 0;
    color: #d6efe6;
  }
  .footer-bottom {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    align-items: center;
    justify-content: center;
    border-top: 1px solid rgba(255, 255, 255, 0.14);
    padding-top: 16px;
    color: #d6efe6;
    font-size: 13px;
    text-align: center;
  }
  .footer-social {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
  }
  .footer-social a {
    color: var(--foot-white);
    text-decoration: none;
    padding: 6px 12px;
    border-radius: 999px;
    border: 1px solid rgba(255, 255, 255, 0.18);
    background: rgba(255, 255, 255, 0.1);
    font-weight: 600;
    font-size: 12px;
  }
  .footer-social a:hover {
    color: var(--foot-sun);
    border-color: rgba(247, 201, 72, 0.5);
  }

  @media (max-width: 720px) {
    .footer-wrap {
      padding: 36px 6vw 18px;
    }
    .footer-bottom {
      flex-direction: column;
      align-items: center;
    }
  }
</style>

<footer class="site-footer">
  <div class="footer-wrap">
    <div class="footer-top">
      <div class="footer-brand">
        <h3>
          <img
            class="footer-logo"
            src="<%= footerCtx %>/assets/Logo.png"
            alt="IntelliWaste logo"
          />
          IntelliWaste
        </h3>
        <p>
          Smart waste management for citizens, admins, and field crews. Report
          faster, assign smarter, and keep cities cleaner.
        </p>
        <div class="footer-badge">Trusted city operations hub</div>
      </div>
      <div>
        <h4 class="footer-title">Quick Links</h4>
        <div class="footer-links">
          <a href="<%= footerCtx %>/index.jsp">Home</a>
          <a href="<%= footerCtx %>/views/about.jsp">About</a>
          <a href="<%= footerCtx %>/views/contact.jsp">Contact</a>
          <a href="<%= footerCtx %>/views/login.jsp">Login</a>
          <a href="<%= footerCtx %>/views/register.jsp">Register</a>
          <a href="<%= footerCtx %>/viewReports">View Reports</a>
        </div>
      </div>
      <div>
        <h4 class="footer-title">Dashboards</h4>
        <div class="footer-links">
          <a href="<%= footerCtx %>/views/admin/dashboard.jsp"
            >Admin Dashboard</a
          >
          <a href="<%= footerCtx %>/views/worker/dashboard.jsp"
            >Worker Dashboard</a
          >
          <a href="<%= footerCtx %>/views/user/dashboard.jsp"
            >Citizen Dashboard</a
          >
        </div>
      </div>
      <div class="footer-card">
        <span>Support</span>
        <p>Email: support@intelliwaste.local</p>
        <p>Hotline: +977 9840123483</p>
        <p>Hours: 08:00 - 17:00, Daily</p>
      </div>
    </div>

    <div class="footer-bottom">
      <div>
        &copy; 2026 IntelliWaste &ndash; Smart Waste Management System | Team IntelliWaste
      </div>
    </div>
  </div>
</footer>
