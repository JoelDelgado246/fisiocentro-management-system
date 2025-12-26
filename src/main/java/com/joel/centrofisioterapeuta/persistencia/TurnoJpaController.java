package com.joel.centrofisioterapeuta.persistencia;

import com.joel.centrofisioterapeuta.logica.Paciente;
import com.joel.centrofisioterapeuta.logica.Turno;

import javax.persistence.*;
import java.util.List;

public class TurnoJpaController {

    private EntityManagerFactory emf = null;

    public TurnoJpaController() {
        this.emf = JpaUtil.getEntityManagerFactory();
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Turno turno) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(turno);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void edit(Turno turno) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(turno);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Turno findTurno(int id) {
        EntityManager em = getEntityManager();
        return em.find(Turno.class, id);
    }

    public List<Turno> findTurnoEntities() {
        EntityManager em = getEntityManager();
        return em.createQuery(
                "SELECT t FROM Turno t", Turno.class
        ).getResultList();
    }

    public List<Turno> findTurnosByFisioterapeuta(int idFisioterapeuta) {
        EntityManager em = getEntityManager();
        try {
            Query q = em.createQuery(
                    "SELECT t FROM Turno t WHERE t.fisio.id = :idFisio ORDER BY t.fechaTurno DESC, t.horaTurno DESC"
            );
            q.setParameter("idFisio", idFisioterapeuta);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Turno turno = em.find(Turno.class, id);
            if (turno != null) {
                em.remove(turno);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
