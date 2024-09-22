package com.example.knu_mingle;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class KnuMingleApplication {

	public static void main(String[] args) {
		new SpringApplicationBuilder(KnuMingleApplication.class)
				.properties("spring.config.location=classpath:/application.yml,classpath:/application-secret.yml")
				.run(args);
	}
}
