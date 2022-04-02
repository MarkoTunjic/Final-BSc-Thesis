package hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Favorite;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable.FavoriteKey;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, FavoriteKey> {

    List<Favorite> findByUserId(Long userId);

    List<Favorite> findByRecipeId(Long recipeId);
}
