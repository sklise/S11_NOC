// Steve Klise http://stevenklise.com
// Nature of Code, ITP Spring 2011

// Week 02

// Better Fish Tank
// With FORCES
// A 'fish' in a fish tank and a 'finger' tapping the glass.

/*
*	TODO
*	Make fish only rotate a bit.
*	Make castles for fish to hide behind, go to.
*	Make fish avoid each other.	
*/

ArrayList fishes;
ArrayList taps;
float intensity;
float G = 1;

void setup()
{
	size(500,500);
	smooth();
	fishes = new ArrayList();
	taps = new ArrayList();
}

void draw()
{
	// Display stuff
	background(255,255,255);
	noFill();
	stroke(0);
	rect(0,0,width-1,height-1);
	cursor(HAND);

	// The Fish
	if(fishes.size() > 0) // if there are fish
	{
	  for(int i=0; i<fishes.size(); i++) // iterate through all fish
	  {
	    Fish temp = (Fish)fishes.get(i);
	    temp.forces(); // calculate forces on fish.
	    temp.update(); // update movement of fish.
	    temp.display(); // draw the fish to the screen.
	  }
	}
	
	// The Taps
	if(taps.size() > 0) // if there is a tap
	{
		for(int i=0; i<taps.size(); i++) // iterate through all taps
		{
			Tap ttap = (Tap)taps.get(i); // get tap
			ttap.decay(); // decay it
			if(ttap.length <= 0) // if the tap is over
			{
				taps.remove(i); // remove the tap
				println("TAP DIED");
			}
		}
	}

	// Instructions
	textAlign(CENTER);
	fill(0);
	text("RIGHT CLICK TO SPAWN FISH",width/2,height-30);
	text("LEFT CLICK TO TAP ON GLASS",width/2,height-15);
}

void mouseClicked()
{
	if(mouseButton == LEFT)
	{
		Tap newtap = new Tap(mouseX,mouseY,intensity);
		taps.add(newtap);
		println("TAP!");
		println("at "+mouseX+", "+mouseY+" with intensity "+intensity);
	}
	intensity = 0;
}

void mousePressed()
{
	if(intensity == 0)
	{
		intensity = millis();
	}
}

void mouseReleased()
{
	if(mouseButton == RIGHT)
	{
	  PVector currentMouse = new PVector(mouseX,mouseY);
	  Fish temp = new Fish(currentMouse,frameCount%(width/2));
	  fishes.add(temp);
	}
	intensity = constrain(millis()-intensity,0,200);
}
