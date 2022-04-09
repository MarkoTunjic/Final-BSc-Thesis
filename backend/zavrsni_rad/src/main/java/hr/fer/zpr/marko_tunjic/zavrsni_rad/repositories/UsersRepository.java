package hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;

@Repository
public interface UsersRepository extends JpaRepository<Users, Long> {
    List<Users> findByRoleId(Long roleId);

    Optional<Users> findByUsername(String username);

    Optional<Users> findByeMail(String eMail);

    boolean existsByUsername(String username);

    boolean existsByeMail(String eMail);
}
