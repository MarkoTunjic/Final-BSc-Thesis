package hr.fer.zpr.marko_tunjic.zavrsni_rad;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
public class ZavrsniRadApplication {

	public static void main(String[] args) {
		SpringApplication.run(ZavrsniRadApplication.class, args);
	}

}
