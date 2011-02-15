// Steve Klise http://stevenklise.com
// Nature of Code, ITP Spring 2011

// Week 01

// A 'fish' in a fish tank and a 'finger' tapping the glass.

ArrayList fishes = new ArrayList();
float topspeed = 2.5;
PVector xaxis;
void setup()
{
  size(500,500);
  smooth();
  xaxis = new PVector(1,0);
}

void draw()
{
  background(255,255,255,255);
  noFill();
  stroke(0);
  rect(0,0,width-1,height-1);
  cursor(HAND);
  if(fishes.size() > 0)
  {
    for(int i=0; i<fishes.size(); i++)
    {
      Fish temp = (Fish)fishes.get(i);
      temp.update();
      temp.display();
    }
  }  
  textAlign(CENTER);
  fill(0);
  text("RIGHT CLICK TO SPAWN FISH",width/2,height-30);
  text("LEFT CLICK TO TAP ON GLASS",width/2,height-15);
}

void mouseReleased()
{
  if(mouseButton == RIGHT)
  {
    PVector currentMouse = new PVector(mouseX,mouseY);
    Fish temp = new Fish(currentMouse,frameCount%(width/2));
    fishes.add(temp);
  }
}
