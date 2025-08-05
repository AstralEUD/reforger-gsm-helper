#!/bin/bash

# Reforger Mod Manager - Linux CLI Tool
# Author: Created for Arma Reforger Server Management
# Purpose: Manage server mods in batches for easier testing and deployment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Unicode symbols for better visual appeal
CHECK_MARK="✓"
CROSS_MARK="✗"
ARROW="→"
GEAR="⚙️"
FOLDER="📁"
FILE="📄"
ROCKET="🚀"

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPER_DIR="$SCRIPT_DIR/reforger-gsm-helper"
SETTINGS_FILE="$HELPER_DIR/settings.json"

# Default paths
DEFAULT_CONFIG_PATH="/home/armarserver/serverfiles/armarserver_config.json"
DEFAULT_ADDONS_PATH="/home/armarserver/serverfiles/profiles/server/addons"

# Print functions with improved styling
print_info() {
    echo -e "${BLUE}${GEAR} [INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}${CHECK_MARK} [SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️  [WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}${CROSS_MARK} [ERROR]${NC} $1"
}

print_step() {
    echo -e "${CYAN}${ARROW} $1${NC}"
}

print_header() {
    clear
    echo -e "${PURPLE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                          ║"
    echo "║                    ${ROCKET} REFORGER MOD MANAGER CLI TOOL ${ROCKET}                   ║"
    echo "║                                                                          ║"
    echo "║                     Manage your Arma Reforger mods in batches            ║"
    echo "║                                                                          ║"
    echo "╚══════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

print_separator() {
    echo -e "${BLUE}────────────────────────────────────────────────────────────────────────────${NC}"
}

print_box() {
    local title="$1"
    local content="$2"
    echo -e "${CYAN}╭─ ${BOLD}${title}${NC}${CYAN} ────────────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│${NC} $content"
    echo -e "${CYAN}╰──────────────────────────────────────────────────────────────────────────╯${NC}"
    echo ""
}

# Check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        print_error "jq is required but not installed. Please install jq first:"
        echo ""
        print_step "For Ubuntu/Debian: ${BOLD}sudo apt-get update && sudo apt-get install jq${NC}"
        print_step "For CentOS/RHEL:   ${BOLD}sudo yum install jq${NC}"
        print_step "For Fedora:        ${BOLD}sudo dnf install jq${NC}"
        print_step "For Arch Linux:    ${BOLD}sudo pacman -S jq${NC}"
        echo ""
        exit 1
    fi
    print_success "jq is installed and ready"
}

# Initialize helper directory and settings
init_helper_dir() {
    if [ ! -d "$HELPER_DIR" ] || [ ! -f "$SETTINGS_FILE" ]; then
        if [ ! -d "$HELPER_DIR" ]; then
            print_separator
            print_warning "Helper directory does not exist: ${FOLDER} $HELPER_DIR"
        else
            print_separator  
            print_warning "Settings file missing: ${FILE} $SETTINGS_FILE"
        fi
        
        echo ""
        echo -e "${YELLOW}${BOLD}Setup required!${NC}"
        echo ""
        echo -n "Would you like to (re)initialize the configuration? [y/N]: "
        read -r response
        
        if [[ "$response" =~ ^[Yy]$ ]]; then
            # Create helper directory if it doesn't exist
            mkdir -p "$HELPER_DIR"
            if [ ! -d "$HELPER_DIR" ]; then
                print_success "Created helper directory: ${FOLDER} $HELPER_DIR"
            fi
            
            print_separator
            print_box "Configuration Setup" "Let's configure your server paths"
            
            # Get config file path
            echo -e "${CYAN}${FILE} Config File Path${NC}"
            echo "Enter the path to your armaserver_config.json file"
            echo -e "Default: ${BOLD}$DEFAULT_CONFIG_PATH${NC}"
            echo -n "Press Enter for default or type custom path: "
            read -r config_path
            config_path=${config_path:-$DEFAULT_CONFIG_PATH}
            
            # Get addons directory path
            echo ""
            echo -e "${CYAN}${FOLDER} Addons Directory Path${NC}"
            echo "Enter the path to your server addons directory"
            echo -e "Default: ${BOLD}$DEFAULT_ADDONS_PATH${NC}"
            echo -n "Press Enter for default or type custom path: "
            read -r addons_path
            addons_path=${addons_path:-$DEFAULT_ADDONS_PATH}
            
            # Create settings.json
            cat > "$SETTINGS_FILE" << EOF
{
  "config_path": "$config_path",
  "addons_path": "$addons_path",
  "batch_size": 10,
  "created_date": "$(date +%Y-%m-%d)"
}
EOF
            echo ""
            print_success "Settings saved to: ${FILE} $SETTINGS_FILE"
            print_separator
        else
            print_info "Setup canceled. Exiting..."
            exit 0
        fi
    fi
}

