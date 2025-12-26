package com.joel.centrofisioterapeuta.persistencia;

import com.joel.centrofisioterapeuta.logica.Recepcionista;

import javax.persistence.*;
import java.util.List;

public class RecepcionistaJpaController {

    private EntityManagerFactory emf = null;

    public RecepcionistaJpaController() {
        this.emf = JpaUtil.getEntityManagerFactory();
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Recepcionista recepcionista) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(recepcionista);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void edit(Recepcionista recepcionista) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(recepcionista);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Recepcionista recepcionista = em.find(Recepcionista.class, id);
            if (recepcionista != null) {
                em.remove(recepcionista);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Recepcionista findRecepcionista(int id) {
        EntityManager em = getEntityManager();
        return em.find(Recepcionista.class, id);
    }

    public List<Recepcionista> findRecepcionistaEntities() {
        EntityManager em = getEntityManager();
        return em.createQuery(
                "SELECT r FROM Recepcionista r", Recepcionista.class
        ).getResultList();
    }
}
