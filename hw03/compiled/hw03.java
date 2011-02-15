import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class hw03 extends PApplet {

// Steve Klise http://stevenklise.com
// Nature of Code, ITP Spring 2011

// Week 03

// Fish Tank, with seaweed.

ArrayList<Fish> fishes;
ArrayList<Tap> taps;
float intensity;
float G = 1;

Node node1;
Node node2;
Random rando;

public void setup()
{
	size(500,500);
	smooth();
	fishes = new ArrayList();
	taps = new ArrayList();
	frameRate(60);
	rando = new Random();
	
	PVector node1anc = new PVector(30,height-10);
	node1 = new Node(0,30,node1anc);
	PVector node2loc = new PVector(28,height-60);
	node2 = new Node(0,20,node1.loc);
}

public void draw()
{
	// Display stuff
	background(255,255,255);
	noFill();
	stroke(0);
	rect(0,0,width-1,height-1);
	cursor(HAND);

	// The Fish
	if(fishes.size() >  0) // if there are fish
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
	if(taps.size() >  0) // if there is a tap
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
	node1.display();
	node2.display();

	// Instructions
	textAlign(CENTER);
	fill(0);
	text("RIGHT CLICK TO SPAWN FISH",width/2,height-30);
	text("LEFT CLICK TO TAP ON GLASS",width/2,height-15);
	
	text(rando.nextGaussian(),widht/2,20);
}

public void mouseClicked()
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

public void mousePressed()
{
	if(intensity == 0)
	{
		intensity = millis();
	}
}

public void mouseReleased()
{
	if(mouseButton == RIGHT)
	{
	  PVector currentMouse = new PVector(mouseX,mouseY);
	  Fish temp = new Fish(currentMouse,frameCount%(width/2));
	  fishes.add(temp);
	}
	intensity = constrain(millis()-intensity,0,200);
}
class Fish
{
  // MOVEMENT
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  // TRAITS
  float mass;
  float skittishness;
  float topspeed; // a topspeed of each fish, determined by skittishness/mass
  // a big skittish fish will only move a bit.
  // a small skittish fish is going to move more crazily.

  Random yswim; // gaussian movement in y direction
  Random xswim; // gaussian movement in x direction

  float buffer = 30; // distance away from an edge at which the buffer zones start.

  Fish(PVector _location, float _skittishness)
  {
    location = _location; // will be input from right mouse click.
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);

    mass = map(location.mag(),0,800,1,20); // wherever the fish is spawned at determines how big he gets
    skittishness = _skittishness;
    topspeed = constrain(skittishness/mass,0,2);
	yswim = new Random();
    xswim = new Random();
  }

  public void forces()
  {
	// If the fish is near the left side of the screen.
	if(location.x <  buffer)
	{
		// add a right pointing acceleration if the fish is too close to the left edge.
		PVector dragLeft = new PVector(velocity.mag(),0);
		dragLeft.mult(0.125f);
		acceleration.add(dragLeft);
		// println("Slowing down");
	}
	else if (location.x >  width-buffer)
	{
		// add a left pointing acceleration if the fish is too close to the right edge.
		PVector dragRight = new PVector(velocity.mag(),0);
		dragRight.mult(-0.125f);
		acceleration.add(dragRight);
		// println("Slowing down");
	}
	else if (location.y >  height-buffer)
	{
		// add a up pointing acceleration if the fish is too close to the bottom edge.
		PVector dragDown = new PVector(0,velocity.mag());
		dragDown.mult(-0.125f);
		acceleration.add(dragDown);
		// println("Slowing down");
	}
	else if (location.y <  buffer)
	{
		// add a down pointing acceleration if the fish is too close to the top edge.
		PVector dragUp = new PVector(0,velocity.mag());
		dragUp.mult(0.125f);
		acceleration.add(dragUp);
		// println("Slowing down");
	}
    else
    {
      acceleration.x = (float)xswim.nextGaussian();
      acceleration.y = (float)yswim.nextGaussian()/20; // changes in Y should be smaller than X.
      acceleration.normalize(); // Normalize
      acceleration.mult(.03f); // Reduce acceleration!
    }
	
	// JUST KEEP SWIMMING, JUST KEEP SWIMMING
	if(acceleration.mag() == 0)
	{
		acceleration.x = (float)xswim.nextGaussian();
	      acceleration.y = (float)yswim.nextGaussian()/20; // changes in Y should be smaller than X.
	      acceleration.normalize(); // Normalize
	      acceleration.mult(.03f); // Reduce acceleration!
	}
  }

	public void update()
	{
		if(taps.size()>0)
		{
			for(int i=0; i <  taps.size(); i++)
			{
				Tap temp = (Tap)taps.get(i);
				isNearby(temp);
			}
		}
		acceleration.div(mass);
		velocity.add(acceleration);
		velocity.limit(topspeed);
		location.add(velocity);
		acceleration.mult(0);
	}

  	public void isNearby(Tap atap)
	{
		PVector force = PVector.sub(location,atap.loc); // a vector point from the tap to the fish.
		float distance = force.mag();
		force.normalize(); // normalize that vector, make it just a direction essentially.
		float m = (G * atap.mass * mass) / (distance * distance);
		force.mult(m);
		acceleration.add(force);
	}

  public void display()
  {
    fill(0);
    pushMatrix();
    	stroke(0);
	    translate(location.x,location.y);
		float fishHead = constrain(velocity.heading2D(),PI/3,-PI/3);
	    rotate(velocity.heading2D());
	    ellipse(0,0,mass*2,mass);
	    triangle(0-mass,0,0-mass*3/2,0+mass/2,0-mass*3/2,0-mass/2);
	    stroke(255,0,0);
    popMatrix();
    // debug lines
    // line(location.x,location.y,(location.x+velocity.x*90),(location.y+velocity.y*90));
  }
}

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
//		loc = _loc;
//		for(int i=0; i< _nNodes; i++)
//		{
//			if(i>0)
//			{
//				
//				Node temp = new Node( , , );
//				nodes.add(temp);
//			}
//		}
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
	
	Node(float theta, float _len, PVector _anchor)
	{
		loc = _loc;
		len = _len;
		anchor = _anchor;
		aVel = 0;
		aAcc = 0.00001f;
		theta = 0;
		damping = 0.5f;
		k = 0.01f;
	}
	
	public void addForce()
	{
		
	}
	
	public void update()
	{
		
	}
	
	public void display()
	{
		stroke(0xff214b18);
		strokeWeight(4);
		line(anchor.x,anchor.y,loc.x,loc.y);
	}
	
}
class Tap
{
	// A tap is a repeller of fish that is generated on left mouse clicks and then decays.
	// Time sensitive inverse gravity.
	
	PVector loc; // where the tap happened.
	float length; // how long it will last.
	float mass; // how massive was the tap?
	
	Tap(float _x, float _y, float _mass)
	{
		loc = new PVector(_x,_y);
		mass = _mass; // this isn't written properly, probably.
		length = 100;
	}
	
	public void decay()
	{
		length--;
	}
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#ffffff", "--stop-color=#cccccc", "hw03" });
  }
}
