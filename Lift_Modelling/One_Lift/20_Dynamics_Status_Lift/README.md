## Dynamics - Lift Status : Moving/Rest

Now that we have seen the basic dynamics of the lift, we shall talk about constraining finer aspects, which may be missed out.

I start with the status of the lift - Moving/Rest. Right now, this transition is free. However, we would want that the lift:

- transitions to the Rest state only at the same time lift door opens
- transitions to the Moving State only after the door closes
- Additionally, we would want that if the floor is within the pressed_buttons or the floor button is pressed in the dircn of the lift, then the lift must come to the Rest state

For these I must make a few amends, firstly, modify the fact open_door a bit, by replacing `s.lift.status = Rest` with `s.lift.status = Moving` as we now, directly want the lift to transition from Moving to Rest state, at the same time door opens.

Secondly, I would need to add a few constraints:
```
if ( s.lift.status = Moving and s1.lift.status = Rest ):
    // to ensure this happens along with opening of door
    - s.lift.floor.door = Close and s1.lift.floor.door = Open
if ( s.lift.status = Rest and s1.lift.status = Moving ):
    // to ensure this happens only after door closes 
    - s.lift.floor.door = Open and s1.lift.floor.door = Close
if (( s.lift.floor in pressed_buttons or ( s.lift.dircn = Up and s.lift.floor.up is Pressed )
    or ( s.lift.dircn = Down and s.lift.floor.down is Pressed )) and s.lift.status = Moving ):
    // ensuring the lift must come to rest
    - s.lift.floor.door = Close and s1.lift.floor.door = Open
```

