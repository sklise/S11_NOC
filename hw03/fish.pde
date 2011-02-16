class Fish
{
  // MOVEMENT
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  // TRAITS
  float mass;
  float skittishness;
  float topspeed; // a topspeed of each fish, determined by skittishness/mass
  // a big skittish fish will only move a bit.
  // a small skittish fish is going to move more crazily.

  Random yswim; // gaussian movement in y direction
  Random xswim; // gaussian movement in x direction

  float buffer = 30; // distance away from an edge at which the buffer zones start.

  Fish(PVector _location, float _skittishness)
  {
    location = _location; // will be input from right mouse click.
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);

    mass = map(location.mag(),0,800,1,20); // wherever the fish is spawned at determines how big he gets
    skittishness = _skittishness;
    topspeed = constrain(skittishness/mass,0,2);
	yswim = new Random();
    xswim = new Random();
  }

  void forces()
  {
	// If the fish is near the left side of the screen.
	if(location.x < buffer)
	{
		// add a right pointing acceleration if the fish is too close to the left edge.
		PVector dragLeft = new PVector(velocity.mag(),0);
		dragLeft.mult(0.125);
		acceleration.add(dragLeft);
		// println("Slowing down");
	}
	else if (location.x > width-buffer)
	{
		// add a left pointing acceleration if the fish is too close to the right edge.
		PVector dragRight = new PVector(velocity.mag(),0);
		dragRight.mult(-0.125);
		acceleration.add(dragRight);
		// println("Slowing down");
	}
	else if (location.y > height-buffer)
	{
		// add a up pointing acceleration if the fish is too close to the bottom edge.
		PVector dragDown = new PVector(0,velocity.mag());
		dragDown.mult(-0.125);
		acceleration.add(dragDown);
		// println("Slowing down");
	}
	else if (location.y < buffer)
	{
		// add a down pointing acceleration if the fish is too close to the top edge.
		PVector dragUp = new PVector(0,velocity.mag());
		dragUp.mult(0.125);
		acceleration.add(dragUp);
		// println("Slowing down");
	}
    else
    {
      acceleration.x = (float)xswim.nextGaussian();
      acceleration.y = (float)yswim.nextGaussian()/20; // changes in Y should be smaller than X.
      acceleration.normalize(); // Normalize
      acceleration.mult(.03); // Reduce acceleration!
    }
	
	//
	// I REALLY WANT TO HAVE WATER CURRENTS BUT THAT MIGHT NOT HAPPEN THIS WEEK.
	//
	
	// JUST KEEP SWIMMING, JUST KEEP SWIMMING
	if(acceleration.mag() == 0)
	{
		acceleration.x = (float)xswim.nextGaussian();
	      acceleration.y = (float)yswim.nextGaussian()/20; // changes in Y should be smaller than X.
	      acceleration.normalize(); // Normalize
	      acceleration.mult(.03); // Reduce acceleration!
	}
  }

	void update()
	{
		if(taps.size()>0)
		{
			for(int i=0; i < taps.size(); i++)
			{
				Tap temp = (Tap)taps.get(i);
				isNearby(temp);
			}
		}
		acceleration.div(mass);
		velocity.add(acceleration);
		velocity.limit(topspeed);
		location.add(velocity);
		acceleration.mult(0);
	}

  	void isNearby(Tap atap)
	{
		PVector force = PVector.sub(location,atap.loc); // a vector point from the tap to the fish.
		float distance = force.mag();
		force.normalize(); // normalize that vector, make it just a direction essentially.
		float m = ( atap.mass * mass) / (distance * distance);
		force.mult(m);
		acceleration.add(force);
	}

  void display()
  {
    fill(0);
    pushMatrix();
    	stroke(0);
		strokeWeight(1);
	    translate(location.x,location.y);
		float fishHead = constrain(velocity.heading2D(),PI/3,-PI/3);
	    rotate(velocity.heading2D());
	    ellipse(0,0,mass*2,mass);
	    triangle(0-mass,0,0-mass*3/2,0+mass/2,0-mass*3/2,0-mass/2);
	    stroke(255,0,0);
    popMatrix();
    // debug lines
    // line(location.x,location.y,(location.x+velocity.x*90),(location.y+velocity.y*90));
  }
}

