package com.grupo04.app.dao;

import com.grupo04.app.model.Tarea;
import com.grupo04.app.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class TareaDAO {

    public void guardar(Tarea tarea) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(tarea);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    public List<Tarea> listarTodas() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Tarea ORDER BY completada ASC, fechaVencimiento DESC", Tarea.class).list();
        }
    }

    public List<Tarea> listarPorEstado(boolean completada) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Tarea WHERE completada = :completada ORDER BY fechaVencimiento DESC", Tarea.class)
                    .setParameter("completada", completada)
                    .list();
        }
    }

    public Tarea obtenerPorId(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Tarea.class, id);
        }
    }

    public void actualizar(Tarea tarea) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(tarea);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    public void eliminar(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Tarea tarea = session.get(Tarea.class, id);
            if (tarea != null) {
                session.remove(tarea);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    public long contarTareas() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT COUNT(*) FROM Tarea", Long.class).uniqueResult();
        }
    }

    public long contarCompletadas() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT COUNT(*) FROM Tarea WHERE completada = true", Long.class).uniqueResult();
        }
    }
}
