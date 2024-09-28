// Considering doors on each floor as open or closed
enum Door { Open, Close }
// Considering the buttons on each floors to be in one of the two states, either Pressed or Not
enum Button { Pressed, Not_Pressed}

// Adding abstract sigs of floors - Basic structure:
// Defining three kind of floors in generic form so as to simplify and handling end floors seperately
abstract sig Top_Floor {
	door: one Door,
	value: Int,                   // added to be able to define ordering within floors
	down: one Button   // only one direction of button possible - down as top floor
}

abstract sig Bottom_Floor {
	door: one Door,
	value: Int,                   // added to be able to define ordering within floors
	up: one Button         // only one direction of button possible - up as bottom floor
}

abstract sig Middle_Floor {
	door: one Door,
	value: Int,                   // added to be able to define ordering within floors
	up: one Button,        // two directions of buttons possible - up or down as middle floor
	down: one Button
}

// Now for a 3-lift system
sig Zero extends Bottom_Floor {}
sig First extends Middle_Floor {}
sig Second extends Top_Floor {}

fact basic_constraints {
	Zero.value = 0
	First.value = 1
	Second.value = 2
}

run{}
