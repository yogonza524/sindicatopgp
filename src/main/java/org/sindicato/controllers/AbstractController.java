/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.controllers;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.hibernate.Criteria;
import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.jboss.logging.Logger;

/**
 * Abstract Class to implements the controller to get DataBase entities
 * @author Gonza
 * @param <T>
 */
public abstract class AbstractController<T> {
    
    /**
     *
     */
    protected static SessionFactory sf;
    
    private Logger Log = Logger.getLogger(AbstractController.class);
    /**
     *
     */
    protected boolean composite = false;
    
    /**
     * List all object in a table
     * @return List of entity object for table T
     */
    public List<T> all(){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        List<T> l = s.createCriteria(classResult()).list();
        beforeAll();
        if(composite){
            for(T o : l){
                o = initialize(o);
            }
        }
        afterAll();
        s.close();
        return l;
    }
    
    /**
     * Get an object from DataBase by key Id
     * @param key represents the id for object entity. If the entity is complex then the id must be like "id.id" for example.
     * @param id represents the id for the table. Can be an Integer, String, etc. Depends the Table design.
     * @return Entity object width the fields initialized with Hibernate
     */
    public T byId(String key,Object id){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        T result = (T)s.createCriteria(this.classResult()).add(Restrictions.eq(key, id)).setMaxResults(1).uniqueResult();
        s.close();
        //result = this.initialize(result);
        return result;
    }
    
    /**
     * Delete obj in DataBase
     * @param obj
     * @return true if obj was removed successfuly. False in otherwise.
     */
    public boolean remove(T obj){
        sf = HibernateUtil.getSessionFactory();
        boolean resp = false;
        try {
            Session s = sf.openSession();
            Transaction tx = s.beginTransaction();
            s.delete(obj);
            tx.commit();
            s.close();
            resp = true;
        } catch (Exception e) {
            Log.log(Logger.Level.FATAL, e.getMessage());
            e.printStackTrace();
        }
        return resp;
    }

    /**
     * Persist obj in DataBase
     * @param obj
     * @return true if obj was added suyccessfuly- False in otherwise.
     */
    public boolean add(T obj){
        sf = HibernateUtil.getSessionFactory();
        boolean resp = false;
        try {
            Session s = sf.openSession();
            Transaction tx = s.beginTransaction();
            s.persist(obj);
            tx.commit();
            s.close();
            resp = true;
        } catch (Exception e) {
            Log.log(Logger.Level.FATAL, e.getMessage());
            e.printStackTrace();
        }
        return resp;
    }
    
    /**
     * Update obj in DataBase
     * @param obj
     * @return true if updated obj successfuly, false in otherwise
     */
    public boolean update(T obj){
        sf = HibernateUtil.getSessionFactory();
        boolean resp = false;
        try {
            Session s = sf.openSession();
            Transaction tx = s.beginTransaction();
            s.clear();
            s.update(obj);
            tx.commit();
            s.close();
            resp = true;
        } catch (Exception e) {
            Log.log(Logger.Level.FATAL, e.getMessage());
            e.printStackTrace();
        }
        return resp;
    }
    
