class BaHex {
  
  public final static int AIR = 0;
  public final static int LIQUID = 1;
  public final static int SOLID = 2;
  
  public final static int PRESSURE = 0;
  public final static int OXYGEN = 1;
  public final static int SULFUR = 2;
  public final static int METHANE = 3;
  public final static int CO2 = 4;
  
  public final static int NOTHING = 0;
  public final static int TYPE1 = 1; // Needs oxygen and sulfur
  public final static int TYPE2 = 2; // Needs methane; hates oxygen
  public final static int TYPE3 = 3; // Needs CO2; hates oxygen
  public final static int TYPE4 = 4; // Needs CO2 and sulfur
  
  public int index;
  public float x;
  public float y;
  
  public int size = 10;
  private int margin;
  
  public BaHexContent contents;
  public int growth;
  
  public int marked = 0;
  
  private BaHexCollection neighbors;
  
  BaHex() {
    margin = 1 + floor((size - 2) / 4);
    contents = new BaHexContent();
    growth = NOTHING;
    neighbors = new BaHexCollection();
  }
  
  public void AddNeighbor(BaHex toAdd) {
    neighbors.add(toAdd);
  }
  
  public void Display(int offX, int offY) {
    
    color displayColor = #FFFFFF;
    int colorValue1 = 0;
    int colorValue2 = 0;
    int colorValue3 = 0;
    int noisePos1 = 0;
    int noisePos2 = 0;
    float saturation = 0.0f;
    float pressure = 0.0f;
    int investigateColor = 0;
    
    noStroke();
    if (contents.type == AIR) {
      // Don't display anything.
    } else if (contents.type == LIQUID) {
      colorMode(HSB, 360, 100, 100);
      if (!investigateMode || investigateType == 0) {
        colorValue1 = 209;
      } else {
        saturation = constrain(pow(1000 * contents.get(investigateType), 2) / 100.0f, 0.0f, 1.0f);
        if (investigateType == OXYGEN) investigateColor = 114;
        else if (investigateType == SULFUR) investigateColor = 0;
        else if (investigateType == METHANE) investigateColor = 62;
        else if (investigateType == CO2) investigateColor = 272;
        //colorValue1 = (360 + (209 + floor(saturation * (investigateColor - 209)))) % 360;
        colorValue1 = investigateColor;
      }
      pressure = contents.get(PRESSURE) / 6.0f;
      colorValue2 = floor(pressure * 100.0f);
      colorValue3 = 100 - floor(pressure * 50.0f);
      
      if (investigateMode && investigateType != 0) {
        colorValue2 = floor(colorValue2 * (saturation));
      }
      
      displayColor = color(colorValue1, colorValue2, colorValue3);
      colorMode(RGB, 255);
      
      fill(displayColor);
      //rect(offX + (x * size) + 1, offY + (y * size) + 1, size - 2, size - 2);
      rect(offX + (x * size), offY + (y * size), size, size);
    } else if (contents.type == SOLID) {
      fill(#000000);
      rect(offX + (x * size) + 1, offY + (y * size) + 1, size - 2, size - 2);
      fill(#CC0000);
      rect(offX + (x * size) + 2, offY + (y * size) + 2, size - 3, size - 3);
    }
    
    if (growth != NOTHING) {
      if (growth == TYPE1) {
        fill(#33FF33);  
      } else if (growth == TYPE2) {
        fill(#33FF33);
      } else if (growth == TYPE3) {
        fill(#33FF33);
      } else if (growth == TYPE4) {
        fill(#33FF33);
      }
      
      stroke(#008800);
      rect (offX + (x * size) + margin, offY + (y * size) + margin, size - (2 * margin) - 1, size - (2 * margin) - 1);
    }
  }
  
  public void Click(int tool) {
    //println(index + ": " + contents.toString());
    if (tool == WATER_TOOL) {
      contents.type = LIQUID;
      contents.clearData();
      contents.set(PRESSURE, 6.0f);
      BaHexCollection collection = GetAllWithinRange(1);
      for (int i = 0; i < collection.size(); ++i) {
        collection.get(i).contents.type = LIQUID;
        collection.get(i).contents.clearData();
        collection.get(i).contents.set(PRESSURE, 6.0f);
      }
    } else if (tool == AIR_TOOL) {
      contents.type = AIR;
      contents.clearData();
      BaHexCollection collection = GetAllWithinRange(3);
      for (int i = 0; i < collection.size(); ++i) {
        if (collection.get(i).contents.type == LIQUID) {
          collection.get(i).contents.set(PRESSURE, max(0.0f, collection.get(i).contents.get(PRESSURE) - 1.0f));
        } else if (collection.get(i).contents.type == SOLID) {
          collection.get(i).contents.type = AIR;
          collection.get(i).contents.clearData();
        }
      }
    } else if (tool == SULFUR_TOOL) {
      contents.type = SOLID;
      contents.clearData();
      contents.set(SULFUR, 2.0f);
      BaHexCollection collection = GetAllWithinRange(1);
      for (int i = 0; i < collection.size(); ++i) {
        collection.get(i).contents.type = SOLID;
        collection.get(i).contents.clearData();
        collection.get(i).contents.set(SULFUR, 2.0f);
      }
    } else if (tool == OXYGEN_TOOL) {
      contents.type = LIQUID;
      contents.clearData();
      contents.set(PRESSURE, 6.0f);
      contents.set(OXYGEN, 1.0f);
      BaHexCollection collection = GetAllWithinRange(1);
      for (int i = 0; i < collection.size(); ++i) {
        collection.get(i).contents.type = LIQUID;
        collection.get(i).contents.clearData();
        collection.get(i).contents.set(PRESSURE, 6.0f);
        collection.get(i).contents.set(OXYGEN, 1.0f);
      }
    } else if (tool == METHANE_TOOL) {
      contents.type = LIQUID;
      contents.clearData();
      contents.set(PRESSURE, 6.0f);
      contents.set(METHANE, 1.0f);
      BaHexCollection collection = GetAllWithinRange(1);
      for (int i = 0; i < collection.size(); ++i) {
        collection.get(i).contents.type = LIQUID;
        collection.get(i).contents.clearData();
        collection.get(i).contents.set(PRESSURE, 6.0f);
        collection.get(i).contents.set(METHANE, 1.0f);
      }
    } else if (tool == CO2_TOOL) {
      contents.type = LIQUID;
      contents.clearData();
      contents.set(PRESSURE, 6.0f);
      contents.set(CO2, 1.0f);
      BaHexCollection collection = GetAllWithinRange(1);
      for (int i = 0; i < collection.size(); ++i) {
        collection.get(i).contents.type = LIQUID;
        collection.get(i).contents.clearData();
        collection.get(i).contents.set(PRESSURE, 6.0f);
        collection.get(i).contents.set(CO2, 1.0f);
      }
    }
  }
  
  public void Tick() {
    BaHexCollection waterSubset;
    BaHexCollection nothingSubset;
    float neighborWaterPressure;
    float neighborDataValue;
    BaHex randomNeighbor;
    float chance;
    float transfer;
    
    // === WATER ====
    if (contents.type == LIQUID) {
      if (contents.get(PRESSURE) < 1.0f) {
        chance = floor(random(100));
        if (chance < 5) {
          contents.type = NOTHING;
          contents.clearData();
        }
      } else {
        waterSubset = neighbors.CollectWithContents(LIQUID);
        for (int dataType = 0; dataType < 5; ++dataType) {
          if (contents.get(dataType) > 0.0f) {
            neighborDataValue = contents.get(dataType);
            for (int i = 0; i < waterSubset.size(); ++i) {
              neighborDataValue += waterSubset.get(i).contents.get(dataType);
            }
            neighborDataValue = neighborDataValue / (waterSubset.size() + 1);
            contents.set(dataType, neighborDataValue);
            for (int i = 0; i < waterSubset.size(); ++i) {
              waterSubset.get(i).contents.set(dataType, neighborDataValue);
            }
          }
        }
        
        nothingSubset = neighbors.CollectWithContents(NOTHING);
        if (nothingSubset.size() > 0 && contents.get(PRESSURE) > 2.0f) {
          randomNeighbor = nothingSubset.get(floor(random(nothingSubset.size())));
          randomNeighbor.contents.type = LIQUID;
          randomNeighbor.contents.clearData();
          randomNeighbor.contents.set(PRESSURE, contents.get(PRESSURE) / 2.0f);
          contents.set(PRESSURE, contents.get(PRESSURE) / 2.0f);
        }
      }
    }
    
    // === AIR ===
    else if (contents.type == AIR) {
      waterSubset = neighbors.CollectWithContents(LIQUID);
      chance = random(5, 100);
      if (chance < pow(2, waterSubset.size())) {
        neighborWaterPressure = 0.0f;
        for (int i = 0; i < waterSubset.size(); ++i) {
          neighborWaterPressure += waterSubset.get(i).contents.get(PRESSURE);
        }
        neighborWaterPressure = neighborWaterPressure / (waterSubset.size() + 1);
        contents.type = LIQUID;
        contents.set(PRESSURE, neighborWaterPressure);
        for (int i = 0; i < waterSubset.size(); ++i) {
          waterSubset.get(i).contents.set(PRESSURE, neighborWaterPressure);
        }
      }
    }
    
    // === SULFUR ===
    else if (contents.type == SOLID && contents.get(SULFUR) > 0.0f) {
      waterSubset = neighbors.CollectWithContents(LIQUID);
      for (int i = 0; i < waterSubset.size(); ++i) {
        transfer = min(contents.get(SULFUR), random(0.2f));
        contents.set(SULFUR, contents.get(SULFUR) - transfer);
        neighbors.get(i).contents.set(SULFUR, neighbors.get(i).contents.get(SULFUR) + transfer);
        if (contents.get(SULFUR) == 0.0f) {
          contents.type = AIR;
        }
      }
    }
    
    if (growth == TYPE1) { // Needs oxygen and sulfur.
      if (contents.type == LIQUID) {
        if (false) {
          growth = NOTHING;
        } else {
          //contents.set(PRESSURE, max(0.0f, contents.get(PRESSURE) - 0.05f));
          if (contents.get(PRESSURE) > 0.5f) {
            waterSubset = neighbors.CollectWithContents(LIQUID);
            if (waterSubset.size() > 0) {
              randomNeighbor = waterSubset.get(floor(random(waterSubset.size())));
              if (randomNeighbor.contents.get(OXYGEN) > 0.01f && randomNeighbor.contents.get(SULFUR) > 0.01f) {
                randomNeighbor.growth = TYPE1;
              }
            }
          }
        }
      }
    }
    else if (growth == TYPE2) { // Nees methane; hates oxygen.
      if (contents.type == LIQUID) {
        if (contents.get(OXYGEN) > 0.004f) {
            growth = NOTHING;
        } else {
          //contents.set(PRESSURE, max(0.0f, contents.get(PRESSURE) - 0.05f));
          if (contents.get(PRESSURE) > 0.5f) {
            waterSubset = neighbors.CollectWithContents(LIQUID);
            if (waterSubset.size() > 0) {
              randomNeighbor = waterSubset.get(floor(random(waterSubset.size())));
              if (randomNeighbor.contents.get(METHANE) > 0.01f) {
                randomNeighbor.growth = TYPE2;
              }
            }
          }
        }
      }
    }
    else if (growth == TYPE3) { // Needs CO2; hates oxygen.
      if (contents.type == LIQUID) {
        if (contents.get(OXYGEN) > 0.004f) {
          growth = NOTHING;
        } else {
          //contents.set(PRESSURE, max(0.0f, contents.get(PRESSURE) - 0.05f));
          if (contents.get(PRESSURE) > 0.5f) {
            chance = random(100);
            if (chance > 90) {
            waterSubset = neighbors.CollectWithContents(LIQUID);
              if (waterSubset.size() > 0) {
                randomNeighbor = waterSubset.get(floor(random(waterSubset.size())));
                if (randomNeighbor.contents.get(CO2) > 0.01f) {
                  randomNeighbor.growth = TYPE3;
                }
              }
            }
          }
        }
      }
    }
    else if (growth == TYPE4) { // Needs CO2 and sulfur; hates methane.
      if (contents.type == LIQUID) {
        if (contents.get(METHANE) > 0.004f) {
          growth = NOTHING;
        } else {
          //contents.set(PRESSURE, max(0.0f, contents.get(PRESSURE) - 0.05f));
          if (contents.get(PRESSURE) > 0.5f) {
            waterSubset = neighbors.CollectWithContents(LIQUID);
            if (waterSubset.size() > 0) {
              randomNeighbor = waterSubset.get(floor(random(waterSubset.size())));
              if (randomNeighbor.contents.get(CO2) > 0.01f && randomNeighbor.contents.get(SULFUR) > 0.01f) {
                randomNeighbor.growth = TYPE4;
              }
            }
          }
        }
      }
    }
    
  }
  
  public boolean CheckBounds(int mX, int mY) {
    if (mX < x * size || mX >= (x + 1) * size ||
        mY < y * size || mY >= (y + 1) * size) {
      return false;
    } else {
      return true;
    }
  }
  
  public BaHexCollection GetAllWithinRange(int range) {
    BaHexCollection collection = new BaHexCollection();
    BaHexCollection toAdd = new BaHexCollection();
    BaHex hexInList, hexNeighbor;
    
    collection.add(this);
    
    for (int i = 0; i < range; ++i) {
      for (int j = 0; j < collection.size(); ++j) {
        hexInList = collection.get(j);
        for (int k = 0; k < hexInList.neighbors.size(); ++k) {
          hexNeighbor = hexInList.neighbors.get(k);
          if (hexNeighbor.marked == 0) {
            hexNeighbor.marked = 1;
            toAdd.add(hexNeighbor);
          }
        }
      }
      
      for (int j = 0; j < toAdd.size(); ++j) {
        collection.add(((BaHex)(toAdd.get(j))));
      }
      
      toAdd.clear();
    }
    
    for (int i = 0; i < collection.size(); ++i) {
      collection.get(i).marked = 0;
    }
    
    return collection;
  }
  
  public void Clear() {
    contents.type = AIR;
    contents.clearData();
    growth = NOTHING;
  }
  
}

//=========================================================================
// BA HEX COLLECTION
//=========================================================================

class BaHexCollection {
  private ArrayList<BaHex> list;
  
  BaHexCollection() {
    list = new ArrayList<BaHex>();
  }
  
  public int CountWithContents(int type) {
    int acc = 0;    
    for (int i = 0; i < size(); ++i) {
      if (get(i).contents.type == type) {
        ++acc;
      }
    }
    return acc;
  }
  
  public BaHexCollection CollectWithContents(int type) {
    BaHexCollection subset = new BaHexCollection();
    for (int i = 0; i < size(); ++i) {
      if (get(i).contents.type == type) {
        subset.add(get(i));
      }
    }
    return subset;
  }
  
  public BaHexCollection CollectWithContentsAndMaxData(int type, int dataType, float maxData) {
    BaHexCollection subset = new BaHexCollection();
    for (int i = 0; i < size(); ++i) {
      if (get(i).contents.type == type && get(i).contents.get(dataType) <= maxData) {
        subset.add(get(i));
      }
    }
    return subset;
  }
  
  public int size() {
    return list.size();
  }
  
  public void add(BaHex toAdd) {
    list.add(toAdd);
  }
  
  public BaHex get(int index) {
    return ((BaHex)(list.get(index)));
  }
  
  public void clear() {
    list.clear();
  }
}

//=========================================================================
// BA HEX CONTENT
//=========================================================================

class BaHexContent {
  public int type;
  public float[] data;

  public BaHexContent() {
    type = 0;
    data = new float[5];
    data[BaHex.PRESSURE] = 0.0f;
    data[BaHex.OXYGEN] = 0.0f;
    data[BaHex.METHANE] = 0.0f;
    data[BaHex.SULFUR] = 0.0f;
    data[BaHex.CO2] = 0.0f;
  }
  
  public void set(int dataType, float value) {
    data[dataType] = value;
  }
  
  public float get(int dataType) {
    return data[dataType];
  }
  
  public void clearData() {
    data[BaHex.PRESSURE] = 0.0f;
    data[BaHex.OXYGEN] = 0.0f;
    data[BaHex.METHANE] = 0.0f;
    data[BaHex.SULFUR] = 0.0f;
    data[BaHex.CO2] = 0.0f;
  }
  
  public String toString() {
    String summary = "";
    summary += "[P: " + data[BaHex.PRESSURE] + "] ";
    summary += "[O: " + data[BaHex.OXYGEN] + "] ";
    summary += "[S: " + data[BaHex.SULFUR] + "] ";
    summary += "[M: " + data[BaHex.METHANE] + "] ";
    summary += "[C: " + data[BaHex.CO2] + "]";
    return summary;
  }
}

//=========================================================================
// BA GRID
//=========================================================================

class BaGrid {
  
  private int gridWidthInHexes;
  private int gridHeightInHexes;
  
  public BaHex[] hexes;
  
  BaGrid(int w, int h) {
    gridWidthInHexes = w;
    gridHeightInHexes = h;
    CreateGrid();
    println("Grid Created!");
  }
  
  public void CreateGrid() {
    hexes = new BaHex[gridWidthInHexes * gridHeightInHexes];
    float posx, posy;
    
    for (int y = 0; y < gridHeightInHexes; ++y) {
      for (int x = 0; x < gridWidthInHexes; ++x) {
        posx = 1.0f * x;
        posy = 1.0f * y;
        if (x % 2 == 1) posy += 0.5f;
        
        BaHex hex = new BaHex();
        hex.index = GetHexIndex(x, y);
        hex.x = posx;
        hex.y = posy;
        
        hexes[GetHexIndex(x, y)] = hex;
      }
    }
    
    for (int j = 0; j < gridHeightInHexes; ++j) {
      for (int i = 0; i < gridWidthInHexes; ++i) {
        if (i % 2 == 1) {
          if (IsValidCell(i, j + 1)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i, j + 1)]);
          if (IsValidCell(i + 1, j + 1)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i + 1, j + 1)]);
          if (IsValidCell(i + 1, j)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i + 1, j)]);
          if (IsValidCell(i, j - 1)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i, j - 1)]);
          if (IsValidCell(i - 1, j)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i - 1, j)]);
          if (IsValidCell(i - 1, j + 1)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i - 1, j + 1)]);
        } else {
          if (IsValidCell(i, j + 1)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i, j + 1)]);
          if (IsValidCell(i + 1, j - 1)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i + 1, j - 1)]);
          if (IsValidCell(i + 1, j)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i + 1, j)]);
          if (IsValidCell(i, j - 1)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i, j - 1)]);
          if (IsValidCell(i - 1, j)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i - 1, j)]);
          if (IsValidCell(i - 1, j - 1)) hexes[GetHexIndex(i, j)].AddNeighbor(hexes[GetHexIndex(i - 1, j - 1)]);
        }
      }
    }
  }
  
  public void ClearGrid() {
    for (int i = 0; i < hexes.length; ++i) {
      hexes[i].Clear();
    }
  }
  
  public int GetHexIndex(int x, int y) {
    return (y * gridWidthInHexes) + x;
  }
  
  public boolean IsValidCell(int x, int y) {
    if (x < 0 || x >= gridWidthInHexes) return false;
    if (y < 0 || y >= gridHeightInHexes) return false;
    
    return true;
  }
  
  public void Display(int offX, int offY) {
    for (int i = 0; i < hexes.length; ++i) {
      hexes[i].Display(offX, offY);
    }
  }
  
  public void Tick() {
    for (int i = 0; i < hexes.length; ++i) {
      hexes[i].Tick();
    }
  }
  
}
