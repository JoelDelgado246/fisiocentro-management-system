package com.joel.centrofisioterapeuta.persistencia;

import com.joel.centrofisioterapeuta.logica.Responsable;

import javax.persistence.*;
import java.util.List;

public class ResponsableJpaController {

    private EntityManagerFactory emf = null;

    public ResponsableJpaController() {
        this.emf = JpaUtil.getEntityManagerFactory();;
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Responsable responsable) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(responsable);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    /* ==========================
       EDIT
       ========================== */
    public void edit(Responsable responsable) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(responsable);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    /* ==========================
       DELETE
       ========================== */
    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Responsable responsable = em.find(Responsable.class, id);
            if (responsable != null) {
                em.remove(responsable);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    /* ==========================
       FIND BY ID
       ========================== */
    public Responsable findResponsable(int id) {
        EntityManager em = getEntityManager();
        return em.find(Responsable.class, id);
    }

    /* ==========================
       FIND ALL
       ========================== */
    public List<Responsable> findResponsableEntities() {
        EntityManager em = getEntityManager();
        TypedQuery<Responsable> query =
                em.createQuery("SELECT r FROM Responsable r", Responsable.class);
        return query.getResultList();
    }

    /* ==========================
       COUNT
       ========================== */
    public int getResponsableCount() {
        EntityManager em = getEntityManager();
        Long count = em.createQuery(
                "SELECT COUNT(r) FROM Responsable r", Long.class
        ).getSingleResult();
        return count.intValue();
    }
}
