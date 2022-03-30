package hr.fer.zpr.marko_tunjic.zavrsni_rad;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EBHealthCheck {

    @GetMapping("/")
    public String checkHealth() {
        return "OK";
    }
}
