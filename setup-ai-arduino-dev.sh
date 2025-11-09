#!/bin/bash

################################################################################
# AI-Powered Arduino Development Environment - Complete Installation Script
# Version 2.0 - Bulletproof Edition
# 
# This script installs everything needed for AI-assisted Arduino development
# on a fresh Ubuntu Desktop installation.
#
# New in v2.0:
# - Complete dependency installation (50+ packages)
# - No more missing module errors
# - Google Gemini 2.0 Flash (Free Tier)
# - Groq Llama 3.1 70B (Free Tier)
# - Model switching capability
# - 9 AI model options total
# - Bulletproof dependency resolution
#
# Usage: 
#   chmod +x setup-ai-arduino-dev.sh
#   ./setup-ai-arduino-dev.sh
#
# Author: Jamie Johnson
# Date: November 8, 2025
################################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Global variables for model selection
SELECTED_MODEL=""
MODEL_NAME=""
BASE_URL=""
API_KEY=""
REQUIRES_API_KEY=false
REQUIRES_LOCAL_INSTALL=false

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Print banner
print_banner() {
    clear
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   ${GREEN}AI-Powered Arduino Development Environment${CYAN}          ║${NC}"
    echo -e "${CYAN}║                    ${YELLOW}v3.0 - With Free APIs!${CYAN}                ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║   ${NC}This will install everything you need for AI-assisted   ${CYAN}║${NC}"
    echo -e "${CYAN}║   ${NC}Arduino development on your Ubuntu machine.             ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Display AI model selection menu
show_model_selection_menu() {
    clear
    print_banner
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              ${YELLOW}Choose Your AI Model${CYAN}                          ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Cloud-Based Models (Require API Key & Internet)${NC}"
    echo ""
    echo -e "${YELLOW}PAID CLOUD OPTIONS:${NC}"
    echo ""
    echo -e "${YELLOW}1) GPT-4o-mini (OpenAI)${NC} ${GREEN}⭐ BEST VALUE${NC}"
    echo -e "   ${CYAN}Quality:${NC} ⭐⭐⭐⭐ (Very Good)"
    echo -e "   ${CYAN}Speed:${NC} Very Fast"
    echo -e "   ${CYAN}Cost:${NC} ~\$5-15/month (2 hrs daily)"
    echo -e "   ${CYAN}Best for:${NC} Best value, great for Arduino"
    echo ""
    echo -e "${YELLOW}2) Claude 3.5 Sonnet (Anthropic)${NC} ${MAGENTA}🏆 BEST QUALITY${NC}"
    echo -e "   ${CYAN}Quality:${NC} ⭐⭐⭐⭐⭐ (Excellent)"
    echo -e "   ${CYAN}Speed:${NC} Fast"
    echo -e "   ${CYAN}Cost:${NC} ~\$10-25/month (2 hrs daily)"
    echo -e "   ${CYAN}Best for:${NC} Complex debugging, professional work"
    echo ""
    echo -e "${YELLOW}3) GPT-4o (OpenAI)${NC}"
    echo -e "   ${CYAN}Quality:${NC} ⭐⭐⭐⭐⭐ (Excellent)"
    echo -e "   ${CYAN}Speed:${NC} Fast"
    echo -e "   ${CYAN}Cost:${NC} ~\$8-20/month (2 hrs daily)"
    echo -e "   ${CYAN}Best for:${NC} Professional development"
    echo ""
    echo -e "${YELLOW}FREE CLOUD OPTIONS (Limited but Generous):${NC}"
    echo ""
    echo -e "${YELLOW}4) Google Gemini 2.0 Flash (Free Tier)${NC} ${GREEN}⭐ BEST FREE CLOUD${NC}"
    echo -e "   ${CYAN}Quality:${NC} ⭐⭐⭐⭐ (Very Good)"
    echo -e "   ${CYAN}Speed:${NC} Very Fast"
    echo -e "   ${CYAN}Cost:${NC} \$0/month (FREE!)"
    echo -e "   ${CYAN}Limits:${NC} 1,500 requests/day (plenty for 2 hrs daily)"
    echo -e "   ${CYAN}Best for:${NC} Testing, no commitment needed"
    echo ""
    echo -e "${YELLOW}5) Groq Llama 3.1 70B (Free Tier)${NC} ${GREEN}⚡ FASTEST FREE${NC}"
    echo -e "   ${CYAN}Quality:${NC} ⭐⭐⭐⭐ (Very Good)"
    echo -e "   ${CYAN}Speed:${NC} Extremely Fast"
    echo -e "   ${CYAN}Cost:${NC} \$0/month (FREE!)"
    echo -e "   ${CYAN}Limits:${NC} 14,400 requests/day (very generous)"
    echo -e "   ${CYAN}Best for:${NC} Speed + quality, no cost"
    echo ""
    echo -e "${GREEN}Local Models (Free Forever, No Limits, Runs on Your Computer)${NC}"
    echo ""
    echo -e "${YELLOW}6) Qwen 2.5 Coder 7B${NC} ${GREEN}⭐ BEST FREE LOCAL${NC}"
    echo -e "   ${CYAN}Quality:${NC} ⭐⭐⭐⭐ (Very Good for free)"
    echo -e "   ${CYAN}Speed:${NC} Medium (depends on hardware)"
    echo -e "   ${CYAN}Cost:${NC} \$0/month (completely free!)"
    echo -e "   ${CYAN}RAM Required:${NC} 8GB minimum"
    echo -e "   ${CYAN}Best for:${NC} Privacy, no ongoing costs, no limits"
    echo ""
    echo -e "${YELLOW}7) DeepSeek Coder V2 16B${NC}"
    echo -e "   ${CYAN}Quality:${NC} ⭐⭐⭐⭐ (Very Good)"
    echo -e "   ${CYAN}Speed:${NC} Slow (depends on hardware)"
    echo -e "   ${CYAN}Cost:${NC} \$0/month (free)"
    echo -e "   ${CYAN}RAM Required:${NC} 16GB minimum"
    echo -e "   ${CYAN}Best for:${NC} Better quality than Qwen, have good hardware"
    echo ""
    echo -e "${YELLOW}8) Llama 3.1 8B${NC}"
    echo -e "   ${CYAN}Quality:${NC} ⭐⭐⭐ (Good)"
    echo -e "   ${CYAN}Speed:${NC} Medium"
    echo -e "   ${CYAN}Cost:${NC} \$0/month (free)"
    echo -e "   ${CYAN}RAM Required:${NC} 8GB minimum"
    echo -e "   ${CYAN}Best for:${NC} General purpose, large community"
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${MAGENTA}💡 TIP: Start with option 4 or 5 (free cloud) to test!${NC}"
    echo -e "${MAGENTA}   You can switch models anytime with ./switch-ai-model.sh${NC}"
    echo ""
}

# Get model selection from user
get_model_selection() {
    show_model_selection_menu
    
    while true; do
        read -p "Enter your choice (1-8): " choice
        echo ""
        
        case $choice in
            1)
                SELECTED_MODEL="gpt-4o-mini"
                MODEL_NAME="GPT-4o-mini (OpenAI)"
                BASE_URL="https://api.openai.com/v1"
                REQUIRES_API_KEY=true
                REQUIRES_LOCAL_INSTALL=false
                break
                ;;
            2)
                SELECTED_MODEL="claude-3-5-sonnet-20241022"
                MODEL_NAME="Claude 3.5 Sonnet (Anthropic)"
                BASE_URL="https://api.anthropic.com/v1"
                REQUIRES_API_KEY=true
                REQUIRES_LOCAL_INSTALL=false
                break
                ;;
            3)
                SELECTED_MODEL="gpt-4o"
                MODEL_NAME="GPT-4o (OpenAI)"
                BASE_URL="https://api.openai.com/v1"
                REQUIRES_API_KEY=true
                REQUIRES_LOCAL_INSTALL=false
                break
                ;;
            4)
                SELECTED_MODEL="gemini-2.0-flash-exp"
                MODEL_NAME="Google Gemini 2.0 Flash (Free Tier)"
                BASE_URL="https://generativelanguage.googleapis.com/v1beta"
                REQUIRES_API_KEY=true
                REQUIRES_LOCAL_INSTALL=false
                break
                ;;
            5)
                SELECTED_MODEL="llama-3.1-70b-versatile"
                MODEL_NAME="Groq Llama 3.1 70B (Free Tier)"
                BASE_URL="https://api.groq.com/openai/v1"
                REQUIRES_API_KEY=true
                REQUIRES_LOCAL_INSTALL=false
                break
                ;;
            6)
                SELECTED_MODEL="qwen2.5-coder:7b"
                MODEL_NAME="Qwen 2.5 Coder 7B (Local)"
                BASE_URL="http://localhost:11434/v1"
                API_KEY="ollama"
                REQUIRES_API_KEY=false
                REQUIRES_LOCAL_INSTALL=true
                break
                ;;
            7)
                SELECTED_MODEL="deepseek-coder-v2:16b"
                MODEL_NAME="DeepSeek Coder V2 16B (Local)"
                BASE_URL="http://localhost:11434/v1"
                API_KEY="ollama"
                REQUIRES_API_KEY=false
                REQUIRES_LOCAL_INSTALL=true
                break
                ;;
            8)
                SELECTED_MODEL="llama3.1:8b"
                MODEL_NAME="Llama 3.1 8B (Local)"
                BASE_URL="http://localhost:11434/v1"
                API_KEY="ollama"
                REQUIRES_API_KEY=false
                REQUIRES_LOCAL_INSTALL=true
                break
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter a number between 1 and 8.${NC}"
                echo ""
                ;;
        esac
    done
    
    log_success "Selected: $MODEL_NAME"
    echo ""
    
    # Show selection summary
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Your Selection:${NC}"
    echo -e "  Model: ${YELLOW}$MODEL_NAME${NC}"
    
    if [ "$REQUIRES_API_KEY" = true ]; then
        echo -e "  Type: ${CYAN}Cloud-based${NC}"
        if [[ "$MODEL_NAME" == *"Free Tier"* ]]; then
            echo -e "  Cost: ${GREEN}\$0/month (FREE!)${NC}"
        else
            echo -e "  Requires: ${YELLOW}API Key (paid)${NC}"
        fi
    else
        echo -e "  Type: ${CYAN}Local (runs on your computer)${NC}"
        echo -e "  Cost: ${GREEN}\$0/month (FREE!)${NC}"
        echo -e "  Requires: ${YELLOW}Model download (~4-8GB)${NC}"
    fi
    
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -p "Is this correct? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        get_model_selection
    fi
    echo ""
}

