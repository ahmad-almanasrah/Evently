package com.example.evently;

import com.example.evently.config.RSAKeyProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@EnableConfigurationProperties(RSAKeyProperties.class)
@SpringBootApplication
public class EventlyApplication {

	public static void main(String[] args) {
		SpringApplication.run(EventlyApplication.class, args);
	}

}
