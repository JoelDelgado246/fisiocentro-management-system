package com.joel.centrofisioterapeuta.persistencia;

import com.joel.centrofisioterapeuta.logica.Horario;

import javax.persistence.*;
import java.util.List;

public class HorarioJpaController {

    private EntityManagerFactory emf = null;

    public HorarioJpaController() {
        this.emf = JpaUtil.getEntityManagerFactory();
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Horario horario) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(horario);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void edit(Horario horario) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(horario);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Horario horario = em.find(Horario.class, id);
            if (horario != null) {
                em.remove(horario);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Horario findHorario(int id) {
        EntityManager em = getEntityManager();
        return em.find(Horario.class, id);
    }

    public List<Horario> findHorarioEntities() {
        EntityManager em = getEntityManager();
        return em.createQuery(
                "SELECT h FROM Horario h", Horario.class
        ).getResultList();
    }
}
