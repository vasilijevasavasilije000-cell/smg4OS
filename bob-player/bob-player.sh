#!/bin/bash
set -e

# Bob Player - The Legendary Media Player
# All of Bob's raps from SuperMarioGlitchy4
# "MAMA LUIGI!" - Bob

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRACKS_FILE="$SCRIPT_DIR/tracks.conf"
NOW_PLAYING_FILE="$SCRIPT_DIR/.now_playing"
PLAYLIST_FILE="$SCRIPT_DIR/.bob_playlist"
HISTORY_FILE="$SCRIPT_DIR/.bob_history"

# Source colors from setup wizard
if [ -f "$SCRIPT_DIR/../setup-wizard/scripts/colors.sh" ]; then
    source "$SCRIPT_DIR/../setup-wizard/scripts/colors.sh"
fi

# Default colors if not sourced
GOLD="${GOLD:-\\033[38;5;220m}"
RED="${RED:-\\033[0;31m}"
GREEN="${GREEN:-\\033[0;32m}"
BLUE="${BLUE:-\\033[0;34m}"
CYAN="${CYAN:-\\033[0;36m}"
YELLOW="${YELLOW:-\\033[0;33m}"
MAGENTA="${MAGENTA:-\\033[0;35m}"
WHITE="${WHITE:-\\033[0;37m}"
NC="${NC:-\\033[0m}"

# Bob Player specific colors
BOB_RED="\\033[38;5;160m"    # Dark red for Bob's chaotic nature
BOB_GOLD="\\033[38;5;208m"   # Orange/gold for legendary vibes
BOB_BLUE="\\033[38;5;033m"   # Royal blue for keyboard mastery

# Initialize files if they don't exist
initialize_files() {
    touch "$NOW_PLAYING_FILE" 2>/dev/null || true
    touch "$PLAYLIST_FILE" 2>/dev/null || true
    touch "$HISTORY_FILE" 2>/dev/null || true
}

# Bob personality functions
bob_intro() {
    clear
    cat << 'EOF'

  ╔══════════════════════════════════════════════════════════════════════════╗
  ║                                                                          ║
  ║            🎵 BOB PLAYER - THE LEGENDARY MUSIC EXPERIENCE 🎵             ║
  ║                                                                          ║
  ║                    "MAMA LUIGI!!!" - Bob The Keyboard Warrior            ║
  ║                                                                          ║
  ║                  Where Bob's Raps Go To Be LEGENDARY! 🔥                 ║
  ║                                                                          ║
  ╚══════════════════════════════════════════════════════════════════════════╝

EOF
    sleep 2
}

bob_say() {
    printf "${BOB_RED}[BOB PLAYER]${NC} $1\n"
}

bob_playing() {
    printf "${GREEN}[NOW PLAYING]${NC} ✨ $1\n"
}

bob_error() {
    printf "${RED}[KEYBOARD SMASH]${NC} ❌ $1\n"
}

bob_loading() {
    printf "${BOB_GOLD}[LOADING...]${NC} ⏳ $1\n"
}

bob_legendary() {
    printf "${BOB_GOLD}[LEGENDARY]${NC} 🔥 $1\n"
}

# Initialize the player
initialize_files

# Show intro on first run
show_main_menu() {
    clear
    bob_intro
    
    while true; do
        cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  BOB PLAYER - MAIN MENU
════════════════════════════════════════════════════════════════════════════

  1) 🎵 Browse & Play Songs         (All of Bob's legendary raps)
  2) 🔍 Search Songs                (Find your favorite Bob track)
  3) ▶️  Now Playing                 (Currently playing track)
  4) 📝 Create Playlist              (Build your Bob collection)
  5) 🔀 Shuffle & Play               (Random Bob experience)
  6) 📜 View History                 (Tracks you've already heard)
  7) 🎚️  Player Controls             (Volume, repeat, etc.)
  8) 💡 Bob's Rap Tips               (How to enjoy Bob properly)
  9) ⚙️  Settings                    (Player preferences)
  0) 🚪 Exit Bob Player             (Back to reality)

════════════════════════════════════════════════════════════════════════════

