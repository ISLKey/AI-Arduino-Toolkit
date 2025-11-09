# AI Arduino Toolkit - Testing Guide

## Testing Your Installation

After running the installation script, use this guide to verify everything works correctly.

---

## 1. Verify Installation Completed

After the script finishes and you've logged out and back in, check that all components are installed:

```bash
# Check Arduino CLI
arduino-cli version

# Check if you're in dialout group (for serial port access)
groups | grep dialout

# Check Ollama is running (for local models)
ollama list

# Check OpenManus is installed
ls -la ~/OpenManus
```

**Expected output:**
- Arduino CLI version should show (e.g., `0.35.3`)
- You should see `dialout` in your groups
- Ollama should list installed models (or be empty if you chose cloud model)
- OpenManus directory should exist

---

## 2. Test Arduino CLI

Test that Arduino CLI can detect boards and compile code:

```bash
# List connected Arduino boards
arduino-cli board list

# Create a test sketch
mkdir -p ~/test-sketch
cd ~/test-sketch
arduino-cli sketch new BlinkTest

# Compile the sketch for Arduino Uno
arduino-cli compile --fqbn arduino:avr:uno BlinkTest
```

**Expected output:**
- `board list` shows your connected Arduino (if plugged in)
- Sketch compiles successfully without errors

---

## 3. Test Local AI Model (If You Chose Local Option)

### Start the AI Assistant

```bash
cd ~
./start-ai-assistant.sh
```

### Test Prompts for Arduino Development

Once OpenManus starts, try these prompts in order (from simple to complex):

#### **Test 1: Simple LED Blink (Basic)**
```
Create an Arduino sketch that blinks the built-in LED on pin 13 every second
```

**What to expect:**
- AI should generate complete Arduino code with `setup()` and `loop()`
- Code should include `pinMode()`, `digitalWrite()`, and `delay()`
- Should be syntactically correct C++ code

**Example expected output:**
```cpp
void setup() {
  pinMode(13, OUTPUT);
}

void loop() {
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
}
```

---

#### **Test 2: Sensor Reading (Intermediate)**
```
Write an Arduino sketch to read a DHT22 temperature and humidity sensor on pin 2 and print the values to serial monitor every 2 seconds
```

**What to expect:**
- AI should include necessary library (`#include <DHT.h>`)
- Should define sensor type and pin
- Should initialize serial communication
- Should read and print sensor values

**Example expected output:**
```cpp
#include <DHT.h>

#define DHTPIN 2
#define DHTTYPE DHT22

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();
  
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.print("°C  Humidity: ");
  Serial.print(humidity);
  Serial.println("%");
  
  delay(2000);
}
```

---

#### **Test 3: Motor Control (Advanced)**
```
Create an Arduino sketch to control a servo motor on pin 9. The servo should sweep from 0 to 180 degrees and back continuously
```

**What to expect:**
- AI should include Servo library
- Should create servo object
- Should attach servo to pin
- Should implement sweep motion

**Example expected output:**
```cpp
#include <Servo.h>

Servo myServo;

void setup() {
  myServo.attach(9);
}

void loop() {
  // Sweep from 0 to 180 degrees
  for (int pos = 0; pos <= 180; pos++) {
    myServo.write(pos);
    delay(15);
  }
  
  // Sweep back from 180 to 0 degrees
  for (int pos = 180; pos >= 0; pos--) {
    myServo.write(pos);
    delay(15);
  }
}
```

---

#### **Test 4: Debugging (AI Understanding)**
```
This Arduino code isn't working. Can you fix it?

void setup() {
  pinMode(13, OUTPUT);
}

void loop() {
  digitalwrite(13, HIGH);
  delay(1000);
  digitalwrite(13, LOW);
  delay(1000);
}
```

**What to expect:**
- AI should identify the error (`digitalwrite` should be `digitalWrite`)
- Should provide corrected code
- Should explain what was wrong

---

#### **Test 5: Complex Project (Full Capability)**
```
Create an Arduino sketch for a simple traffic light system with red, yellow, and green LEDs on pins 8, 9, and 10. The sequence should be: green for 5 seconds, yellow for 2 seconds, red for 5 seconds, then repeat
```

**What to expect:**
- AI should define all three pins
- Should implement proper timing sequence
- Should use clear variable names
- Code should be well-structured

---

## 4. Test Cloud AI Model (If You Chose Cloud Option)

The same prompts above work for cloud models. Cloud models (especially Claude 3.5 and GPT-4o) will typically:
- Provide more detailed explanations
- Include comments in the code
- Suggest improvements or alternatives
- Be faster to respond

---

## 5. Test Model Switching

