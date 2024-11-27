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

// Now for a 6-floor one lift system
// UPDATE FOR SCALING
sig Zero extends Bottom_Floor {}
sig First, Second, Third, Fourth extends Middle_Floor {}
sig Fifth extends Top_Floor {}

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
	// UPDATE FOR SCALING
	Zero.value = 0
	First.value = 1
	Second.value = 2
	Third.value = 3
	Fourth.value = 4
	Fifth.value = 5

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

	// constraining the s.floors to be equal to the set of all 6 floor states
	// UPDATE FOR SCALING
	all s: State | #s.floors = 6 and  
	some f1:Zero | f1 in s.floors and 
	some f2:First | f2 in s.floors and  
	some f3:Second | f3 in s.floors and
	some f4:Third | f4 in s.floors and
	some f5:Fourth | f5 in s.floors and
	some f6:Fifth | f6 in s.floors
}

fact first {
	// Initialising that the lifts in the first State with zeroth floor, no pressed_buttons,
	first.lift.floor in Zero
	no first.lift.pressed_buttons
	first.lift.status = Rest
	first.lift.dirc in Up
	// Initialising the floors with doors closed, buttons invalidated/Not_pressed
	all f: first.floors | f.door = Close and
	(( f.up != Invalid ) => ( f.up = Not_Pressed )) and 
	(( f.down != Invalid ) => ( f.down = Not_Pressed ))
	// some s:State | s.lift.floor in Second and s.lift.dirc = Down

	// some s: State - last, s1: s.next | s.lift.floor.door = Open and s1.lift.floor.door = Close and s.lift.floor in First and s.lift.floor.up = Not_Pressed and 
	// all s:State | all f: s.floors | f in Second => f.down= Not_Pressed and f not in s.lift.pressed_buttons
}

