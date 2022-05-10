package hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Image;

@Repository
public interface ImageRepository extends JpaRepository<Image, Long> {

    List<Image> findByRecipeId(Long recipeId);

    void deleteByRecipeId(Long recipeId);
}
