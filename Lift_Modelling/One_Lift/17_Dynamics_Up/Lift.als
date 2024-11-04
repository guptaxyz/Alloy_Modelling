// Using an inbuilt-util for ordering between states
open util/ordering[ State ]

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
	all f: Floor | ( some s: State | f in s.floors )

	// constraining that for all states, the pressed_buttons within the state.lift must point to floors within state.floors
	all s: State | ( all p: s.lift.pressed_buttons | p in s.floors )
	
	//  constraining that for all states, the floor of the state.lift must be within state.floors
	all s: State | ( s.lift.floor in s.floors )

	// constraining the s.floors to be equal to the set of all 3 floor states
	all s: State | #s.floors = 3 and  
	some f1:Zero | f1 in s.floors and 
	some f2:First | f2 in s.floors and  
	some f3:Second | f3 in s.floors
}

fact first {
	// Initialising that the lifts in the first State with zeroth floor, no pressed_buttons,
	first.lift.floor in Zero
	no first.lift.pressed_buttons
	first.lift.status = Moving
	first.lift.dirc = Up
	// Initialising the floors with doors closed, buttons invalidated/Not_pressed
	all f: first.floors | f.door = Close and
	(( f.up != Invalid ) => ( f.up = Not_Pressed )) and 
	(( f.down != Invalid ) => ( f.down = Not_Pressed ))

	some s: State | s.lift.floor in Second
}

fact open_door {
	// specifying the case for the opening of floor door
	all s: State - last, s1: s.next {
		(( s.lift.floor.door = Close and s1.lift.floor.door = Open ) =>
		(
			// lift is at rest and moves to the same direction as before and after opening of door
			s.lift.status = Rest and s1.lift.status = Rest and
			s.lift.dirc = s1.lift.dirc and
		
			// there should be a button pressed or the floor button should be pressed               
			( s.lift.floor in s.lift.pressed_buttons or
			( s.lift.dirc = Up and s.lift.floor.up = Pressed ) or
			( s.lift.dirc = Down and s.lift.floor.down = Pressed )) and 

			// the floor should essentially remain the same
			s.lift.floor.value = s1.lift.floor.value and

			// constraining the pressed_buttons of the lift accordingly
			( s.lift.floor in s.lift.pressed_buttons => 
			s1.lift.pressed_buttons = s.lift.pressed_buttons - s.lift.floor + s1.lift.floor ) and
			( s.lift.floor not in s.lift.pressed_buttons => s1.lift.pressed_buttons = s.lift.pressed_buttons ) and

			// constraining the floor button states accordingly
			( s.lift.floor.up = Pressed => s1.lift.floor.up = Pressed ) and
			( s.lift.floor.down = Pressed => s1.lift.floor.down = Pressed ) and
			( s.lift.floor.up = Not_Pressed => s1.lift.floor.up = Not_Pressed ) and
			( s.lift.floor.down = Not_Pressed => s1.lift.floor.down = Not_Pressed ) and

			// updating the floors set
			s1.floors = s.floors - s.lift.floor + s1.lift.floor
		))

		// adding constrain to allow door opening, only if lift is on that floor
		(
			all f: s.floors, f1: s1.floors | 
			( f.door = Close and f1.door = Open and f.value = f1.value ) =>
			( s.lift.floor = f and s1.lift.floor = f1 )
		)
	}
}

fact up {
	// specifying the case for the lift moving up
	all s: State - last, s1: s.next {
		// constraining that the next floor if has higher value than the current floor 
		// then can go at max one floor up, as well as the motion is maintained
		( s.lift.floor.value < s1.lift.floor.value ) =>
		{
			s1.lift.floor.value < s.lift.floor.value + 2
			s.lift.dirc = Up and s1.lift.dirc = Up
			s.lift.status = Moving and s1.lift.status = Moving
			s1.lift.pressed_buttons = s.lift.pressed_buttons
			s1.floors = s.floors
		}
	}
}

run{} for exactly 3 State, exactly 3 Lift, exactly 3 Floor
