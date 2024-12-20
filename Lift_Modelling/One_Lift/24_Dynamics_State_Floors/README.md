## Dynamics - Floors of a State

We are almost on the the verge of completing a one lift system, however we are yet to constrain the floors of a state.

I haven't yet talked about how and when should the floors change. Now, when we think about it, we had previously constrained the floors to be 3, and exactly one Zero, First and Second to be there in each state. This time, however we would further want that any two adjacent states can only have different floors state if the floor (either Zero, First or Second) is in essence different, either the buttons or the door.

We do this in order to minimize the no. of states in existence, as well as ensure clarity of movement.

For this:
```
// pseudocode
// s: State, s1: s.next,
for all f: s.floors - s1.floors, f1: s1.floors:
    if f.value = f1.value:
        // now, we have ensured that we are talking with the states which have the same value
        // and one of which got removed from s and other added in s1
        - not ( f.up = f1.up and f.down = f1.down and f.door = f1.door )  
```

Implementing this, and rerunning, this eems fine, however, I notice another problem - <br> 

When I try to go to first floor from the ground and open doors, starting from Rest, on the basis that only the first floor button is pressed. The lift is going up, however, it won't open doors, and hence, I'm getting no satisfiable instances. <br>
I'm getting this as I had constrained the lift to open doors only either the floor was in the pressed_buttons of the lift or the lift button in the dirc of the lift is pressed. But here, I realise that the dirc condition stands only if some floors exist above the current one, which need to be visited else should be discarded. <br>

For this I write another predicate which returns True/False, simply based upon a state s, to tell whether to take dirc into consideration:
```
// defined as helper function, to consider the direction of the lift
pred consider_dirc ( s: State, up_dirc: Int )  {
	((up_dirc = 1) => some f: s.floors | f.value > s.lift.floor.value and ( f in s.lift.pressed_buttons or f.up = Pressed or f.down = Pressed ))
	((up_dirc = 0) => some f: s.floors | f.value < s.lift.floor.value and ( f in s.lift.pressed_buttons or f.up = Pressed or f.down = Pressed ))
}
```

Now, implementing this and running I get:
![image.png](image.png)

This shows, that we have achieved the desired functionality. <br> However, in order to get this, had to change this constrain of lift stopping everywhere in the code and it seemed cumbersome. <br> Hence, realise I should isolate the algorithm and part related to stopping of the lift to trivialise the process.

After final debugging and isolating the same, the code can be found in [Lift.als](Lift.als).

