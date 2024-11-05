## Dynamics - Closing Door

In this I try to implement the dynamics of closing of door, building upon previous implementation.
As discussed, I specify the movement and then imply the scenario which must be met for the movement to occur.

Keeping this in mind, I note down the pseudocode of criterias which must be met:
```
if ( s.lift.floor.door = Open and s1.lift.floor.door = Close ):
  - ensure lift is at rest and moves in the direction accordingly (for now, looking to implement basic sweep)
  - either the floor should be within the pressed_buttons or the floor up/down button should be pressed
  - if the floor was within pressed_buttons of the lift then must be removed
  - and/or if the button in the dirc of the lift was pressed then it must be unpressed after
  - rest of the s.lift.floor should essentially remain the same, except for the door
  - must update only this floor linked with the state 
```

Upon modelling using the design of Opening of door, and modifying this, as can be seen in [old_Lift.als](old_Lift.als), and running the analyzer for satisfiable instance I get:

![1.png](1.png)
