## Dynamics - Lift Dirc: Up/Down

Here we are looking to constrain the change in dirc of the lift. 

Normally this would also depend on the algorithm we use, however I have for now, made the assumption to go with basic sweep algorithm.

#### Basic Sweep Algorithm:

Basically, as the name suggests, we want to continue in a particular dirc of movement as long as there are floors in that dirc which we need to visit. If there are 
none, we switch the dirc and either continue movement or stop based upon whether there are floors in the new dirc to be reached.

```
if in motion:
    - continue that dirc of motion as long as there is a floor which you need to reach in that dirc
    if no floor in the dirc of motion:
        - change dirc of motion
        if no floor needed to reach in new dirc:
            - come to Rest
else:
    if some floor needed to reach:
        - move in that dirc
    else:
        - stay at Rest
```

Now, I had previously specified the dirc and status of the lift a bit randomly (set it to something such as when after the door closes). So herein, I'll first work 
on the predicate for the dirc of the lift, predicate for the status shall be discussed later (probably in the next directory).

I need to define a predicate which correctly returns the direction of the lift, also in the meanwhile shall constrain, that there shouldn't be any dirc switches,
except when the door of the lift just closes at a floor. To constrain this we need to introduce:

