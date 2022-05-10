package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Comments;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.CommentsRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;

@Service
public class CommentsService {
    @Autowired
    private CommentsRepository commentsRepository;

    @Autowired
    private UsersRepository usersRepository;
    @Autowired
    private RecipeRepository recipeRepository;

    @Transactional
    public Comments addComment(Long userId, Long recipeId, String commentText) {
        Users user = usersRepository.findById(userId).get();
        Recipe recipe = recipeRepository.findById(recipeId).get();
        return commentsRepository.save(new Comments(commentText, user, recipe));
    }

    @Transactional
    public void deleteComment(Long id) {
        commentsRepository.deleteById(id);
    }
}
