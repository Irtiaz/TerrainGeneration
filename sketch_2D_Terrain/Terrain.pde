class Terrain {
  private TerrainChunk chunk1, chunk2;
  private ShiftDirection shiftDirection;
  private float clipXMin, clipXMax;
  
  public Terrain(float minX, float maxX, float groundLevel, int iterations, float maxHeight, float reductionFactor, ShiftDirection shiftDirection, float clipXMin, float clipXMax) {
    chunk1 = new TerrainChunk(minX, maxX, groundLevel, iterations, maxHeight, reductionFactor);
    
    if (shiftDirection == ShiftDirection.LEFT) {
      chunk2 = new TerrainChunk(maxX, 2 * maxX - minX, groundLevel, iterations, maxHeight, reductionFactor);
    }
    
    else {
      chunk2 = new TerrainChunk(2 * minX - maxX, minX, groundLevel, iterations, maxHeight, reductionFactor);
    }
    
    this.shiftDirection = shiftDirection;
    
    this.clipXMin = clipXMin;
    this.clipXMax = clipXMax;
  }
  
  public void shift(float speed) {
    chunk1.shift(speed, shiftDirection);
    chunk2.shift(speed, shiftDirection);
    
    PVector criticalPoint = shiftDirection == ShiftDirection.LEFT? chunk1.lastPoint() : chunk1.firstPoint();
    
    if (criticalPoint.x < clipXMin || criticalPoint.x > clipXMax) {
      chunk1 = chunk2;
      chunk2 = chunk2.reset();
    }
  }
  
  public void render() {
    if (shiftDirection == ShiftDirection.LEFT) {
      chunk1.render(null, chunk2.firstPoint(), clipXMin, clipXMax);
      chunk2.render(chunk1.lastPoint(), null, clipXMin, clipXMax);
    }
    else {
      chunk1.render(chunk2.lastPoint(), null, clipXMin, clipXMax);
      chunk2.render(null, chunk1.firstPoint(), clipXMin, clipXMax);
    }
  }
  
}


enum ShiftDirection {
  LEFT,
  RIGHT
}
