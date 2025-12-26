package com.joel.centrofisioterapeuta.persistencia;

import com.joel.centrofisioterapeuta.logica.Paciente;

import javax.persistence.*;
import java.util.List;

public class PacienteJpaController {

    private EntityManagerFactory emf = null;

    public PacienteJpaController() {
        this.emf = JpaUtil.getEntityManagerFactory();
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Paciente paciente) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(paciente);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void edit(Paciente paciente) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(paciente);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Paciente paciente = em.find(Paciente.class, id);
            if (paciente != null) {
                em.remove(paciente);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Paciente findPaciente(int id) {
        EntityManager em = getEntityManager();
        return em.find(Paciente.class, id);
    }

    public List<Paciente> findPacienteEntities() {
        EntityManager em = getEntityManager();
        TypedQuery<Paciente> query =
                em.createQuery("SELECT p FROM Paciente p", Paciente.class);
        return query.getResultList();
    }

    public int getPacienteCount() {
        EntityManager em = getEntityManager();
        Long count = em.createQuery(
                "SELECT COUNT(p) FROM Paciente p", Long.class
        ).getSingleResult();
        return count.intValue();
    }
}
