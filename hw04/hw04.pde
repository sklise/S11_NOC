// Steven Klise <http://stevenklise.com>
// Nature of Code, ITP 2011
// Week 04

// Fish Tank, now a Particle System

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
	fill(14,153,250,180);
	rect(0,20,width,height);
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