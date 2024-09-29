## Tackling problems - floors set mapped to a state should be complete

To tackle this problem, we add a new constraint to:
- fix the size of state.floors to 3
- ensure that each floor instance is included within this set
```
    all s: State | #s.floors = 3 and
    some f1:Zero | f1 in s.floors and
    some f2:First | f2 in s.floors and
    some f3:Second | f3 in s.floors
```
Now, we shall modify the run statement and execute it multiple times, to check:

1. <p>
```
run{} for 1 State, 1 Lift, exactly 3 Floor
```
![Alloy Output](8_Ordering_Lift_1.png) <br>
The above seems consistent with what we wanted. </p>

2. <p>
```
run{} for 1 State, 1 Lift, exactly 4 Floor
```
![Alloy Output](8_Ordering_Lift_2.png) <br>
A problem is spotted, Second0 state is existing on it's own which shouldn't be the case. A floor should only exist when it's mapped from something ~ **#NEEDTOFIX - 1**<br> 
Rest of the instance seems consistent. </p>

3. <p>
```
run{} for 2 State, 2 Lift, exactly 4 Floor
```
![Alloy Output](8_Ordering_Lift_3.png) <br>
Two new problems are spotted:
- First0 state isn't pointed by any any state, however still exists within the pressed_buttons of Lift0 ~ **#NEEDTOFIX - 2**
- Upon, observing we notice that both the states are pointing to the same three floors only. This is the case with rest of the instances as well, however they should pt. to three floors but those may not necessarily be the same ones ~ **#NEEDTOFIX - 3** <br> 
</p> 

4. <p>
```
run{} for 2 State, 2 Lift, exactly 6 Floor
```
![Alloy Output](8_Ordering_Lift_4.png) <br>
One new problem is spotted:
- the floor at which Lift0 is pointing to is First0, however this doesn't even exist inside the floors mapped to by it's parent state (State1) ~ **#NEEDTOFIX - 4**
</p> 

