BaGrid grid;
int nextTick;

public final int WATER_TOOL = 0;
public final int SULFUR_TOOL = 1;
public final int METHANE_TOOL = 2;
public final int OXYGEN_TOOL = 3;
public final int CO2_TOOL = 4;
public final int AIR_TOOL = 5;
public final int TOOLS_LENGTH = 6;

int[] samples;
String[] sampleLetters;
int currentSample = 0;

int tool = WATER_TOOL;
  
public boolean investigateMode = true;
public int investigateType = 0;

PFont font;
PFont font2;
PImage bg;

void setup() {
  size(800, 600);
  bg = loadImage("background.png");
  
  grid = new BaGrid(79, 45);
  nextTick = 1000;
  
  font = loadFont("OpenSans-16.vlw");
  font2 = loadFont("OpenSans-30.vlw");
  textFont(font);
  textSize(16);
  
  samples = new int[6];
  samples[0] = 2;
  samples[1] = 1;
  samples[2] = 3;
  samples[3] = 2;
  samples[4] = 4;
  samples[5] = 1;
  
  sampleLetters = new String[6];
  sampleLetters[0] = "A";
  sampleLetters[1] = "B";
  sampleLetters[2] = "C";
  sampleLetters[3] = "D";
  sampleLetters[4] = "E";
  sampleLetters[5] = "F";
  
  placeSample();
}