EOF
    
        read -p "Choose an option [0-9]: " choice
        
        case $choice in
            1) browse_and_play ;;
            2) search_songs ;;
            3) show_now_playing ;;
            4) create_playlist ;;
            5) shuffle_play ;;
            6) view_history ;;
            7) player_controls ;;
            8) bob_tips ;;
            9) settings ;;
            0) 
                bob_say "Thanks for listening to Bob! Your chaotic energy will be legendary!"
                echo ""
                exit 0
                ;;
            *)
                bob_error "Invalid option! Even Bob's keyboard has better input!"
                sleep 1
                ;;
        esac
    done
}

browse_and_play() {
    clear
    bob_loading "Loading your legendary Bob collection..."
    sleep 1
    
    echo ""
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  BOB'S LEGENDARY RAP COLLECTION
════════════════════════════════════════════════════════════════════════════

EOF
    
    # Read and display tracks
    local count=0
    local -a track_array
    
    while IFS='|' read -r title artist duration album year bpm || [ -n "$title" ]; do
        [[ "$title" =~ ^#.*$ ]] && continue
        [[ -z "$title" ]] && continue
        
        title=$(echo "$title" | xargs)
        artist=$(echo "$artist" | xargs)
        duration=$(echo "$duration" | xargs)
        album=$(echo "$album" | xargs)
        
        ((count++))
        track_array+=("$title|$artist|$duration|$album")
        
        printf "  %2d) ${CYAN}%-40s${NC} [%-15s] ${GOLD}%s${NC}\n" \
            "$count" "$title" "$duration" "$artist"
    done < <(tail -n +2 "$TRACKS_FILE")
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Select a track to play (0-$count): " track_choice
    
    if [[ "$track_choice" -ge 1 && "$track_choice" -le $count ]]; then
        local selected="${track_array[$((track_choice-1))]}"
        play_track "$selected"
    else
        bob_error "That's not even a real track number!"
        sleep 2
    fi
}

play_track() {
    local track_info="$1"
    local title=$(echo "$track_info" | cut -d'|' -f1)
    local artist=$(echo "$track_info" | cut -d'|' -f2)
    local duration=$(echo "$track_info" | cut -d'|' -f3)
    
    clear
    cat << EOF
════════════════════════════════════════════════════════════════════════════
  🎵 NOW PLAYING
════════════════════════════════════════════════════════════════════════════

EOF
    
    bob_playing "$title"
    printf "\n  Artist: ${BOB_RED}$artist${NC}\n"
    printf "  Duration: ${BOB_GOLD}$duration${NC}\n\n"
    
    # Save to now playing
    echo "$title|$artist|$duration|$(date '+%Y-%m-%d %H:%M:%S')" > "$NOW_PLAYING_FILE"
    
    # Add to history
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $title" >> "$HISTORY_FILE"
    
    # Simulate playback with loading animation
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════

  ●●● Bob's legendary vibes loading...

EOF
    
    for i in {1..3}; do
        printf "  ${BOB_GOLD}●${NC}"
        sleep 0.5
    done
    
    echo ""
    echo ""
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  PLAYING TRACK
════════════════════════════════════════════════════════════════════════════

  [|||||||||||||||||||||||||||] 100%
  
  Controls:
    P) Pause           S) Skip to next      R) Repeat track
    Q) Queue          V) Volume            L) Show lyrics
    0) Back to menu

════════════════════════════════════════════════════════════════════════════

EOF
    
    read -p "Control: " control
    
    case $control in
        P|p)
            bob_say "Paused Bob's legendary rap! Press play when you're ready for chaos!"
            sleep 2
            ;;
        S|s)
            bob_say "Skipping to the next track! Bob doesn't do boring!"
            sleep 1
            ;;
        R|r)
            bob_say "REPEATING! Bob's got INFINITE LEGENDARY POWER!"
            sleep 2
            ;;
        L|l)
            show_lyrics "$title"
            ;;
        Q|q)
            bob_say "Added to queue! Your playlist is getting LEGENDARY!"
            echo "$title" >> "$PLAYLIST_FILE"
            sleep 1
            ;;
        V|v)
            read -p "Volume (0-100): " volume
            bob_say "Volume set to $volume%! Chaos level: MAXIMUM!"
            sleep 1
            ;;
        0)
            return
            ;;
        *)
            bob_error "Invalid control! Even Bob knows how to use a keyboard!"
            sleep 1
            ;;
    esac
}

