// Using an inbuilt-util for ordering between states
open util/ordering[State]

// Considering doors on each floor as open or closed
enum Door { Open, Close }
// Considering the buttons on each floors to be in one of the three states, either Pressed, Not_Pressed or Invalid
// Invalid state added, so as to declare buttons which cannot be used
enum Button { Pressed, Not_Pressed, Invalid}

// Considering that the Lift  can either be at Rest or Moving
enum Status { Rest, Moving }
// Considering that the Lift's direction can be up or down
enum Dirc { Up, Down }

// Adding abstract sigs of floors - Basic structure:
// Defining one sig of floors in generic form so as to simplify and handle end floors together
abstract sig Floor {
	door: one Door,
	value: Int,                   // added to be able to define ordering within floors
	up: one Button,               // two directions of buttons possible for the floors - up or down
	down: one Button
}

// Now seperating the different kinds of floors within the Floor abstraction
abstract sig Top_Floor, Bottom_Floor, Middle_Floor extends Floor {}

// Now for a 3-lift system
sig Zero extends Bottom_Floor {}
sig First extends Middle_Floor {}
sig Second extends Top_Floor {}

// Initialising the Lift sig
sig Lift {
	floor: one Floor,                              // necessary to store to determine the doors, lift movement
	status: one Status,                            // tells about whether the lift is moving or not
	dirc: one Dirc,                                // tells about the inherent direction of motion of the lift
	pressed_buttons: set Floor                     // store the pressed_buttons inside the lift
}

// Adding States for introducing ordering within different states of the lift
sig State {
	lift: one Lift,           // since, talking a single lift system, each state has a Lift
	floors: set Floor         // contain all the floors for that particular state, i.e. all the info. abt the floors at that pt.
}

fact basic_constraints {
	Zero.value = 0
	First.value = 1
	Second.value = 2

	// Invalidating the floor buttons
	all t: Top_Floor| t.up = Invalid
	all b: Bottom_Floor| b.down = Invalid
	
	// Adding constraints for the floor buttons which should always be pressable
	all m: Middle_Floor| m.up != Invalid
	all m: Middle_Floor| m.down != Invalid
	all t: Top_Floor| t.down != Invalid
	all b: Bottom_Floor| b.up != Invalid
}

fact state_constraints {
	// adding constraint to ensure that all existing lifts are mapped to some state
	all l: Lift | ( some s: State | l in s.lift )

	// constraining the existence of floors using there mapping to some state
	all f: Floor | (some s: State | f in s.floors)

	// constraining that for all states, the pressed_buttons within the state.lift must point to floors within state.floors
	all s: State | (all p: s.lift.pressed_buttons | p in s.floors)
	
	//  constraining that for all states, the floor of the state.lift must be within state.floors
	all s: State | (s.lift.floor in s.floors)

	// constraining the s.floors to be equal to the set of all 3 floor states
	all s: State | #s.floors = 3 and  
	some f1:Zero | f1 in s.floors and 
	some f2:First | f2 in s.floors and  
	some f3:Second | f3 in s.floors
}

run{} for 3 State, 3 Lift, exactly 9 Floor 
