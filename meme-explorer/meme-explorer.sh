#!/bin/bash

# 🌐 MEME EXPLORER - THE DANKEST BROWSER 🌐
# "Where the internet's memes go to be LEGENDARY!"
# Powered by SMG4 (Meme Edition)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
WIZARD_DIR="$PROJECT_ROOT/setup-wizard"
EXPLORER_CONFIG="$SCRIPT_DIR/bookmarks.conf"
HISTORY_FILE="$SCRIPT_DIR/.meme_history"

# Source colors from setup wizard
source "$WIZARD_DIR/scripts/colors.sh"

# Meme Explorer specific colors
MEME_PURPLE='\033[38;5;135m'  # Purple for meme energy
MEME_ORANGE='\033[38;5;208m'  # Orange for notification

meme_intro() {
    clear
    cat << 'EOF'

    ╔════════════════════════════════════════════════════════════════╗
    ║                                                                ║
    ║           🌐 MEME EXPLORER - THE DANKEST BROWSER 🌐          ║
    ║              "Where Memes Go To Be LEGENDARY!"                ║
    ║                                                                ║
    ║    Welcome to the internet's most meme-powered browser!       ║
    ║    Powered by pure chaotic energy and SMG4 vibes.             ║
    ║    *Dial-up modem sounds intensify*                           ║
    ║                                                                ║
    ╚════════════════════════════════════════════════════════════════╝

EOF
    sleep 2
}

meme_say() {
    local message="$1"
    echo -e "${MEME_PURPLE}[MEME EXPLORER]${NC} ${CYAN}$message${NC}"
}

meme_found() {
    local message="$1"
    echo -e "${GREEN}[DANK FIND]${NC} ✨ $message${NC}"
}

meme_error() {
    local message="$1"
    echo -e "${RED}[404 MEME NOT FOUND]${NC} ${YELLOW}$message${NC}"
}

meme_loading() {
    local message="$1"
    echo -e "${MEME_ORANGE}[LOADING...]${NC} ${MEME_ORANGE}⏳ $message${NC}"
}

show_meme_animation() {
    echo ""
    echo -e "${MEME_PURPLE}   🌐 LOADING MEME ENERGY 🌐${NC}"
    for i in {1..3}; do
        echo -ne "${MEME_ORANGE}●${NC}"
        sleep 0.2
    done
    echo ""
    echo ""
}

show_main_menu() {
    meme_intro
    
    echo ""
    meme_say "Welcome to MEME EXPLORER - The internet's most chaotic browser!"
    echo ""
    
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  MAIN MENU${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "  ${CYAN}1)${NC} ${WHITE}Browse Bookmarks${NC}     (Your favorite meme sites)"
    echo -e "  ${CYAN}2)${NC} ${WHITE}Search Memes${NC}         (Find the dankest content)"
    echo -e "  ${CYAN}3)${NC} ${WHITE}Add Bookmark${NC}         (Save a legendary site)"
    echo -e "  ${CYAN}4)${NC} ${WHITE}View History${NC}         (Your meme journey)"
    echo -e "  ${CYAN}5)${NC} ${WHITE}Random Meme Site${NC}    (Surprise me!)"
    echo -e "  ${CYAN}6)${NC} ${WHITE}Meme Tips${NC}            (Pro meme browsing advice)"
    echo -e "  ${CYAN}0)${NC} ${WHITE}Exit Browser${NC}         (Back to reality)"
    echo ""
    
    read -p "Choose an option [0-6]: " choice
    
    echo ""
    case $choice in
        1) browse_bookmarks ;;
        2) search_memes ;;
        3) add_bookmark ;;
        4) view_history ;;
        5) random_meme_site ;;
        6) show_meme_tips ;;
        0) 
            meme_say "Thanks for exploring memes with me! Stay dank!"
            exit 0
            ;;
        *) 
            meme_error "That's not a valid option, chief!"
            sleep 1
            show_main_menu
            ;;
    esac
}

