package hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Comments;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable.CommentsKey;

@Repository
public interface CommentsRepository extends JpaRepository<Comments, CommentsKey> {

    List<Comments> findByUserId(Long userId);

    List<Comments> findByRecipeId(Long recipeId);
}
