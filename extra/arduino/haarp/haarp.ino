
#include <Brain.h>

Brain brain( Serial );

void setup() {
    Serial.begin( 9600 );
}

void loop() {
    if( brain.update() ) {
        Serial.println( brain.readSignalQuality() );
        Serial.println( brain.readCSV() );
    }
}
