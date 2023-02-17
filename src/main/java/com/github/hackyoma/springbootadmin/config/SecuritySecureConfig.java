package com.github.hackyoma.springbootadmin.config;

import de.codecentric.boot.admin.server.config.AdminServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.SecurityProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import java.util.UUID;

/**
 * SecuritySecureConfig
 *
 * @author hackyo
 * @version 2022/7/15
 */
@EnableWebSecurity
@Configuration(proxyBeanMethods = false)
public class SecuritySecureConfig {

    private final AdminServerProperties adminServer;
    private final SecurityProperties security;

    @Autowired
    public SecuritySecureConfig(AdminServerProperties adminServer, SecurityProperties security) {
        this.adminServer = adminServer;
        this.security = security;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        SavedRequestAwareAuthenticationSuccessHandler successHandler = new SavedRequestAwareAuthenticationSuccessHandler();
        successHandler.setTargetUrlParameter("redirectTo");
        successHandler.setDefaultTargetUrl(this.adminServer.path("/"));

        return http.authorizeHttpRequests()
                .requestMatchers(this.adminServer.path("/assets/**")).permitAll()
                .requestMatchers(this.adminServer.path("/actuator/info")).permitAll()
                .requestMatchers(this.adminServer.path("/actuator/health")).permitAll()
                .requestMatchers(this.adminServer.path("/login")).permitAll()
                .anyRequest().authenticated().and()
                .formLogin().loginPage(this.adminServer.path("/login")).successHandler(successHandler).and()
                .logout().logoutUrl(this.adminServer.path("/logout")).and()
                .httpBasic(Customizer.withDefaults())
                .csrf().disable()
                .rememberMe().key(UUID.randomUUID().toString()).tokenValiditySeconds(1209600).and()
                .build();
    }

    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {
        return new InMemoryUserDetailsManager(
                User.withUsername(security.getUser().getName())
                        .password("{noop}" + security.getUser().getPassword())
                        .roles("USER")
                        .build()
        );
    }

}
