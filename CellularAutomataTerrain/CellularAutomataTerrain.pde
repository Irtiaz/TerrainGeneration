float cellSize = 10;

int[][] board;

void setup() {
  size(1200, 900);
  
  int rows = (int)(height / cellSize);
  int cols = (int)(width / cellSize);
  
  board = new int[rows][cols];
  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      board[i][j] = random(1) < 0.5? 1 : 0;
    }
  }
  
  noStroke();
}

void draw() {
  for (int i = 0; i < board.length; ++i) {
    for (int j = 0; j < board[i].length; ++j) {
      if (board[i][j] == 1) {
        fill(125, 141, 134);
      } else {
        fill(62, 63, 41);
      }
      //fill(board[i][j] * 255);
      rect(j * cellSize, i * cellSize, cellSize, cellSize);
    }
  }
  
  update();
}

void keyPressed() {
  if (key == ' ') {
    save("ca.png");
  }
}

int neighborSum(int i, int j) {
  int sum = 0;
  
  for (int iIncrement = -1; iIncrement <= 1; ++iIncrement) {
    for (int jIncrement = -1; jIncrement <= 1; ++jIncrement) {
      if (iIncrement == 0 && jIncrement == 0) continue;
      int neighborI = i + iIncrement;
      int neighborJ = j + jIncrement;
      
      if (neighborI < 0 || neighborI >= board.length) continue;
      if (neighborJ < 0 || neighborJ >= board[0].length) continue;
      
      sum += board[neighborI][neighborJ];
    }
  }
  
  return sum;
}

void update() {
  int[][] nextGenerationBoard = new int[board.length][board[0].length];
  for (int i = 0; i < board.length; ++i) {
    for (int j = 0; j < board[i].length; ++j) {
      if (board[i][j] == 1 && neighborSum(i, j) >= 4) nextGenerationBoard[i][j] = 1;
      else if (board[i][j] == 0 && neighborSum(i, j) >= 5) nextGenerationBoard[i][j] = 1;
      else nextGenerationBoard[i][j] = 0;
    }
  }
  
  board = nextGenerationBoard;
}
