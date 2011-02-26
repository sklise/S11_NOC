// Steven Klise <http://stevenklise.com>
// Nature of Code, ITP 2011
// Week 04

// Fish Tank, now a Particle System

// TODO:
// - Make food.eaten() recognize the front half of the fish. (Heading 2D, mass)
// + Make the fish want food.
// - Make fish avoid overlapping.
// - Get the fish moving on their own flow field.
// - Morph a flow field over time.

System tank;
FlowField flowfield;

void setup()
{
	size(500,500);
	smooth();
	frameRate(60);
	
	flowfield = new FlowField(16);
	tank = new System();
}

void draw()
{
	// Graphics
	background(255,255,255);
	noStroke();
	fill(14,153,250,180); // the water
	rect(0,20,width,height);
	fill(39,17,14);
	rect(0,height-10,width,height); // the ground
	noFill();
	stroke(0);
	rect(0,0,width-1,height-1);
	cursor(HAND);
	
	// The system.
	tank.run();
	
	if ( frameCount <= 1200 )
	{
		textAlign(CENTER);
		text("RIGHT CLICK TO SPAWN FISH. LEFT CLICK TO DROP FOOD",width/2,height-30);
	}
}

void mouseClicked()
{
	if(mouseButton == RIGHT)
	{
		tank.addFish();
	}
}