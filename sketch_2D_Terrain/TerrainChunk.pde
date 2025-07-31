import java.util.List;
import java.util.LinkedList;

class TerrainChunk {
  private List<PVector> points;
  
  private float minX, maxX, groundLevel, maxHeight, reductionFactor;
  private int iterations;

  public TerrainChunk(float minX, float maxX, float groundLevel, int iterations, float maxHeight, float reductionFactor) {
    points = new LinkedList<>();
    
    this.minX = minX;
    this.maxX = maxX;
    this.groundLevel = groundLevel;
    this.iterations = iterations;
    this.maxHeight = maxHeight;
    this.reductionFactor = reductionFactor;

    float baseLine = groundLevel - maxHeight;

    points.add(new PVector(minX, baseLine));
    points.add(new PVector(maxX, baseLine));

    float nextHeight = maxHeight;
    for (int i = 0; i < iterations; ++i) {
      subdivide(nextHeight);

      nextHeight /= reductionFactor;
    }
  }
  
  public TerrainChunk reset() {
    return new TerrainChunk(minX, maxX, groundLevel, iterations, maxHeight, reductionFactor);
  }
  
  public PVector firstPoint() {
    return points.get(0).copy();
  }
  
  public PVector lastPoint() {
    return points.get(points.size() - 1).copy();
  }
  
  
  public void shift(float speed, ShiftDirection direction) {
    for (int i = 0; i < points.size(); ++i) {
      points.get(i).x += speed * (direction == ShiftDirection.LEFT? -1 : 1);
    }
  }
  

  public void subdivide(float maxHeight) {
    subdivide(0, points.size(), maxHeight);
  }


  private void subdivide(int startIndex, int endIndexExclusive, float maxHeight) {
    List<PVector> insertions = new ArrayList<>();

    for (int i = startIndex; i < endIndexExclusive - 1; ++i) {
      PVector p1 = points.get(i);
      PVector p2 = points.get(i + 1);
      PVector midPoint = PVector.div(PVector.add(p1, p2), 2);

      PVector p1p2 = PVector.sub(p2, p1);
      PVector perpendicular = new PVector(p1p2.y, -p1p2.x);
      perpendicular.normalize();

      float displacement = random(-maxHeight, maxHeight);
      PVector extrudedPoint = PVector.add(midPoint, PVector.mult(perpendicular, displacement));

      insertions.add(extrudedPoint);
    }

    for (int i = 0; i < insertions.size(); ++i) {
      PVector newPoint = insertions.get(i);
      points.add(startIndex + 2 * i + 1, newPoint);
    }
  }

  public void render(PVector startPoint, PVector endPoint, float clipXMin, float clipXMax) {
    beginShape();
    if (startPoint != null) {
      vertex(startPoint.x, groundLevel);
      vertex(startPoint.x, startPoint.y);
    } else {
      vertex(points.get(0).x, groundLevel);
    }
    for (PVector p : points) {
      if (p.x < clipXMin || p.x > clipXMax) continue;
      vertex(p.x, p.y);
    }
    if (endPoint != null) {
      vertex(endPoint.x, endPoint.y);
      vertex(endPoint.x, groundLevel);
    }
    else {
      vertex(points.get(points.size() - 1).x, groundLevel);
    }
    endShape(CLOSE);
  }
}