Try switching between different AI models:

```bash
./switch-ai-model.sh
```

Select a different model and test with the same prompts to compare quality.

---

## 6. Test Arduino Upload (With Real Hardware)

If you have an Arduino connected:

```bash
# Save AI-generated code to a file
cd ~/test-sketch/BlinkTest
nano BlinkTest.ino
# Paste the AI-generated code, save and exit (Ctrl+X, Y, Enter)

# Upload to Arduino
arduino-cli upload --fqbn arduino:avr:uno --port /dev/ttyUSB0 BlinkTest

# Monitor serial output (if code uses Serial)
arduino-cli monitor --port /dev/ttyUSB0
```

**Note**: Replace `/dev/ttyUSB0` with your actual Arduino port (find it with `arduino-cli board list`)

---

## 7. Performance Benchmarks

### Local Models (Qwen 2.5 Coder 7B)
- **Response time**: 10-30 seconds for simple prompts
- **Quality**: Good for basic Arduino tasks
- **RAM usage**: ~4-6GB
- **Best for**: Privacy, offline work, simple projects

### Cloud Models (Free Tier)
- **Google Gemini**: 2-5 seconds response time
- **Groq**: 1-3 seconds (fastest!)
- **Quality**: Very good for Arduino
- **Best for**: Testing, learning, hobby projects

### Cloud Models (Paid)
- **GPT-4o-mini**: 3-6 seconds, excellent quality
- **Claude 3.5 Sonnet**: 4-8 seconds, best quality
- **Best for**: Professional work, complex debugging

---

## 8. Troubleshooting Tests

### Test: AI Assistant Won't Start
```bash
# Check current configuration
./show-ai-model.sh

# Check if OpenManus is installed
ls -la ~/OpenManus

# Check if virtual environment exists
ls -la ~/OpenManus/.venv
```

### Test: Local Model Not Responding
```bash
# Check if Ollama is running
systemctl status ollama

# Check if model is downloaded
ollama list

# Try pulling the model manually
ollama pull qwen2.5-coder:7b
```

### Test: Cloud Model API Errors
```bash
# Check API key is configured
cat ~/OpenManus/config/config.toml | grep api_key

# Test API key manually (for Gemini)
curl -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Hello"}]}]}' \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=YOUR_API_KEY"
```

---

## 9. Quality Comparison Test

Run this same prompt on different models and compare:

```
Create an Arduino sketch to read an ultrasonic sensor (HC-SR04) on pins 7 (trigger) and 6 (echo), and light up an LED on pin 13 when an object is closer than 20cm
```

**Compare:**
- Code correctness
- Code quality (comments, structure)
- Response time
- Explanation quality

---

## 10. Success Criteria

Your installation is successful if:

✅ Arduino CLI compiles sketches without errors  
✅ AI assistant starts without errors  
✅ AI can generate basic Arduino code (Test 1)  
✅ AI can include libraries correctly (Test 2)  
✅ AI can debug code (Test 4)  
✅ Code compiles with `arduino-cli compile`  
✅ (Optional) Code uploads and runs on real Arduino  

---

## Expected Test Results Summary

| Test | Local AI (Qwen) | Cloud Free (Gemini/Groq) | Cloud Paid (Claude/GPT) |
|------|-----------------|--------------------------|-------------------------|
| Test 1 (LED Blink) | ✅ Pass | ✅ Pass | ✅ Pass |
| Test 2 (Sensor) | ✅ Pass | ✅ Pass | ✅ Pass |
| Test 3 (Servo) | ✅ Pass | ✅ Pass | ✅ Pass |
| Test 4 (Debug) | ⚠️ May struggle | ✅ Pass | ✅ Pass |
| Test 5 (Complex) | ⚠️ Basic solution | ✅ Good solution | ✅ Excellent solution |
| Response Time | 10-30s | 2-5s | 3-8s |
| Code Quality | Good | Very Good | Excellent |
| Explanations | Basic | Good | Detailed |

---

## Next Steps After Testing

1. **If all tests pass**: Start building your Arduino projects!
2. **If some tests fail**: Check the troubleshooting section
3. **If you want better quality**: Try switching to a paid cloud model
4. **If you want faster responses**: Try Groq (free and very fast)
5. **If you want privacy**: Stick with local models

---

## Getting Help

If tests fail:
1. Check the error messages carefully
2. Try switching to a different AI model
3. Verify your API key is correct (for cloud models)
4. Make sure you logged out and back in after installation
5. Check that Arduino is properly connected (for upload tests)

---

**Happy Arduino Development with AI!** 🎉

---

**Author**: Jamie Johnson  
**Version**: 1.0  
**Date**: November 2025