# Load settings
load_settings() {
    if [ -f "$SETTINGS_FILE" ]; then
        CONFIG_PATH=$(jq -r '.config_path' "$SETTINGS_FILE" 2>/dev/null || echo "")
        ADDONS_PATH=$(jq -r '.addons_path' "$SETTINGS_FILE" 2>/dev/null || echo "")
        BATCH_SIZE=$(jq -r '.batch_size' "$SETTINGS_FILE" 2>/dev/null || echo "10")
        
        # Validate jq output
        if [ -z "$CONFIG_PATH" ] || [ "$CONFIG_PATH" == "null" ]; then
            print_error "Invalid config_path in settings file"
            print_info "Please delete the settings file and run the script again to reinitialize"
            print_info "rm -f $SETTINGS_FILE"
            exit 1
        fi
        if [ -z "$ADDONS_PATH" ] || [ "$ADDONS_PATH" == "null" ]; then
            print_error "Invalid addons_path in settings file"
            print_info "Please delete the settings file and run the script again to reinitialize"
            print_info "rm -f $SETTINGS_FILE"
            exit 1
        fi
        print_success "Settings loaded successfully"
    else
        print_warning "Settings file not found. Initializing setup..."
        return 1  # Return non-zero to indicate settings need to be created
    fi
}

# Validate paths
validate_paths() {
    if [ ! -f "$CONFIG_PATH" ]; then
        print_error "Config file not found: $CONFIG_PATH"
        print_info "Please check your settings in: $SETTINGS_FILE"
        exit 1
    fi
    
    if [ ! -d "$(dirname "$ADDONS_PATH")" ]; then
        print_error "Addons parent directory not found: $(dirname "$ADDONS_PATH")"
        print_info "Please check your settings in: $SETTINGS_FILE"
        exit 1
    fi
}

# Count mods in config file
count_mods() {
    local config_file="$1"
    jq '.game.mods | length' "$config_file"
}

