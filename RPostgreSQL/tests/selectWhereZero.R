
## selectWhereZero test
##
## test for the 'Issue 1' on the Google Code issue log
## this was reported in June and fixed by Joe Conway (svr committ r100)
##
## Assumes that
##  a) PostgreSQL is running, and
##  b) the current user can connect
## both of which are not viable for release but suitable while we test
##
## Dirk Eddelbuettel, 03 Oct 2009

## only run this if this env.var is set correctly
if (Sys.getenv("POSTGRES_USER") != "" & Sys.getenv("POSTGRES_HOST") != "" & Sys.getenv("POSTGRES_DATABASE") != "") {

    ## try to load our module and abort if this fails
    stopifnot(require(RPostgreSQL))
    stopifnot(require(datasets))

    ## load the PostgresSQL driver
    drv <- dbDriver("PostgreSQL")

    ## connect to the default db
    con <- dbConnect(drv,
                     user=Sys.getenv("POSTGRES_USER"),
                     password=Sys.getenv("POSTGRES_PASSWD"),
                     host=Sys.getenv("POSTGRES_HOST"),
                     dbname=Sys.getenv("POSTGRES_DATABASE"),
                     port=ifelse((p<-Sys.getenv("POSTGRES_PORT"))!="", p, 5432))


    if (dbExistsTable(con, "tmpirisdata")) {
        print("Removing tmpirisdata\n")
        dbRemoveTable(con, "tmpirisdata")
    }

    dbWriteTable(con, "tmpirisdata", iris)

    ## run a simple query and show the query result
    res <- dbGetQuery(con, "select * from tmpirisdata where \"Species\"=0")
    print(res)

    ## cleanup
    if (dbExistsTable(con, "tmpirisdata")) {
        print("Removing tmpirisdata\n")
        dbRemoveTable(con, "tmpirisdata")
    }

    ## and disconnect
    dbDisconnect(con)
    cat("PASS:  reached to the end of the test code without segmentation fault\n")
}