browse_bookmarks() {
    if [ ! -f "$EXPLORER_CONFIG" ]; then
        meme_error "No bookmarks found! Add some first!"
        sleep 1
        show_main_menu
        return
    fi
    
    meme_say "Loading your legendary bookmarks..."
    show_meme_animation
    
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  YOUR MEME BOOKMARKS${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    local bookmark_num=1
    declare -a bookmark_urls
    
    while IFS='|' read -r name description url category || [ -n "$name" ]; do
        [[ "$name" =~ ^#.*$ ]] && continue
        [[ -z "$name" ]] && continue
        
        name=$(echo "$name" | xargs)
        description=$(echo "$description" | xargs)
        url=$(echo "$url" | xargs)
        category=$(echo "$category" | xargs)
        
        printf "  ${CYAN}%2d)${NC} %-25s ${MEME_PURPLE}%-15s${NC} %s\n" "$bookmark_num" "$name" "[$category]" "$description"
        bookmark_urls[$bookmark_num]="$url"
        ((bookmark_num++))
    done < <(tail -n +2 "$EXPLORER_CONFIG" 2>/dev/null || echo "")
    
    echo ""
    echo -e "  ${CYAN}0)${NC}  ${WHITE}Back to Menu${NC}"
    echo ""
    
    read -p "Open bookmark (0-$((bookmark_num-1))): " selection
    
    if [[ $selection == "0" ]]; then
        show_main_menu
    elif [[ $selection -ge 1 && $selection -lt $bookmark_num ]]; then
        open_url "${bookmark_urls[$selection]}"
    else
        meme_error "Invalid bookmark!"
        sleep 1
        browse_bookmarks
    fi
}

open_url() {
    local url="$1"
    
    echo ""
    meme_loading "Connecting to the meme dimension..."
    show_meme_animation
    
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  BROWSING: $url${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${CYAN}URL:${NC} $url"
    echo -e "${CYAN}Status:${NC} ${GREEN}✓ Connection successful${NC}"
    echo -e "${CYAN}Content Type:${NC} text/meme"
    echo -e "${CYAN}Meme Level:${NC} ${MEME_PURPLE}LEGENDARY${NC}"
    echo ""
    
    echo -e "${YELLOW}[Preview]${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  🎉 Welcome to the legendary meme dimension! 🎉"
    echo "  You've accessed a LEGENDARY meme site!"
    echo ""
    echo "  This is where the best memes on the internet hang out."
    echo "  Pure chaotic energy and 100% dank content guaranteed!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Save to history
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $url" >> "$HISTORY_FILE"
    
    meme_found "Page loaded successfully! You're now experiencing pure meme energy!"
    
    read -p "Press Enter to go back..."
    browse_bookmarks
}

search_memes() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  MEME SEARCH ENGINE${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -p "What memes are you looking for? " search_query
    
    meme_loading "Searching the dankest corners of the internet..."
    show_meme_animation
    
    echo -e "${GREEN}Search results for: \"$search_query\"${NC}"
    echo ""
    echo "  ${MEME_PURPLE}1)${NC} $search_query - Know Your Meme"
    echo "  ${MEME_PURPLE}2)${NC} $search_query - Reddit Thread"
    echo "  ${MEME_PURPLE}3)${NC} $search_query - Urban Dictionary"
    echo "  ${MEME_PURPLE}4)${NC} $search_query - YouTube Compilation"
    echo "  ${MEME_PURPLE}5)${NC} $search_query - Twitter Feed"
    echo ""
    
    meme_say "Found 5 legendary results!"
    
    read -p "Open result (1-5) or press Enter to go back: " result_choice
    
    if [[ $result_choice =~ ^[1-5]$ ]]; then
        case $result_choice in
            1) open_url "https://knowyourmeme.com/memes/$search_query" ;;
            2) open_url "https://reddit.com/r/memes/search?q=$search_query" ;;
            3) open_url "https://urbandictionary.com/define.php?term=$search_query" ;;
            4) open_url "https://youtube.com/results?search_query=$search_query+meme+compilation" ;;
            5) open_url "https://twitter.com/search?q=$search_query" ;;
        esac
    else
        show_main_menu
    fi
}

