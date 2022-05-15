package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Rating;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable.RatingKey;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RatingRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;

@Service
public class RatingService {
    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private RatingRepository ratingRepository;

    public Boolean addRating(Long userId, Long recipeId, Integer ratingValue) {
        if (ratingValue > 5 || ratingValue < 0)
            throw new IllegalArgumentException("Rating can be from 1 to 5");
        RatingKey ratingKey = new RatingKey(userId, recipeId);
        Optional<Rating> optionalRating = ratingRepository.findById(ratingKey);
        if (!optionalRating.isPresent()) {
            Users user = usersRepository.findById(userId).get();
            Recipe recipe = recipeRepository.findById(recipeId).get();
            ratingRepository.save(new Rating(ratingValue, user, recipe));
            return true;
        }
        Rating rating = optionalRating.get();
        rating.setRatingValue(ratingValue);
        ratingRepository.save(rating);
        return true;
    }
}
