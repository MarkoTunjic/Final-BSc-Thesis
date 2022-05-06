package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.resolvers;

import java.io.FileNotFoundException;
import java.io.IOException;

import javax.mail.MessagingException;

import com.coxautodev.graphql.tools.GraphQLMutationResolver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Component;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.LoginResponse;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RecipePayload;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RegisterRequest;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.RecipeService;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.UsersService;

@Component
public class MutationResolver implements GraphQLMutationResolver {

    @Autowired
    private UsersService usersService;

    @Autowired
    private RecipeService recipeService;

    @PreAuthorize("isAnonymous()")
    public LoginResponse login(String identifier, String password) {
        return usersService.loginUser(identifier, password);
    }

    @PreAuthorize("isAnonymous()")
    public Users register(RegisterRequest payload) throws MessagingException, FileNotFoundException, IOException {
        return usersService.registerUser(payload);
    }

    public Recipe addRecipe(RecipePayload payload) throws FileNotFoundException, IOException {
        return recipeService.addRecipe(payload);
    }
}
