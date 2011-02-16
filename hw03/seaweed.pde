class Seaweed
{
	/*
	A Seaweed is an ordered set of nodes each with a
	preferred distance from the previous node, treated
	as a spring constant. Nodes move like rather rigid
	spring pendulums, but with a high amount of damping
	
	Wishlist:
	Seaweeds move based on the proximity of fish, i.e.
	*/
	
	PVector loc; // Where the seaweed is planted.
	ArrayList<Node> nodes; // How many Nodes there are to make up the plant.
	
	Seaweed(PVector _loc, int _nNodes )
	{
		loc = _loc;
		nodes = new ArrayList();
		for(int i=0; i< _nNodes; i++)
		{
			Node temp;
			if(i == 0)
			{
				temp = new Node(HALF_PI,noise(noiseoff)*30+5,loc);
			}
			else
			{
				temp = new Node(HALF_PI,noise(noiseoff)*30+5,nodes.get(i-1).loc);
			}
			nodes.add(temp);
			noiseoff+=0.1;
		}
	}
	
	void update()
	{
		for(int i = 0; i < nodes.size(); i++)
		{
			Node n = nodes.get(i);
			n.update();
		}
	}
	
	void display()
	{
		for(int i = 0; i < nodes.size(); i++)
		{
			Node n = nodes.get(i);
			n.display();
		}
	}
}
class Node
{
	/*
	A Node is a spring-pendulum element of a Seaweed.
	*/
	
	PVector anchor; // Where the Node is anchored, in practice will be a reference to the location of another node.
	PVector loc; // Where the Node is.
	float len; // Length from anchor to location.
	float theta; // Angle of Node.
	float aVel; // Angular velocity
	float aAcc; // Angular acceleration
	
	float damping; // We're in water and this isn't really a pendulum, so slow it down quite a bit.
	float k; // Spring constant, I want a rather rigid spring.
	
	Node(float _theta, float _len, PVector _anchor)
	{
		theta = _theta; // Angle from the X-Axis.
		len = _len; // 'Radius'
		anchor = _anchor;
		float x = len * cos(theta); // Simply converting Radial to Cartesian.
		float y = -len * sin(theta); // len is negative because the y axis is opposite Cartesian.
		loc = new PVector(anchor.x+x,anchor.y+y); // The location of the Node is in reference to its anchor.
		aVel = 0;
		aAcc = 0.001;
		damping = 0.5;
		k = 0.01;
	}
	
	void addForce()
	{
		
	}
	
	void update()
	{
		aAcc = (float)rando.nextGaussian()/20;
		aVel += aAcc;
		aVel *= damping;
		theta += aVel;
		theta = constrain(theta,PI/3,PI*2/3);
		loc.x = len * cos(theta)+anchor.x;
		loc.y = -len * sin(theta)+anchor.y;
		aAcc = 0;
	}
	
	void display()
	{
		stroke(#214b18);
		strokeWeight(4);
		line(anchor.x,anchor.y,loc.x,loc.y);
	}
	
}
