library(shiny)
library(caret)
library(kernlab)
data(spam)

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
    k$overall["Accuracy"]
}

shinyServer(
  function(input, output) {
    output$oid1 = renderPrint({myPredict(input$id2)})
  }
)
