// Steve Klise http://stevenklise.com
// Nature of Code, ITP Spring 2011

// Week 03

// Fish Tank, with seaweed.

ArrayList<Fish> fishes;
ArrayList<Tap> taps;
float intensity;
float G = -0.9; // Arbitrary antigravity because we are underwater.

Node node1;
Node node2;
Random rando;

void setup()
{
	size(500,500);
	smooth();
	fishes = new ArrayList();
	taps = new ArrayList();
	frameRate(60);
	rando = new Random();
	
	PVector node1anc = new PVector(width/2,height/2);
	node1 = new Node(HALF_PI,20,node1anc);
	node2 = new Node(HALF_PI,30,node1.loc);
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
	    Fish temp = fishes.get(i);
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
			Tap ttap = taps.get(i); // get tap
			ttap.decay(); // decay it
			if(ttap.length <= 0) // if the tap is over
			{
				taps.remove(i); // remove the tap
				println("TAP DIED");
			}
		}
	}
	
	// The Seaweed
	node1.addForce();
	node1.update();
	node1.display();
	node2.addForce();
	node2.update();
	node2.display();

	// Instructions
	textAlign(CENTER);
	fill(0);
	text("RIGHT CLICK TO SPAWN FISH",width/2,height-30);
	text("LEFT CLICK TO TAP ON GLASS",width/2,height-15);
	
	float temper = (float)rando.nextGaussian();
	text(temper,width/2,20);
	text("Theta: "+node1.theta,width/2,40);
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