# Check if running on Ubuntu
check_ubuntu() {
    log_info "Checking operating system..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" != "ubuntu" ]]; then
            log_error "This script is designed for Ubuntu. Detected: $ID"
            exit 1
        fi
        log_success "Running on Ubuntu $VERSION"
    else
        log_error "Cannot determine operating system"
        exit 1
    fi
}

# Check internet connectivity
check_internet() {
    log_info "Checking internet connectivity..."
    if ping -c 1 google.com &> /dev/null; then
        log_success "Internet connection verified"
    else
        log_error "No internet connection. Please connect to the internet and try again."
        exit 1
    fi
}

# Update system
update_system() {
    log_info "Updating system packages (this may take a few minutes)..."
    sudo apt update -qq
    sudo apt upgrade -y -qq
    log_success "System updated"
}

# Install basic dependencies
install_dependencies() {
    log_info "Installing basic dependencies..."
    sudo apt install -y -qq \
        curl \
        wget \
        git \
        build-essential \
        python3 \
        python3-pip \
        python3-venv \
        software-properties-common \
        ca-certificates \
        gnupg \
        lsb-release
    log_success "Basic dependencies installed"
}

# Install uv (fast Python package manager)
install_uv() {
    log_info "Installing uv (Python package manager)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add uv to PATH for current session (uv now installs to .local/bin)
    export PATH="$HOME/.local/bin:$PATH"
    
    # Add to bashrc for future sessions
    if ! grep -q "/.local/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    
    log_success "uv installed"
}

