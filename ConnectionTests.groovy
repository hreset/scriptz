#!/usr/bin/env groovy

/**
 * Simple script to try executing a SQL query on a database connection
 * after an ever increasing amount of minutes -- to see if it drops.
 *
 * Example use: 
 * ConnectionTests -u henson -p p4ssw0rd -c jdbc:oracle:thin:@localhost:1521:XE
 * 
 * @author henson.reset@gmail.com
 * @version 2015.05.05
 */

import groovy.sql.Sql
import groovy.util.CliBuilder

/**
 * Try executing a query on the database connection after an ever-increasing
 * amount of minutes, starting at startVal and ending at maxVal.
 *
 * @param    user        Username for database connection
 * @param    pass        Password for database connection
 * @param    connString  Connection string for database connection
 * @param    oraDriver   String representing Oracle driver to use
 * @param    startVal    Lowest minute limit to start testing at
 * @param    delta       Increment to advance from startVal to maxVal
 * @param    maxVal      Highest minute limit to run tests at
 *
 * @return null if fails, Integer of minutes representing last successful delay
 */
Integer runTests(String user, String pass, String connString, String oraDriver,
    int startVal=0, int delta=5, int maxVal=120)
{
    Integer minuteDelay // Using Integer so it can be null
    Date date
    // Test SQL statement to run. Can be anything. 
    String query = "select count(*) cnt from spriden " +
        "where upper(spriden_last_name) = 'STURGILL'"
     
    try {
        Sql.withInstance(connString, user, pass, oraDriver) {    
            for(minuteDelay = new Integer(startVal); 
                minuteDelay.intValue() < maxVal; 
                minuteDelay = new Integer(minuteDelay.intValue() + delta)) {
                
                println "Waiting ${minuteDelay} minutes before trying next test."
                Thread.sleep(1000 * 60 * minuteDelay)
                date = new Date()
                
                it.eachRow(query) {
                    println "Executed query successfully after ${minuteDelay} " +
                        "minutes. (${date})"
                }
                
            }      
        }
    } catch (java.sql.SQLRecoverableException e) {
        
    }
    
    return minuteDelay
}

/** Driver for implicitly created ConnectionTests class. */
static void main(String[] args) 
{
    /* constants */
    final int START_VAL = 55
    final int DELTA = 5
    final int MAX_VAL = 120
   
    String oraDriver = "oracle.jdbc.driver.OracleDriver"
    Integer maxDelta
    
    /* Define command-line options. */
    def cli = new CliBuilder(usage:'ConnectionTests -u <username> -p <pass> ' +
        '-c <connString>', header:'Parameters:')                      
    cli.u(args:1, argName:'user', 'Username for database connection')
    cli.p(args:1, argName:'pass', 'Password for database connection')
    cli.c(args:1, argName:'connString', 'Connection string for database connection.')
    def options = cli.parse(args)

    /* If we got the parameters we need, start the tests! */   
    if (!(options.u && options.p && options.c)) {
        cli.usage()
    } else {
        println "Starting connection tests.."
        maxDelta = runTests(options.u, options.p, options.c, oraDriver, 
            START_VAL, DELTA, MAX_VAL)
        if (maxDelta) {
            println "Could not connect once delay reached ${maxDelta} minutes."
        } else {
            println 'Could not connect to database. Are you connected to VPN?'
        }
    }
}


