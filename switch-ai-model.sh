#!/bin/bash

################################################################################
# AI Model Switcher for Arduino Development
# Version: 2.0
# 
# This script allows you to easily switch between different AI models
# without reinstalling everything.
#
# Usage: ./switch-ai-model.sh
#
# Author: Jamie Johnson
# Date: November 8, 2025
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Global variables
SELECTED_MODEL=""
MODEL_NAME=""
BASE_URL=""
API_KEY=""
REQUIRES_API_KEY=false
REQUIRES_LOCAL_INSTALL=false
CONFIG_FILE="$HOME/OpenManus/config/config.toml"

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

# Check if OpenManus is installed
check_installation() {
    if [ ! -d "$HOME/OpenManus" ]; then
        log_error "OpenManus not found at $HOME/OpenManus"
        log_error "Please run the installation script first"
        exit 1
    fi
    
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "Config file not found at $CONFIG_FILE"
        exit 1
    fi
    
    log_success "OpenManus installation found"
}

# Show current configuration
show_current_config() {
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Current Configuration:${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    
    current_model=$(grep -m 1 'model = ' "$CONFIG_FILE" | cut -d'"' -f2)
    current_base_url=$(grep -m 1 'base_url = ' "$CONFIG_FILE" | cut -d'"' -f2)
    
    echo -e "Model: ${GREEN}$current_model${NC}"
    echo -e "Base URL: ${CYAN}$current_base_url${NC}"
    
    if [[ "$current_base_url" == *"localhost"* ]]; then
        echo -e "Type: ${MAGENTA}Local (runs on your computer)${NC}"
    else
        echo -e "Type: ${BLUE}Cloud-based${NC}"
    fi
    
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Display model selection menu
show_model_selection_menu() {
    clear
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              ${YELLOW}Switch AI Model${CYAN}                               ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    
    show_current_config
    
    echo -e "${GREEN}Cloud-Based Models (Require API Key & Internet)${NC}"
    echo ""
    echo -e "${YELLOW}PAID CLOUD OPTIONS:${NC}"
    echo ""
    echo -e "${YELLOW}1) GPT-4o-mini (OpenAI)${NC} ${GREEN}⭐ BEST VALUE${NC}"
    echo -e "   Quality: ⭐⭐⭐⭐ | Speed: Very Fast | Cost: ~\$5-15/month"
    echo ""
    echo -e "${YELLOW}2) Claude 3.5 Sonnet (Anthropic)${NC} ${MAGENTA}🏆 BEST QUALITY${NC}"
    echo -e "   Quality: ⭐⭐⭐⭐⭐ | Speed: Fast | Cost: ~\$10-25/month"
    echo ""
    echo -e "${YELLOW}3) GPT-4o (OpenAI)${NC}"
    echo -e "   Quality: ⭐⭐⭐⭐⭐ | Speed: Fast | Cost: ~\$8-20/month"
    echo ""
    echo -e "${YELLOW}FREE CLOUD OPTIONS (Limited but Generous):${NC}"
    echo ""
    echo -e "${YELLOW}4) Google Gemini 2.0 Flash (Free Tier)${NC} ${GREEN}⭐ BEST FREE CLOUD${NC}"
    echo -e "   Quality: ⭐⭐⭐⭐ | Speed: Very Fast | Cost: \$0 | Limit: 1,500/day"
    echo ""
    echo -e "${YELLOW}5) Groq Llama 3.1 70B (Free Tier)${NC} ${GREEN}⚡ FASTEST FREE${NC}"
    echo -e "   Quality: ⭐⭐⭐⭐ | Speed: Extremely Fast | Cost: \$0 | Limit: 14,400/day"
    echo ""
    echo -e "${GREEN}Local Models (Free Forever, No Limits, Runs on Your Computer)${NC}"
    echo ""
    echo -e "${YELLOW}6) Qwen 2.5 Coder 7B${NC} ${GREEN}⭐ BEST FREE LOCAL${NC}"
    echo -e "   Quality: ⭐⭐⭐⭐ | Speed: Medium | Cost: \$0 | RAM: 8GB min"
    echo ""
    echo -e "${YELLOW}7) DeepSeek Coder V2 16B${NC}"
    echo -e "   Quality: ⭐⭐⭐⭐ | Speed: Slow | Cost: \$0 | RAM: 16GB min"
    echo ""
    echo -e "${YELLOW}8) Llama 3.1 8B${NC}"
    echo -e "   Quality: ⭐⭐⭐ | Speed: Medium | Cost: \$0 | RAM: 8GB min"
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Get model selection
get_model_selection() {
    show_model_selection_menu
    
    while true; do
        read -p "Enter your choice (1-8, or 0 to cancel): " choice
        echo ""
        
        case $choice in
            0)
                log_info "Cancelled"
                exit 0
                ;;
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
                echo -e "${RED}Invalid choice. Please enter 0-8.${NC}"
                echo ""
                ;;
        esac
    done
    
    log_success "Selected: $MODEL_NAME"
    echo ""
}

# Get API key
get_api_key() {
    if [ "$REQUIRES_API_KEY" = true ]; then
        echo ""
        echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}API Key Required${NC}"
        echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
        echo ""
        
        if [[ "$MODEL_NAME" == *"OpenAI"* ]]; then
            echo "Get your OpenAI API key:"
            echo "→ https://platform.openai.com/api-keys"
            
        elif [[ "$MODEL_NAME" == *"Claude"* ]]; then
            echo "Get your Anthropic API key:"
            echo "→ https://console.anthropic.com/settings/keys"
            
        elif [[ "$MODEL_NAME" == *"Gemini"* ]]; then
            echo "Get your Google API key:"
            echo "→ https://makersuite.google.com/app/apikey"
            echo ""
            log_info "Google Gemini has a generous FREE tier!"
            
        elif [[ "$MODEL_NAME" == *"Groq"* ]]; then
            echo "Get your Groq API key:"
            echo "→ https://console.groq.com/keys"
            echo ""
            log_info "Groq is FREE with very generous limits!"
        fi
        
        echo ""
        read -sp "Enter your API key (or press Enter to skip): " API_KEY
        echo ""
        
        if [ -z "$API_KEY" ]; then
            log_warning "No API key provided. You'll need to add it manually."
            API_KEY="YOUR_API_KEY_HERE"
        else
            log_success "API key received"
        fi
    fi
}

# Check/install Ollama
check_ollama() {
    if [ "$REQUIRES_LOCAL_INSTALL" = true ]; then
        if ! command -v ollama &> /dev/null; then
            log_warning "Ollama not found. Installing..."
            curl -fsSL https://ollama.com/install.sh | sh
            log_success "Ollama installed"
        else
            log_success "Ollama already installed"
        fi
    fi
}

# Download local model
download_local_model() {
    if [ "$REQUIRES_LOCAL_INSTALL" = true ]; then
        echo ""
        echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}Local Model Download${NC}"
        echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
        echo ""
        
        # Check if model already exists
        if ollama list | grep -q "$SELECTED_MODEL"; then
            log_success "Model $SELECTED_MODEL already downloaded"
            return
        fi
        
        model_size="4-8GB"
        if [[ "$SELECTED_MODEL" == *"16b"* ]]; then
            model_size="8-12GB"
        elif [[ "$SELECTED_MODEL" == *"70b"* ]]; then
            model_size="40GB+"
        fi
        
        echo -e "Model: ${YELLOW}$MODEL_NAME${NC}"
        echo -e "Download size: ~${model_size}"
        echo ""
        
        read -p "Download now? (y/n): " download_now
        
        if [[ "$download_now" == "y" || "$download_now" == "Y" ]]; then
            log_info "Downloading $MODEL_NAME..."
            ollama pull "$SELECTED_MODEL"
            log_success "Model downloaded"
        else
            log_warning "Skipping download. Run later: ollama pull $SELECTED_MODEL"
        fi
    fi
}