show_lyrics() {
    local title="$1"
    clear
    cat << EOF
════════════════════════════════════════════════════════════════════════════
  📝 LYRICS: $title
════════════════════════════════════════════════════════════════════════════

EOF
    
    case "$title" in
        "MAMA LUIGI REMIX")
            cat << 'EOF'
🎤 MAMA LUIGI! MAMA LUIGI! 🎤
It's me, Mario!
She calls me on my D-PHONE, She's asking why I never call her
And I said "MAMA MIAAA!"

Yo, Bob in the place to be!
With my LEGENDARY keyboard fury!
Why you always gotta test me?
Just eat the spaghetti already!

MAMA LUIGI, MAMA LUIGI!
Why you so crazy?
MAMA LUIGI, can't you see?
You're driving me crazy!

Bob's dropping knowledge on these fools
They don't know Bob went to schools!
Keyboard smashing is my fuel!
Chaos is my golden rule!

MAMA LUIGI! 🎤
EOF
            ;;
        "It's Me, Bob!")
            cat << 'EOF'
🎤 It's Me, Bob! 🎤

Yo, it's me, Bob,
The one and only, the chosen,
My keyboard is frozen,
But my raps are golden!

Jumping through your speakers,
Creating total chaos,
Making all the freakers,
Bob's the one who'll slay us!

I'm legendary, visionary,
Everything I do is necessary,
My raps are extraordinary,
Bob's vocabulary is legendary!

It's me, BOB!
The rap god of SMG4!
Open up the castle door,
I'm bringing legendary folklore!
EOF
            ;;
        *)
            cat << EOF
🎤 $title - Bob's Legendary Lyrics 🎤

Yo, it's Bob on the mic,
With my keyboard fight!
Every track is dynamite,
Chaotic energy burning bright!

Bob's the legend, Bob's the king,
Listen to the bells ring!
Every single rap I sing,
Makes the whole world swing!

Chaos, keyboard, legendary might,
Bob's raps burning through the night,
Golden flows, infinite height,
This is Bob's ultimate right!

MAMA LUIGI!
EOF
            ;;
    esac
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Press Enter to continue..."
}