add_bookmark() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  ADD LEGENDARY BOOKMARK${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -p "Site name (e.g., 'Dank Memes'): " site_name
    read -p "Description: " site_desc
    read -p "URL: " site_url
    read -p "Category (e.g., 'Reddit', 'YouTube', 'Forum'): " site_cat
    
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  BOOKMARK SUMMARY${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${WHITE}Name:${NC}        $site_name"
    echo -e "${WHITE}Description:${NC} $site_desc"
    echo -e "${WHITE}URL:${NC}         $site_url"
    echo -e "${WHITE}Category:${NC}    $site_cat"
    echo ""
    
    read -p "Save this legendary bookmark? (y/n) " confirm
    
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo "$site_name | $site_desc | $site_url | $site_cat" >> "$EXPLORER_CONFIG"
        meme_found "$site_name has been added to your legendary bookmarks!"
        sleep 2
    else
        meme_say "Bookmark not saved."
        sleep 1
    fi
    
    show_main_menu
}

view_history() {
    if [ ! -f "$HISTORY_FILE" ]; then
        meme_error "Your browsing history is empty!"
        sleep 1
        show_main_menu
        return
    fi
    
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  YOUR MEME JOURNEY${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    meme_say "Your legendary meme browsing history:"
    echo ""
    tail -20 "$HISTORY_FILE" | nl
    echo ""
    
    read -p "Press Enter to go back..."
    show_main_menu
}

random_meme_site() {
    if [ ! -f "$EXPLORER_CONFIG" ]; then
        meme_error "No bookmarks to pick from! Add some first!"
        sleep 1
        show_main_menu
        return
    fi
    
    echo ""
    meme_loading "Selecting a random legendary meme site..."
    show_meme_animation
    
    local random_line=$(tail -n +2 "$EXPLORER_CONFIG" 2>/dev/null | shuf -n 1)
    
    if [ -z "$random_line" ]; then
        meme_error "No bookmarks found!"
        sleep 1
        show_main_menu
        return
    fi
    
    IFS='|' read -r name description url category <<< "$random_line"
    url=$(echo "$url" | xargs)
    
    meme_found "Surprise! Opening: $(echo "$name" | xargs)"
    echo ""
    
    open_url "$url"
}

show_meme_tips() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  PRO MEME BROWSING TIPS 🎓${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    meme_say "Here are some legendary meme browsing tips:"
    echo ""
    
    tips=(
        "💡 Always check Know Your Meme before using a meme - context is EVERYTHING"
        "💡 Save legendary memes as bookmarks so you can share them later"
        "💡 Browse Reddit's r/memes when you need fresh, dank content"
        "💡 YouTube meme compilations are 10x better than single memes"
        "💡 Twitter is where memes are BORN - get there early for top tier content"
        "💡 Urban Dictionary has the BEST meme explanations"
        "💡 Check the date - old memes can come back as 'retro' memes"
        "💡 Meme formats are like stocks - invest early for max gains"
        "💡 Crossover memes (mixing formats) get the most engagement"
        "💡 Never force a meme - it's gotta be organic and LEGENDARY"
    )
    
    for tip in "${tips[@]}"; do
        echo "  $tip"
    done
    
    echo ""
    read -p "Press Enter to go back..."
    show_main_menu
}

# Main
if [ ! -f "$EXPLORER_CONFIG" ]; then
    cat > "$EXPLORER_CONFIG" << 'DEFAULTS'
# Meme Explorer Bookmarks Configuration
# Format: Site Name | Description | URL | Category

Reddit Memes | The front page of the internet's memes | https://reddit.com/r/memes | Reddit
Know Your Meme | The meme encyclopedia | https://knowyourmeme.com | Reference
Twitter | Where memes are born | https://twitter.com/search?q=meme | Social
YouTube Memes | Video meme compilations | https://youtube.com/@memepage | Video
4chan /b/ | The birthplace of chaos | https://boards.4chan.org/b/ | Chan
TikTok Trends | Short form meme content | https://tiktok.com/@foryoupage | Video
Imgur Memes | Image meme hosting | https://imgur.com/r/memes | Images
9GAG | The classic meme site | https://9gag.com | Legacy
Tumblr Memes | Aesthetic meme reblogging | https://tumblr.com/search/meme | Social
Urban Dictionary | Meme definitions | https://urbandictionary.com | Reference
DEFAULTS
fi

show_main_menu
