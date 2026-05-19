<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    boolean submitted = "POST".equalsIgnoreCase(request.getMethod());
%>
<!DOCTYPE html>
<html>
  <head>
    <title>Contact - IntelliWaste</title>
    <style>
      .contact-hero {
        margin: 24px 0 18px;
        padding: 24px;
        border-radius: 18px;
        background: linear-gradient(135deg, #e9f7f1 0%, #e6f1ff 100%);
        border: 1px solid #dfeee8;
      }
      .contact-hero h1 { margin: 0 0 6px; color: #0b2b22; font-size: 30px; }
      .contact-hero p { margin: 0; color: #1f4f41; line-height: 1.6; }
      .contact-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 16px;
        margin: 24px 0;
      }
      .contact-card {
        background: #ffffff;
        border-radius: 14px;
        padding: 16px;
        border: 1px solid #e2eee8;
      }
      .contact-card h3 { margin: 0 0 6px; color: #1f7a5c; font-size: 16px; }
      .contact-card p { margin: 0; color: #3c564c; }
      .contact-form {
        background: #ffffff;
        border-radius: 16px;
        padding: 22px;
        border: 1px solid #e2eee8;
        margin-bottom: 40px;
      }
      .contact-form label { display: block; font-weight: 600; margin: 8px 0 6px; }
      .contact-form input,
      .contact-form textarea {
        width: 100%;
        border: 1px solid #cfded8;
        border-radius: 8px;
        padding: 10px;
        font-family: inherit;
        box-sizing: border-box;
      }
      .contact-form textarea { resize: vertical; min-height: 120px; }
      .contact-form button {
        margin-top: 12px;
        background: #1f7a5c;
        color: #ffffff;
        border: none;
        border-radius: 999px;
        padding: 10px 20px;
        cursor: pointer;
        font-weight: 600;
      }
      .contact-success {
        background: #d3f9d8;
        color: #1f6b4f;
        padding: 12px;
        border-radius: 8px;
        margin-bottom: 12px;
      }
      @media (max-width: 720px) {
        .contact-hero { padding: 20px; }
      }
    </style>
  </head>
  <body>
    <jsp:include page="navbar.jsp" />
    <div class="container">
      <section class="contact-hero">
        <h1>Contact & Support</h1>
        <p>Need help or want to share feedback? Our team is here for you.</p>
      </section>

      <section class="contact-grid">
        <div class="contact-card">
          <h3>Support Email</h3>
          <p>support@intelliwaste.local</p>
        </div>
        <div class="contact-card">
          <h3>Hotline</h3>
          <p>+977 9840123483</p>
        </div>
        <div class="contact-card">
          <h3>Working Hours</h3>
          <p>08:00 - 17:00, Daily</p>
        </div>
      </section>

      <section class="contact-form">
        <h2>Send us a message</h2>
        <% if (submitted) { %>
          <div class="contact-success">Thanks for reaching out. We will respond soon.</div>
        <% } %>
        <form action="<%= ctx %>/views/contact.jsp" method="post">
          <label for="name">Full Name</label>
          <input id="name" name="name" type="text" required />

          <label for="email">Email</label>
          <input id="email" name="email" type="email" required />

          <label for="message">Message</label>
          <textarea id="message" name="message" required></textarea>

          <button type="submit">Send Message</button>
        </form>
      </section>
    </div>
    <jsp:include page="footer.jsp" />
  </body>
</html>
