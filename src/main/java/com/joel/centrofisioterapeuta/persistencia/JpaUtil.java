package com.joel.centrofisioterapeuta.persistencia;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class JpaUtil {

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("CentroFisioPU");

    public static EntityManagerFactory getEntityManagerFactory() {
        return emf;
    }
}
