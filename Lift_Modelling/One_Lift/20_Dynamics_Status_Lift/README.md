## Dynamics - Lift Status : Moving/Rest

Now that we have seen the basic dynamics of the lift, we shall talk about constraining finer aspects, which may be missed out.

I start with the status of the lift - Moving/Rest. Right now, this transition is free. However, we would want that the lift:

- transitions to the Rest state only at the same time lift door opens
- transitions to the Moving State only after the door closes
- Additionally, we would want that if the floor is within the pressed_buttons or the floor button is pressed in the dircn of the lift, then the lift must come to the 
  Rest state
