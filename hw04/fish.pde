class Fish
{
	// MOVEMENT
	PVector loc;
	PVector vel;
	PVector acc;

	// TRAITS
	float mass;
	float skittishness;
	float topspeed; // a topspeed of each fish, determined by skittishness/mass
	// a big skittish fish will only move a bit.
	// a small skittish fish is going to move more crazily.
	int hunger;

	Random yswim; // gaussian movement in y direction
	Random xswim; // gaussian movement in x direction

	float buffer = 30; // distance away from an edge at which the buffer zones start.

	Fish(PVector _location, float _skittishness)
	{
	  	loc = _location; // will be input from right mouse click.
	  	vel = new PVector(0,0);
	  	acc = new PVector(0,0);
	  	mass = map(loc.mag(),0,800,1,20); // wherever the fish is spawned at determines how big he gets
	  	skittishness = _skittishness;
	  	topspeed = constrain(skittishness/mass,1.5,2);
		yswim = new Random();
	  	xswim = new Random();
		hunger = (int)map(mass,1,20,1,5);
	}

	void forces()
	{
		// If the fish is near the left side of the screen.
		if(loc.x < buffer)
		{
			// add a right pointing acceleration if the fish is too close to the left edge.
			PVector dragLeft = new PVector(vel.mag(),0);
			dragLeft.mult(0.125);
			acc.add(dragLeft);
		}
		else if (loc.x > width-buffer)
		{
			// add a left pointing acceleration if the fish is too close to the right edge.
			PVector dragRight = new PVector(vel.mag(),0);
			dragRight.mult(-0.125);
			acc.add(dragRight);
		}
		else if (loc.y > height-buffer)
		{
			// add a up pointing acceleration if the fish is too close to the bottom edge.
			PVector dragDown = new PVector(0,vel.mag());
			dragDown.mult(-0.125);
			acc.add(dragDown);
		}
		else if (loc.y < buffer+7)
		{
			// add a down pointing acceleration if the fish is too close to the top edge.
			PVector dragUp = new PVector(0,vel.mag());
			dragUp.mult(0.125);
			acc.add(dragUp);
		}
		  else
		  {
		    acc.x = (float)xswim.nextGaussian();
		    acc.y = (float)yswim.nextGaussian()/20; // changes in Y should be smaller than X.
		    acc.normalize(); // Normalize
		    acc.mult(.04); // Reduce acceleration!
		  }

		// JUST KEEP SWIMMING, JUST KEEP SWIMMING
		if(acc.mag() == 0)
		{
			acc.x = (float)xswim.nextGaussian();
			acc.y = (float)yswim.nextGaussian()/20; // changes in Y should be smaller than X.
			acc.normalize(); // Normalize
			acc.mult(.03); // Reduce acceleration!
		}
	}

	void update()
	{
		if( frameCount % 60 == 0)
		{
			hunger++;
			hunger = constrain(hunger,0,10);
		}
		vel.add(acc);
		vel.limit(topspeed);
		loc.add(vel);
		acc.mult(0);
	}

  	void hunger(ArrayList<Food> b)
	{
		if( hunger > 0 )
		{
			float leastDistance = MAX_FLOAT;
			int closest = 0;
			// Find the closest piece of food.
			// Go towards it.
			for(int i=0; i < b.size(); i++)
			{
				Food m = b.get(i);
				float dis = dist(m.loc.x,m.loc.y,loc.x,loc.y);
				if( dis < leastDistance )
				{
					leastDistance = dis;
					closest = i;
				}
			}
			if( leastDistance <= width/2 )
			{
				Food m = b.get(closest);
				PVector direction = PVector.sub(m.loc,loc); // Get the direction between the fish and the food
				direction.div(leastDistance);
				direction.mult(topspeed/2);
				acc.add(direction);
			}
		}
	}

  void display()
  {
    fill(0);
    pushMatrix();
    	stroke(0);
		strokeWeight(1);
	    translate(loc.x,loc.y);
		float fishHead = constrain(vel.heading2D(),PI/3,-PI/3);
	    rotate(vel.heading2D());
	    ellipse(0,0,mass*2,mass);
	    triangle(0-mass,0,0-mass*3/2,0+mass/2,0-mass*3/2,0-mass/2);
	    stroke(255,0,0);
    popMatrix();
  }
}