# Update configuration
update_config() {
    log_info "Updating configuration..."
    
    # Backup current config
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
    log_info "Backup created: $CONFIG_FILE.backup"
    
    # Update main LLM config
    sed -i "s/model = \".*\"/model = \"$SELECTED_MODEL\"/" "$CONFIG_FILE"
    sed -i "s|base_url = \".*\"|base_url = \"$BASE_URL\"|" "$CONFIG_FILE"
    sed -i "s/api_key = \".*\"/api_key = \"$API_KEY\"/" "$CONFIG_FILE"
    
    # Update vision model config (second occurrence)
    sed -i "0,/model = \".*\"/! {0,/model = \".*\"/ s/model = \".*\"/model = \"$SELECTED_MODEL\"/}" "$CONFIG_FILE"
    sed -i "0,/base_url = \".*\"/! {0,/base_url = \".*\"/ s|base_url = \".*\"|base_url = \"$BASE_URL\"|}" "$CONFIG_FILE"
    sed -i "0,/api_key = \".*\"/! {0,/api_key = \".*\"/ s/api_key = \".*\"/api_key = \"$API_KEY\"/}" "$CONFIG_FILE"
    
    log_success "Configuration updated"
}

# Update model info script
update_model_info() {
    cat > ~/model_info.sh << EOF
#!/bin/bash
echo "Current AI Model Configuration:"
echo "================================"
echo ""
echo "Model: $MODEL_NAME"
echo "Type: $([ "$REQUIRES_LOCAL_INSTALL" = true ] && echo "Local (runs on your computer)" || echo "Cloud-based")"
echo ""
echo "Configuration file: ~/OpenManus/config/config.toml"
echo "Backup file: ~/OpenManus/config/config.toml.backup"
echo ""
if [ "$REQUIRES_LOCAL_INSTALL" = true ]; then
    echo "To download model: ollama pull $SELECTED_MODEL"
    echo "To list models: ollama list"
    echo "Model status:"
    ollama list | grep "$SELECTED_MODEL" || echo "  Model not downloaded yet"
else
    echo "API endpoint: $BASE_URL"
    echo "API key configured: $([ "$API_KEY" != "YOUR_API_KEY_HERE" ] && echo "Yes" || echo "No - add to config file")"
fi
echo ""
echo "To switch models again: ./switch_model.sh"
EOF
    chmod +x ~/model_info.sh
    log_success "Model info script updated"
}

