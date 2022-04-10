package hr.fer.zpr.marko_tunjic.zavrsni_rad.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.services.UsersService;

@RestController
public class VerificationController {
    @Autowired
    private UsersService usersService;

    @GetMapping("/verify/{code}")
    public ResponseEntity<?> verifyUser(@PathVariable String code) {
        usersService.verifiyUser(code);
        return new ResponseEntity<>("Your registration has been verified!", HttpStatus.OK);
    }
}