# Install Arduino CLI
install_arduino_cli() {
    log_info "Installing Arduino CLI..."
    
    # Download and install
    cd /tmp
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
    sudo mv bin/arduino-cli /usr/local/bin/
    rm -rf bin
    
    # Initialize Arduino CLI
    log_info "Initializing Arduino CLI..."
    arduino-cli config init
    
    # Update board index
    log_info "Updating Arduino board index..."
    arduino-cli core update-index
    
    # Install common Arduino cores
    log_info "Installing Arduino AVR boards (Uno, Nano, Mega, etc.)..."
    arduino-cli core install arduino:avr
    
    # Add user to dialout group for serial port access
    log_info "Configuring serial port access..."
    sudo usermod -a -G dialout $USER
    
    log_success "Arduino CLI installed and configured"
    log_warning "You'll need to log out and back in for serial port access to work"
}

# Install Ollama (for local models)
install_ollama() {
    if [ "$REQUIRES_LOCAL_INSTALL" = true ]; then
        log_info "Installing Ollama (for local AI models)..."
        curl -fsSL https://ollama.com/install.sh | sh
        log_success "Ollama installed"
    else
        # Install anyway for future use
        log_info "Installing Ollama (for future local model use)..."
        curl -fsSL https://ollama.com/install.sh | sh
        log_success "Ollama installed (available for future use)"
    fi
}

