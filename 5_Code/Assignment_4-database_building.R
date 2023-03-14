###################################################################################
###                          NOTE FOR SIMONA                                    ###                                                          ###
###  I decided to merge the information on the species table and source         ###
###  table into a new table I named sample_info. I did this because both        ### 
###  tables contain details on the samples I am working on. Then I added        ### 
###  species abbreviation to the phasing stat table in order to link each       ###
###  Species abbreviation with the rest of the information on that species,     ###
###  just as you suggested. The only change I made to your suggestion is        ###
###  merging the species table and source table instead of merging the source   ### 
###  table and the phasing stat table. Please let me know what you think.       ###
###################################################################################


### Loading  package ###
library(DBI)

### Establishing a database connection ####
my_db <- dbConnect(RSQLite::SQLite(), "my_db.db")
class (my_db)

### Creating the sample_ info table in the database  ###
dbExecute(my_db, "CREATE TABLE sample_info (
                        goFlagID varchar(20) NOT NULL,
                        species_name varchar(30),
                        species_family char(20),
                        ploidy varchar(3),
                        species_abbreviation varchar(10),
                        provenance varchar(45),
                        collector varchar(20),
                        database_ID varchar(30),
                        voucher_ID varchar(30),
                        PRIMARY KEY (goFlagID)
                        );")


### importing sample_info data  ###

sample_info <- read.csv("sample_info.csv", stringsAsFactors = FALSE)
names(sample_info)


### Plugging sample_info data into table  ###

dbWriteTable(my_db, "sample_info", sample_info, append = TRUE)


### Sending queries to the database  ###
dbGetQuery(my_db, "SELECT * FROM sample_info LIMIT 10;")



###  Creating the Phasing_stats_table in the database ###
dbExecute(my_db, "CREATE TABLE Phasing_stats_table (
                        species_abbreviation varchar(10) NOT NULL PRIMARY KEY,
                        goFlagID varchar(20) NOT NULL,
                        no_of_loci INTEGER,
                        no_var_loc INTEGER,
                        no_nonvar_loc INTEGER,
                        no_phased_loci INTEGER,
                        avg_length float,
                        avg_nonvar float,
                        avg_het float,
                        FOREIGN KEY (goFlagID) REFERENCES sample_info(goFlagID)
                        );")


### importing Phasing_stats_table data  ###

Phasing_stats_table <- read.csv("Phasing_stats_table.csv", stringsAsFactors = FALSE)
names(Phasing_stats_table)


### Plugging Phasing_stats_table data into table  ###

dbWriteTable(my_db, "Phasing_stats_table", Phasing_stats_table, append = TRUE)


###  Sending queries to the database  ###
dbGetQuery(my_db, "SELECT * FROM Phasing_stats_table LIMIT 10;")