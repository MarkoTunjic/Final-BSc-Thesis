package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import org.springframework.stereotype.Service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.List;
import java.util.Optional;

import javax.mail.MessagingException;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.Filter;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.LoginResponse;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RegisterRequest;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.UsersResponse;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RoleRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.security.JwtUtils;

@Service
public class UsersService {
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UsersRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private FileService fileService;

    @Autowired
    private MailService mailService;

    public static final int USERS_PER_PAGE = 10;

    private SecureRandom sr = new SecureRandom();

    public LoginResponse loginUser(String identifier, String password) {
        String username;
        Users user;
        if (identifier.contains("@")) {
            Optional<Users> optionalUser = userRepository.findByeMail(identifier);
            if (optionalUser.isEmpty())
                throw new IllegalStateException("Invalid username or password");
            user = optionalUser.get();
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

    @Transactional
    public Users registerUser(RegisterRequest payload) throws MessagingException, FileNotFoundException, IOException {
        if (userRepository.existsByUsername(payload.getUsername()))
            throw new IllegalArgumentException("Username already exists in database");
        if (userRepository.existsByeMail(payload.geteMail()))
            throw new IllegalArgumentException("EMail already exists in database");
        if (payload.getUsername().isBlank())
            throw new IllegalArgumentException("Username can not be blank");
        if (payload.geteMail().isBlank())
            throw new IllegalArgumentException("Email can not be blank");
        if (payload.getPassword().equals(payload.getPassword().toLowerCase()))
            throw new IllegalArgumentException("Password must contain at least 1 uppercase");
        if (payload.getPassword().length() < 8)
            throw new IllegalArgumentException("Password must have atleast 8 characters");
        StringBuilder codeBuilder = new StringBuilder();
        for (int i = 0; i < 30; i++)
            codeBuilder.append(sr.nextInt(10));
        String url;
        if (payload.getProfilePicture() != null)
            url = fileService.upload(payload.getProfilePicture(), payload.getUsername() + "_profilePicture.png");
        else
            url = FileService.DEFAULT_PROFILE_PICTURE;
        Users user = new Users(payload.getUsername(), payload.geteMail(), encoder.encode(payload.getPassword()),
                url, false, false, roleRepository.getById((long) 1), codeBuilder.toString());
        userRepository.save(user);
        mailService.sendConfirmationMail(user);
        return user;
    }

    @Transactional
    public void verifiyUser(String code) {
        Users user = userRepository.findByConfirmationCode(code);
        user.setConfirmed(true);
        userRepository.save(user);
    }

    public Users getById(Long userId) {
        return userRepository.findById(userId).get();
    }

    @Transactional
    public Boolean changeBanStatus(Long userId, Boolean banStatus) {
        Users user = userRepository.findById(userId).get();
        user.setBanned(banStatus);
        userRepository.save(user);
        return true;
    }

    public UsersResponse getUsers(Filter filter) {
        String nameLike = filter.getNameLike() == null ? "" : filter.getNameLike();
        List<Users> users = userRepository.getTen((filter.getIndex() - 1) * USERS_PER_PAGE, nameLike);
        Double numberOfPages = Math.ceil(userRepository.countByName(nameLike) / (USERS_PER_PAGE * 1.d));
        return new UsersResponse(users, numberOfPages.intValue(), filter.getIndex());
    }
}