void draw() {
  strokeWeight(1);
  image(bg, 0, 0);  
  grid.Display(5, 50);
  
  stroke(#000000);
  noFill();
  rect(5, 50, 789, 454);
  
  if (tool != WATER_TOOL && tool != AIR_TOOL) {
    stroke(#71C4B6);
    fill(#FFFFFF);
    rect(10, 60, 210, 30);
    stroke(#000000);
    fill(#71C4B6);
    textAlign(LEFT);
    if (tool == SULFUR_TOOL) {
      text("Sulfur Level", 45, 82);
      fill(#D89595);
    } else if (tool == OXYGEN_TOOL) {
      text("Oxygen Level", 45, 82);
      fill(#A9DDA4);
    } else if (tool == METHANE_TOOL) {
      text("Methane Level", 45, 82);
      fill(#D3D68F);
    } else if (tool == CO2_TOOL) {
      text("Carbon Dioxide Level", 45, 82);
      fill(#C2A4DD);
    }
    rect(13, 63, 24, 24);
  }
  
  if (millis() > nextTick) {
    grid.Tick();
    
    nextTick += 100;
  }
  
  if (isMouseDown) {
    mouseDown();
  }
  
  fill(#FFFFFF);
  textFont(font2);
  textSize(30);
  textAlign(CENTER);
  text(sampleLetters[currentSample], 407, 35);
  textFont(font);
  textSize(16);
  
  noFill();
  textAlign(CENTER);
  if (tool == WATER_TOOL) {
    stroke(#FFFFFF);
    strokeWeight(8);
    rect(34, 544, 114, 40);
    stroke(#71C4B6);
    strokeWeight(1);
    rect(34, 544, 114, 40);
    fill(#FFFFFF);
    text("PURE WATER", 400, 530);
  } else if (tool == SULFUR_TOOL) {
    stroke(#FFFFFF);
    strokeWeight(8);
    rect(158, 544, 114, 40);
    stroke(#71C4B6);
    strokeWeight(1);
    rect(158, 544, 114, 40);
    fill(#FFFFFF);
    text("SULFUR POWDER", 400, 530);
  } else if (tool == METHANE_TOOL) {
    stroke(#FFFFFF);
    strokeWeight(8);
    rect(282, 544, 114, 40);
    stroke(#71C4B6);
    strokeWeight(1);
    rect(282, 544, 114, 40);
    fill(#FFFFFF);
    text("METHANE IN SOLUTION", 400, 530);
  } else if (tool == OXYGEN_TOOL) {
    stroke(#FFFFFF);
    strokeWeight(8);
    rect(405, 544, 114, 40);
    stroke(#71C4B6);
    strokeWeight(1);
    rect(405, 544, 114, 40);
    fill(#FFFFFF);
    text("OXYGEN IN SOLUTION", 400, 530);
  } else if (tool == CO2_TOOL) {
    stroke(#FFFFFF);
    strokeWeight(8);
    rect(529, 544, 114, 40);
    stroke(#71C4B6);
    strokeWeight(1);
    rect(529, 544, 114, 40);
    fill(#FFFFFF);
    text("CARBON DIOXIDE IN SOLUTION", 400, 530);
  } else if (tool == AIR_TOOL) {
    stroke(#FFFFFF);
    strokeWeight(8);
    rect(653, 544, 114, 40);
    stroke(#71C4B6);
    strokeWeight(1);
    rect(653, 544, 114, 40);
    fill(#FFFFFF);
    text("REMOVE CHEMICALS", 400, 530);
  }
}


boolean isMouseDown = false;
void mousePressed() {
  isMouseDown = true;
}

void mouseReleased() {
  isMouseDown = false;
}

void mouseDown() {
  if (mouseButton == LEFT) {
    for (int i = 0; i < grid.hexes.length; ++i) {
      if (grid.hexes[i].CheckBounds(mouseX - 5, mouseY - 50)) {
        grid.hexes[i].Click(tool);
      }
    }
    
    if (34 < mouseX && mouseX < 34 + 114 && 544 < mouseY && mouseY < 584) {
      tool = WATER_TOOL;
      investigateType = 0;
    } else if (158 < mouseX && mouseX < 158 + 114 && 544 < mouseY && mouseY < 584) {
      tool = SULFUR_TOOL;
      investigateType = BaHex.SULFUR;
    } else if (282 < mouseX && mouseX < 282 + 114 && 544 < mouseY && mouseY < 584) {
      tool = METHANE_TOOL;
      investigateType = BaHex.METHANE;
    } else if (405 < mouseX && mouseX < 405 + 114 && 544 < mouseY && mouseY < 584) {
      tool = OXYGEN_TOOL;
      investigateType = BaHex.OXYGEN;
    } else if (529 < mouseX && mouseX < 529 + 114 && 544 < mouseY && mouseY < 584) {
      tool = CO2_TOOL;
      investigateType = BaHex.CO2;
    } else if (653 < mouseX && mouseX < 653 + 114 && 544 < mouseY && mouseY < 584) {
      tool = AIR_TOOL;
      investigateType = 0;
    }
    
  } else if (mouseButton == RIGHT) {
  }
}

void mouseWheel(MouseEvent event) {
  int e = ceil(event.getCount());
  tool = (tool + TOOLS_LENGTH + e) % TOOLS_LENGTH;
  
  if (tool == SULFUR_TOOL) {
    investigateType = BaHex.SULFUR;
  } else if (tool == OXYGEN_TOOL) {
    investigateType = BaHex.OXYGEN;
  } else if (tool == CO2_TOOL) {
    investigateType = BaHex.CO2;
  } else if (tool == METHANE_TOOL) {
    investigateType = BaHex.METHANE;
  } else {
    investigateType = 0;
  }
}

void keyTyped() {
  println("Key: " + key + " (" + int(key) + ")");
  if (key == 'x') {
    investigateMode = !investigateMode;
  } else if (int(key) == 9) {
    currentSample = (currentSample + 1) % samples.length;
    println("Current Sample: " + currentSample);
    grid.ClearGrid();
    placeSample();
  } else if (int(key) == 32) {
    println("Current Sample: " + currentSample);
    grid.ClearGrid();
    placeSample();
  }
}

void placeSample() {
  BaHex hex; //1777
  hex = grid.hexes[1753];
  hex.growth = samples[currentSample];
  for (int i = 0; i < hex.neighbors.size(); ++i) {
    hex.neighbors.get(i).growth = samples[currentSample];
  }
  hex = grid.hexes[1800];
  hex.growth = samples[currentSample];
  for (int i = 0; i < hex.neighbors.size(); ++i) {
    hex.neighbors.get(i).growth = samples[currentSample];
  }
}