fact open_door {
	// specifying the case for the opening of floor door
	all s: State - last, s1: s.next {
		(( s.lift.floor.door = Close and s1.lift.floor.door = Open ) =>
		(
			// lift comes at rest and moves to the same direction as before and after opening of door
			s1.lift.status = Rest and
			s.lift.dirc = s1.lift.dirc and
		
			// there should be a button pressed or the floor button should be pressed               
			to_stop_lift[ s ] and

			// the floor should essentially remain the same
			s.lift.floor.value = s1.lift.floor.value and

			// constraining the pressed_buttons of the lift accordingly
			( s.lift.floor in s.lift.pressed_buttons => 
			s1.lift.pressed_buttons = s.lift.pressed_buttons - s.lift.floor + s1.lift.floor ) and
			( s.lift.floor not in s.lift.pressed_buttons => s1.lift.pressed_buttons = s.lift.pressed_buttons ) and

			// constraining the floor button states accordingly
			( s.lift.floor.up in Pressed => s1.lift.floor.up in Pressed ) and
			( s.lift.floor.down in Pressed => s1.lift.floor.down in Pressed ) and
			( s.lift.floor.up in Not_Pressed => s1.lift.floor.up in Not_Pressed ) and
			( s.lift.floor.down in Not_Pressed => s1.lift.floor.down in Not_Pressed ) and

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

		// UPDATE FOR SCALING
		( s.lift.floor.value < s1.lift.floor.value ) =>
		{
			s1.lift.floor.value < s.lift.floor.value + 2 and
			s.lift.dirc = Up and 
			( s1.lift.floor.value = 5 => s1.lift.dirc = Down ) and
			( s1.lift.floor.value < 5 => s1.lift.dirc = Up ) and
			s.lift.status = Moving and s1.lift.status = Moving and
			s1.lift.pressed_buttons = s.lift.pressed_buttons and
			s1.floors = s.floors
		}
	}
}

fact down {
	// specifying the case for the lift moving down
	all s: State - last, s1: s.next {
		// constraining that the next floor if has lower value than the current floor 
		// then can go at max one floor down, as well as the motion is maintained
		( s.lift.floor.value > s1.lift.floor.value ) =>
		{
			s1.lift.floor.value + 2 > s.lift.floor.value and
			s.lift.dirc = Down and
			( s1.lift.floor.value = 0 => s1.lift.dirc = Up ) and
			( s1.lift.floor.value > 0 => s1.lift.dirc = Down ) and
			s.lift.status = Moving and s1.lift.status = Moving and
			s1.lift.pressed_buttons = s.lift.pressed_buttons and
			s1.floors = s.floors
		}
	}
}

fact close_door {
	// specifying the case for the closing of floor door and changing direction of lift
	all s: State - last, s1: s.next {
		(( s.lift.floor.door = Open and s1.lift.floor.door = Close ) =>
		(
			// lift is at rest and moves in the direction accordingly, before and after opening of door
			lift_dirc_status [ s, s1 ] and
		
			// condition for the stopping of the lift, may vary, based on algo. used             
			to_stop_lift[ s ] and

			// the floor should essentially remain the same
			s.lift.floor.value = s1.lift.floor.value and

			// constraining the pressed_buttons of the lift accordingly - removing the floor which was just visited
			( s.lift.floor in s.lift.pressed_buttons => 
			s1.lift.pressed_buttons = s.lift.pressed_buttons - s.lift.floor ) and
			( s.lift.floor not in s.lift.pressed_buttons => s1.lift.pressed_buttons = s.lift.pressed_buttons ) and

			// constraining the floor button states accordingly
			(( s.lift.floor.up = Pressed and s1.lift.dirc = Up ) => s1.lift.floor.up = Not_Pressed ) and
			(( s.lift.floor.down = Pressed and s1.lift.dirc = Down ) => s1.lift.floor.down = Not_Pressed ) and
			(( s.lift.floor.up = Pressed and s1.lift.dirc = Down ) => s1.lift.floor.up = Pressed ) and
			(( s.lift.floor.down = Pressed and s1.lift.dirc = Up ) => s1.lift.floor.down = Pressed ) and
			( s.lift.floor.up = Not_Pressed => s1.lift.floor.up = Not_Pressed ) and
			( s.lift.floor.down = Not_Pressed => s1.lift.floor.down = Not_Pressed ) and

			// updating the floors set
			s1.floors = s.floors - s.lift.floor + s1.lift.floor
		))

		// adding constrain to allow door closing, only if lift is on that floor -- SAFETY Condition
		(
			all f: s.floors, f1: s1.floors | 
			( f.door = Open and f1.door = Close and f.value = f1.value ) =>
			( s.lift.floor = f and s1.lift.floor = f1 )
		)
	}
}

fact pressed_buttons {
	// constraining the change in the pressed_buttons of the lift

	all s: State - last, s1: s.next {
		// constraining that the floor can be removed only when the door is closing again
		( s1.lift.pressed_buttons in s.lift.pressed_buttons and not ( s.lift.pressed_buttons in s1.lift.pressed_buttons )) =>
		( s.lift.floor.door = Open and s1.lift.floor.door = Close )
	}

	// NEED TO CHECK IF WANT TO KEEP IT OR NOT
	all s: State - last, s1: s.next {
		// constraining that the floor can be pressed only when the lift is at rest and someone just entered
		( s.lift.pressed_buttons in s1.lift.pressed_buttons and not ( s1.lift.pressed_buttons in s.lift.pressed_buttons )) =>
		( s.lift.floor.door = Open and s.lift.status = Rest and s1.lift.status = Rest and
		s.lift.dirc = s1.lift.dirc and s.lift.floor = s1.lift.floor and s.floors = s1.floors and
		to_stop_lift[ s ] )
	}

	all s: State - last, s1: s.next {
		// constraining that the pressed_buttons in neighbouring states shouldn't be incomparable 
		// except when the door opened due to which a floor state got removed and a similar one added
		(( s.lift.pressed_buttons not in s1.lift.pressed_buttons ) and 
		( s1.lift.pressed_buttons not in s.lift.pressed_buttons )) =>
		s.lift.floor.door = Close and s1.lift.floor.door = Open
	}
}

fact lift_status {
	// constraining the status of the lift
	
	all s: State - last, s1: s.next {
		// constraining that if the lift was open then transition to the Moving state at the same time lift door closes
		(( s.lift.status = Rest and s1.lift.status = Moving and s.lift.floor.door = Open ) =>
		( s1.lift.floor.door = Close ))

		// and the predicate lift_dirc_status must be true
		(( s.lift.status = Rest and s1.lift.status = Moving and s.lift.floor.door = Close ) =>
		( lift_dirc_status [ s, s1 ] ))   
	}

	all s: State - last, s1: s.next {
		// constraining that the lift should transition to the rest state only after the lift door opens
		// or the lift reaches ground floor, and has nowhere to go
		( s.lift.status = Moving and s1.lift.status = Rest ) =>
		( 
			( s.lift.floor.door = Close and s1.lift.floor.door = Open )
			or
			( s1.lift.floor in Zero and not consider_dirc[s1, 1] and s1.lift.floor.door = Close )
		)
	}

	all s: State - last, s1: s.next {
		// constraining that if the floor is within the pressed_buttons or the floor button is pressed 
		// then the lift must come to the Rest state
		( to_stop_lift[ s ] and s.lift.floor.door = Close ) =>
		( s1.lift.floor.door = Open )
	}
}

fact floor_buttons {
	all s: State - last, s1: s.next {
		all f: s.floors, f1: s1.floors {
			// here, we constrain that a floor button can become not_pressed only when 
			// the door is closing on some floor
			( f.up = Pressed and f1.up = Not_Pressed and f.value = f1.value ) =>
			( f.door = Open and f1.door = Close )
			
			( f.down = Pressed and f1.down = Not_Pressed and f.value = f1.value ) =>
			( f.door = Open and f1.door = Close )

			// we don't want to constrain the pressing of buttons on the floor
		} 
	}
}

fact dirc_switch {
	// to constrain dirc switches only when lift starts moving from rest
	// or the lift has reached the end topmost or bottommost floor
	// UPDATE FOR SCALING
	all s: State - last, s1: s.next {
		( s.lift.dirc != s1.lift.dirc ) =>
		(( s.lift.status = Rest and s1.lift.status = Moving ) or
		( s.lift.floor.value != s1.lift.floor.value and (s1.lift.floor in Zero  or s1.lift.floor in Fifth )))
	}
}

fact start_rest {
	// to constrain the lift to move the moment a button is pressed on any floor
	all s: State - last, s1: s.next {
		( s.lift.floor not in s.lift.pressed_buttons and s.lift.floor.up != Pressed and
		s.lift.floor.down != Pressed and s.lift.floor.door = Close and s.lift.status = Rest ) =>
		( lift_dirc_status [ s, s1 ] ) 	
	}
}

fact state_floors {
	// to constrain the floors to be diff. only if they are actually diff.
	all s, s1: State | s != s1 => {
		all f: s.floors - s1.floors, f1: s1.floors {
			( f.value = f1.value ) =>
			( f.up != f1.up or f.down != f1.down or f.door != f1.door )
		} 
	}
}

fact move_lift {
	all s: State - last, s1: s.next {
		( s.lift.status = Moving and not to_stop_lift[ s ] ) =>
		s.lift.floor.value != s1.lift.floor.value
	}
}


// Specifying Algo. in this part :-

// defined as helper function, to consider the direction of the lift
pred consider_dirc ( s: State, up_dirc: Int )  {
	((up_dirc = 1) => some f: s.floors | f.value > s.lift.floor.value and ( f in s.lift.pressed_buttons or f.up = Pressed or f.down = Pressed ))
	((up_dirc = 0) => some f: s.floors | f.value < s.lift.floor.value and ( f in s.lift.pressed_buttons or f.up = Pressed or f.down = Pressed ))
}

// write the mechanism in which scenario you want the lift to stop
pred to_stop_lift ( s: State )  {
	( s.lift.floor in s.lift.pressed_buttons or
	(
		(( consider_dirc[ s, 1 ] and s.lift.dirc = Up) => s.lift.floor.up = Pressed )
		and
		(( consider_dirc[ s, 0 ] and s.lift.dirc = Down) => s.lift.floor.down = Pressed )
		and
		(( not consider_dirc [ s, 1 ] and s.lift.dirc = Up) => s.lift.floor.down = Pressed or s.lift.floor.up = Pressed )
		and
		(( not consider_dirc [ s, 0 ] and s.lift.dirc = Down) => s.lift.floor.down = Pressed or s.lift.floor.up = Pressed )
	))
}

// write the main algo. behind the lift - here, basic Elevator Algorithm taken
pred lift_dirc_status ( s: State, s1: State )  {

	( s.lift.dirc = Up ) => 
	{
		// tackle the scenario in which some states which need to be visited are above the current floor
		(
			( consider_dirc[ s, 1 ] ) =>
			( s1.lift.dirc = Up and s1.lift.status = Moving )
		)

		// tackle the scenario in which some states which need to be visited are below the current floor
		(
			( consider_dirc[ s, 0 ] and not consider_dirc[ s, 1 ]) =>
			( s1.lift.dirc = Down and s1.lift.status = Moving )
		)

		// tackle the scenario in which no states have the need to be visited
		(
			( not ( consider_dirc[ s, 0 ] or consider_dirc[ s, 1 ] )) =>
			(
				((( s.lift.floor.up = Pressed or s.lift.floor.down = Pressed ) and s.lift.floor.door = Open ) =>
				(
					( s.lift.floor.up = Pressed => s1.lift.dirc = Up ) and
					((  s.lift.floor.up = Not_Pressed and s.lift.floor.down = Pressed ) => s1.lift.dirc = Down ) and s1.lift.status = Moving 
				)) and
				( not (( s.lift.floor.up = Pressed or s.lift.floor.down = Pressed ) and s.lift.floor.door = Open ) =>
				(( not s1.lift.floor in Zero => s1.lift.dirc = Down and s1.lift.status = Moving ) and
				( s1.lift.floor in Zero => s1.lift.dirc = Up and s1.lift.status = Rest )))
			)
		)
	}

	( s.lift.dirc = Down ) => 
	{
		// tackle the scenario in which some states which need to be visited are below the current floor
		(
			( consider_dirc[ s, 0 ] ) =>
			( s1.lift.dirc = Down and s1.lift.status = Moving )
		)

		// tackle the scenario in which some states which need to be visited are above the current floor
		(
			( consider_dirc[ s, 1 ] and not consider_dirc[ s, 0 ]) =>
			( s1.lift.dirc = Up and s1.lift.status = Moving )
		)
		
		// tackle the scenario in which no states have the need to be visited
		(
			( not ( consider_dirc[ s, 0 ] or consider_dirc[ s, 1 ] )) =>
			(
				((( s.lift.floor.up = Pressed or s.lift.floor.down = Pressed ) and s.lift.floor.door = Open ) =>
				(
					( s.lift.floor.down = Pressed => s1.lift.dirc = Down ) and
					(( not  s.lift.floor.down = Pressed  and s.lift.floor.up = Pressed ) => s1.lift.dirc = Up ) and s1.lift.status = Moving 
				)) and
				( not (( s.lift.floor.up = Pressed or s.lift.floor.down = Pressed ) and s.lift.floor.door = Open ) =>
				( s1.lift.dirc = Down and s1.lift.status = Moving ))
			)
		)
	}
}

run{} for exactly 7 State, exactly 7 Lift,  15 Floor
