

## Read Training data
print("Read... Data")
TrainDataDir<-"./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train"
TrainData<-read.table(paste(TrainDataDir,"/X_train.txt",sep=""), comment.char="",sep="")
TrainSubject<-read.table(paste(TrainDataDir,"/subject_train.txt",sep=""), comment.char="",sep="")
TrainActivity<-read.table(paste(TrainDataDir,"/y_train.txt",sep=""), comment.char="",sep="")

## Read Test data
TestDataDir<-"./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test"
TestData<-read.table(paste(TestDataDir,"/X_test.txt",sep=""), comment.char="",sep="")
TestSubject<-read.table(paste(TestDataDir,"/subject_test.txt",sep=""), comment.char="",sep="")
TestActivity<-read.table(paste(TestDataDir,"/y_test.txt",sep=""), comment.char="",sep="")

## Read activity lables
ActvityLabes<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", comment.char="",sep="")
n2a<-function(labels,data){
    theI<-match(data,labels$V1)
    labels[theI,2]
}
TrainActivityNames<-sapply(TrainActivity,function (x) n2a(ActvityLabes,x))
TestActivityNames<-sapply(TestActivity,function (x) n2a(ActvityLabes,x))

print("Processing Data")
## columns containing the required data
Featurenames<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", comment.char="",sep="")
RequiredColums<-c(1:6,41:46,121:126)

TrainData2<-TrainData[,RequiredColums]
TestData2<-TestData[,RequiredColums]
rm(TrainData)
rm(TestData)
## attach subject and activity for each record

TrainData3<-cbind(TrainSubject,TrainActivityNames,TrainData2)
TestData3<-cbind(TestSubject,TestActivityNames,TestData2)
rm(TrainData2)
rm(TestData2)
## give names to each column
ColName<-c("Subject","Activity",as.character(Featurenames[RequiredColums,2]))
colnames(TrainData3)<-ColName
colnames(TestData3)<-ColName
Data1<-merge(TrainData3,TestData3,all=1)

## another dataset, store average for each subject and each activit
Factors<-interaction(Data1$Subject,Data1$Activity)
tt_data<-split(Data1,Factors)
Data2<-lapply(tt_data,function(x) colMeans(x[,3:20]))

print("Saving Data")
save("Data1",file="Data1")

save("Data2",file="Data2")

rm(list=ls())