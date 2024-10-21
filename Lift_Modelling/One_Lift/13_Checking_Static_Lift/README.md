## Static Lift Completion - Verification

So, uptil here, we had step-by-step discussed, builded and debugged the features of a lift, including adding ordering in between the states.

Now, before we move to the dynamic aspects of lift, we shall want to verify that the lift is behaving as we intended. For this, one might want to count the number of
satisfiable instances and compare it with what the number must be logically. If both are the same for multiple conditions, one may say that the modelling of a static 
lift is completed.

However, neither Alloy, nor the analyzer supports this functionality (until now) to give the number of satisfiable instances. After much deliberation I decided to write a script in java to run the .jar file of Alloy analyzer iteratively, this can be found [AlloyInstanceCounter.java](./AlloyInstanceCounter.java).
<br> Then I used the commands to compile, and subsequently run the files:
```
javac -cp .:alloy4.2_2015-02-22.jar AlloyInstanceCounter.java
java -cp .:alloy4.2_2015-02-22.jar AlloyInstanceCounter
```

Now, we shall run this for multiple conditions:

1. `run{} for 1 State, 1 Lift, 3 Floor` <br>
   
2. 
 
