<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%
String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html>
  <head>
    <title>IntelliWaste — Smart Waste Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
      @import url("https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Space+Grotesk:wght@400;500;600;700&display=swap");

      :root {
        --ink: #0b2b22;
        --leaf: #1f7a5c;
        --river: #1e6aa8;
        --sun: #f7c948;
        --mist: #e6f4ef;
        --white: #ffffff;
        --shadow: 0 20px 45px rgba(6, 24, 20, 0.18);
      }
      * {
        box-sizing: border-box;
      }
      html {
        overflow-x: hidden;
        background: #ecf7ff;
      }
      body.home-page {
        font-family: "Space Grotesk", "Segoe UI", sans-serif;
        margin: 0;
        color: var(--ink);
        background:
          radial-gradient(circle at 20% 20%, #c2f0dc 0%, transparent 50%),
          radial-gradient(circle at 80% 10%, #b8d8ff 0%, transparent 45%),
          linear-gradient(140deg, #f6fff9 0%, #ecf7ff 100%);
        min-height: 100vh;
        overflow-x: hidden;
        position: relative;
        width: 100%;
      }
      body.home-page::before,
      body.home-page::after {
        content: "";
        position: absolute;
        border-radius: 999px;
        filter: blur(0.5px);
        opacity: 0.45;
        z-index: 0;
      }
      body.home-page::before {
        width: 520px;
        height: 520px;
        top: -180px;
        right: -140px;
        background: radial-gradient(circle, #ffe9b0 0%, transparent 70%);
      }
      body.home-page::after {
        width: 420px;
        height: 420px;
        bottom: 0;
        left: -120px;
        background: radial-gradient(circle, #b8f1d9 0%, transparent 70%);
      }
      .page {
        position: relative;
        z-index: 1;
      }
      .home-page .site-footer {
        margin-top: 32px;
      }
      .hero {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 32px;
        align-items: center;
        padding: 72px 6vw 40px;
      }
      .hero h1 {
        font-family: "DM Serif Display", "Space Grotesk", serif;
        font-size: clamp(36px, 4vw, 56px);
        margin: 0 0 16px;
      }
      .hero p {
        font-size: 18px;
        line-height: 1.6;
        margin: 0 0 22px;
        color: #18463b;
        max-width: 540px;
      }
      .hero-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
      }
      .button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        padding: 12px 22px;
        border-radius: 999px;
        font-weight: 600;
        text-decoration: none;
        border: 1px solid transparent;
        transition:
          transform 0.2s ease,
          box-shadow 0.2s ease;
      }
      .button-primary {
        background: linear-gradient(135deg, var(--leaf) 0%, #1a6e55 100%);
        color: var(--white);
        box-shadow: 0 14px 32px rgba(31, 122, 92, 0.28);
      }
      .button-secondary {
        background: var(--white);
        color: var(--ink);
        border-color: #cfe7dd;
      }
      .button:hover {
        transform: translateY(-2px);
      }
      .hero-card {
        background: var(--white);
        border-radius: 24px;
        padding: 28px;
        box-shadow: var(--shadow);
        border: 1px solid rgba(11, 43, 34, 0.06);
      }
      .hero-card h3 {
        margin: 0 0 10px;
        font-size: 18px;
      }
      .hero-metric {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px 0;
        border-bottom: 1px solid #eef4f1;
        font-weight: 600;
      }
      .hero-metric:last-child {
        border-bottom: none;
      }
      .metric-tag {
        background: var(--mist);
        color: #17664c;
        padding: 4px 10px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
      }
      .section {
        padding: 32px 6vw 64px;
      }
      .section-title {
        font-size: 26px;
        margin: 0 0 20px;
      }
      .grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 18px;
      }
      .card {
        background: var(--white);
        border-radius: 18px;
        padding: 18px;
        border: 1px solid #e6f0ec;
        box-shadow: 0 12px 28px rgba(7, 29, 23, 0.08);
      }
      .card h4 {
        margin: 0 0 8px;
      }
      .steps {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 16px;
      }
      .step {
        background: linear-gradient(145deg, #f7fffc 0%, #e7f4ff 100%);
        border-radius: 18px;
        padding: 18px;
        border: 1px solid #dbeee6;
      }
      .step span {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: var(--sun);
        font-weight: 700;
        margin-bottom: 10px;
      }
      .cta {
        margin: 0 6vw 0;
        background: linear-gradient(120deg, #0f3d2e 0%, #1e6aa8 100%);
        color: var(--white);
        padding: 36px;
        border-radius: 26px;
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
      }
      .cta h2 {
        margin: 0;
        font-size: 28px;
      }
      .cta p {
        margin: 6px 0 0;
        max-width: 520px;
      }

      @media (max-width: 720px) {
        .hero {
          padding: 48px 6vw 32px;
        }
        .cta {
          padding: 28px;
        }
        .home-page .site-footer {
          margin-top: 16px;
        }
      }
    </style>
  </head>
  <body class="home-page">
    <%@ include file="views/navbar.jsp" %>
    <div class="page">
      <section class="hero">
        <div>
          <h1>Smart waste, cleaner cities.</h1>
          <p>
            IntelliWaste connects citizens, admins, and field teams in one
            streamlined hub. Report issues fast, assign crews instantly, and
            track resolution in real time.
          </p>
          <div class="hero-actions">
            <a
              class="button button-primary"
              href="<%= ctx %>/views/register.jsp"
              >Create account</a
            >
            <a class="button button-secondary" href="<%= ctx %>/views/login.jsp"
              >Login</a
            >
          </div>
        </div>
        <div class="hero-card">
          <h3>Live operations pulse</h3>
          <div class="hero-metric">
            <span>Citizen reports</span>
            <span class="metric-tag">Instant</span>
          </div>
          <div class="hero-metric">
            <span>Smart assignment</span>
            <span class="metric-tag">Optimized</span>
          </div>
          <div class="hero-metric">
            <span>Field updates</span>
            <span class="metric-tag">Verified</span>
          </div>
          <div class="hero-metric">
            <span>City dashboards</span>
            <span class="metric-tag">Unified</span>
          </div>
        </div>
      </section>

      <section class="section">
        <h2 class="section-title">Built for every role</h2>
        <div class="grid">
          <div class="card">
            <h4>Citizens</h4>
            <p>Report waste issues in seconds and follow status updates.</p>
          </div>
          <div class="card">
            <h4>Administrators</h4>
            <p>Assign crews, monitor SLAs, and manage categories.</p>
          </div>
          <div class="card">
            <h4>Field teams</h4>
            <p>Receive clear assignments with location and evidence.</p>
          </div>
          <div class="card">
            <h4>Analytics</h4>
            <p>Spot trends, track response time, and improve coverage.</p>
          </div>
        </div>
      </section>

      <section class="section">
        <h2 class="section-title">How it works</h2>
        <div class="steps">
          <div class="step">
            <span>1</span>
            <h4>Report</h4>
            <p>Citizens log issues with category and location.</p>
          </div>
          <div class="step">
            <span>2</span>
            <h4>Assign</h4>
            <p>Admins route tasks to the best available crew.</p>
          </div>
          <div class="step">
            <span>3</span>
            <h4>Resolve</h4>
            <p>Workers complete the job and post proof instantly.</p>
          </div>
        </div>
      </section>

      <section class="cta">
        <div>
          <h2>Ready to keep the city clean?</h2>
          <p>Join IntelliWaste and turn reports into action in minutes.</p>
        </div>
        <a class="button button-secondary" href="<%= ctx %>/views/register.jsp"
          >Get started</a
        >
      </section>
    </div>
    <%@ include file="views/footer.jsp" %>
  </body>
</html>
