import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
final int NUM_ROWS = 20, NUM_COLS = 20;
private Life[][] buttons; //2d array of Life buttons each representing one cell
private boolean[][] buffer; //2d array of booleans to store state of buttons array
private boolean running = true; //used to start and stop program

public void setup () {
  size(400, 400);
  frameRate(6);
  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new Life[NUM_ROWS][NUM_COLS];
  buffer = new boolean[NUM_ROWS][NUM_COLS];
  
  for(int i = 0; i < NUM_ROWS;i++){
    for(int j =0;j<NUM_COLS;j++){
      buttons[i][j] = new Life(i,j);
      buffer[i][j] = false;
    }
  }
}

public void draw () {
  background( 0 );
  if (running == false) //pause the program
    return;
  copyFromButtonsToBuffer();
  
  //use nested loops to draw the buttons here
  for(int i = 0; i < NUM_ROWS;i++){
    for(int j =0;j<NUM_COLS;j++){
      int neighbors = countNeighbors(i,j);
      if(neighbors == 3){
        buffer[i][j] = true;
      }else if(neighbors != 2){
        buffer[i][j] = false;
      }
      buttons[i][j].draw();
    }
  }
  copyFromBufferToButtons();
}

public void keyPressed() {
  running = !running;
}

public void copyFromBufferToButtons() {
  for(int i = 0; i < NUM_ROWS;i++){
    for(int j =0;j<NUM_COLS;j++){
      buttons[i][j].setLife(buffer[i][j]);
    }
  }
}

public void copyFromButtonsToBuffer() {
  for(int i = 0; i < NUM_ROWS;i++){
    for(int j =0;j<NUM_COLS;j++){
      buffer[i][j] = buttons[i][j].getLife();
    }
  }
}

public boolean isValid(int r, int c) {
  if((r>=0 && c >=0 ) && (r < NUM_ROWS && c < NUM_COLS)){
    return true;
  }
  return false;
}

public int countNeighbors(int row, int col) {
  int neighbors = 0;
  int[] yDir = {0,0,1,1,-1,-1,1,-1};
  int[] xDir = {1,-1,0,1,0,1,-1,-1};
  int nRow, nCol;
  for(int i = 0; i < 8;i++){
    nRow = row + yDir[i];
    nCol = col + xDir[i];
    if(isValid(nRow, nCol) && buttons[nRow][nCol].getLife()==true){
       neighbors++;
    }
  }
  return neighbors;
}

public class Life {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean alive;

  public Life (int row, int col) {
     width = 400/NUM_COLS;
     height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    alive = Math.random() < .5; // 50/50 chance cell will be alive
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    alive = !alive; //turn cell on and off with mouse press
  }
  public void draw () {    
    if (alive != true)
      fill(0);
    else 
      fill( 150 );
    rect(x, y, width, height);
  }
  public boolean getLife() {
    return alive;
  }
  public void setLife(boolean living) {
    alive = living;
  }
}
