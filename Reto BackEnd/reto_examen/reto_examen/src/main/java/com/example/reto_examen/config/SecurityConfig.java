package com.example.reto_examen.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        /*
         * Permite el acceso sin autenticacion a swagger
         * protege cualquier otro endpoint
         * desactiva CSRF (util si se esta usando API REST pura)
         * Usa autenticacion básica por defecto (Authorization Basic...)
         * 
         * LINK de Swagger http://localhost:8080/swagger-ui/index.html
         */
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        // swagger sin autenticacion
                        .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()
                        // todo lo demas protegido
                        .anyRequest().authenticated())
                .httpBasic(Customizer.withDefaults());
        return http.build();
    }
}
