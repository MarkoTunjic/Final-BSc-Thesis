package hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Video;

@Repository
public interface VideoRepository extends JpaRepository<Video, Long> {
}
