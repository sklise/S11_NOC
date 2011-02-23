class System
{
	// EVERYTHING ALL THE TIME
	ArrayList<Fish> fishes; // f
	ArrayList<Food> bits; // b
	ArrayList<Detritus> remains; // r
	
	System()
	{
		fishes = new ArrayList<Fish>();
		bits = new ArrayList<Food>();
		remains = new ArrayList<Detritus>();
	}
	
	void run()
	{
		// The Fish
		if(fishes.size() > 0) // if there are fish
		{
			for(Fish f : fishes) // iterate through all fish
			{
				f.forces(); // calculate forces on fish.
				f.update(); // update movement of fish.
				f.display(); // draw the fish to the screen.
			}
		}
		sprinkleFood();
		// The Food
		if(bits.size() > 0)
		{
			println(bits.size());
			Iterator<Food> i = bits.iterator();
			while(i.hasNext())
			{
				Food b = i.next();
				b.follow(flowfield);
				b.run();
				if( b.eaten(fishes) )
				{
					i.remove(); // If the food was eaten, delete it.
				}
				if( b.grounded() ) // If the Food has hit the ground, turn it in to a Crumb.
				{
					i.remove(); // Remove it from 'bits'
					remains.add(new Crumb(b.loc,b.angles,b.r));
				}
			}
		}
		
		if( remains.size() > 0 )
		{
			Iterator<Detritus> i = remains.iterator();
			while(i.hasNext())
			{
				Detritus d = i.next();
				d.display();
			}
		}
	}
	
	void addFish()
	{
		PVector currentMouse = new PVector(mouseX,mouseY);
		fishes.add(new Fish(currentMouse,frameCount%(width/2)));
	}
	
	void sprinkleFood()
	{
		if(mousePressed && mouseButton == LEFT && frameCount % 3 == 0)
		{
			bits.add(new Food(mouseX,20));
		}
	}
}
