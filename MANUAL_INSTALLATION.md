# Manual Installation Guide (If Script Fails)

If the automated script doesn't work for any reason, follow these manual steps.

## Prerequisites

Fresh Ubuntu Desktop with internet connection.

---

## Step 1: Update System (5 minutes)

```bash
sudo apt update
sudo apt upgrade -y
```

---

## Step 2: Install Basic Dependencies (3 minutes)

```bash
sudo apt install -y curl wget git build-essential python3 python3-pip python3-venv
```

---

## Step 3: Install uv (Python Package Manager) (2 minutes)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
```

---

## Step 4: Install Arduino CLI (5 minutes)

```bash
# Download and install
cd /tmp
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
sudo mv bin/arduino-cli /usr/local/bin/

# Initialize
arduino-cli config init
arduino-cli core update-index
arduino-cli core install arduino:avr

# Configure serial access
sudo usermod -a -G dialout $USER
```

**Important**: Log out and back in after this step!

---

## Step 5: Install Ollama (Optional, for local LLM) (3 minutes)

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

---

## Step 6: Install OpenManus (10 minutes)

```bash
# Clone repository
cd ~
git clone https://github.com/FoundationAgents/OpenManus.git
cd OpenManus

# Create virtual environment
~/.cargo/bin/uv venv --python 3.12
source .venv/bin/activate

# Install dependencies
~/.cargo/bin/uv pip install -r requirements.txt

# Install Playwright
playwright install chromium
```

---

## Step 7: Configure OpenManus (5 minutes)

```bash
cd ~/OpenManus
cp config/config.example.toml config/config.toml
nano config/config.toml
```

Edit the file and replace `YOUR_API_KEY_HERE` with your actual OpenAI API key in two places:

```toml
[llm]
model = "gpt-4o-mini"
base_url = "https://api.openai.com/v1"
api_key = "sk-YOUR-ACTUAL-KEY-HERE"  # ← Change this
max_tokens = 4096
temperature = 0.0

[llm.vision]
model = "gpt-4o-mini"
base_url = "https://api.openai.com/v1"
api_key = "sk-YOUR-ACTUAL-KEY-HERE"  # ← Change this too
```

Save (Ctrl+O, Enter) and exit (Ctrl+X).

---

## Step 8: Create Helper Scripts (2 minutes)

### Start Script

```bash
cat > ~/start_openmanus.sh << 'EOF'
#!/bin/bash
cd ~/OpenManus
source .venv/bin/activate
python main.py
EOF

chmod +x ~/start_openmanus.sh
```

### Test Script

```bash
cat > ~/test_arduino.sh << 'EOF'
#!/bin/bash
echo "Testing Arduino CLI..."
echo ""
echo "Connected Arduino boards:"
arduino-cli board list
echo ""
echo "Installed cores:"
arduino-cli core list
EOF

chmod +x ~/test_arduino.sh
```

---

## Step 9: Test Installation (2 minutes)

### Test Arduino CLI

```bash
./test_arduino.sh
```

Expected output:
```
Testing Arduino CLI...

Connected Arduino boards:
Port         Protocol Type              Board Name FQBN            Core
/dev/ttyACM0 serial   Serial Port (USB) Arduino Uno arduino:avr:uno arduino:avr

Installed cores:
ID          Installed Latest Name
arduino:avr 1.8.6     1.8.6  Arduino AVR Boards
```

### Test OpenManus

```bash
./start_openmanus.sh
```

Type: `Hello, can you help me with Arduino?`

If it responds, everything is working!

---

## Troubleshooting

### Arduino CLI Not Found

```bash
which arduino-cli
```

If empty, reinstall:
```bash
cd /tmp
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
sudo mv bin/arduino-cli /usr/local/bin/
```

### Serial Port Permission Denied

```bash
sudo usermod -a -G dialout $USER
```

Then log out and back in.

### OpenManus Won't Start

Check Python version:
```bash
python3 --version
```

Should be 3.12 or higher.

Check virtual environment:
```bash
cd ~/OpenManus
source .venv/bin/activate
which python
```

Should show: `/home/YOUR-USERNAME/OpenManus/.venv/bin/python`

### API Key Error

Verify your API key:
```bash
grep "api_key" ~/OpenManus/config/config.toml
```

Make sure it starts with `sk-` and has no quotes issues.

---

## Optional: Download Local Model

If you want to use free local LLM instead of OpenAI:

```bash
ollama pull qwen2.5-coder:7b
```

Then edit config:
```bash
nano ~/OpenManus/config/config.toml
```

Change:
```toml
[llm]
model = "qwen2.5-coder:7b"
base_url = "http://localhost:11434/v1"
api_key = "ollama"
```

---

## Verification Checklist

- [ ] `arduino-cli version` shows version number
- [ ] `arduino-cli board list` detects your Arduino
- [ ] `./start_openmanus.sh` starts without errors
- [ ] OpenManus responds to your messages
- [ ] You can create and compile Arduino sketches

---

## Total Time

- Automated script: **10-15 minutes**
- Manual installation: **30-40 minutes**

---

## Next Steps

Once everything is working:

1. Read the Quick Start Guide: `cat ~/OpenManus_README.txt`
2. Try creating your first Arduino sketch
3. Experiment with different commands
4. Join the OpenManus community for support

---

**Installation complete! Happy coding! 🚀**
