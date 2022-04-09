package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.resolvers;

import com.coxautodev.graphql.tools.GraphQLMutationResolver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.LoginResponse;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RegisterRequest;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RoleRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.security.JwtUtils;

@Component
public class MutationResolver implements GraphQLMutationResolver {

    @Autowired
    AuthenticationManager authenticationManager;
    @Autowired
    UsersRepository userRepository;
    @Autowired
    RoleRepository roleRepository;
    @Autowired
    PasswordEncoder encoder;
    @Autowired
    JwtUtils jwtUtils;

    @PreAuthorize("isAnonymous()")
    public LoginResponse login(String identifier, String password) {
        String username;
        Users user;
        if (identifier.contains("@")) {
            user = userRepository.findByeMail(identifier).get();
            username = user.getUsername();
        } else {
            user = userRepository.findByUsername(identifier).get();
            username = identifier;
        }

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(username, password));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        return new LoginResponse(user, jwt);
    }

    @PreAuthorize("isAnonymous()")
    public LoginResponse register(RegisterRequest payload) {
        if (userRepository.existsByUsername(payload.getUsername()))
            throw new IllegalArgumentException("Username already exists in database");
        if (userRepository.existsByeMail(payload.geteMail()))
            throw new IllegalArgumentException("EMail already exists in database");
        Users user = new Users(payload.getUsername(), payload.geteMail(), encoder.encode(payload.getPassword()),
                payload.getProfilePicture(), false, true, roleRepository.getById((long) 1));
        userRepository.save(user);
        return login(payload.getUsername(), payload.getPassword());
    }
}