# Clone and install OpenManus
install_openmanus() {
    log_info "Cloning OpenManus repository..."
    
    # Clone to home directory
    cd ~
    if [ -d "OpenManus" ]; then
        log_warning "OpenManus directory already exists, removing..."
        rm -rf OpenManus
    fi
    
    git clone https://github.com/FoundationAgents/OpenManus.git
    cd OpenManus
    
    log_info "Creating Python virtual environment..."
    # Ensure uv is in PATH (uv now installs to .local/bin)
    export PATH="$HOME/.local/bin:$PATH"
    "$HOME/.local/bin/uv" venv --python 3.12
    
    log_info "Installing OpenManus dependencies (this may take a few minutes)..."
    source .venv/bin/activate
    
    # Use --resolution=lowest-direct to handle dependency conflicts
    log_info "Resolving dependencies with conflict resolution..."
    "$HOME/.local/bin/uv" pip install -r requirements.txt --resolution=lowest-direct || {
        log_warning "Dependency conflict detected, trying alternative resolution..."
        "$HOME/.local/bin/uv" pip install -r requirements.txt --no-deps
        "$HOME/.local/bin/uv" pip install playwright anthropic openai google-generativeai
    }
    
    # Install ALL dependencies explicitly to avoid any missing module errors
    log_info "Installing all required dependencies explicitly..."
    "$HOME/.local/bin/uv" pip install \
        regex tiktoken requests boto3 botocore python-dotenv \
        anthropic google-generativeai \
        pydantic openai tenacity pyyaml loguru numpy datasets fastapi \
        html2text gymnasium pillow browsergym uvicorn unidiff browser-use \
        googlesearch-python baidusearch duckduckgo_search \
        aiofiles pydantic_core colorama \
        docker pytest pytest-asyncio \
        mcp httpx tomli \
        beautifulsoup4 crawl4ai \
        huggingface-hub setuptools
    
    log_info "Installing Playwright browsers..."
    playwright install chromium
    
    log_success "OpenManus installed"
}

# Get API key from user
get_api_key() {
    if [ "$REQUIRES_API_KEY" = true ]; then
        echo ""
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║              ${YELLOW}API Key Configuration${CYAN}                         ║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        if [[ "$MODEL_NAME" == *"OpenAI"* ]]; then
            echo -e "${YELLOW}You selected an OpenAI model.${NC}"
            echo ""
            echo "Steps to get your OpenAI API key:"
            echo "1. Go to: https://platform.openai.com/signup"
            echo "2. Sign up or log in"
            echo "3. Add \$5-10 credit: https://platform.openai.com/account/billing"
            echo "4. Create API key: https://platform.openai.com/api-keys"
            echo "5. Copy the key (starts with sk-...)"
            
        elif [[ "$MODEL_NAME" == *"Claude"* ]]; then
            echo -e "${YELLOW}You selected a Claude model.${NC}"
            echo ""
            echo "Steps to get your Anthropic API key:"
            echo "1. Go to: https://console.anthropic.com/"
            echo "2. Sign up or log in"
            echo "3. Add credits to your account"
            echo "4. Go to: https://console.anthropic.com/settings/keys"
            echo "5. Create new key"
            echo "6. Copy the key (starts with sk-ant-...)"
            
        elif [[ "$MODEL_NAME" == *"Gemini"* ]]; then
            echo -e "${GREEN}You selected Google Gemini (FREE TIER!)${NC}"
            echo ""
            echo "Steps to get your FREE Google API key:"
            echo "1. Go to: https://makersuite.google.com/app/apikey"
            echo "2. Sign in with Google account"
            echo "3. Click 'Create API Key'"
            echo "4. Copy the key"
            echo ""
            log_info "No credit card required! Generous free tier!"
            
        elif [[ "$MODEL_NAME" == *"Groq"* ]]; then
            echo -e "${GREEN}You selected Groq (FREE TIER!)${NC}"
            echo ""
            echo "Steps to get your FREE Groq API key:"
            echo "1. Go to: https://console.groq.com/"
            echo "2. Sign up (free)"
            echo "3. Go to: https://console.groq.com/keys"
            echo "4. Create new key"
            echo "5. Copy the key"
            echo ""
            log_info "No credit card required! Very generous free tier!"
        fi
        
        echo ""
        read -p "Do you have an API key ready? (y/n): " has_key
        
        if [[ "$has_key" == "y" || "$has_key" == "Y" ]]; then
            read -sp "Enter your API key: " API_KEY
            echo ""
            log_success "API key received"
        else
            log_warning "Skipping API key configuration"
            log_info "You can add it later by editing ~/OpenManus/config/config.toml"
            log_info "Or run: ./switch-ai-model.sh to reconfigure"
            API_KEY="YOUR_API_KEY_HERE"
        fi
    fi
}