search_songs() {
    clear
    echo ""
    read -p "$(printf "${CYAN}Search for Bob's tracks:${NC} ")" search_term
    
    echo ""
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  SEARCH RESULTS
════════════════════════════════════════════════════════════════════════════

EOF
    
    local found=0
    local count=0
    local -a track_array
    
    while IFS='|' read -r title artist duration album year bpm || [ -n "$title" ]; do
        [[ "$title" =~ ^#.*$ ]] && continue
        [[ -z "$title" ]] && continue
        
        if [[ "${title,,}" =~ ${search_term,,} ]]; then
            found=1
            ((count++))
            track_array+=("$title|$artist|$duration|$album")
            
            title=$(echo "$title" | xargs)
            artist=$(echo "$artist" | xargs)
            duration=$(echo "$duration" | xargs)
            
            printf "  %2d) ${CYAN}%-40s${NC} [%-10s]\n" "$count" "$title" "$duration"
        fi
    done < <(tail -n +2 "$TRACKS_FILE")
    
    if [[ $found -eq 0 ]]; then
        bob_error "No tracks found! Even Bob's search can fail!"
        sleep 2
        return
    fi
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Play track (0-$count): " choice
    
    if [[ "$choice" -ge 1 && "$choice" -le $count ]]; then
        play_track "${track_array[$((choice-1))]}"
    fi
}

show_now_playing() {
    clear
    echo ""
    
    if [ -f "$NOW_PLAYING_FILE" ] && [ -s "$NOW_PLAYING_FILE" ]; then
        cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  NOW PLAYING
════════════════════════════════════════════════════════════════════════════

EOF
        
        while IFS='|' read -r title artist duration timestamp || [ -n "$title" ]; do
            bob_playing "$title"
            printf "\n  Artist: ${BOB_RED}$artist${NC}\n"
            printf "  Duration: ${BOB_GOLD}$duration${NC}\n"
            printf "  Started: ${BLUE}$timestamp${NC}\n\n"
        done < "$NOW_PLAYING_FILE"
        
        cat << 'EOF'
════════════════════════════════════════════════════════════════════════════

  Status: ▶️  PLAYING

  [|||||||||||||||||||||||||||] 45% (1:40 / 3:45)

════════════════════════════════════════════════════════════════════════════
EOF
    else
        bob_say "Nothing is playing! Start with option 1 to hear Bob's legendary raps!"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

create_playlist() {
    clear
    echo ""
    read -p "$(printf '${CYAN}Playlist name:${NC} ')" playlist_name
    
    if [ -z "$playlist_name" ]; then
        bob_error "You need a name for your legendary playlist!"
        sleep 2
        return
    fi
    
    local playlist_db="$SCRIPT_DIR/.playlist_$playlist_name"
    > "$playlist_db"
    
    bob_say "Creating playlist: $playlist_name"
    
    echo ""
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  BOB'S LEGENDARY RAP COLLECTION (Select tracks for your playlist)
════════════════════════════════════════════════════════════════════════════

EOF
    
    local count=0
    local -a track_array
    
    while IFS='|' read -r title artist duration album year bpm || [ -n "$title" ]; do
        [[ "$title" =~ ^#.*$ ]] && continue
        [[ -z "$title" ]] && continue
        
        ((count++))
        track_array+=("$title|$artist|$duration|$album")
        
        title=$(echo "$title" | xargs)
        printf "  %2d) ${CYAN}%-40s${NC}\n" "$count" "$title"
    done < <(tail -n +2 "$TRACKS_FILE")
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Add tracks (comma-separated numbers, e.g., 1,3,5): " selections
    
    local track_count=0
    IFS=',' read -ra TRACKS <<< "$selections"
    
    for track_num in "${TRACKS[@]}"; do
        track_num=$(echo "$track_num" | xargs)
        if [[ "$track_num" -ge 1 && "$track_num" -le $count ]]; then
            echo "${track_array[$((track_num-1))]}" >> "$playlist_db"
            ((track_count++))
        fi
    done
    
    bob_legendary "Added $track_count tracks to '$playlist_name'! Your playlist is LEGENDARY!"
    sleep 2
}

shuffle_play() {
    clear
    bob_loading "Shuffling Bob's LEGENDARY collection..."
    sleep 1
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════════"
    echo ""
    
    # Get random track
    local line_count=$(grep -v "^#" "$TRACKS_FILE" | grep -c ".")
    local random_line=$((RANDOM % line_count + 2))
    
    local track_info=$(sed -n "${random_line}p" "$TRACKS_FILE")
    
    bob_legendary "Bob's CHAOS MODE ACTIVATED!"
    echo ""
    sleep 1
    
    play_track "$track_info"
}

view_history() {
    clear
    echo ""
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  YOUR BOB LISTENING HISTORY
════════════════════════════════════════════════════════════════════════════

EOF
    
    if [ -f "$HISTORY_FILE" ] && [ -s "$HISTORY_FILE" ]; then
        tail -n 20 "$HISTORY_FILE" | nl -w 2 -s ') '
    else
        bob_say "You haven't listened to any Bob tracks yet! Start playing!"
    fi
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Press Enter to continue..."
}

player_controls() {
    clear
    echo ""
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  PLAYER CONTROLS
════════════════════════════════════════════════════════════════════════════

  1) 🔊 Volume Control        (Adjust Bob's chaos level)
  2) 🔁 Repeat Mode            (Loop Bob's legendary raps)
  3) ⏭️  Skip Behavior          (Forward through Bob's tracks)
  4) 🎚️  Equalizer             (Enhance Bob's sound)
  5) 🔐 Audio Quality          (Crystal clear Bob)
  0) Back to menu

════════════════════════════════════════════════════════════════════════════

EOF
    
    read -p "Select control [0-5]: " control_choice
    
    case $control_choice in
        1)
            read -p "Set volume (0-100): " vol
            bob_say "Volume set to $vol%! Bob's chaotic energy is at level $vol!"
            sleep 2
            ;;
        2)
            read -p "Repeat mode (off/one/all): " repeat_mode
            bob_say "Repeat set to: $repeat_mode. Bob's LEGENDARY tracks will keep playing!"
            sleep 2
            ;;
        3)
            bob_say "Skip forward by 10 seconds! Bob doesn't have time for boring parts!"
            sleep 2
            ;;
        4)
            bob_say "Equalizer adjusted for maximum chaos! Bob's sound is CRYSTAL CLEAR!"
            sleep 2
            ;;
        5)
            bob_say "Audio quality set to LEGENDARY! Every note of Bob is pristine!"
            sleep 2
            ;;
        0)
            return
            ;;
        *)
            bob_error "Invalid control!"
            sleep 1
            ;;
    esac
}