# Clean addons directory with user confirmation
clean_addons() {
    print_separator
    print_box "Clean Addons Directory" "Remove all files from addons folder"
    
    if [ -d "$ADDONS_PATH" ]; then
        # Show current addons directory contents
        local addon_count=$(find "$ADDONS_PATH" -mindepth 1 2>/dev/null | wc -l)
        echo -e "${CYAN}${FOLDER} Addons Directory:${NC} $ADDONS_PATH"
        echo -e "${CYAN}📦 Items Found:${NC} ${BOLD}$addon_count${NC} files/folders"
        
        if [ "$addon_count" -eq 0 ]; then
            print_info "Addons directory is already empty"
            return
        fi
        
        echo ""
        echo -e "${YELLOW}⚠️  Warning: This will delete ALL contents in the addons directory!${NC}"
        echo -e "${YELLOW}   This action cannot be undone.${NC}"
        echo ""
        
        while true; do
            echo -n "Do you want to proceed? [y/N]: "
            read -r confirm
            case "$confirm" in
                [Yy]|[Yy][Ee][Ss])
                    print_step "Cleaning addons directory: ${FOLDER} $ADDONS_PATH"
                    # Use find for safer deletion, avoid issues with special characters
                    if find "$ADDONS_PATH" -mindepth 1 -delete 2>/dev/null; then
                        print_success "Addons directory cleaned successfully"
                    else
                        # Fallback method if find fails
                        if rm -rf "${ADDONS_PATH:?}"/* 2>/dev/null; then
                            print_success "Addons directory cleaned successfully (fallback method)"
                        else
                            print_error "Failed to clean addons directory"
                            return 1
                        fi
                    fi
                    break
                    ;;
                [Nn]|[Nn][Oo]|"")
                    print_info "Addons directory cleaning cancelled"
                    break
                    ;;
                *)
                    echo "Please answer yes (y) or no (n)"
                    ;;
            esac
        done
    else
        print_warning "Addons directory does not exist: ${FOLDER} $ADDONS_PATH"
        echo -n "Do you want to create it? [y/N]: "
        read -r create_confirm
        case "$create_confirm" in
            [Yy]|[Yy][Ee][Ss])
                mkdir -p "$ADDONS_PATH"
                print_success "Created addons directory: ${FOLDER} $ADDONS_PATH"
                ;;
            *)
                print_info "Directory creation cancelled"
                ;;
        esac
    fi
    
    print_separator
}

# Create backup and batch files
create_batches() {
    local today=$(date +%Y-%m-%d)
    local batch_dir="$HELPER_DIR/$today"
    
    print_separator
    print_box "Batch Creation" "Creating mod batches for $(date +%B\ %d,\ %Y)"
    
    # Create today's directory
    mkdir -p "$batch_dir"
    
    # Create backup of original config (this keeps the original filename when copied back)
    local backup_file="$batch_dir/armarserver_config_original.json.bak"
    cp "$CONFIG_PATH" "$backup_file"
    print_success "Original config backed up to: ${FILE} armarserver_config_original.json.bak"
    
    # Count total mods
    local total_mods=$(count_mods "$CONFIG_PATH")
    print_info "Total mods detected: ${BOLD}$total_mods${NC}"
    
    if [ "$total_mods" -eq 0 ]; then
        print_warning "No mods found in config file"
        return
    fi
    
    # Calculate number of batches
    local num_batches=$(( (total_mods + BATCH_SIZE - 1) / BATCH_SIZE ))
    print_info "Creating ${BOLD}$num_batches${NC} batch files with ${BOLD}$BATCH_SIZE${NC} mods each"
    echo ""
    
    # Create batch files
    for ((i=1; i<=num_batches; i++)); do
        # For cumulative batches: each batch contains mods from 1 to (i * BATCH_SIZE)
        local end_index=$(( i * BATCH_SIZE ))
        
        # Ensure we don't exceed total mods
        if [ "$end_index" -gt "$total_mods" ]; then
            end_index=$total_mods
        fi
        
        # Create batch config file (these will be renamed to armarserver_config.json when applied)
        local batch_file="$batch_dir/armarserver_config_batch_$i.json"
        
        # Use jq to create a new config with cumulative mods from start (0) to end_index
        if ! jq --argjson end "$end_index" \
           '.game.mods = (.game.mods | .[:$end])' \
           "$CONFIG_PATH" > "$batch_file"; then
            print_error "Failed to create batch file $i"
            continue
        fi
        
        local batch_mod_count=$(count_mods "$batch_file")
        print_success "Batch $i: ${BOLD}$batch_mod_count mods${NC} (mods 1-$batch_mod_count)"
    done
    
    echo ""
    print_success "All batch files created in: ${FOLDER} $batch_dir"
    print_separator
}

# List available batches
list_batches() {
    local today=$(date +%Y-%m-%d)
    local batch_dir="$HELPER_DIR/$today"
    
    if [ ! -d "$batch_dir" ]; then
        print_error "No batch files found for today ($today)"
        print_info "Run the tool first to create batch files"
        return 1
    fi
    
    print_box "Available Configurations" "Today: $(date +%B\ %d,\ %Y)"
    
    # Get original mod count for option 0
    local backup_file="$batch_dir/armarserver_config_original.json.bak"
    local original_count="unknown"
    if [ -f "$backup_file" ]; then
        original_count=$(count_mods "$backup_file")
    fi
    
    echo -e "${GREEN}${BOLD} 0)${NC} ${ARROW} Restore original config (${BOLD}$original_count mods${NC})"
    echo ""
    
    # List batch files with proper sorting
    local batch_files=($(find "$batch_dir" -name "armarserver_config_batch_*.json" 2>/dev/null | sort -V))
    
    if [ ${#batch_files[@]} -eq 0 ]; then
        print_warning "No batch files found"
        return 1
    fi
    
    for ((i=0; i<${#batch_files[@]}; i++)); do
        local batch_num=$((i+1))
        local mod_count=$(count_mods "${batch_files[i]}")
        printf "${BLUE}${BOLD}%2d)${NC} ${ARROW} Batch %d (${BOLD}%d mods${NC})\n" "$batch_num" "$batch_num" "$mod_count"
    done
    
    echo ""
    echo -e "${CYAN}${BOLD}97)${NC} ${ARROW} ${CYAN}Clean addons directory (remove all addon files)${NC}"
    echo -e "${PURPLE}${BOLD}98)${NC} ${ARROW} ${PURPLE}Change batch size (currently: $BATCH_SIZE mods per batch)${NC}"
    echo -e "${YELLOW}${BOLD}99)${NC} ${ARROW} ${YELLOW}Recreate all batches (rebuild from current config)${NC}"
    echo ""
    echo -e "${RED}${BOLD} q)${NC} ${ARROW} ${RED}Exit${NC}"
    echo ""
    print_separator
}

# Change batch size function
change_batch_size() {
    print_separator
    print_box "Batch Size Configuration" "Current batch size: $BATCH_SIZE mods per batch"
    
    echo -e "${CYAN}Enter new batch size (number of mods per batch):${NC}"
    echo -e "Current: ${BOLD}$BATCH_SIZE${NC}"
    echo -e "Recommended: ${BOLD}5-20${NC} (smaller = more batches, larger = fewer batches)"
    echo ""
    echo -n "New batch size: "
    read -r new_size
    
    # Validate input
    if [[ ! "$new_size" =~ ^[0-9]+$ ]] || [ "$new_size" -lt 1 ] || [ "$new_size" -gt 100 ]; then
        print_error "Invalid batch size. Please enter a number between 1 and 100"
        return 1
    fi
    
    # Update settings file
    local temp_file=$(mktemp)
    jq --argjson new_size "$new_size" '.batch_size = $new_size' "$SETTINGS_FILE" > "$temp_file" && mv "$temp_file" "$SETTINGS_FILE"
    
    # Update current variable
    BATCH_SIZE="$new_size"
    
    print_success "Batch size changed to: ${BOLD}$new_size${NC} mods per batch"
    
    # Ask if user wants to recreate batches immediately
    echo ""
    echo -n "Would you like to recreate batches with the new size now? [y/N]: "
    read -r recreate_now
    
    if [[ "$recreate_now" =~ ^[Yy]$ ]]; then
        recreate_batches
    else
        print_info "Batch size updated. Use option 99 to recreate batches when ready"
    fi
}

# Recreate batches function
recreate_batches() {
    local today=$(date +%Y-%m-%d)
    local batch_dir="$HELPER_DIR/$today"
    
    print_separator
    print_warning "This will delete all existing batch files and recreate them from the current config"
    echo ""
    echo -n "Are you sure you want to continue? [y/N]: "
    read -r confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Operation canceled"
        return 0
    fi
    
    # Remove existing batch files but keep the original backup
    if [ -d "$batch_dir" ]; then
        print_step "Removing existing batch files..."
        find "$batch_dir" -name "armarserver_config_batch_*.json" -delete 2>/dev/null || true
        print_success "Existing batch files removed"
    fi
    
    # Create new batches from current config
    print_info "Creating new batches from current configuration..."
    create_batches
}

# Apply selected batch
apply_batch() {
    local selection="$1"
    local today=$(date +%Y-%m-%d)
    local batch_dir="$HELPER_DIR/$today"
    
    print_separator
    
    if [ "$selection" == "0" ]; then
        # Restore original (백업본을 원래 파일 이름인 armarserver_config.json으로 복사)
        local backup_file="$batch_dir/armarserver_config_original.json.bak"
        if [ -f "$backup_file" ]; then
            if cp "$backup_file" "$CONFIG_PATH"; then
                local mod_count=$(count_mods "$CONFIG_PATH")
                print_success "Original config restored with ${BOLD}$mod_count mods${NC}"
                print_step "File copied: armarserver_config_original.json.bak ${ARROW} armarserver_config.json"
                print_info "Note: Use menu option 97 to clean addons directory if needed"
            else
                print_error "Failed to restore original config"
                return 1
            fi
        else
            print_error "Original backup file not found: $backup_file"
            return 1
        fi
    else
        # Apply specific batch (배치 파일을 원래 파일 이름인 armarserver_config.json으로 복사)
        local batch_file="$batch_dir/armarserver_config_batch_$selection.json"
        if [ -f "$batch_file" ]; then
            if cp "$batch_file" "$CONFIG_PATH"; then
                local mod_count=$(count_mods "$CONFIG_PATH")
                print_success "Applied batch $selection with ${BOLD}$mod_count mods${NC}"
                print_step "File copied: armarserver_config_batch_$selection.json ${ARROW} armarserver_config.json"
                print_info "Note: Use menu option 97 to clean addons directory if needed"
            else
                print_error "Failed to apply batch $selection"
                return 1
            fi
        else
            print_error "Batch file not found: $batch_file"
            return 1
        fi
    fi
    
    print_separator
}

# Interactive batch selection
interactive_selection() {
    while true; do
        list_batches
        
        echo -e "${CYAN}${BOLD}Please select a configuration to apply:${NC}"
        echo -n "Enter your choice (0 for original, 97-99 for options, q to exit): "
        read -r selection
        
        # Handle exit
        if [[ "$selection" =~ ^[Qq]$ ]]; then
            print_info "Exiting Reforger Mod Manager. Goodbye! 👋"
            exit 0
        fi
        
        # Handle special options
        if [ "$selection" = "97" ]; then
            clean_addons
            continue  # Return to menu after cleaning addons
        elif [ "$selection" = "98" ]; then
            change_batch_size
            continue  # Return to menu after changing batch size
        elif [ "$selection" = "99" ]; then
            recreate_batches
            continue  # Return to menu after recreation
        fi
        
        # Validate numeric input
        if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
            echo ""
            print_error "Please enter a valid number, 97-99, or 'q' to exit"
            echo ""
            continue
        fi
        
        local today=$(date +%Y-%m-%d)
        local batch_dir="$HELPER_DIR/$today"
        local max_batches=$(find "$batch_dir" -name "armarserver_config_batch_*.json" 2>/dev/null | wc -l)
        
        if [ "$selection" -eq 0 ] || ([ "$selection" -ge 1 ] && [ "$selection" -le "$max_batches" ]); then
            apply_batch "$selection"
            break
        else
            echo ""
            print_error "Invalid selection. Please choose between 0 and $max_batches, 97-99 for options, or 'q' to exit"
            echo ""
        fi
    done
}

# Show current status
show_status() {
    print_box "Current Server Configuration" "System status and paths"
    
    echo -e "${CYAN}${FILE} Config Path:${NC} $CONFIG_PATH"
    echo -e "${CYAN}${FOLDER} Addons Path:${NC} $ADDONS_PATH"
    
    if [ -f "$CONFIG_PATH" ]; then
        local current_mods=$(count_mods "$CONFIG_PATH")
        echo -e "${CYAN}${GEAR} Current Mods:${NC} ${BOLD}$current_mods${NC}"
        
        # Show config file modification time
        local mod_time=$(stat -c %y "$CONFIG_PATH" 2>/dev/null | cut -d. -f1 || echo "unknown")
        echo -e "${CYAN}📅 Last Modified:${NC} $mod_time"
    else
        echo -e "${CYAN}${GEAR} Current Mods:${NC} ${RED}Config file not found${NC}"
    fi
    
    echo -e "${CYAN}📦 Batch Size:${NC} $BATCH_SIZE mods per batch"
    
    # Show disk space for config directory
    local config_dir=$(dirname "$CONFIG_PATH")
    if [ -d "$config_dir" ]; then
        local disk_space=$(df -h "$config_dir" 2>/dev/null | awk 'NR==2 {print $4}' || echo "unknown")
        echo -e "${CYAN}💾 Available Space:${NC} $disk_space"
    fi
    
    echo ""
}

# Main function
main() {
    print_header
    
    # Check requirements
    print_step "Checking system requirements..."
    check_jq
    
    # Initialize if needed (this must come before load_settings)
    init_helper_dir
    
    # Load settings (only after initialization is complete)
    print_step "Loading configuration..."
    if ! load_settings; then
        print_error "Failed to load settings after initialization. Something went wrong."
        exit 1
    fi
    
    # Validate paths
    print_step "Validating paths..."
    validate_paths
    
    # Show current status
    show_status
    
    # Check if we have batch files for today
    local today=$(date +%Y-%m-%d)
    local batch_dir="$HELPER_DIR/$today"
    
    if [ ! -d "$batch_dir" ] || [ ! -f "$batch_dir/armarserver_config_original.json.bak" ]; then
        print_info "No batch files found for today, creating new ones..."
        create_batches
    else
        print_info "Found existing batch files for today"
        print_separator
    fi
    
    # Interactive selection
    interactive_selection
    
    echo ""
    print_success "Operation completed successfully! ${ROCKET}"
    print_info "Your Arma Reforger server is ready with the selected mod configuration"
    echo ""
}

# Run main function
if [ "${1:-}" == "--init" ] || [ "${1:-}" == "--reinit" ]; then
    print_header
    print_info "Force re-initialization requested..."
    
    # Remove existing settings
    if [ -f "$SETTINGS_FILE" ]; then
        rm -f "$SETTINGS_FILE"
        print_success "Removed existing settings file"
    fi
    
    # Check requirements
    print_step "Checking system requirements..."
    check_jq
    
    # Force initialization
    init_helper_dir
    
    print_success "Re-initialization completed! ${ROCKET}"
    print_info "You can now run the script normally: ./reforger-mod-manager.sh"
    exit 0
else
    main "$@"
fi
