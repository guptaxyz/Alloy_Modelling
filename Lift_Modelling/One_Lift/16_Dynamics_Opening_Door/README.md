## Dynamics - Opening Door

In this I try to implement the dynamics of opening of door, building upon previous implementation.
As discussed, I specify the movement and then imply the scenario which must be met for the movement to occur.

Keeping this in mind, I note down the pseudocode of criterias which must be met:
```
if ( s.lift.floor.door = Open and s1.lift.floor.door = Close ):
  - ensure lift is at rest and moves to the same direction as before and after opening of door
  - either the floor should be within the pressed_buttons or the floor up/down button should be pressed
  - the s.lift.floor should essentially remain the same, except for the door
  - must update only this floor linked with the state 
```

Upon modelling this as can be seen in ![old_Lift.als](old_Lift.als), and simulating for satisfiable instance we get:

![old](old.png)
