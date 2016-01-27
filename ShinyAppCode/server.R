library(e1071)
library(shiny)
library(caret)
library(kernlab)
data(spam)

set.seed(32342)

inTrain <- createDataPartition(y=spam$type, p=0.75, list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

myPredict <- function(chosenColumns){
    set.seed(32343)
    
    allNeededColumns = c(chosenColumns, "type")
    
    trainingTemp = training[, allNeededColumns]
    modelFit <- train(type ~., data=trainingTemp, method="glm")
    
    testingTemp = testing[, allNeededColumns]
    predictions <- predict(modelFit, newdata=testingTemp)
    
    k = confusionMatrix(predictions,testingTemp$type)
    a = capture.output(k$table)
    b = capture.output(k$overall["Accuracy"])
    cat(sprintf("%s\n%s\n%s\n%s\n\n%s\n%s", a[1], a[2], a[3], a[4], b[1], b[2]))
}

shinyServer(
  function(input, output) {
    output$oid1 = renderPrint({myPredict(input$id2)})
  }
)
