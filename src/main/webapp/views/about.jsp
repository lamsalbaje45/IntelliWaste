<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%
String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html>
  <head>
    <title>About - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
      .about-hero {
        margin: 24px 0 18px;
        padding: 28px;
        border-radius: 18px;
        background: linear-gradient(135deg, #e9f7f1 0%, #e6f1ff 100%);
        border: 1px solid #dfeee8;
      }
      .about-hero h1 {
        margin: 0 0 8px;
        font-size: 32px;
        color: #0b2b22;
      }
      .about-hero p {
        margin: 0;
        max-width: 720px;
        line-height: 1.6;
        color: #1f4f41;
      }
      .about-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 16px;
        margin: 24px 0 12px;
      }
      .about-card {
        background: #ffffff;
        border-radius: 14px;
        padding: 18px;
        border: 1px solid #e2eee8;
        box-shadow: 0 10px 22px rgba(9, 32, 24, 0.06);
      }
      .about-card h3 {
        margin: 0 0 8px;
        color: #1f7a5c;
        font-size: 18px;
      }
      .about-card p {
        margin: 0;
        color: #3c564c;
        line-height: 1.6;
      }
      .about-panel {
        margin: 24px 0 40px;
        padding: 22px;
        border-radius: 16px;
        background: #ffffff;
        border: 1px solid #e2eee8;
      }
      .about-panel h2 {
        margin: 0 0 10px;
        color: #0b2b22;
      }
      .about-panel ul {
        margin: 0;
        padding-left: 18px;
        color: #3c564c;
        line-height: 1.7;
      }
      @media (max-width: 720px) {
        .about-hero {
          padding: 20px;
        }
        .about-hero h1 {
          font-size: 28px;
        }
        .about-panel {
          padding: 18px;
        }
      }
    </style>
  </head>
  <body>
    <jsp:include page="navbar.jsp" />
    <div class="container">
      <section class="about-hero">
        <h1>About IntelliWaste</h1>
        <p>
          IntelliWaste is a smart waste management platform built to connect
          citizens, administrators, and field teams. Our goal is to turn reports
          into action quickly, improve accountability, and keep communities
          clean.
        </p>
      </section>

      <section class="about-grid">
        <div class="about-card">
          <h3>Our Institution</h3>
          <p>
            We are dedicated to sustainable city services, combining technology
            and operational workflows to deliver faster waste response.
          </p>
        </div>
        <div class="about-card">
          <h3>Our Mission</h3>
          <p>
            Create a reliable, transparent system that helps citizens report
            issues and empowers teams to resolve them efficiently.
          </p>
        </div>
        <div class="about-card">
          <h3>Our Approach</h3>
          <p>
            We streamline reporting, assignment, and tracking so decisions are
            made with real-time visibility and clear priorities.
          </p>
        </div>
      </section>

      <section class="about-panel">
        <h2>What makes IntelliWaste different</h2>
        <ul>
          <li>Unified dashboards for admins, workers, and citizens.</li>
          <li>
            Fast assignment flow with status tracking and proof of completion.
          </li>
          <li>Actionable insights to improve service coverage over time.</li>
        </ul>
      </section>
    </div>
    <jsp:include page="footer.jsp" />
  </body>
</html>
