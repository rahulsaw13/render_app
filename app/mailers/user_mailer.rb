class UserMailer < ApplicationMailer
    default from: 'Logo Sweets Team'

    def welcome_email(user)
      mail(
        to: user[:email],
        subject: "Welcome to Logo Sweets - You're Successfully Registered!",
        content_type: "text/html",
        body: "Hello #{user[:name]},<br><br>
               Thank you for signing up with <b>Logo Sweets</b>! We're excited to have you as part of our shopping community.<br><br>
               Happy shopping!<br><br>
               <b>Logo Sweets Team</b><br>
               <i>Your favorite place to shop online</i>"
        )
    end

    def reset_password_email(user, token)
      @reset_link = (user[:role_id] == 1) ? "#{ENV['FRONTEND_URL']}/user-reset-password?token=#{token}" : "#{ENV['FRONTEND_URL']}/reset-password?token=#{token}"
  
      mail(
        to: user.email,
        subject: "Reset Your Password - Logo Sweets",
        content_type: "text/html",
        body: "Hello #{user[:name]},<br><br>
               We received a request to reset your password.<br>
               Click the link below to change your password:<br><br>
               <a href='#{@reset_link}'>Reset Password</a><br><br>
               If you didn't request this, you can ignore this email.<br><br>
               <b>Logo Sweets Team</b>"
      )
    end

    def password_changed(user)
      mail(
        to: user[:email],
        subject: "Your Password Has Been Successfully Changed - Logo Sweets",
        content_type: "text/html",
        body: "Hello #{user[:name]},<br><br>
               This is a confirmation that your password has been successfully changed.<br><br>
               If you did not initiate this change, please contact our support team immediately.<br><br>
               Stay safe and happy shopping!<br><br>
               <b>Logo Sweets Team</b><br>"
      )
    end

    def send_otp_email(user, otp)
      @otp = otp
      mail(
        to: user[:email],
        subject: "Your One-Time Password (OTP) for Phone Number Verification",
        content_type: "text/html",
        body: "
          Hello #{user[:name]},
          Thank you for signing up with <b>Logo Sweets</b>!<br>
    
          To verify your phone number, please use the following One-Time Password (OTP):<br>
          <h2 style='color: #d97706;'>#{@otp}</h2><br>
    
          This OTP is valid for <b>5 minutes</b>.
    
          If you did not request this, please ignore this email.<br><br>
    
          Happy shopping!<br><br>
          <b>Logo Sweets Team</b>
        "
      )
    end    
end
