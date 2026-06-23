#!/bin/bash

# 📈 STONKS APP MARKET 📈
# "Where apps go to make BIG MONEY... or just get installed!"
# Powered by SMG4 (Stonks Edition)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
WIZARD_DIR="$PROJECT_ROOT/setup-wizard"
STONKS_CONFIG="$SCRIPT_DIR/apps.conf"

# Source colors from setup wizard
source "$WIZARD_DIR/scripts/colors.sh"

# Stonks-specific color
STONKS_GREEN='\033[38;5;82m'  # Bright green for stonks gains
CHART=('📈' '📊' '💹' '💰' '🚀' '$$$')

stonks_intro() {
    clear
    cat << 'EOF'

    ╔════════════════════════════════════════════════════════════════╗
    ║                                                                ║
    ║                   📈 STONKS APP MARKET 📈                     ║
    ║                 "Apps Go BRRR With Gains!!!"                  ║
    ║                                                                ║
    ║    Welcome to the smg4OS App Store where every install        ║
    ║    is a FINANCIAL SUCCESS! The apps are STONKS!               ║
    ║    *Stock market ticker noises intensify*                     ║
    ║                                                                ║
    ╚════════════════════════════════════════════════════════════════╝

EOF
    sleep 2
}

stonks_say() {
    local message="$1"
    echo -e "${GOLD}[STONKS BROKER]${NC} ${STONKS_GREEN}📈 $message${NC}"
}

stonks_bull() {
    local message="$1"
    echo -e "${STONKS_GREEN}[BULL MARKET]${NC} ${STONKS_GREEN}🚀 $message${NC}"
}

stonks_alert() {
    local message="$1"
    echo -e "${YELLOW}[STOCK ALERT]${NC} ${YELLOW}⚠️  $message${NC}"
}

show_stonks_ticker() {
    echo ""
    echo -e "${STONKS_GREEN}   📈 LIVE MARKET DATA 📈${NC}"
    echo -e "${STONKS_GREEN}═══════════════════════════════════════${NC}"
    echo -e "   ${CHART[$((RANDOM % ${#CHART[@]}))]}\$GME  +999%  TO THE MOON!!!"
    echo -e "   ${CHART[$((RANDOM % ${#CHART[@]}))]}\$STONK +∞%   INFINITE GAINS!!!"
    echo -e "   ${CHART[$((RANDOM % ${#CHART[@]}))]}\$APP  +420%  HODL THIS APP!!!"
    echo -e "${STONKS_GREEN}═══════════════════════════════════════${NC}"
    echo ""
}

show_apps_menu() {
    stonks_intro
    
    echo ""
    stonks_say "Welcome to the STONKS app market! Where every app is a 📈 WINNER 📈"
    show_stonks_ticker
    
    echo -e "${BLUE}AVAILABLE APPS IN STONKS MARKET:${NC}"
    echo ""
    
    local app_num=1
    declare -a app_names
    
    while IFS='|' read -r name category description popularity package_name || [ -n "$name" ]; do
        # Skip comments and empty lines
        [[ "$name" =~ ^#.*$ ]] && continue
        [[ -z "$name" ]] && continue
        
        name=$(echo "$name" | xargs)  # trim whitespace
        category=$(echo "$category" | xargs)
        description=$(echo "$description" | xargs)
        popularity=$(echo "$popularity" | xargs)
        
        printf "  ${CYAN}%2d)${NC} %-20s ${STONKS_GREEN}%-12s${NC} %s\n" "$app_num" "$name" "[$category]" "$description"
        app_names[$app_num]="$name"
        ((app_num++))
    done < <(tail -n +2 "$STONKS_CONFIG")
    
    echo ""
    echo -e "  ${CYAN}0)${NC}  ${WHITE}Exit Stonks Market${NC}"
    echo ""
    
    read -p "Select app to install (0-$((app_num-1))): " selection
    
    if [[ $selection == "0" ]]; then
        stonks_say "Thanks for checking out the STONKS market! Your portfolio thanks you!"
        exit 0
    elif [[ $selection -ge 1 && $selection -lt $app_num ]]; then
        install_app "${app_names[$selection]}"
    else
        stonks_alert "That's not a valid stock ticker, chief! Try again!"
        show_apps_menu
    fi
}

install_app() {
    local app_name="$1"
    
    echo ""
    stonks_bull "ANALYZING APP: $app_name..."
    sleep 1
    
    # Get app details from config
    local app_info=$(grep "^$app_name|" "$STONKS_CONFIG" | head -1)
    
    if [ -z "$app_info" ]; then
        stonks_alert "App not found in market!"
        show_apps_menu
        return
    fi
    
    IFS='|' read -r name category description popularity package_name <<< "$app_info"
    
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  APP DETAILS${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${WHITE}App Name:${NC}        $name"
    echo -e "${WHITE}Category:${NC}        $category"
    echo -e "${WHITE}Description:${NC}     $description"
    echo -e "${WHITE}Market Cap:${NC}      ${popularity}% 📈"
    echo -e "${WHITE}Package:${NC}         $package_name"
    echo ""
    
    read -p "Install $name? (y/n) " confirm
    
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo ""
        stonks_say "🚀 INITIATING APP INSTALLATION SEQUENCE... 🚀"
        echo ""
        
        # Simulate installation
        for i in {1..5}; do
            echo -ne "${STONKS_GREEN}▓${NC}"
            sleep 0.3
        done
        echo ""
        echo ""
        
        stonks_bull "💰 INSTALLATION SUCCESSFUL! 💰"
        stonks_bull "$name is now part of your WINNING PORTFOLIO!"
        echo ""
        stonks_say "Your apps are 📈 MOONING 📈 right now!"
        echo ""
        
        show_stonks_ticker
        
        read -p "Install another app? (y/n) " another
        if [[ $another == "y" || $another == "Y" ]]; then
            show_apps_menu
        else
            stonks_say "Thanks for trading at STONKS! Your portfolio is LEGENDARY!"
            exit 0
        fi
    else
        stonks_say "Skipping $name. More opportunities will come!"
        sleep 1
        show_apps_menu
    fi
}

# Main
show_apps_menu
