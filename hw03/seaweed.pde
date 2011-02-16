class Seaweed
{
	/*
	A Seaweed is an ordered set of nodes each with a
	preferred distance from the previous node, treated
	as a spring constant. Nodes move like rather rigid
	spring pendulums, but with a high amount of damping
	
	**** REQUIRES THE NODE CLASS ****
	
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
			Node temp; // Iterate through and create the specified number of Nodes
			if(i == 0) // If this is the base node
			{
				temp = new Node(HALF_PI,noise(noiseoff)*30+5,loc); // Use the Seaweed.loc as the anchor point
			}
			else // otherwise use the previous node as the anchor.
			{
				temp = new Node(HALF_PI,noise(noiseoff)*30+5,nodes.get(i-1).loc);
			}
			nodes.add(temp); // Add the node to the list.
			noiseoff+=0.1; // Increment the Perlin Noise.
		}
	}
	
	void update()
	{
		for(int i = 0; i < nodes.size(); i++)
		{
			Node n = nodes.get(i);
			n.update(); // Run update on all Nodes.
		}
	}
	
	void display()
	{
		for(int i = 0; i < nodes.size(); i++)
		{
			Node n = nodes.get(i);
			n.display(); // Display all Nodes.
		}
	}
}