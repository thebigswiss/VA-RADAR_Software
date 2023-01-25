/*************** IMPORTS *************/
/*************************************/

/* Importiert das Serial Interface Modul */
import processing.serial.*;
/* Importiert das Interrupt Module */
import java.awt.event.KeyEvent;
/* Importiert das IO Module */
import java.io.IOException;
/* Importiert das Sound Module */
import processing.sound.*;

/*************************************/
/*************** KLASSEN *************/

/*erzeugt eine BrownNoise Klasse */
BrownNoise noise;
/* Erzeugt eine Serielle Klasse */
Serial port;

/*************************************/
/************ VARIABLEN **************/

String angle=""; // winkel Sensor
String distance=""; // distanz zum Objekt
String data=""; // data strem
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index=0;
PFont orcFont;

/*************************************/
/************ FUNKTIONEN *************/

/* Initialisierungs Funktion */
void setup()
{
 size (1236, 764); // Fenster Grösse in pixel
 smooth();
 port = new Serial(this,Serial.list()[0], 9600); // startet die serielle Kommunikation
 /* // liest die Daten von der seriellen Schnittstelle bis zu dem Zeichen ",". Also Winkel.Abstand  */
 port.bufferUntil('.');
 noise = new BrownNoise(this); // init Sound
}

/* Main Funktion */
void draw()
{  
  fill(98,245,31);
  /* Simulation von Bewegungsunschärfe und langsamer Überblendung der sich bewegenden Linie */
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.065);
  
  fill(98,245,31); // Grüne Farbe
  drawRadar(); // Zeichnet Hintergrung
  drawLine(); // Zeichnet die Linie 
  drawText(); // Schreibt alle Texte
  drawPoint(); // Setzt den Punkt bei distanz < 40 cm
}

void serialEvent (Serial port)
{
  // Liest die Daten von der seriellen Schnittstelle bis zum Zeichen "." und setzt sie in die String-Variable "data".
  data = port.readStringUntil('.');
  data = data.substring(0,data.length()-1); // Löscht den "."
  
  index = data.indexOf(","); // findet das Zeichen "," und setzt es in die Variable "index1" ein
  angle = data.substring(0, index); // Den Winkel abspeichern
  distance = data.substring(index+1, data.length()); // Die Distanz absperichern
  
  // konvertiert die String-Variablen in Integer
  iAngle = int(angle);
  iDistance = int(distance);
}
void drawRadar()
{
  pushMatrix();
  translate(width/2,height-height*0.074); // verschiebt die Startkoordinaten an einen neuen Ort
  noFill();
  strokeWeight(1);
  stroke(98,245,31);

  // zeichnet die Bogenlinien
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);

  // zeichnet die Winkellinien
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(15)),(-width/2)*sin(radians(15)));
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(45)),(-width/2)*sin(radians(45)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(75)),(-width/2)*sin(radians(75)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(105)),(-width/2)*sin(radians(105)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(135)),(-width/2)*sin(radians(135)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
  popMatrix();
}

void drawLine()
{
  pushMatrix();
  translate(width/2,height-height*0.074); // verschiebt die Startkoordinaten an einen neuen Ort
  strokeWeight(7);
  stroke(30,250,60); // Grüne Farbe
  /* wandelt den Abstand vom Sensor zum Objekt in cm zu Pixel */
  pixsDistance = iDistance*((height-height*0.1666)*0.025); 
  // Begrenzung der Reichweite auf 40 cm
  if(iDistance<40)
  {
    // zeichnet die Linie entsprechend dem Winkel und der Entfernung
    line(0,0,pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)));
    noise.play(); // Spielt Sound ab
  }
  else
  {
    /* zeichnet die Linie entsprechend dem Winkel und der Entfernung */
    line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle))); 
    noise.stop(); // Stop den Sound
  }
  popMatrix();
}

void drawPoint()
{
  pushMatrix();
  translate(width/2,height-height*0.074); // verschiebt die Startkoordinaten an einen neuen Ort
  strokeWeight(12); // Dicke
  stroke(30,250,60); // Grüne Farbe
  pixsDistance = iDistance*((height-height*0.1666)*0.025); // wandelt den Punkt vom Objekt von cm to pixel
  if(iDistance<40)
  {
    point(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawText()
{
  pushMatrix();
  
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(98,245,31);
  textSize(20);
  
  text("10cm",width-width*0.3854,height-height*0.0833);
  text("20cm",width-width*0.281,height-height*0.0833);
  text("30cm",width-width*0.177,height-height*0.0833);
  text("40cm",width-width*0.0729,height-height*0.0833);
  textSize(15);
  text(" VA Lukas Ambros 2022 ", width-width*0.875, height-height*0.0277);
  text("Winkel: " + iAngle +" °", width-width*0.48, height-height*0.0277);
  text("Distanz: ", width-width*0.26, height-height*0.0277);
  if(iDistance<40)
  {
    text("        " + iDistance +" cm", width-width*0.225, height-height*0.0277);
  }
  textSize(20);
  fill(98,245,60);
  translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}
