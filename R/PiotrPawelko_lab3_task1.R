library(ISLR)
data(College)

#Task 1

names <- rownames(College)
texas <- grep("Texas", names)
length(texas)

univeristies <- grep("University", names)
length(univeristies)
colleges <- grep("College", names)
length(colleges)
