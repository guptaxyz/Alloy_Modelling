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

Upon modelling this as can be seen in [old_Lift.als](old_Lift.als), and running the analyzer for satisfiable instance I get:

![old](old.png)

On analyzing this instance, one can notice that in the next state (state1), the doors of Second open, whereas, this shouldn't be happening as the lift isn't on this floor. Looking back at the psuedocode, I realise that, I had only constrained opening of door for the floor on which the lift is and missed the rest of the floors.

Now, I modify the prev, to constrain the opening of doors to only if the lift is at the given floor, as can be found in [Lift.als](Lift.als).

