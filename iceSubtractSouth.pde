
import com.hamoid.*;
import java.util.*;

VideoExport videoExport;

PImage img1;
PImage img2;
PImage mask;

color purple = color(127, 0, 127);
color white = color(255, 255, 255);

int width = 968;
int height = 520;

Map<String, Float> iceData = new HashMap<String, Float>();

public static class Utils{
  public static DateTime GetNonLeapYear(){
    return new DateTime(2001,1,1,0,0,0,0);
  }
  
  public static String GetFilenameForDate(String path, int year, int dayOfYear){
    File f;
    String filename;
    
    // Years up to 1988 only have data for every second day so if png doesn't exist then try the next day
    do{
      DateTime dt = GetNonLeapYear().withDayOfYear(dayOfYear);
            
      int month = dt.monthOfYear().get();
      int day = dt.dayOfMonth().get();
      
      filename = String.format( path+"..\\combinedPngsSouth\\nt_%d%02d%02d_s.png", year, month, day);
      f = new File(filename);
      
      dayOfYear++;
      if(dayOfYear > 365) dayOfYear = dayOfYear - 3; // Don't go to the next next, simply skip back a few days - close enough!
    }
    while(!f.exists());
    
    return f.getAbsolutePath();
  }
}

public void loadIceData()
{
  String[] lines = loadStrings("SH_seaice_extent.csv");
  
  for (String line : lines) {
    String[] data = split(line, ',');
    String key = String.format("%04d-%02d-%02d", int(trim(data[0])), int(trim(data[1])), int(trim(data[2])));
    iceData.put(key, float(trim(data[3])));
  }
}

void setup(){
  loadIceData();
  size(968, 520);
  mask = loadImage("..\\combinedPngsSouth\\mask_s.png").get(12,85,316,333);
    
  frameRate(30);
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(30);
  videoExport.startMovie();
}


int dayOfYear = 1;
Float iceArea1979 = 0.0;
void draw(){
  fill(purple);
  background(purple);
  
  img1 = loadImage(Utils.GetFilenameForDate(sketchPath(""), 1979, dayOfYear)).get(12,85,316,333);
  img1.filter(GRAY);
  image(img1,10,100);
  image(img1,316+10,100);
  
  img2 = loadImage(Utils.GetFilenameForDate(sketchPath(""), 2016, dayOfYear)).get(12,85,316,333);
  img2.filter(GRAY);
  image(img2,316*2+10,100);
  
  blend(img2, 0, 0, 316, 333, 316+10, 100, 316, 333, SUBTRACT);
  
  image(mask,10,100);
  image(mask,316+10,100);
  image(mask,316*2+10,100);
  
  DateTime dt = Utils.GetNonLeapYear().plus(Period.days(dayOfYear));
  
  String month = dt.monthOfYear().getAsText();
  fill(white);
  textSize(25);
  textAlign(CENTER);
  text("Antarctic sea ice concentration difference between 1979 and 2016", width/2,25);
  text(month, width/2, height - 25);
  text("1979", 316/2 +10 , 90);
  text("Difference", 316/2 + 316 +10, 90);
  text("2016", 316/2 + 316*2 +10, 90);
  text("@kevpluck", width/2, 57);
  
  String key1979 = String.format("1979-%02d-%02d", dt.monthOfYear().get(), dt.dayOfMonth().get());
  if(iceData.containsKey(key1979)){iceArea1979 = iceData.get(key1979);}
  Float iceArea2016 = iceData.get(String.format("2016-%02d-%02d", dt.monthOfYear().get(), dt.dayOfMonth().get()));
  
  Float diff = Math.abs(iceArea1979 - iceArea2016);
  
  text(String.format("%.1fM Km²", iceArea1979), 316/2 +10, height - 50);
  text(String.format("%.1fM Km²", diff), 316/2 + 316 +10, height - 50);
  text(String.format("%.1fM Km²", iceArea2016), 316/2 + 316*2 +10, height - 50);
  
  textSize(10);
  text("Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data (NSIDC-0051), Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations", width/2, height - 8);
  
  dayOfYear++;
  if(dayOfYear > 365) {
    noLoop();
    videoExport.endMovie();
  }
  else
    videoExport.saveFrame();
}