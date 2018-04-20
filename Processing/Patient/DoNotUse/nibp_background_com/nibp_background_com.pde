            
/*******************************************************************/
//    project introduction
/*******************************************************************/
import processing.serial.*;

/*******************************************************************/
// define variables
/*******************************************************************/
//for rs232
Serial myPort;  // Create object from Serial class
int[] serialInArray = new int[4];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
boolean firstContact = false;        // Whether we've heard from the microcontroller
int ecg_data =0;
int ppg_data =0;
int nibp_AC_data =0;
int nibp_DC_data =0;

//for chart
int screen_Xmax = 1359;
int screen_Ymax = 660;

int chart1_Xmax = 1359 - 360;
int chart1_Ymax = 100 + 550/4;
int chart1_Xmin = 10;
int chart1_Ymin = 100;
int chart2_Xmax = 1359 - 360;
int chart2_Ymax = chart1_Ymax + 550/4;
int chart2_Xmin = 10;
int chart2_Ymin = chart1_Ymin + 550/4;
int chart3_Xmax = 1359 - 360;
int chart3_Ymax = chart2_Ymax + 550/4;
int chart3_Xmin = 10;
int chart3_Ymin = chart2_Ymin + 550/4;
int chart4_Xmax = 1359 - 360;
int chart4_Ymax = chart3_Ymax + 550/4;
int chart4_Xmin = 10;
int chart4_Ymin = chart3_Ymin + 550/4;

int chart1_X = 20;
int chart1_y = 1;
int pre_data = 0, curr_data = chart1_Ymin + (chart1_Ymax - chart1_Ymin)/2;
int pre_data2 = 0, curr_data2 = chart2_Ymin + (chart2_Ymax - chart2_Ymin)/2;
int pre_data3 = 0, curr_data3 = chart3_Ymin + (chart3_Ymax - chart3_Ymin)/2;
int pre_data4 = 0, curr_data4 = chart4_Ymin + (chart4_Ymax - chart4_Ymin)/2;

//for graph speed
int g_cnt=0;

//Color Setting
color White = color(255,255,255);
color Black = color(0,0,0);
color Gray = color(20,20,20,100);
color EcgColor = color(0,255,0);
color PpgColor = color(255,100,255);
color NibpColor_AC = color(100,255,255);
color NibpColor_DC = color(255,255,100);

//for Date
int[] Date;
String hospitalname = "HOSPITAL NAME";
String bed_num = "BED-000";
String patient_name = "PATIENT NAME";
String ecg = "E C G - L E A D I";
String ppg = "P P G";
String nibp_AC = "N I B P - D C";
String nibp_DC = "N I B P - A C";

//for loading
float color_loading = 0;
float color_dir = 1;

//for button
int pauseX, pauseY;          //
int pauseSizeX = 80;
int pauseSizeY = 20;
int measureX, measureY;
int measureSizeX = 85;
int measureSizeY = 20;
int buttonArc = 55;
color pauseColor;
color pauseHighlight;
color measureColor;
color measureHighlight;
boolean pauseOver = false;    
boolean measureOver = false;  //button setting
boolean pausePressed = false;
boolean measurePressed = false;

/*******************************************************************/
//setup fuction()...
/*******************************************************************/
void setup() 
{
  size(1360, 684); 
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  draw_background();
  
}//End of setup()...

/*******************************************************************/
// draw() function ....
/*******************************************************************/
void draw()
{
  button_setting();
  button();
     WaveformChart1(ecg_data*2);
        WaveformChart2(ppg_data);
            WaveformChart3(nibp_DC_data);
                WaveformChart4(nibp_AC_data);
 
}//End of draw()..

/*******************************************************************/
// rs232 event()....
/*******************************************************************/
void serialEvent(Serial myPort) {
 
  int inByte = myPort.read();
  if (firstContact == false) {
    if (inByte == 0xff) { 
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
    } //end of if()...
  } //end of if()...
  else {
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 2 bytes:
    if (serialCount == 4 ) {
      serialCount = 0;  // Reset serialCount:
      ecg_data = serialInArray[0];
      ppg_data = serialInArray[1];
      nibp_AC_data = serialInArray[2];
      nibp_DC_data = serialInArray[3];
      /*
      g_cnt++;
      if(g_cnt > 4){
        
       WaveformChart1(ecg_data);
        WaveformChart2(ppg_data);
         WaveformChart3(nibp_AC_data);
          WaveformChart4(nibp_DC_data);
          
          g_cnt = 0;
      }*/
      firstContact = false;
    } //end of if()...
  } //end of if else()...
} //end of serial event()...