# Print summary
print_summary() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              ${GREEN}Model Switch Complete!${CYAN}                      ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}New Configuration:${NC}"
    echo -e "  Model: ${GREEN}$MODEL_NAME${NC}"
    echo -e "  Type: ${CYAN}$([ "$REQUIRES_LOCAL_INSTALL" = true ] && echo "Local" || echo "Cloud-based")${NC}"
    
    if [ "$REQUIRES_API_KEY" = true ]; then
        if [ "$API_KEY" != "YOUR_API_KEY_HERE" ]; then
            echo -e "  API Key: ${GREEN}Configured ✓${NC}"
        else
            echo -e "  API Key: ${RED}Not configured${NC}"
        fi
    fi
    
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo -e "1. ${GREEN}Start OpenManus:${NC}"
    echo "   ./start_openmanus.sh"
    echo ""
    echo -e "2. ${CYAN}View configuration:${NC}"
    echo "   ./model_info.sh"
    echo ""
    echo -e "3. ${YELLOW}Test your new model:${NC}"
    echo "   Try: 'Create a simple Arduino LED blink sketch'"
    echo ""
    
    if [ "$API_KEY" = "YOUR_API_KEY_HERE" ]; then
        echo -e "${RED}⚠️  Remember to add your API key to:${NC}"
        echo "   $CONFIG_FILE"
        echo ""
    fi
    
    if [ "$REQUIRES_LOCAL_INSTALL" = true ]; then
        if ! ollama list | grep -q "$SELECTED_MODEL"; then
            echo -e "${YELLOW}⚠️  Don't forget to download the model:${NC}"
            echo "   ollama pull $SELECTED_MODEL"
            echo ""
        fi
    fi
    
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Main function
main() {
    clear
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              ${YELLOW}AI Model Switcher for Arduino Development${CYAN}                 ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    check_installation
    get_model_selection
    get_api_key
    check_ollama
    download_local_model
    update_config
    update_model_info
    print_summary
}

# Run main
main
