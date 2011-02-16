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
		damping = 0.99;
		k = 0.01;
		
		//
		PVector diff = PVector.sub(anchor,loc);
		
		theta = atan2(diff.y,diff.x) ;
	}
	
	void addForce()
	{
		theta += noise(noiseoff)/12;
		noiseoff+=0.1;
	}
	
	void update()
	{
		aAcc = (-G/len)*cos(theta);
		aVel += aAcc;
		aVel *= damping;
		theta = constrain(theta,PI/3,PI*2/3);
		loc.x = len * cos(theta)+anchor.x;
		loc.y = -len * sin(theta)+anchor.y;
		
		theta += aVel;
		aAcc = 0;
	}
	
	void display()
	{
		stroke(#214b18);
		strokeWeight(4);
		line(anchor.x,anchor.y,loc.x,loc.y);
	}
	
}