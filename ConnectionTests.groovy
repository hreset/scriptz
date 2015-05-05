this.class.classLoader.rootLoader.addURL(new URL("file:///ojdbc6.jar"))

import groovy.sql.Sql

/**
 * Simple script to test database for dropping connections.
 *
 * @author Henson
 * @date   2015.05.01
 */

Sql.withInstance("jdbc:oracle:thin:@SOMESERVER:15215:SOMETNS",
                 "henson", "PASSWORD", "oracle.jdbc.driver.OracleDriver")
                {
                     while (minuteDelay <= 120) {  
                         // Sleep increasing number of minutes
                         Thread.sleep(1000 * 60 * minuteDelay) 
                         Date date = new Date()
                         it.eachRow(query) {
                             println "After ${minuteDelay} minutes - ${it.cnt} (${date})"
                         }
                         minuteDelay += 5
                     }
                 }
