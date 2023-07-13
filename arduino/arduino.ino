#define max_presets 6

#include <string.h>

// Heating control
float roomTemp = 12.3, releaseTemp = 34.5, returnTemp = 23.4,
      pRoomTemp = 22.0, pRoomIntTemp = 34.5, pHeater1DeltaTemp = 3.5,
      pHeater2DeltaTemp = 7.5, pPumpDeltaTemp = 5.5;
bool heater1 = false, heater2 = true, pump = true;
String heatingMode = "auto_mode";
float temperatureHistory[] = { 24, 23, 24, 24, 22, 23, 22, 23, 22, 23, 22, 24, 24, 23, 24, 23, 22, 24, 22, 27 };
float consumptionHistory[] = { 1994, 1987, 1981, 1972, 1966, 2000, 1990, 1965, 1986, 1969, 1989, 1974, 1989, 1973, 1997, 1998, 1999, 1990, 1986, 1984 };

// LED control
String presetEffects[] = { "s", "s", "p", "p", "f", "f" };
String presetColors[] = { "green", "green", "white", "white", "red", "red" };
String currentEffect = "pulse", currentColor = "#00ff00";
bool showCurrentEffect = false;
int activePreset = 0;

template<typename T, size_t N>
String arrayToString(const T (&arr)[N]) {
  String result;
 
  for (size_t i = 0; i < N; i++) {
    result += String(arr[i]);
    if (i < N - 1) {
      result += ",";
    }
  }
 
  return result;
}

void modifyArrayFromString(const String& inputString, String *arr) {
  String currentElement;
  int currentIndex = 0;
  
  for (int i = 0; i < inputString.length(); ++i) {
    if (inputString.charAt(i) == ',') {
      if (currentIndex < max_presets) {
        arr[currentIndex++] = currentElement;
        currentElement = "";
      }

      continue;
    }
    
    currentElement += inputString.charAt(i);
  }
  
  if (currentIndex < max_presets) {
    arr[currentIndex] = currentElement;
  }
}


void sendVariable(String id) {
  if(id == "all") {
    sendVariable("room"); Serial.flush();  delay(30);
    sendVariable("release"); Serial.flush();  delay(30);
    sendVariable("return"); Serial.flush();  delay(30);
    sendVariable("p_room"); Serial.flush();  delay(30);
    sendVariable("p_room_int"); Serial.flush();  delay(30);
    sendVariable("p_heater_1_delta"); Serial.flush();  delay(30);
    sendVariable("p_heater_2_delta"); Serial.flush();  delay(30);
    sendVariable("p_pump_delta"); Serial.flush();  delay(30);
    sendVariable("heater_1"); Serial.flush();  delay(30);
    sendVariable("heater_2"); Serial.flush();  delay(30);
    sendVariable("pump"); Serial.flush();  delay(30);
    sendVariable("heating_mode"); Serial.flush();  delay(30);
    //sendVariable("temperature_history"); Serial.flush();  delay(30);
    //sendVariable("consumption_history"); Serial.flush();  delay(30);
    sendVariable("preset_effects"); Serial.flush();  delay(30);
    //sendVariable("preset_colors"); Serial.flush();  delay(30);
    sendVariable("current_effect"); Serial.flush();  delay(30);
    sendVariable("current_color"); Serial.flush();  delay(30);
    sendVariable("show_current_effect"); Serial.flush();  delay(30);
    sendVariable("active_preset"); Serial.flush();  delay(30);
    return;
  }

  if (id == "temperature_history"
      || id == "consumption_history"
      || id == "preset_effects"
      || id == "preset_colors")
    Serial.print("+");
  else
    Serial.print("-");

  Serial.print(id + ": ");
  Serial.flush();

  if (id == "room") Serial.println(roomTemp);
  else if (id == "release") Serial.println(releaseTemp);
  else if (id == "return") Serial.println(returnTemp);
  else if (id == "p_room") Serial.println(pRoomTemp);
  else if (id == "p_room_int") Serial.println(pRoomIntTemp);
  else if (id == "p_heater_1_delta") Serial.println(pHeater1DeltaTemp);
  else if (id == "p_heater_2_delta") Serial.println(pHeater2DeltaTemp);
  else if (id == "p_pump_delta") Serial.println(pPumpDeltaTemp);
  else if (id == "heater_1") Serial.println(heater1 ? "true" : "false");
  else if (id == "heater_2") Serial.println(heater2 ? "true" : "false");
  else if (id == "pump") Serial.println(pump ? "true" : "false");
  else if (id == "heating_mode") Serial.println(heatingMode);
  else if (id == "temperature_history") Serial.println(arrayToString(temperatureHistory));
  else if (id == "consumption_history") Serial.println(arrayToString(consumptionHistory));
  else if (id == "preset_effects") Serial.println(arrayToString(presetEffects));
  else if (id == "preset_colors") Serial.println(arrayToString(presetColors));
  else if (id == "current_effect") Serial.println(currentEffect);
  else if (id == "current_color") Serial.println(currentColor);
  else if (id == "show_current_effect") Serial.println(showCurrentEffect ? "true" : "false");
  else if (id == "active_preset") Serial.println(activePreset);
  else Serial.println();
}

void receiveVariable(String id, String value) {
  if (id == "p_room") pRoomTemp = value.toFloat();
  else if (id == "p_room_int") pRoomIntTemp = value.toFloat();
  else if (id == "p_heater_1_delta") pHeater1DeltaTemp = value.toFloat();
  else if (id == "p_heater_2_delta") pHeater2DeltaTemp = value.toFloat();
  else if (id == "p_pump_delta") pPumpDeltaTemp = value.toFloat();
  else if (id == "heater_1") heater1 = (value == "true");
  else if (id == "heater_2") heater2 = (value == "true");
  else if (id == "pump") pump = (value == "true");
  else if (id == "heating_mode") heatingMode = value;
  else if (id == "preset_effects") modifyArrayFromString(value, presetEffects);
  else if (id == "preset_colors") modifyArrayFromString(value, presetColors);
  else if (id == "current_effect") currentEffect = value;
  else if (id == "current_color") currentColor = value;
  else if (id == "show_current_effect") showCurrentEffect = (value == "true");
  else if (id == "active_preset") activePreset = value.toInt();

  sendVariable(id);
}

void processInput(String command, String arg) {
  if (command == "GET")
    sendVariable(arg);
  else
    receiveVariable(command, arg);

  Serial.flush();
}

void setup() {
  Serial.begin(9600);
  Serial.println("Starting...");
}

void loop() {
  if (Serial.available()) {
    Serial.flush();

    String command = Serial.readStringUntil(':');
    command.trim();

    String arg = Serial.readString();
    arg.trim();
    Serial.flush();

    processInput(command, arg);
  }

  delay(10);
}
