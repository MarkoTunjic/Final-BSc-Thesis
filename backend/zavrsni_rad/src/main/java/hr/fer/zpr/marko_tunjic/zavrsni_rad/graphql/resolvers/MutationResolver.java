package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.resolvers;

import java.io.FileNotFoundException;
import java.io.IOException;

import javax.mail.MessagingException;

import com.coxautodev.graphql.tools.GraphQLMutationResolver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.LoginResponse;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RecipePayload;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RegisterRequest;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Comments;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.CommentsService;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.FavoriteService;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.RatingService;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.RecipeService;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.UsersService;

@Component
public class MutationResolver implements GraphQLMutationResolver {

    @Autowired
    private UsersService usersService;

    @Autowired
    private RecipeService recipeService;

    @Autowired
    private FavoriteService favoriteService;

    @Autowired
    private CommentsService commentsService;

    @Autowired
    private RatingService ratingService;

    @PreAuthorize("isAnonymous()")
    public LoginResponse login(String identifier, String password) {
        return usersService.loginUser(identifier, password);
    }

    @PreAuthorize("isAnonymous()")
    public Users register(RegisterRequest payload) throws MessagingException, FileNotFoundException, IOException {
        return usersService.registerUser(payload);
    }

    @PreAuthorize("hasAuthority('USER')")
    public Recipe addRecipe(RecipePayload payload) throws FileNotFoundException, IOException {
        Object userDetails = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if ((userDetails instanceof String)) {
            System.out.println("anonymus");
        } else {
            System.out.println(((UserDetails) userDetails).getAuthorities());
        }
        return recipeService.addRecipe(payload);
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('MODERATOR')")
    public Boolean editFavorite(Long userId, Long recipeId, Boolean state)
            throws FileNotFoundException, IOException, MessagingException {
        return favoriteService.editFavorite(userId, recipeId, state);
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('MODERATOR')")
    public Boolean deleteRecipe(Long recipeId)
            throws FileNotFoundException, IOException, MessagingException {
        return recipeService.deleteRecipe(recipeId);
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('MODERATOR')")
    public Comments addComment(Long userId, Long recipeId, String commentText) {
        return commentsService.addComment(userId, recipeId, commentText);
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('MODERATOR')")
    public Boolean addRating(Long userId, Long recipeId, Integer ratingValue) {
        return ratingService.addRating(userId, recipeId, ratingValue);
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('MODERATOR')")
    public Boolean deleteComment(Long commentId) {
        return commentsService.deleteComment(commentId);
    }

    @PreAuthorize("hasAuthority('MODERATOR')")
    public Boolean changeBanStatus(Long userId, Boolean banStatus) {
        return usersService.changeBanStatus(userId, banStatus);
    }

    @PreAuthorize("hasAuthority('MODERATOR')")
    public Boolean changeApproovedStatus(Long recipeId, Boolean isApprooved) {
        return recipeService.changeApprovedStatus(recipeId, isApprooved);
    }
}
