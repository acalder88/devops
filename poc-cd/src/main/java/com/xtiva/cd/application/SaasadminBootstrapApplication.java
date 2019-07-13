package com.xtiva.cd.application;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@ComponentScan("com.xtiva.cd")
@SpringBootApplication
public class SaasadminBootstrapApplication {


  public static void main(String[] args) {
    SpringApplication app = new SpringApplication(SaasadminBootstrapApplication.class);
    app.run(args);
  }
}

