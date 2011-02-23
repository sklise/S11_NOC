class Food
{
	// Food is a flake of food. It is a quadrilateral.
	// When it hits the ground, it is eliminated as a food.
	
	PVector loc; // where the tap happened.
	float[] angles = new float[4];
	float r;
	
	Food(float _x, float _y)
	{
		loc = new PVector(_x,_y);
		angles[0] = random(0,HALF_PI);
		angles[1] = random(HALF_PI,PI);
		angles[2] = random(PI,PI+HALF_PI);
		angles[3] = random(PI+HALF_PI,TWO_PI);
		r = 3;
	}
	
	void run()
	{
		move();
		display();
	}
	
	void move()
	{
		loc.y++;
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
	
	boolean grounded()
	{
		if( loc.y > height-11)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
