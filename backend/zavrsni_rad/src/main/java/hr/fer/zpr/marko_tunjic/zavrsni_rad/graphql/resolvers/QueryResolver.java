package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.resolvers;

import com.coxautodev.graphql.tools.GraphQLQueryResolver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Component;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.RecipeService;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.UsersService;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.Filter;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.Recipes;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.UsersResponse;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;

@Component
public class QueryResolver implements GraphQLQueryResolver {
    @Autowired
    private RecipeService recipeService;

    @Autowired
    private UsersService usersService;

    @PreAuthorize("hasAuthority('USER') or hasAuthority('MODERATOR') or isAnonymous()")
    public Recipes getRecipes(Filter filter) {
        return recipeService.getRecipesForFilter(filter);
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('MODERATOR') or isAnonymous()")
    public Recipe getSingleRecipe(Long recipeId) {
        return recipeService.getById(recipeId);
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('MODERATOR') or isAnonymous()")
    public Users getUserForId(Long userId) {
        return usersService.getById(userId);
    }

    @PreAuthorize("hasAuthority('MODERATOR')")
    public UsersResponse getUsers(Filter filter) {
        return usersService.getUsers(filter);
    }

    @PreAuthorize("hasAuthority('MODERATOR')")
    public Recipes getNotApprovedRecipes(Filter filter) {
        return recipeService.getNotApproovedRecipes(filter);
    }
}
