// Considering doors on each floor as open or closed
enum Door { Open, Close }
// Considering the buttons on each floors to be in one of the three states, either Pressed, Not_Pressed or Invalid
// Invalid state added, so as to declare buttons which cannot be used
enum Button { Pressed, Not_Pressed, Invalid}

// Adding abstract sigs of floors - Basic structure:
// Defining one sig of floors in generic form so as to simplify and handle end floors together
abstract sig Floor {
	door: one Door,
	value: Int,                   // added to be able to define ordering within floors
	up: one Button,        // two directions of buttons possible for the floors - up or down
	down: one Button
}

// Now seperating the different kinds of floors within the Floor abstraction
abstract sig Top_Floor, Bottom_Floor, Middle_Floor extends Floor {}

// Now for a 3-lift system
sig Zero extends Bottom_Floor {}
sig First extends Middle_Floor {}
sig Second extends Top_Floor {}

fact basic_constraints {
	Zero.value = 0
	First.value = 1
	Second.value = 2

	// Invalidating the floor buttons
	Top_Floor.up = Invalid
	Bottom_Floor.down = Invalid
}

run{}
