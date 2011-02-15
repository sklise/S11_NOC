class Tap
{
	// A tap is a repeller of fish that is generated on left mouse clicks and then decays.
	// Time sensitive inverse gravity.
	
	PVector loc; // where the tap happened.
	float length; // how long it will last.
	float mass; // how massive was the tap?
	
	Tap(float _x, float _y, float _mass)
	{
		loc = new PVector(_x,_y);
		mass = _mass; // this isn't written properly, probably.
		length = 100;
	}
	
	void decay()
	{
		length--;
	}
}