void WaveformChart1(int data){
  
  int offset = 5;
  float scalef = 0.7;
  pre_data = curr_data;
  if(data > 160) data = 160;
  curr_data = (chart1_Ymax - (int)(data*scalef)) - offset;
  
  stroke(EcgColor);
  noFill();
  /*if( pre_data >= chart1_Ymax ){
    pre_data = chart1_Ymin + (chart1_Ymax - chart1_Ymin)/2;
    curr_data = chart1_Ymin + (chart1_Ymax - chart1_Ymin)/2;
  }//End of if()..
  if( pre_data <= chart1_Ymin ){
    pre_data = chart1_Ymin + (chart1_Ymax - chart1_Ymin)/2;
    curr_data = chart1_Ymin + (chart1_Ymax - chart1_Ymin)/2;
  }//End of if()..
  */
  line(chart1_X,pre_data, chart1_X + 1, curr_data);
  chart1_X = chart1_X + 1;
  if(chart1_X > chart1_Xmax - 20 ){
    //chart1_X = chart1_Xmin
      chart1_X = chart1_Xmin + 10;  
    draw_background();
  }//End of if()...
}//End of WaveformChart()...

void WaveformChart2(int data){
//  int offset = (chart1_Ymax-chart1_Ymin)/2 + 500;
  int offset = -140;
  float scalef = 0.60;
  pre_data2 = curr_data2;
  curr_data2 = (chart1_Ymax - (int)(data*scalef)) - offset;
  stroke(PpgColor);
  line(chart1_X,pre_data2, chart1_X + 1, curr_data2);
//  chart1_X = chart1_X + 1;
  if(chart1_X > chart1_Xmax){
    //chart1_X = chart1_Xmin
    chart1_X = chart1_Xmin + 10;    
    draw_background();
  }//End of if()...
}//End of WaveformChart()...

void WaveformChart3(int data){
//  int offset = (chart1_Ymax-chart1_Ymin)/2 + 500;
  int offset = -250 ;
  float scalef = 0.5;
  pre_data3 = curr_data3;
  curr_data3 = (chart1_Ymax - (int)(data*scalef)) - offset;
  stroke(NibpColor_AC);
  line(chart1_X,pre_data3 , chart1_X + 1, curr_data3 );
 // chart1_X = chart1_X + 1;
  if(chart1_X > chart1_Xmax){
    //chart1_X = chart1_Xmin
    chart1_X = chart1_Xmin + 10;    
    draw_background();
  }//End of if()...
}//End of WaveformChart()...

void WaveformChart4(int data){
//  int offset = (chart1_Ymax-chart1_Ymin)/2 + 500;
  int offset = -400;
  float scalef = 0.55;
  pre_data4 = curr_data4;
  curr_data4 = (chart1_Ymax - (int)(data*scalef)) - offset;
  stroke(NibpColor_DC);
  line(chart1_X,pre_data4 , chart1_X + 1, curr_data4 );
//  chart1_X = chart1_X + 1;
  if(chart1_X > chart1_Xmax){
    //chart1_X = chart1_Xmin;
    chart1_X = chart1_Xmin + 10;    
    draw_background();
  }//End of if()...
}//End of WaveformChart()...

/*******************************************************************/
// background Setting..
/*******************************************************************/
void blank_rect(int x1,  int y1, int x2, int y2){
  line(x1,y1,x1,y2);
  line(x1,y1,x2,y1);
  line(x1,y2,x2,y2);
  line(x2,y1,x2,y2);
}//End of blank_rect();

void full_rect(int x1, int y1, int x2, int y2){
  stroke(Black);
  for( int i = x1; i<x2; i++ ){
    line(i, y1, i, y2);
  }//End of for()..
  
  stroke(White);
  strokeWeight(2);
  blank_rect(x1, y1, x2, y2);
}//End of full_rect()..

void draw_background(){
  background(Gray);
  fill(Black);
  info_draw();
  chart1_draw();
  chart2_draw();
  chart3_draw();
  chart4_draw();
  //blank_rect( chart1_Xmin, chart1_Ymin, chart1_Xmax, chart1_Ymax );
  //blank_rect( chart2_Xmin, chart2_Ymin, chart2_Xmax, chart2_Ymax );
  //blank_rect( chart3_Xmin, chart3_Ymin, chart3_Xmax, chart3_Ymax );
  //blank_rect( chart4_Xmin, chart4_Ymin, chart4_Xmax, chart4_Ymax );
}//End of draw_background()..

