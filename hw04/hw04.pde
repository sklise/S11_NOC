// Steven Klise <http://stevenklise.com>
// Nature of Code, ITP 2011
// Week 04

// Fish Tank, now a Particle System

System tank;

void setup()
{
	size(500,500);
	smooth();
	frameRate(60);
	
	tank = new System();
}

void draw()
{
	// Graphics
	background(255,255,255);
	noFill();
	stroke(0);
	rect(0,0,width-1,height-1);
	fill(0);
	rect(0,height-10,width,height);
	cursor(HAND);

	tank.run();
}

void mouseClicked()
{
	if(mouseButton == RIGHT)
	{
		tank.addFish();
	}
}