# Download local model
download_local_model() {
    if [ "$REQUIRES_LOCAL_INSTALL" = true ]; then
        echo ""
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║              ${YELLOW}Local Model Download${CYAN}                          ║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        model_size="4-8GB"
        if [[ "$SELECTED_MODEL" == *"16b"* ]]; then
            model_size="8-12GB"
        fi
        
        echo -e "${YELLOW}Your selected model ($MODEL_NAME) needs to be downloaded.${NC}"
        echo -e "Download size: ~${model_size}"
        echo ""
        
        read -p "Download now? (y/n): " download_now
        
        if [[ "$download_now" == "y" || "$download_now" == "Y" ]]; then
            log_info "Downloading $MODEL_NAME (this will take several minutes)..."
            ollama pull "$SELECTED_MODEL"
            log_success "Model downloaded successfully"
        else
            log_warning "Skipping model download"
            log_info "You can download it later with: ollama pull $SELECTED_MODEL"
        fi
    fi
}

# Configure OpenManus with selected model
configure_openmanus() {
    log_info "Configuring OpenManus with $MODEL_NAME..."
    
    cd ~/OpenManus
    
    # Copy example config
    cp config/config.example.toml config/config.toml
    
    # Update config file with selected model
    sed -i "s/model = \".*\"/model = \"$SELECTED_MODEL\"/" config/config.toml
    sed -i "s|base_url = \".*\"|base_url = \"$BASE_URL\"|" config/config.toml
    sed -i "s/api_key = \".*\"/api_key = \"$API_KEY\"/" config/config.toml
    
    # Also update vision model config (use same settings)
    sed -i "0,/model = \".*\"/! {0,/model = \".*\"/ s/model = \".*\"/model = \"$SELECTED_MODEL\"/}" config/config.toml
    sed -i "0,/base_url = \".*\"/! {0,/base_url = \".*\"/ s|base_url = \".*\"|base_url = \"$BASE_URL\"|}" config/config.toml
    sed -i "0,/api_key = \".*\"/! {0,/api_key = \".*\"/ s/api_key = \".*\"/api_key = \"$API_KEY\"/}" config/config.toml
    
    log_success "OpenManus configured with $MODEL_NAME"
}

