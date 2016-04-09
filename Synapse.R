library()
search()

source("http://depot.sagebase.org/CRAN.R")
pkgInstall("synapseClient")

require(synapseClient)
synapseLogin('example@user.com', 'samplePassword')


search()



setHook(
  packageEvent("synapseClient", "attach"),
  function(...){
    ## log me in to Synapse
    ## if you have your information in a .synapseConfig file
    synapseLogin('erokan@gmail.com','6239604')
    
    ## or if you do not have your .synapseConfig file set up
    ## synapseLogin('example@user.com', 'samplePassword')
  }
)


## Define information to store in the entity
myProject <- Project(name = paste("Test Project", gsub(":", "", Sys.time(), fixed=T), sep=" "))

## Store the project on Synapse
myProject <- synStore(myProject)



## Create a Folder under the Project
myFolder <- Folder(name = "figures", parentId = myProject$properties$id)
myFolder <- synStore(myFolder)


## GET THE FILE WITH RESPONSES
respFile <- synGet('syn1906479')
respDF <- read.delim(file=respFile@filePath, header=T)

## GET THE EXPRESSION DATA
exprFile <- synGet('syn1906480')
exprDF <- read.delim(file=getFileLocation(exprFile), header=T, row.names="X")


respPvals <- apply(exprDF, 1, function(x){
  fit <- summary(lm(x ~ respDF$response))
  return(fit$coefficients[2, 4])
})



plotPath <- file.path(tempdir(), "pvalueHistogram.png")
png(plotPath)
hist(respPvals, main="", xlab="P-value for random response")
dev.off()

## STORE IN OUR FOLDER WE CREATED EARLIER WITH TWO ANNOTATIONS
plotFile <- File(path=plotPath, parentId=myFolder$properties$id)
synSetAnnotations(plotFile) <- list(model="lm", response="random")
plotFile <- synStore(plotFile)



onWeb(plotFile)




## FROM THE PREVIOUS EXAMPLE, WE HAVE THE FOLLOWING SYNAPSE OBJECTS IN MEMORY:
##   exprFile
##   respFile
##   plotFile

## CODE WHICH WAS USED TO GENERATE THE P-VALUE HISTOGRAM
codeFile <- synGet('syn1910084')

## LINK THESE TOGETHER WITH PROVENANCE
act <- Activity(name="p-value histogram",
                used=list(
                  list(entity=codeFile, wasExecuted=T),
                  list(entity=exprFile, wasExecuted=F),
                  list(entity=respFile, wasExecuted=F)))
act <- synStore(act)
generatedBy(plotFile) <- act
plotFile <- synStore(plotFile)


##Using 'synStore' (a shortcut)
plotFile <- synStore(plotFile, activityName="p-value histogram", 
                     used=list(
                       list(entity=codeFile, wasExecuted=T),
                       list(entity=exprFile, wasExecuted=F),
                       list(entity=respFile, wasExecuted=F)))


synapseQuery('SELECT id, name FROM entity WHERE parentId=="syn1901847"')

qTcga <- synapseQuery('SELECT id, name FROM entity WHERE parentId=="syn2812925" AND acronym=="BRCA"')
qTcga

qBrca <- synapseQuery(paste('SELECT id, name FROM entity WHERE parentId=="', qTcga$entity.id, '" AND platform=="IlluminaHiSeq_RNASeqV2"', sep=""))
qBrca

myFileObject <- synGet("syn417812")


evaluation  <- synGetEvaluation(1111111)

submission  <- submit(evaluation, entity, teamName="More random than you")



df<-data.frame("n"=c(1.1, 2.2, 3.3),
               "c"=c("foo", "bar", "bar"),
               "i"=as.integer(c(10,10,20)))

tcresult<-as.tableColumns(df)
cols<-tcresult$tableColumns

fileHandleId<-tcresult$fileHandleId

cols[[2]]@maximumSize<-as.integer(20)


projectId<-"syn5870657"
schema<-TableSchema(name="aschema", parent=projectId, columns=cols)
table<-Table(schema, fileHandleId)
table<-synStore(table, retrieveData=TRUE)


schemaId<-propertyValue(table@schema, "id")
queryResult<-synTableQuery(sprintf("select * from %s where c='bar'", schemaId))


queryResult@values[2,"n"]<-pi
table<-synStore(queryResult, retrieveData=TRUE)
table@values


rowsToDelete<-synTableQuery(sprintf("select * from %s where c='foo'", schemaId)) synDeleteRows(rowsToDelete)

synDelete(schemaId)

df<-data.frame("n"=c(1.1, 2.2, 3.3),
               "c"=c("foo", "bar", "bar"),
               "i"=as.integer(c(10,10,20)))


##JSON
library("RJSON")
json_file <- "https://data.ny.gov/api/views/9a8c-vfzj/rows.json"
json_data <- fromJSON(file=json_file)