    /**
     * Gets the last object of the table , if there initializes its attributes of entity type . But returns null .
     * @param key
     * @return Last object with the key param if exists. Otherwise returns null.
     */
    public T getLast(String key){
        sf = HibernateUtil.getSessionFactory();
        T result = null;
        try {
            Session s = sf.openSession();
            result = (T) s.createCriteria(classResult()).addOrder(Order.desc(key)).setMaxResults(1).uniqueResult();
            s.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }     
        
    public T byRestrictions(List<Criterion> restrictions){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria cri = s.createCriteria(this.classResult());
        Iterator i = restrictions.iterator();
        while(i.hasNext()){
            Criterion c = (Criterion)i.next();
            cri.add(c);
        }
        T result = (T) cri.setMaxResults(1).uniqueResult();
        s.close();
        result = this.initialize(result);
        return result;
    }
    
    public List<T> listByRestrictions(List<Criterion> restrictions){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria cri = s.createCriteria(this.classResult());
        Iterator i = restrictions.iterator();
        while(i.hasNext()){
            Criterion c = (Criterion)i.next();
            cri.add(c);
        }
        List<T> result = (List<T>) cri.list();
        s.close();
        return result;
    }
    
        
    /**
     *
     * @return
     */
    public abstract Class<T> classResult();
    
    /**
     * Hibernate Initialization for the entity
     * @param entity
     * @return the same object but if any of their attributes has the notation "Entity " that attribute will be initialized by Hibernate
     */
    public  T initialize(T entity){
            if(entity != null){
                    for(Field f : entity.getClass().getDeclaredFields()){
                            Class type = f.getType();
                            Annotation[] notes = type.getAnnotations();
                            for(Annotation n : notes){
                                    if(n.toString().contains("Entity")){
                                            Hibernate.initialize(f);
                                    }
                            }
                    }
            }
            return entity;
    }
    
    /**
     * Template method to execute before All method <br />
     * template method to be overridden in the subclass
     */
    public void beforeAll(){}
    
    /**
     * Tremplate method to execute after All method <br />
     * template method to be overridden in the subclass
     */
    public void afterAll(){}
    
    public void setComposite(Boolean comp){
        this.composite = comp;
    }
    
    public List<T> widthRestrictions(Map<String,Object> restrictions){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria cri = s.createCriteria(this.classResult());
        for(Map.Entry<String,Object> entry : restrictions.entrySet()){
            cri.add(Restrictions.eq(entry.getKey(), entry.getValue()));
        }
        List<T> output = cri.list();
        s.close();
        return output;
    }
    
    public T withParams(Map<String,Object> restrictions){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria cri = s.createCriteria(this.classResult());
        for(Map.Entry<String,Object> entry : restrictions.entrySet()){
            cri.add(Restrictions.eq(entry.getKey(), entry.getValue()));
        }
        T output = (T) cri.setMaxResults(1).uniqueResult();
        s.close();
        return output;
    }
    
    public List<T> widthRestrictionsLike(Map<String,Object> restrictions){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria cri = s.createCriteria(this.classResult());
        for(Map.Entry<String,Object> entry : restrictions.entrySet()){
            cri.add(Restrictions.like(entry.getKey(),"%" + entry.getValue() + "%"));
        }
        List<T> output = cri.list();
        s.close();
        return output;
    }
    
    public List<T> widthOneRestriction(String key, Object value){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria cri = s.createCriteria(this.classResult());
        cri.add(Restrictions.eq(key, value));
        List<T> output = cri.list();
        s.close();
        return output;
    }
    
    public List<T> widthOneRestrictionLike(String key, String value){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria cri = s.createCriteria(this.classResult());
        cri.add(Restrictions.like(key,"%" + value + "%"));
        List<T> output = cri.list();
        s.close();
        return output;
    }
    
    public List<T> allOrderBy(String key, org.sindicato.enums.Order order){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria c = s.createCriteria(this.classResult());
        c.addOrder(order.equals(org.sindicato.enums.Order.ASC)? Order.asc(key): Order.desc(key));
        List<T> output = c.list();
        s.close();
        return output;
    }
    
    public List<T> withRestrictionsOrderBy(Map<String,Object> restrictions,String key, org.sindicato.enums.Order order){
        sf = HibernateUtil.getSessionFactory();
        Session s = sf.openSession();
        Criteria cri = s.createCriteria(this.classResult());
        for(Map.Entry<String,Object> entry : restrictions.entrySet()){
            cri.add(Restrictions.eq(entry.getKey(), entry.getValue()));
        }
        cri.addOrder(order.equals(org.sindicato.enums.Order.ASC)? Order.asc(key): Order.desc(key));
        List<T> output = cri.list();
        s.close();
        return output;
    }
    
    public List callProcedure(String query, Map<String,Object> params){
        sf = HibernateUtil.getSessionFactory();
        List result = null;
        try {
            Session s = sf.openSession();
            Transaction tx = s.beginTransaction();
            Query consulta = s.createSQLQuery(query);
                if (params != null) {
                    Iterator it = params.entrySet().iterator();
                    while (it.hasNext()) {
                        Map.Entry pair = (Map.Entry)it.next();
                        consulta.setParameter((String)pair.getKey(), pair.getValue());
                    }
                }
                result = consulta.list();
                tx.commit();
                s.close();
            } catch (Exception e) {
        }
        return result;
    }
}
