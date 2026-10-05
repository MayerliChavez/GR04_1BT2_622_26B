package com.grupo06.app.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class HibernateUtil {

    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            Configuration configuration = new Configuration()
                    .configure("hibernate.cfg.xml");

            Properties localProperties = new Properties();

            try (InputStream input = HibernateUtil.class
                    .getClassLoader()
                    .getResourceAsStream("hibernate.local.properties")) {

                if (input == null) {
                    throw new IllegalStateException(
                            "No se encontró hibernate.local.properties. " +
                                    "Ejecute setup.ps1 para configurar la conexión a SQL Server."
                    );
                }

                localProperties.load(input);
            }

            for (String propertyName : localProperties.stringPropertyNames()) {
                configuration.setProperty(
                        propertyName,
                        localProperties.getProperty(propertyName)
                );
            }

            return configuration.buildSessionFactory();

        } catch (Exception e) {
            System.err.println(
                    "No se pudo crear la SessionFactory de Hibernate"
            );

            throw new ExceptionInInitializerError(e);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        getSessionFactory().close();
    }
}