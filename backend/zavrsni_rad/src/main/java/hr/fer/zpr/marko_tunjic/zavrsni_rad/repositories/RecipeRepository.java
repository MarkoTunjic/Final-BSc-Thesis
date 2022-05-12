package hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;

@Repository
public interface RecipeRepository extends JpaRepository<Recipe, Long> {

        List<Recipe> findByUserId(Long userId);

        @Query("SELECT r FROM Recipe r WHERE r.recipeName LIKE %?1% AND r.isApprooved=?2 AND r.cookingDuration<=?3")
        List<Recipe> findByApprovedAndNameLikeAndCookingDuration(String nameLike, Boolean isApproved,
                        Integer cookingDuration);

        @Query("SELECT r FROM Recipe r WHERE r.recipeName LIKE %?1% AND r.isApprooved=?2 AND r.cookingDuration<=?3 AND r.user.id=?4")
        List<Recipe> findByApprovedAndNameLikeAndCookingDurationAndUserId(String nameLike, Boolean isApproved,
                        Integer cookingDuration,
                        Long userId);

        @Query(value = "SELECT * FROM recipe WHERE is_approoved=?2 AND recipe_name LIKE %?3% ORDER BY id LIMIT 10 OFFSET ?1", nativeQuery = true)
        List<Recipe> getTen(Integer offset, Boolean approved, String nameLike);

        @Query(value = "SELECT COUNT(*) FROM recipe WHERE recipe_name LIKE %?1% AND is_approoved=?2", nativeQuery = true)
        Long countByNameAndApprooved(String nameLike, Boolean approved);
}
