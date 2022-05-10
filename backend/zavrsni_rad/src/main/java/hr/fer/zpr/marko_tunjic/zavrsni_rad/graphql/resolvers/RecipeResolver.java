package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.resolvers;

import java.util.List;

import com.coxautodev.graphql.tools.GraphQLResolver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Comments;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Favorite;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Image;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Ingredient;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Rating;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.RecipeStep;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Video;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable.FavoriteKey;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable.RatingKey;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.CommentsRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.FavoriteRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.ImageRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.IngredientRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RatingRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeStepRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.VideoRepository;

@Component
public class RecipeResolver implements GraphQLResolver<Recipe> {

    @Autowired
    private RecipeStepRepository recipeStepRepository;

    @Autowired
    private IngredientRepository ingredientRepository;

    @Autowired
    private ImageRepository imageRepository;

    @Autowired
    private RatingRepository ratingRepository;

    @Autowired
    private CommentsRepository commentsRepository;

    @Autowired
    private FavoriteRepository favoriteRepository;

    @Autowired
    private VideoRepository videoRepository;

    @Autowired
    private UsersRepository usersRepository;

    public List<RecipeStep> getRecipeSteps(Recipe recipe) {
        return recipeStepRepository.findByRecipeId(recipe.getId());
    }

    public List<Ingredient> getIngredients(Recipe recipe) {
        return ingredientRepository.findByRecipeId(recipe.getId());
    }

    public List<Image> getImages(Recipe recipe) {
        return imageRepository.findByRecipeId(recipe.getId());
    }

    public List<Rating> getRatings(Recipe recipe) {
        return ratingRepository.findByRecipeId(recipe.getId());
    }

    public List<Comments> getComments(Recipe recipe) {
        return commentsRepository.findByRecipeId(recipe.getId());
    }

    public List<Favorite> getFavoriteTo(Recipe recipe) {
        return favoriteRepository.findByRecipeId(recipe.getId());
    }

    public List<Video> getVideos(Recipe recipe) {
        return videoRepository.findByRecipeId(recipe.getId());
    }

    public Double getAverageRating(Recipe recipe) {
        Double average = ratingRepository.averageRatingForRecipe(recipe.getId());
        return average == null ? 0 : average;
    }

    public Boolean isLikedByCurrentUser(Recipe recipe) {

        Object userDetails = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (userDetails instanceof String)
            return false;

        String username = ((UserDetails) userDetails).getUsername();

        Users user = usersRepository.findByUsername(username).get();
        boolean exists = favoriteRepository.existsById(new FavoriteKey(user.getId(), recipe.getId()));
        return exists;
    }

    public Integer ratingFromCurrentUser(Recipe recipe) {

        Object userDetails = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (userDetails instanceof String)
            return 0;

        String username = ((UserDetails) userDetails).getUsername();

        Users user = usersRepository.findByUsername(username).get();
        Rating rating = ratingRepository.findById(new RatingKey(user.getId(), recipe.getId())).get();
        return rating.getRatingValue();
    }
}
