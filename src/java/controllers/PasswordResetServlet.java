package controllers;

import jakarta.mail.Message;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.IOException;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.UserBean;
import models.UserDAO;

/**
 * Camada Controller: Gerenciador do Ciclo de Recuperação de Senhas. Valida
 * credenciais cruzadas, gera tokens e despacha e-mails HTML via SMTP local.
 */
@WebServlet("/recuperar-senha/*")
public class PasswordResetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Bloqueia varreduras via GET redirecionando para o formulário visual legítimo
        response.sendRedirect(request.getContextPath() + "/pagina?p=forgot_password");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        UserDAO dao = new UserDAO();

        if ("/solicitar".equals(pathInfo)) {
            String email = request.getParameter("email").trim();
            String phone = request.getParameter("phone").trim();

            // Executa a validação conjunta de e-mail e telefone cadastrados (Model do Capítulo 10)
            UserBean user = dao.findByEmailAndPhone(email, phone);

            if (user != null) {
                // Gerar token numérico aleatório seguro de 6 dígitos
                SecureRandom rand = new SecureRandom();
                int num = rand.nextInt(1000000);
                String token = String.format("%06d", num);

                // Define 5 minutos de expiração
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.MINUTE, 5);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String expiryTime = sdf.format(cal.getTime());

                // Registra o token temporário e a validade na linha do usuário no MySQL
                if (dao.setResetToken(user.getId(), token, expiryTime)) {
                    // DISPARA O PROCESSO DE ENVIO DO JAKARTA MAIL PARA O MAILHOG
                    boolean emailEnviado = enviarEmailMailHog(user.getEmail(), user.getName(), token);

                    if (emailEnviado) {
                        request.setAttribute("message", "Um código de 6 dígitos foi enviado para o seu e-mail.");
                        request.setAttribute("message_type", "success");
                        // Despacha o fluxo mantendo o feedback para a view de digitação do código
                        request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("message", "Erro ao disparar e-mail. Certifique-se de que o MailHog está ativo na porta 1025.");
                        request.setAttribute("message_type", "error");
                    }
                } else {
                    request.setAttribute("message", "Erro ao registrar parâmetros de recuperação no banco de dados.");
                    request.setAttribute("message_type", "error");
                }
            } else {
                // Blindagem de segurança: Resposta de sucesso genérica contra varreduras maliciosas
                request.setAttribute("message", "Se os dados informados estiverem corretos, um código foi enviado.");
                request.setAttribute("message_type", "success");
                request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                return;
            }

            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
        }

        // ADICIONE ESTE BLOCO DENTRO DO MÉTODO doPost() DO SEU PasswordResetServlet.java:
        if ("/alterar".equals(pathInfo)) {
            String token = request.getParameter("token").trim();
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");

            // 1. Validações de Borda: Garante a integridade dos parâmetros recebidos
            if (token.length() != 6 || !token.matches("\\d+")) {
                request.setAttribute("message", "O código deve conter exatamente 6 números.");
                request.setAttribute("message_type", "error");
                request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("message", "As senhas não coincidem.");
                request.setAttribute("message_type", "error");
                request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                return;
            }

            if (newPassword.length() < 6) {
                request.setAttribute("message", "A senha deve ter no mínimo 6 caracteres.");
                request.setAttribute("message_type", "error");
                request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                return;
            }

            // 2. Validação Temporal: Consulta o MySQL para checar se o token existe e está no prazo de 5 minutos
            UserBean userToken = dao.getUserByResetToken(token);

            if (userToken != null) {
                // Se o token for legítimo, invoca a atualização de senha com o jBcrypt (Capítilo 10)
                if (dao.resetPassword(userToken.getId(), newPassword)) {
                    // Limpa a URL e redireciona para a tela de login disparando o aviso verde de sucesso
                    response.sendRedirect(request.getContextPath() + "/pagina?p=login&msg=password_reset");
                } else {
                    request.setAttribute("message", "Erro interno ao atualizar a senha no banco de dados.");
                    request.setAttribute("message_type", "error");
                    request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                }
            } else {
                // Se o token não for localizado ou a data atual superou o prazo gravado em reset_expires
                request.setAttribute("message", "Código de recuperação inválido ou já expirado.");
                request.setAttribute("message_type", "error");
                request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
            }
        }
    }

    /**
     * MÁGICA DO JAKARTA MAIL: Configura as propriedades do envelope SMTP e
     * despacha o fluxo HTML de forma limpa direto para a inbox local do
     * MailHog.
     */
    private boolean enviarEmailMailHog(String destinoEmail, String nomeUsuario, String token) {
        // Configuração das propriedades do envelope SMTP do MailHog ($mail->isSMTP())
        Properties props = new Properties();
        props.put("mail.smtp.host", "localhost"); // Servidor local do MailHog
        props.put("mail.smtp.port", "1025");      // Porta SMTP padrão do MailHog
        props.put("mail.smtp.auth", "false");     // MailHog aceita conexões sem autenticação por padrão
        props.put("mail.mime.charset", "UTF-8");

        // Cria a sessão com o servidor SMTP do Jakarta Mail
        Session session = Session.getInstance(props, null);

        try {
            MimeMessage message = new MimeMessage(session);

            // Define o remetente (setFrom)
            message.setFrom(new InternetAddress("nao-responda@projresponsivo.com", "Sistema Gestão de Serviços de Informática"));

            // Define o destinatário (addAddress)
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(destinoEmail));

            // Assunto estruturado com codificação UTF-8 do e-mail
            message.setSubject("Código de Recuperação de Senha - Gestão de Serviços de Informática", "UTF-8");

            // Corpo do e-mail estruturado no formato HTML em blocos de estilização CSS Inline
            String corpoHtml = "<div style='font-family: Arial, sans-serif; max-width: 500px; padding: 25px; border: 1px solid #e2e8f0; border-radius: 8px;'>"
                    + "<h2 style='color: #1e3a8a;'>Recuperação de Senha</h2>"
                    + "<p>Olá, <strong>" + nomeUsuario + "</strong>.</p>"
                    + "<p>Seu código de verificação seguro é:</p>"
                    + "<div style='background-color: #f1f5f9; padding: 15px; text-align: center; font-size: 26px; font-weight: bold; letter-spacing: 5px; color: #1e3a8a; border-radius: 6px; margin: 20px 0;'>"
                    + token
                    + "</div>"
                    + "<p style='font-size: 11px; color: #64748b;'>Atenção: Este código expirará automaticamente em 5 minutos.</p>"
                    + "</div>";

            // Configura como texto HTML ($mail->isHTML(true))
            message.setContent(corpoHtml, "text/html; charset=utf-8");

            // Envia o e-mail definitivamente
            Transport.send(message);
            return true;

        } catch (Exception e) {
            System.err.println("Falha ao disparar e-mail via Jakarta Mail: " + e.getMessage());
            return false;
        }
    }
}
