#INITIALIZING
setwd("F:/pm/project")
all_dat <- read.csv("pml-training.csv")[,-1]
test_dat <- read.csv("pml-testing.csv")[,-1]

#CLEANING, DELETING FEATURES W/ NA, TIMESTAMP/IDENTITY FEATURES
all_dat[all_dat == ""] <- NA

na_idx <- which(colSums(is.na(all_dat)) != 0)
identime_idx <- 1:6
zero_idx <- nearZeroVar(all_dat)

newdata1 <- all_dat[,-c(identime_idx, zero_idx, na_idx)]
test1 <- test_dat[,-c(identime_idx, zero_idx, na_idx)]

newdata1_Corr <- cor(newdata1[,-ncol(newdata1)])
highCorr <- findCorrelation(newdata1_Corr, 0.90)
newdata2 <- newdata1[, -highCorr]

all_dat_cleaned <- newdata2
test_dat_cleaned <- test1[,-highCorr]



library(caret)

ctrl <- rfeControl(functions = rfFuncs,
                   method = "cv",
                   verbose = FALSE)
print(Sys.time())
rffit <- rfe(all_dat_cleaned[,-ncol(all_dat_cleaned)], all_dat_cleaned$classe,
                sizes = c(10, 20, 30, 40),
                 rfeControl = ctrl)
print(Sys.time())

(error <- (1 - subset(rffit$results, Variables==40)$Accuracy))
plot(rffit, type = c("g", "o"))
densityplot(rffit)
predict(rffit$fit,test_dat_cleaned)
