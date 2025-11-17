package com.group10.furniture_store.service.sendEmail;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class SendEmailToVerify {
    public String getRandom() {
        Random rnd = new Random();
        int num = rnd.nextInt(999999);
        return String.format("%06d", num);
    }

    @Autowired
    private JavaMailSender mailSender;

    public boolean sendEmail(String toEmail, String subject, String body) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("furniturestoreonline247@gmail.com");
            message.setTo(toEmail);
            message.setSubject(subject);
            message.setText(body);
            mailSender.send(message);
            return true;
        } catch (Exception ex) {
            System.out.println("Error sending email : " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }
}
