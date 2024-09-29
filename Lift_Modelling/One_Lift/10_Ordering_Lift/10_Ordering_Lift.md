## Tackling NEEDTOFIX-2

As stated in the version-8 of One_Lift, we need to constrain that the pressed_buttons inside a lift can only point to floors which are mapped with the parent state 
(NEEDTOFIX-2) i.e. state.lift => ( all p : state.lift.pressed_buttons | p in state.floors )  

For this we can simply add a fact constraining the pressed_buttons of a lift to be such :
```
	all s: State | (all p: s.lift.pressed_buttons | p in s.floors)
```