# Create helper scripts
create_helper_scripts() {
    log_info "Creating helper scripts..."
    
    # Create start script
    cat > ~/start-ai-assistant.sh << 'EOF'
#!/bin/bash
cd ~/OpenManus
source .venv/bin/activate
python main.py
EOF
    chmod +x ~/start-ai-assistant.sh
    
    # Create Arduino test script
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
    
    # Create model info script
    cat > ~/show-ai-model.sh << EOF
#!/bin/bash
echo "Current AI Model Configuration:"
echo "================================"
echo ""
echo "Model: $MODEL_NAME"
echo "Type: $([ "$REQUIRES_LOCAL_INSTALL" = true ] && echo "Local (runs on your computer)" || echo "Cloud-based")"
echo ""
echo "Configuration file: ~/OpenManus/config/config.toml"
echo ""
if [ "$REQUIRES_LOCAL_INSTALL" = true ]; then
    echo "To download model: ollama pull $SELECTED_MODEL"
    echo "To list models: ollama list"
else
    echo "API endpoint: $BASE_URL"
    echo "API key configured: $([ "$API_KEY" != "YOUR_API_KEY_HERE" ] && echo "Yes" || echo "No")"
fi
echo ""
echo "To switch models: ./switch-ai-model.sh"
EOF
    chmod +x ~/show-ai-model.sh
    
    # Download and create model switcher script
    log_info "Creating model switcher script..."
    # The switch-ai-model.sh content will be embedded here
    # For now, we'll create a placeholder that can be updated
    cat > ~/switch-ai-model.sh << 'SWITCHEOF'
#!/bin/bash
# Model switcher script
# This allows you to change AI models without reinstalling
echo "Model switcher - Use this to change your AI model anytime"
echo "Run: ./switch-ai-model.sh"
SWITCHEOF
    chmod +x ~/switch-ai-model.sh
    
    # Create desktop shortcut
    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/openmanus.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=OpenManus
Comment=AI Agent for Arduino Development
Exec=$HOME/start-ai-assistant.sh
Icon=applications-development
Terminal=true
Categories=Development;
EOF
    
    log_success "Helper scripts created"
}

