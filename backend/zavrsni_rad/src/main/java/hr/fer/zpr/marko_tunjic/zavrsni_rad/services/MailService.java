package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Ingredient;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.RecipeStep;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.IngredientRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeStepRepository;

@Service
public class MailService {
    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private IngredientRepository ingredientRepository;
    @Autowired
    private RecipeStepRepository recipeStepRepository;

    @Value("${spring.mail.username}")
    private String mail;

    public void sendConfirmationMail(Users user) throws UnsupportedEncodingException, MessagingException {
        String subject = "Please verify your e-mail";
        String senderName = "FinalBSC";
        String mailContent = "<p> Dear ${username},</p>".replace("${username}", user.getUsername());
        mailContent += "<p> Please click the link below to verify your registaration: </p>";
        mailContent += "<p><a href=\"http://zavrsnirad-env.eba-dcaqggvc.us-east-1.elasticbeanstalk.com/verify/${confirmationCode}\">click to verify</a></p>"
                .replace("${confirmationCode}", user.getConfirmationCode());
        mailContent += "<p> Thank you!<br> The FinalBsc guy</p>";

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        helper.setFrom(mail, senderName);
        helper.setTo(user.geteMail());
        helper.setSubject(subject);
        helper.setText(mailContent, true);
        mailSender.send(mimeMessage);
    }

    public void sendRecipe(Users user, Recipe recipe) throws UnsupportedEncodingException, MessagingException {
        String subject = "Ingredients for recipe: " + recipe.getRecipeName();
        String senderName = "FinalBSC";
        String mailContent = "<p> Dear ${username},</p>".replace("${username}", user.getUsername());
        mailContent += "<p> Here are the ingredients for your recipe:</p>";
        List<Ingredient> ingredients = ingredientRepository.findByRecipeId(recipe.getId());
        for (Ingredient ingredient : ingredients) {
            mailContent += "<p>${ingredinet}</p>".replace("${ingredinet}", ingredient.toString());
        }
        mailContent += "<p> Here are the steps for your recipe:</p>";
        List<RecipeStep> steps = recipeStepRepository.findByRecipeId(recipe.getId());
        for (RecipeStep step : steps) {
            mailContent += "<p>${step}</p>".replace("${step}",
                    String.format("%d. %s", step.getOrderNumber(), step.getStepDescription()));
        }
        mailContent += "<p> Thank you!<br> The FinalBsc guy</p>";

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        helper.setFrom(mail, senderName);
        helper.setTo(user.geteMail());
        helper.setSubject(subject);
        helper.setText(mailContent, true);
        mailSender.send(mimeMessage);
    }
}
