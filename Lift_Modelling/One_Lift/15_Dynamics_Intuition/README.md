## Dynamics - Intuition

Now, when I think about introducing movement between states of different forms, I get multiple ideas:

- **Method I** - specify formally in which scenario the movement is to be allowed, and if the situation is met then the movement happens
- **Method II** - specify formally if a movement occurs then what scenario/situation of the states should have been met, in the state and state.next

#### Analyzing the Methods -

Both on surface level seem equivalent. However,

**Method I** : <br>
If from a state, multiple movements are possible then, by the nature of implementation, implication specifying all such movements must be true. Which in situations, might be tougher to constrain, as the movements might be conflicting of each other.

**Method II** :<br>
This seems more desirable, as we can simply constrain the intial scenarios given the movement. Also from the modelling perspective, it is easier to think, okay this happened (the movement), but under what circumstances would we want this to occur.

So I'll proceed forward with method II for now, revisiting it later.
