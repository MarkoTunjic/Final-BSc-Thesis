package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.resolvers;

import java.util.List;

import com.coxautodev.graphql.tools.GraphQLQueryResolver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Component;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.RecipeService;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.Filter;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.Recipes;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;

@Component
public class QueryResolver implements GraphQLQueryResolver {
    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private RecipeService recipeService;

    public List<Users> getUsers() {
        return usersRepository.findAll();
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('USER') or isAnonymous()")
    public Recipes getRecipes(Filter filter) {
        return recipeService.getRecipesForFilter(filter);
    }

    @PreAuthorize("hasAuthority('USER') or hasAuthority('USER') or isAnonymous()")
    public Recipe getSingleRecipe(Long recipeId) {
        return recipeService.getById(recipeId);
    }
}
