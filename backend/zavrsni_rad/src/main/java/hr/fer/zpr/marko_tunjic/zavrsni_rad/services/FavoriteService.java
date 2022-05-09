package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import java.io.UnsupportedEncodingException;

import javax.mail.MessagingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Favorite;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable.FavoriteKey;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.FavoriteRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;

@Service
public class FavoriteService {
    @Autowired
    private FavoriteRepository favoriteRepository;

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private MailService mailService;

    public boolean editFavorite(Long userId, Long recipeId, Boolean state)
            throws UnsupportedEncodingException, MessagingException {
        Users user = usersRepository.findById(userId).get();
        Recipe recipe = recipeRepository.findById(recipeId).get();
        if (state) {
            favoriteRepository.save(new Favorite(user, recipe));
            mailService.sendRecipe(user, recipe);
            return state;
        }
        Favorite favorite = favoriteRepository.findById(new FavoriteKey(userId, recipeId)).get();
        favoriteRepository.delete(favorite);
        return state;
    }
}
