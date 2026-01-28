const functions = require("firebase-functions");
const nodemailer = require("nodemailer");
const { logger } = require("firebase-functions");

// Configure email transporter
// For production, use environment config
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: functions.config().email?.user || process.env.EMAIL_USER,
    pass: functions.config().email?.password || process.env.EMAIL_PASSWORD,
  },
});

/**
 * Send verification email to new users
 */
exports.sendVerificationEmail = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
  }

  const { email, displayName } = data;

  if (!email) {
    throw new functions.https.HttpsError("invalid-argument", "Email is required");
  }

  try {
    const mailOptions = {
      from: `"Rigoo Marine" <${functions.config().email?.user || "noreply@rigoomarine.com"}>`,
      to: email,
      subject: "Verify Your Email - Rigoo Marine",
      html: `
        <!DOCTYPE html>
        <html>
          <head>
            <style>
              body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
              .container { max-width: 600px; margin: 0 auto; padding: 20px; }
              .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                        color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
              .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
              .button { display: inline-block; padding: 12px 30px; background: #667eea; 
                       color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }
              .footer { text-align: center; margin-top: 20px; color: #888; font-size: 12px; }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="header">
                <h1>🚤 Rigoo Marine</h1>
                <p>Welcome Aboard!</p>
              </div>
              <div class="content">
                <h2>Hi ${displayName || "there"}!</h2>
                <p>Thank you for joining Rigoo Marine, your premier marine marketplace.</p>
                <p>Please verify your email address to get started.</p>
                <a href="${context.auth.token.email_verified}" class="button">Verify Email</a>
                <p>If the button doesn't work, copy and paste this link into your browser:</p>
                <p style="word-break: break-all; color: #667eea;">${context.auth.token.email_verified}</p>
              </div>
              <div class="footer">
                <p>© ${new Date().getFullYear()} Rigoo Marine. All rights reserved.</p>
              </div>
            </div>
          </body>
        </html>
      `,
    };

    await transporter.sendMail(mailOptions);
    logger.info(`Verification email sent to: ${email}`);

    return { success: true, message: "Verification email sent" };
  } catch (error) {
    logger.error("Error sending verification email:", error);
    throw new functions.https.HttpsError("internal", "Failed to send email");
  }
});

/**
 * Send welcome email to verified users
 */
exports.sendWelcomeEmail = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
  }

  const { email, displayName } = data;

  if (!email) {
    throw new functions.https.HttpsError("invalid-argument", "Email is required");
  }

  try {
    const mailOptions = {
      from: `"Rigoo Marine" <${functions.config().email?.user || "noreply@rigoomarine.com"}>`,
      to: email,
      subject: "Welcome to Rigoo Marine! 🚤",
      html: `
        <!DOCTYPE html>
        <html>
          <head>
            <style>
              body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
              .container { max-width: 600px; margin: 0 auto; padding: 20px; }
              .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                        color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
              .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
              .feature { background: white; padding: 15px; margin: 10px 0; border-radius: 8px; 
                        border-left: 4px solid #667eea; }
              .footer { text-align: center; margin-top: 20px; color: #888; font-size: 12px; }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="header">
                <h1>🚤 Welcome to Rigoo Marine!</h1>
              </div>
              <div class="content">
                <h2>Hi ${displayName || "there"}!</h2>
                <p>Your account is now verified and ready to use. Here's what you can do:</p>
                
                <div class="feature">
                  <h3>🛥️ Browse Listings</h3>
                  <p>Explore premium yachts, boats, and jet skis.</p>
                </div>
                
                <div class="feature">
                  <h3>🎉 Discover Events</h3>
                  <p>Find and book exclusive marine events.</p>
                </div>
                
                <div class="feature">
                  <h3>🔧 Shop Parts</h3>
                  <p>Get quality marine parts and accessories.</p>
                </div>
                
                <div class="feature">
                  <h3>⚙️ Find Services</h3>
                  <p>Connect with expert marine mechanics.</p>
                </div>
                
                <p>Ready to dive in? Start exploring now!</p>
              </div>
              <div class="footer">
                <p>© ${new Date().getFullYear()} Rigoo Marine. All rights reserved.</p>
                <p>Need help? Contact us at support@rigoomarine.com</p>
              </div>
            </div>
          </body>
        </html>
      `,
    };

    await transporter.sendMail(mailOptions);
    logger.info(`Welcome email sent to: ${email}`);

    return { success: true, message: "Welcome email sent" };
  } catch (error) {
    logger.error("Error sending welcome email:", error);
    throw new functions.https.HttpsError("internal", "Failed to send email");
  }
});

/**
 * Send order confirmation email
 */
exports.sendOrderConfirmation = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
  }

  const { email, displayName, orderNumber, items, totalAmount } = data;

  if (!email || !orderNumber) {
    throw new functions.https.HttpsError("invalid-argument", "Email and order number are required");
  }

  try {
    const itemsHtml = items.map((item) => `
      <tr>
        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${item.name}</td>
        <td style="padding: 10px; border-bottom: 1px solid #ddd; text-align: center;">${item.quantity}</td>
        <td style="padding: 10px; border-bottom: 1px solid #ddd; text-align: right;">$${item.price}</td>
      </tr>
    `).join("");

    const mailOptions = {
      from: `"Rigoo Marine" <${functions.config().email?.user || "noreply@rigoomarine.com"}>`,
      to: email,
      subject: `Order Confirmation #${orderNumber} - Rigoo Marine`,
      html: `
        <!DOCTYPE html>
        <html>
          <head>
            <style>
              body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
              .container { max-width: 600px; margin: 0 auto; padding: 20px; }
              .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                        color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
              .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
              table { width: 100%; border-collapse: collapse; background: white; margin: 20px 0; }
              th { background: #667eea; color: white; padding: 12px; text-align: left; }
              .total { font-weight: bold; font-size: 18px; color: #667eea; }
              .footer { text-align: center; margin-top: 20px; color: #888; font-size: 12px; }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="header">
                <h1>🚤 Order Confirmed!</h1>
                <p>Order #${orderNumber}</p>
              </div>
              <div class="content">
                <h2>Hi ${displayName || "there"}!</h2>
                <p>Thank you for your order. We've received it and will process it shortly.</p>
                
                <table>
                  <thead>
                    <tr>
                      <th>Item</th>
                      <th style="text-align: center;">Quantity</th>
                      <th style="text-align: right;">Price</th>
                    </tr>
                  </thead>
                  <tbody>
                    ${itemsHtml}
                    <tr>
                      <td colspan="2" style="padding: 15px; text-align: right; font-weight: bold;">Total:</td>
                      <td class="total" style="padding: 15px; text-align: right;">$${totalAmount}</td>
                    </tr>
                  </tbody>
                </table>
                
                <p>We'll send you another email when your order ships.</p>
              </div>
              <div class="footer">
                <p>© ${new Date().getFullYear()} Rigoo Marine. All rights reserved.</p>
              </div>
            </div>
          </body>
        </html>
      `,
    };

    await transporter.sendMail(mailOptions);
    logger.info(`Order confirmation sent to: ${email} for order: ${orderNumber}`);

    return { success: true, message: "Order confirmation sent" };
  } catch (error) {
    logger.error("Error sending order confirmation:", error);
    throw new functions.https.HttpsError("internal", "Failed to send email");
  }
});