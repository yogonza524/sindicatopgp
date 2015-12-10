/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.cron;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.jboss.logging.Logger;
import org.quartz.CronScheduleBuilder;
import static org.quartz.JobBuilder.newJob;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import static org.quartz.TriggerBuilder.newTrigger;
import org.quartz.impl.StdSchedulerFactory;

/**
 *
 * @author Gonzalo
 */
public class Inspector implements ServletContextListener  {

     private Scheduler scheduler = null;
     private final Logger LOGGER = Logger.getLogger(Inspector.class);
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.log(Logger.Level.INFO, "Context Initialized!");
        
                int hours = 8 ;
                String cronExpression = "0 0 0/8 1/1 * ? *";
        
                try {
                        // Setup the Job class and the Job group
                        JobDetail job = newJob(CheckPagos.class).withIdentity("CheckPagos", "Group").build();

                        Trigger trigger = newTrigger()
                            .withIdentity("TriggerName", "Group")
                            .withSchedule(CronScheduleBuilder.cronSchedule(cronExpression)) //Ejecutar cada "hours" horas
//                            .withSchedule(CronScheduleBuilder.cronSchedule("0 0/10 * 1/1 * ? *")) //Ejecutar cada 10 minutos
                            .build();

                        // Setup the Job and Trigger with Scheduler & schedule jobs
                        scheduler = new StdSchedulerFactory().getScheduler();
                        scheduler.start();
                        scheduler.scheduleJob(job, trigger);
                }
                catch (SchedulerException e) {
                        LOGGER.log(Logger.Level.FATAL, e.getMessage());
                }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.log(Logger.Level.FATAL, "Quartz ha finalizado");
    }

}
