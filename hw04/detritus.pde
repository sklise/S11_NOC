class Detritus
{
	// Detritus is a shape that does not move.
	// It is non-interactive.
	PVector loc;
	
	Detritus()
	{
		
	}
	
	void display()
	{
		
	}
}

class Crumb extends Detritus
{
	// A Detritus in the shape of fish food.
	float[] angles = new float[4];
	float r;
	
	Crumb(PVector _l, float[] _a, float _r)
	{
		loc = _l;
		angles = _a;
		r = _r;
	}
	
	void display()
	{
		noStroke();
		fill(127,60,27,200);
		quad(
			loc.x+r*cos(angles[0]),loc.y+r*sin(angles[0]),
			loc.x+r*cos(angles[1]),loc.y+r*sin(angles[1]),
			loc.x+r*cos(angles[2]),loc.y+r*sin(angles[2]),
			loc.x+r*cos(angles[3]),loc.y+r*sin(angles[3])
		);
	}
}