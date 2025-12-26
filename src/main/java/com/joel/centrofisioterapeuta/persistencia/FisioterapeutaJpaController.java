package com.joel.centrofisioterapeuta.persistencia;

import com.joel.centrofisioterapeuta.logica.Fisioterapeuta;

import javax.persistence.*;
import java.util.List;

public class FisioterapeutaJpaController {

    private EntityManagerFactory emf = null;

    public FisioterapeutaJpaController() {
        this.emf = JpaUtil.getEntityManagerFactory();
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Fisioterapeuta fisio) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(fisio);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void edit(Fisioterapeuta fisio) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(fisio);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Fisioterapeuta fisio = em.find(Fisioterapeuta.class, id);
            if (fisio != null) {
                em.remove(fisio);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Fisioterapeuta findFisioterapeuta(int id) {
        EntityManager em = getEntityManager();
        return em.find(Fisioterapeuta.class, id);
    }

    public List<Fisioterapeuta> findFisioterapeutaEntities() {
        EntityManager em = getEntityManager();
        return em.createQuery(
                "SELECT f FROM Fisioterapeuta f", Fisioterapeuta.class
        ).getResultList();
    }

    public Fisioterapeuta findFisioterapeutaByUsuario(int idUsuario) {
        EntityManager em = getEntityManager();
        try {
            Query q = em.createQuery(
                    "SELECT f FROM Fisioterapeuta f WHERE f.usuario.idUsuario = :idUsuario"
            );
            q.setParameter("idUsuario", idUsuario);

            List<Fisioterapeuta> resultados = q.getResultList();
            if (resultados != null && !resultados.isEmpty()) {
                return resultados.get(0);
            }
            return null;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}
