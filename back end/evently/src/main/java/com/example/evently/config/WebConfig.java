package com.example.evently.config;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 1. Map the URL "http://.../uploads/filename"
        registry.addResourceHandler("/uploads/**")
                // 2. To the "uploads" folder in your project root
                // "file:./" means "file system, current directory"
                .addResourceLocations("file:./uploads/");
    }
}