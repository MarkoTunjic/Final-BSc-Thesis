package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.resolvers;

import java.util.List;

import com.coxautodev.graphql.tools.GraphQLResolver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Role;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;

@Component
public class RoleResolver implements GraphQLResolver<Role> {
    @Autowired
    private UsersRepository usersRepository;

    public List<Users> getUsers(Role role) {
        return usersRepository.findByRoleId(role.getId());
    }
}