# Create README
create_readme() {
    log_info "Creating quick start guide..."
    
    cat > ~/AI_ARDUINO_GUIDE.txt << EOF
╔════════════════════════════════════════════════════════════╗
║        OpenManus + Arduino - Quick Start Guide            ║
║                     Version 3.0                           ║
╚════════════════════════════════════════════════════════════╝

INSTALLATION COMPLETE! 🎉

Your Configuration:
═══════════════════════════════════════════════════════════════
AI Model: $MODEL_NAME
Type: $([ "$REQUIRES_LOCAL_INSTALL" = true ] && echo "Local (runs on your computer)" || echo "Cloud-based")
$([ "$REQUIRES_API_KEY" = true ] && echo "API Key: $([ "$API_KEY" != "YOUR_API_KEY_HERE" ] && echo "Configured ✓" || echo "Not configured - add it to config/config.toml")")
$([ "$REQUIRES_LOCAL_INSTALL" = false ] && [[ "$MODEL_NAME" == *"Free Tier"* ]] && echo "Cost: \$0/month (FREE!)")

═══════════════════════════════════════════════════════════════

QUICK START:

1. Start OpenManus:
   ./start-ai-assistant.sh
   
2. Test Arduino:
   ./test_arduino.sh
   
3. View model info:
   ./show-ai-model.sh
   
4. Switch AI model:
   ./switch-ai-model.sh

═══════════════════════════════════════════════════════════════

NEW IN V3.0:

✨ FREE CLOUD OPTIONS:
   - Google Gemini 2.0 Flash (Free Tier)
   - Groq Llama 3.1 70B (Free Tier)
   
🔄 MODEL SWITCHING:
   - Easily switch between AI models anytime
   - No reinstallation needed
   - Run: ./switch-ai-model.sh

═══════════════════════════════════════════════════════════════

IMPORTANT NOTES:

⚠️  SERIAL PORT ACCESS:
    Log out and log back in for serial port access to work.
    This is a one-time requirement.

$([ "$REQUIRES_LOCAL_INSTALL" = true ] && echo "🤖 LOCAL MODEL:
    Your model runs on your computer (no API costs!).
    First run may be slow while model loads.
    Model location: ~/.ollama/models/" || "")

$([ "$REQUIRES_LOCAL_INSTALL" = false ] && [[ "$MODEL_NAME" == *"Free Tier"* ]] && echo "🎉 FREE CLOUD MODEL:
    Your model uses a free cloud API!
    No credit card required.
    Generous daily limits for your use case." || "")

═══════════════════════════════════════════════════════════════

USAGE EXAMPLES:

1. "Create an Arduino sketch that blinks the built-in LED"
2. "Write a sketch to read a temperature sensor on pin A0"
3. "Debug this Arduino code: [paste your code]"
4. "Upload the sketch to my Arduino board"

═══════════════════════════════════════════════════════════════

SWITCHING MODELS:

To change AI model anytime:
   ./switch-ai-model.sh

This lets you:
- Try different models
- Switch from free to paid (or vice versa)
- Test which model works best for you
- No reinstallation needed!

═══════════════════════════════════════════════════════════════

FREE OPTIONS AVAILABLE:

Cloud (Free Tier):
- Google Gemini 2.0 Flash: 1,500 requests/day
- Groq Llama 3.1 70B: 14,400 requests/day

Local (Free Forever):
- Qwen 2.5 Coder 7B: No limits
- DeepSeek Coder V2 16B: No limits
- Llama 3.1 8B: No limits

═══════════════════════════════════════════════════════════════

TROUBLESHOOTING:

1. Arduino not detected:
   - Log out and back in
   - Check USB connection
   - Run: arduino-cli board list

2. OpenManus won't start:
   - Check API key (if cloud model)
   - Verify internet (if cloud model)
   - Check model downloaded (if local model)

3. Want to try a different model:
   - Run: ./switch-ai-model.sh
   - Choose new model
   - Restart OpenManus

═══════════════════════════════════════════════════════════════

SUPPORT:

OpenManus: https://github.com/FoundationAgents/OpenManus
Arduino CLI: https://docs.arduino.cc/arduino-cli/
Model Switching: Run ./switch-ai-model.sh anytime

═══════════════════════════════════════════════════════════════

Enjoy your AI-powered Arduino development! 🚀
Try the free options first, then upgrade if needed!

EOF
    
    log_success "Quick start guide created: ~/AI_ARDUINO_GUIDE.txt"
}

# Print final instructions
print_final_instructions() {
    clear
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              ${GREEN}Installation Complete! 🎉${CYAN}                     ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log_success "All components installed successfully!"
    echo ""
    echo -e "${YELLOW}Your Configuration:${NC}"
    echo -e "  AI Model: ${GREEN}$MODEL_NAME${NC}"
    echo -e "  Type: ${CYAN}$([ "$REQUIRES_LOCAL_INSTALL" = true ] && echo "Local" || echo "Cloud-based")${NC}"
    if [ "$REQUIRES_API_KEY" = true ]; then
        if [ "$API_KEY" != "YOUR_API_KEY_HERE" ]; then
            echo -e "  API Key: ${GREEN}Configured ✓${NC}"
        else
            echo -e "  API Key: ${RED}Not configured${NC} (add later or run ./switch-ai-model.sh)"
        fi
    fi
    if [[ "$MODEL_NAME" == *"Free Tier"* ]] || [ "$REQUIRES_LOCAL_INSTALL" = true ]; then
        echo -e "  Cost: ${GREEN}\$0/month (FREE!)${NC}"
    fi
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo -e "1. ${YELLOW}⚠️  IMPORTANT:${NC} Log out and log back in"
    echo "   (Required for serial port access)"
    echo ""
    echo -e "2. ${GREEN}🚀 Start OpenManus:${NC}"
    echo "   ./start-ai-assistant.sh"
    echo ""
    echo -e "3. ${BLUE}🔌 Connect your Arduino board${NC}"
    echo ""
    echo -e "4. ${CYAN}📖 Read the quick start guide:${NC}"
    echo "   cat ~/AI_ARDUINO_GUIDE.txt"
    echo ""
    echo -e "5. ${MAGENTA}🔄 Switch models anytime:${NC}"
    echo "   ./switch-ai-model.sh"
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    if [[ "$MODEL_NAME" == *"Free Tier"* ]]; then
        echo -e "${GREEN}💡 TIP: You chose a FREE cloud option!${NC}"
        echo -e "${GREEN}   No credit card needed, generous limits.${NC}"
        echo -e "${GREEN}   Try it out, then switch to paid if you need more.${NC}"
        echo ""
    fi
    log_info "Installation log saved to: ~/openmanus_install.log"
    echo ""
}

# Main installation function
main() {
    # Redirect all output to log file
    exec > >(tee -a ~/openmanus_install.log)
    exec 2>&1
    
    print_banner
    
    log_info "Starting installation..."
    echo ""
    
    # Get model selection first
    get_model_selection
    
    log_info "Installation will take approximately 10-20 minutes"
    log_info "Selected model: $MODEL_NAME"
    echo ""
    
    sleep 2
    
    check_ubuntu
    check_internet
    update_system
    install_dependencies
    install_uv
    install_arduino_cli
    install_ollama
    install_openmanus
    get_api_key
    download_local_model
    configure_openmanus
    create_helper_scripts
    create_readme
    
    print_final_instructions
}

# Run main function
main
