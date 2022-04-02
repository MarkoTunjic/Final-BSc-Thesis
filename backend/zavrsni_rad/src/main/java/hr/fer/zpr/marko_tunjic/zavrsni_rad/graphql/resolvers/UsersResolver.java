package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.resolvers;

import java.util.List;

import com.coxautodev.graphql.tools.GraphQLResolver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Comments;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Favorite;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Rating;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.CommentsRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.FavoriteRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RatingRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeRepository;

@Component
public class UsersResolver implements GraphQLResolver<Users> {

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private CommentsRepository commentsRepository;

    @Autowired
    private RatingRepository ratingRepository;

    @Autowired
    private FavoriteRepository favoriteRepository;

    public List<Recipe> getRecipes(Users user) {
        return recipeRepository.findByUserId(user.getId());
    }

    public List<Comments> getComments(Users user) {
        return commentsRepository.findByUserId(user.getId());
    }

    public List<Rating> getRatings(Users user) {
        return ratingRepository.findByUserId(user.getId());
    }

    public List<Favorite> getFavorites(Users user) {
        return favoriteRepository.findByUserId(user.getId());
    }
}