bob_tips() {
    clear
    echo ""
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  💡 BOB'S RAP TIPS - HOW TO ENJOY LEGENDARY MUSIC
════════════════════════════════════════════════════════════════════════════

  💡 Always start with "MAMA LUIGI REMIX"
     Classic Bob energy that sets the chaotic tone!

  💡 Bob's best raps are in the 3:45 - 4:30 range
     Perfect length for maximum legendary impact!

  💡 Listen to the entire "Bob The Legendary" album first
     Builds your appreciation for Bob's journey!

  💡 Create multiple playlists for different moods
     Chaos mode, chill mode, rage mode - Bob has it all!

  💡 Don't skip "Bob's Battle Rap" - it's a CLASSIC!
     Pure keyboard warrior energy!

  💡 "Chaos Incarnate Flow" hits different at high volume
     Really captures Bob's untamed spirit!

  💡 The "Spooky Scary Raps" album is pure chaotic gold
     Perfect for those legendary late-night vibes!

  💡 Bob's skits are as good as his raps
     Don't skip "Bob's Infinite Wisdom"!

  💡 Shuffle mode is DANGEROUS - you might hear a banger!
     Bob's randomness = pure legendary content!

  💡 Share Bob's raps with your friends
     Spread the chaotic, legendary energy!

════════════════════════════════════════════════════════════════════════════

EOF
    read -p "Press Enter to continue..."
}

settings() {
    clear
    echo ""
    cat << 'EOF'
════════════════════════════════════════════════════════════════════════════
  ⚙️  BOB PLAYER SETTINGS
════════════════════════════════════════════════════════════════════════════

  1) 🎨 Theme                  (Currently: Bob Chaos Dark)
  2) 🔔 Notifications          (Currently: Enabled)
  3) 💾 Auto-Save History      (Currently: Enabled)
  4) 🎯 Default Volume         (Currently: 85%)
  5) 🎵 Audio Format           (Currently: MP3 320kbps)
  6) ℹ️  About Bob Player      (Version info)
  0) Back to menu

════════════════════════════════════════════════════════════════════════════

EOF
    
    read -p "Select setting [0-6]: " setting_choice
    
    case $setting_choice in
        1)
            bob_say "Theme is already LEGENDARY! Bob doesn't need other themes!"
            sleep 2
            ;;
        2)
            bob_say "Notifications enabled! Bob will alert you to LEGENDARY moments!"
            sleep 2
            ;;
        3)
            bob_say "Auto-save history is ON! Your Bob journey is being recorded!"
            sleep 2
            ;;
        4)
            read -p "Set default volume (0-100): " default_vol
            bob_say "Default volume set to $default_vol%!"
            sleep 2
            ;;
        5)
            bob_say "Audio quality is PRISTINE! Crystal clear Bob chaos!"
            sleep 2
            ;;
        6)
            cat << 'EOF'

════════════════════════════════════════════════════════════════════════════
  BOB PLAYER v1.0 - LEGENDARY EDITION
════════════════════════════════════════════════════════════════════════════

  Creator: smg4OS Development
  Powered by: Bob's INFINITE CHAOTIC ENERGY
  Theme: SuperMarioGlitchy4
  
  Bob Player is dedicated to bringing you the most legendary,
  chaotic, and absolutely INSANE music experience possible!
  
  All of Bob's raps in one place!
  "Where Bob's Music Goes To Be LEGENDARY!"

  Features:
  ✨ 25+ Bob tracks and raps
  ✨ Full playlist management
  ✨ Browse, search, and shuffle
  ✨ Playback history
  ✨ Bob's legendary personality
  ✨ Complete audio controls
  
  Special thanks to Bob for the absolute CHAOS!

════════════════════════════════════════════════════════════════════════════

EOF
            read -p "Press Enter to continue..."
            ;;
        0)
            return
            ;;
        *)
            bob_error "Invalid setting!"
            sleep 1
            ;;
    esac
}

# Start the player
show_main_menu
