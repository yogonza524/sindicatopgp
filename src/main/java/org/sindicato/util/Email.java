/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.util;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Email {
    
        private static final String ORIGIN = "sindicatopgp";
        private static final String PASS = "jajkaN17";
    
	public static boolean sendToken(String token, String email) {
            
                Boolean resp = false;
            
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.socketFactory.port", "465");
		props.put("mail.smtp.socketFactory.class",
				"javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.port", "465");

		Session session = Session.getInstance(props,
			new javax.mail.Authenticator() {
                                @Override
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication("sindicatopgp","jajkaN17");
				}
			});

		try {

			MimeMessage  message = new MimeMessage(session);
			message.setRecipients(Message.RecipientType.TO,
					InternetAddress.parse(email)); //Set the receptor
			message.setSubject("Registración casi lista");
			message.setContent("<html><body><h1 style='margin-left:35px; font-family:Calibri;'>Gracias por registrarse!</h1><h3 style='margin-left:35px; font-family: Calibri;'>Para terminar la registración por favor acceda al siguiente link:</h3><a href='"+ token +"' style='margin-left:35px; color:blue'>Activar</a><p style='font-family:Calibri;margin-left:35px;'>Nota: Si no reconoce este mensaje desestimelo. Ante cualquier duda comuniquese con nosotros a dividsoft@gmail.com</p><img src='http://sindicatopgp-yogonza524.rhcloud.com/resources/img/slogan.jpg' /></body></html>", "text/html; charset=utf-8");;

			Transport.send(message);

			resp = true;

		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
                
                return resp;
	}
        
        private static Properties init(){
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.port", "888");
            return props;
        }
        
        private static Session authenticate(Properties props){
            Session session = Session.getInstance(props,
			new javax.mail.Authenticator() {
                                @Override
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(ORIGIN,PASS);
				}
			});
            return session;
        }
        
        private static Boolean execute(Session session,String email, String subject, String body){
            boolean resp = false;
            try {

			MimeMessage  message = new MimeMessage(session);
			message.setRecipients(Message.RecipientType.TO,
					InternetAddress.parse(email)); //Set the receptor
			message.setSubject(subject);
			message.setContent(body, "text/html; charset=utf-8");

			Transport.send(message);

			resp = true;

		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
            return resp;
        }
        
        public static boolean send(String email, String subject, String body){
            Properties props = init();
            Session session = authenticate(props);
            return execute(session, email, subject, body);
        }
}