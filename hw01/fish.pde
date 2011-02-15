class Fish
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float fishSize;
  float skittishness;
  PVector offset;
  Random yswim;
  Random xswim;

  Fish(PVector _location, float _skittishness)
  {
    location = _location; // will be input from right mouse click.
    fishSize = map(location.mag(),0,800,1,20); // wherever the fish is spawned at determines how big he gets
    offset = new PVector(0,0);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    skittishness = _skittishness;
    yswim = new Random();
    xswim = new Random();
  }

  void update()
  {
    if(mousePressed == true && mouseButton == LEFT) // if the mouse is pressed (if the glass is tapped).
    {
      PVector mouse = new PVector(mouseX,mouseY); // find where the mouse is.
      PVector evade = PVector.sub(location,mouse); // Get the vector pointing away from the mouse.
      float space = evade.mag();
      if(space <= skittishness+20)
      {
        evade.normalize();
        print("EVADE ");
        acceleration = PVector.mult(evade,.25);
        acceleration.normalize(); // Normalize
        println(acceleration);
      }
    }
    else
    {
      acceleration.x = (float)xswim.nextGaussian();
      acceleration.y = (float)yswim.nextGaussian()/20; // changes in Y should be smaller than X.
      acceleration.normalize(); // Normalize
      acceleration.mult(.03); // Reduce acceleration!
    }
    
    checkEdge();
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
  }

  void checkEdge()
  {
    if(location.x+fishSize >= width)
    {
      location.x = width-fishSize;
      velocity.x *= -1; // At an inflection in velocity
    } else if (location.x <= fishSize)
    {
      location.x = fishSize;
      velocity.x *= -1;
    }
    if(location.y >= height-fishSize/2)
    {
      location.y = height-fishSize/2;
      velocity.y *= -1; // At an inflection in velocity
    } else if (location.y <= fishSize/2)
    {
      location.y = fishSize/2;
      velocity.y *=-1;
    }
  }

  void display()
  {
    fill(0);
    pushMatrix();
    stroke(0);
    xaxis = new PVector(1.0,0.0);
    translate(location.x,location.y);
    rotate(velocity.heading2D());
    ellipse(0,0,fishSize*2,fishSize);
    triangle(0-fishSize,0,0-fishSize*3/2,0+fishSize/2,0-fishSize*3/2,0-fishSize/2);
    stroke(255,0,0);
    popMatrix();
    // debug lines
    //line(location.x,location.y,(location.x+velocity.x*90),(location.y+velocity.y*90));
  }
}

