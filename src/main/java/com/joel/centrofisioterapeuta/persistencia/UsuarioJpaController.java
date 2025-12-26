package com.joel.centrofisioterapeuta.persistencia;

import com.joel.centrofisioterapeuta.logica.Usuario;

import javax.persistence.*;
import java.util.List;

public class UsuarioJpaController {

    private EntityManagerFactory emf = null;

    public UsuarioJpaController() {
        this.emf = JpaUtil.getEntityManagerFactory();
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Usuario usuario) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(usuario);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void edit(Usuario usuario) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(usuario);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Usuario usuario = em.find(Usuario.class, id);
            if (usuario != null) {
                em.remove(usuario);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Usuario findUsuario(int id) {
        EntityManager em = getEntityManager();
        return em.find(Usuario.class, id);
    }

    public List<Usuario> findUsuarioEntities() {
        EntityManager em = getEntityManager();
        return em.createQuery(
                "SELECT u FROM Usuario u", Usuario.class
        ).getResultList();
    }

    public Usuario findByNombreUsuario(String nombreUsuario) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM Usuario u WHERE u.nombreUsuario = :nombre",
                            Usuario.class
                    ).setParameter("nombre", nombreUsuario)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

//    public Usuario validarUsuario(String username, String password) {
//        EntityManager em = getEntityManager();
//        try {
//            TypedQuery<Usuario> query = em.createQuery(
//                    "SELECT u FROM Usuario u WHERE u.nombreUsuario = :user AND u.contrasenia = :pass",
//                    Usuario.class
//            );
//            query.setParameter("user", username);
//            query.setParameter("pass", password);
//
//            return query.getSingleResult();
//        } catch (NoResultException e) {
//            return null;
//        } finally {
//            em.close();
//        }
//    }
}