void info_draw(){
  stroke(White);
  strokeWeight(2);
  blank_rect(10,20,30,40); 
  
  textSize(25);
  fill(White);
  text(hospitalname, 40,40 );
  text(patient_name, 200, 80);
  text(bed_num, 40, 80 );
  
  Date = new int[3];
  Date[0] = year();
  Date[1] = month();
  Date[2] = day();
  text(Date[0], screen_Xmax/1.7, 40);  
  text("-", screen_Xmax/1.7 + 70, 40);
  text(Date[1], screen_Xmax/1.7 + 100, 40);
  text("-", screen_Xmax/1.7 + 130, 40);
  text(Date[2], screen_Xmax/1.7 + 150, 40);    //Text of Date..
  
}//End of info_draw()..

void chart1_draw(){
  stroke(White); // color of line
  strokeWeight(2); // Weight of line
  fill(Black);
  blank_rect(chart1_Xmin, chart1_Ymin, chart1_Xmax, chart1_Ymax);
  blank_rect(chart1_Xmax, chart1_Ymin, screen_Xmax - 10, chart1_Ymax);
  textSize(35);               //textsize for INFO Page..
  fill(EcgColor);
  text(ecg, chart1_Xmax + 20, chart1_Ymin + 40);        //Text of ECG INFO..
}//End of chart1_draw()..

void chart2_draw(){
  stroke(White); // color of line
  strokeWeight(2); // Weight of line
  fill(Black);
  blank_rect(chart2_Xmin, chart2_Ymin, chart2_Xmax, chart2_Ymax );
  blank_rect(chart2_Xmax, chart2_Ymin, screen_Xmax - 10, chart2_Ymax );
  textSize(35);               //textsize for INFO Page..
  fill(PpgColor);
  text(ppg, chart2_Xmax + 20, chart2_Ymin + 40);        //Text of PPG INFO..
}//End of chart1_draw()..

void chart3_draw(){
  stroke(White); // color of line
  strokeWeight(2); // Weight of line
  fill(Black);
  blank_rect(chart3_Xmin, chart3_Ymin, chart3_Xmax, chart3_Ymax );
  blank_rect(chart3_Xmax, chart3_Ymin, screen_Xmax - 10, chart3_Ymax);
  
  textSize(35);               //textsize for INFO Page..
  fill(NibpColor_AC);
  text(nibp_AC, chart3_Xmax + 20, chart3_Ymin + 40 );        //Text of PPG INFO..
}//End of chart2_draw()..

void chart4_draw(){
  stroke(White); // color of line
  strokeWeight(2); // Weight of line
  fill(Black);
  blank_rect(chart4_Xmin, chart4_Ymin, chart4_Xmax, chart4_Ymax );
  blank_rect(chart4_Xmax, chart4_Ymin, screen_Xmax - 10, chart4_Ymax);
  
  textSize(35);               //textsize for INFO Page..
  fill(NibpColor_DC);
  text(nibp_DC, chart4_Xmax + 20, chart4_Ymin + 40 );        //Text of PPG INFO..
}//End of chart2_draw()..

/*******************************************************************/
// button functions
/*******************************************************************/

void button_setting(){
  pauseColor = Black;        //
  pauseHighlight = White;
  pauseX = screen_Xmax/2 + 120;
  pauseY = 60;                  //pause Button Setting..
  
  measureColor = Black;
  measureHighlight = White;
  measureX = pauseX + 100;
  measureY = 60;
}

void button(){
  update(mouseX, mouseY);   //
  if( pauseOver ){
    fill(pauseHighlight);
  } else{
    fill(pauseColor);
  }
  stroke(color(255,100,100));                    //  outline of Pause Button
  rect(pauseX, pauseY, pauseSizeX, pauseSizeY,buttonArc,buttonArc,buttonArc,buttonArc);  //  pause Button source..
  
  if( measureOver ){
    fill(measureHighlight);
  } else{
    fill(measureColor);
  }
  stroke(color(125,125,255));                    //  outline of Measure Button
  rect(measureX, measureY, measureSizeX, measureSizeY,buttonArc,buttonArc,buttonArc,buttonArc);  //  measure Button source..
  
  textSize(18);
  fill(color(255,100,100));
  text("Pause", pauseX + 15, pauseY + pauseSizeY/2 + 5);
  fill(color(125,125,255));
  text("Measure", measureX +7, measureY + measureSizeY/2 + 5);
}//End of button()..

void update(int x, int y) {
 if( overMeasure(measureX, measureY, measureSizeX, measureSizeY) ){
   pauseOver = false;
   measureOver = true;
 }  
  else if ( overPause(pauseX, pauseY, pauseSizeX, pauseSizeY) ) {
    pauseOver = true;
    measureOver = false;
  } else {
    pauseOver = measureOver = false;
  }
}//end of update()..

boolean overMeasure(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}//end of overMeasure()..

boolean overPause(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}//end of overPause()..

void mousePressed() {
  if (pauseOver) {
   
  }
  
  if (measureOver) {
    
  }
}//end of mousePressd()..

