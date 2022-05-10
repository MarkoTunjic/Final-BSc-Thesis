package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import org.springframework.stereotype.Service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.SecureRandom;

import javax.mail.MessagingException;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.LoginResponse;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RegisterRequest;
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

    private SecureRandom sr = new SecureRandom();

    public LoginResponse loginUser(String identifier, String password) {
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

    @Transactional
    public Users registerUser(RegisterRequest payload) throws MessagingException, FileNotFoundException, IOException {
        if (userRepository.existsByUsername(payload.getUsername()))
            throw new IllegalArgumentException("Username already exists in database");
        if (userRepository.existsByeMail(payload.geteMail()))
            throw new IllegalArgumentException("EMail already exists in database");
        StringBuilder codeBuilder = new StringBuilder();
        for (int i = 0; i < 30; i++) {
            switch (sr.nextInt(0, 3)) {
                case 0:
                    codeBuilder.append((char) sr.nextInt('a', 'z' + 1));
                    break;
                case 1:
                    codeBuilder.append((char) sr.nextInt('A', 'Z' + 1));
                    break;
                case 2:
                    codeBuilder.append((char) sr.nextInt('0', '9' + 1));
                    break;
            }
        }
        String url = fileService.upload(payload.getProfilePicture(), payload.getUsername() + "_profilePicture.png");
        Users user = new Users(payload.getUsername(), payload.geteMail(), encoder.encode(payload.getPassword()),
                url, false, false, roleRepository.getById((long) 1), codeBuilder.toString());
        System.out.println(codeBuilder.toString());
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
}
