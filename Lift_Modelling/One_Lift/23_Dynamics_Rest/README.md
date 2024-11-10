## Dynamics - starting from Rest

We have made quite some progress uptil here, however we haven't yet constrained the Lift to start moving on it's own i.e. I had only constrained that the Lift changes from Rest to Moving, when door closes.

However, here we shouldn't have used this condition as this presents a possibility of Lift never starting from rest.<br>
Say a lift was at rest on Zero floor, a button on Second floor is clicked, then the lift must transition to Moving in the next state. To implement this:
```
    // modifying the original condition of transition from rest to moving
    all s: State - last, s1: s.next {
        // constraining that if the lift was open then transition to the Moving state at the same time lift door closes
		( s.lift.status = Rest and s1.lift.status = Moving and s.lift.floor.door = Open ) =>
		( s1.lift.floor.door = Close )

        // and the predicate lift_dirc_status must be true
        ( s.lift.status = Rest and s1.lift.status = Moving ) =>
        ( lift_dirc_status [ s, s1 ] )   
	}
```

Additionally, we must ensure that a stagnant lift the moment a button is pressed on any floor starts moving. For this:
```
    // pseudocode
     
```
