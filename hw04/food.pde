class Food
{
	// Food is a flake of food. It is a quadrilateral.
	// When it hits the ground, it is eliminated as a food.
	
	PVector loc;
	PVector vel;
	PVector acc;
	float[] angles = new float[4];
	float r;
	float maxspeed;
	float maxforce;
	float buffer = 10;
	
	Food(float _x, float _y)
	{
		loc = new PVector(_x,_y);
		vel = new PVector(0,0);
		acc = new PVector(0,0);
		angles[0] = random(0,HALF_PI);
		angles[1] = random(HALF_PI,PI);
		angles[2] = random(PI,PI+HALF_PI);
		angles[3] = random(PI+HALF_PI,TWO_PI);
		maxspeed = random(1,1.75);
		maxforce = random(0.1f,0.3f);
		r = 3;
	}
	
	void run()
	{
		move();
		display();
	}
	
	void move()
	{
		vel.add(acc);
		vel.limit(maxspeed);
		loc.add(vel);
		acc.mult(0);
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
	boolean eaten(ArrayList<Fish> pop)
	{
		// Check the distance between this food and a population.
		// If it's close, it got eaten.
		
		boolean justOnce = false;
		for(Fish f : pop)
		{
			if( dist(f.loc.x,f.loc.y,loc.x,loc.y) <= r )
			{
				justOnce = true;
			}
		}
		if(justOnce)
		{
			return true;
		}
		else
		{
			return false;
		}
		
	}
	
	/////////////////////////////////////////////////////////////
	// From here to the end of this class, Dan Shiffman wrote it.
	// http://www.shiffman.net/teaching/nature/steering/
	/////////////////////////////////////////////////////////////
	void follow(FlowField f)
	{
		// Look ahead
		PVector ahead = vel.get();
		ahead.normalize();
		ahead.mult(32); // Arbitrarily look 32 pixels ahead
		PVector lookup = PVector.add(loc,ahead);

		// What is the vector at that spot in the flow field?
		PVector desired = f.lookup(lookup);
		// Scale it up by maxspeed
		desired.mult(maxspeed);
		// Steering is desired minus velocity
		PVector steer = PVector.sub(desired, vel);
		steer.limit(maxforce);  // Limit to maximum steering force
		acc.add(steer);
		
		//
		if(loc.x < buffer)
		{
			// add a right pointing acceleration if the fish is too close to the left edge.
			PVector dragLeft = new PVector(vel.mag(),0);
			dragLeft.mult(maxforce*1.2);
			acc.add(dragLeft);
		}
		else if (loc.x > width-buffer)
		{
			// add a left pointing acceleration if the fish is too close to the right edge.
			PVector dragRight = new PVector(vel.mag(),0);
			dragRight.mult(-1.2*maxforce);
			acc.add(dragRight);
		}
		else if (loc.y > height-buffer)
		{
			// add a up pointing acceleration if the fish is too close to the bottom edge.
			PVector dragDown = new PVector(0,vel.mag());
			dragDown.mult(-1.2*maxforce);
			acc.add(dragDown);
		}
		else if (loc.y < buffer+7)
		{
			// add a down pointing acceleration if the fish is too close to the top edge.
			PVector dragUp = new PVector(0,vel.mag());
			dragUp.mult(1.2*maxforce);
			acc.add(dragUp);
		}
	}
}


// LIFTING THE FLOW FIELD WHOLE-SALE

// Flow Field Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2009

class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field

  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    init();
  }

  void init() {
    // Reseed noise so we get a new flow field every time
    noiseSeed((int)random(10000));
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        // Use perlin noise to get an angle between 0 and 2 PI
        float theta = map(noise(xoff,yoff),0,1,0,PI);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = new PVector(cos(theta),sin(theta));
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }

  // Draw every vector
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j],i*resolution,j*resolution,resolution-2);
      }
    }

  }

  // Renders a vector object 'v' as an arrow and a location 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(100);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int i = (int) constrain(lookup.x/resolution,0,cols-1);
    int j = (int) constrain(lookup.y/resolution,0,rows-1);
    return field[i][j].get();
  }


}