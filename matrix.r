##Matrix Operations
A<-matrix(c(30,32,23,34,54,15,26,76,5,34,99,41,7,87,55),ncol=3)
colnames(A)<-c("Ankara","İstanbul","Antalya")
rownames(A)<-paste("3/",12:16,sep='')

B<-matrix(c(130,132,123,134,154,115,126,176,15,134,199,141,17,187,155),ncol=3)
colnames(B)<-c("Adana","İzmir","Bursa")
rownames(B)<-paste("3/",12:16,sep='')

temp_data<-cbind(A,B)
