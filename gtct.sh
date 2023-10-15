#!/bin/sh

# Ending Variables
badactions=0 # 0 good ending, 4 or less ok ending, 5 or more bad ending, 10 evil ending 
goodactions=0 # if 0 bad actions and 5 good actions hero ending

gavemoneytohomelessguy=false
talkedtohomelessguy=false
homelessguysprite="E"

# Set colors
export GUM_CHOOSE_CURSOR_FOREGROUND="#2635ff"
export GUM_CHOOSE_SELECTED_FOREGROUND="#2635ff"
export GUM_INPUT_CURSOR_FOREGROUND="#2635ff"
export GUM_CONFIRM_SELECTED_BACKGROUND="#2635ff"
export GUM_SPIN_SPINNER_FOREGROUND="#2635ff"

# Area Variables
sawtown=false
knowstobreakintotown=false
talkedtoguard=false
didbreakintotown=false
fixedtreehouse=false
canexamineshackmore=false
cesmsymbol=" "

# Inventory Variables
currency=20
canofbeans=false # I don't know why, but the can of beans will be the running joke of these games
portableladder=false
gotportladder=false # "got" represents if the item was picked up by the player so you can't pick it up again
gotcanofbeans=false

# The Inventory System (I wish I didn't have to use fake spaces for the inventory items)
viewinv() {
    area=$1
    gumoptions=""

    clear
    if [ $currency -gt 0 ]; then
        gumoptions="\$$currency"
    fi
    if [ "$canofbeans" = true ]; then
        gumoptions="$gumoptions Can⠀of⠀Beans"
    fi
    if [ "$portableladder" = true ]; then
        gumoptions="$gumoptions Portable⠀Ladder"
    fi
    
    echo "What would you like to use?"
    echo ""
    input=$(gum choose $gumoptions)
    
    case $input in
        "\$$currency")
            if [ "$area" = 4 ]; then
                if [ "$talkedtohomelessguy" = true ]; then
                    if [ "$gavemoneytohomelessguy" = false ]; then
                        gum confirm "Are you sure you want to give \$10 to the Old Man?"
                        
                        if [ "$?" = 1 ]; then
                            echo "Keegan: I guess charity might not be a good idea right now."
                        else
                            currency=$(( currency - 10 ))
                            goodactions=$(( goodactions + 1 ))
                            gavemoneytohomelessguy=true
                            echo "Keegan: Here you go."
                            pause
                            echo "Old Man: Wow! Thank you so much! I'm going to get some food later."
                        fi
                    else
                        echo "Keegan: I don't need to use this yet."
                    fi
                else
                    echo "Keegan: I don't need to use this yet."
                fi
            else
                echo "Keegan: I don't need to use this yet."
            fi
            ;;
        "Can⠀of⠀Beans")
            if [ "$area" = 43429324934894328934898934289324923 ]; then
                echo "gjreoijgriokjgri"
            else
                echo "Keegan: I don't need to use this yet."
            fi
            ;;
        "Portable⠀Ladder")
            if [ "$area" = 5 ]; then
                if [ "$portableladder" = true ]; then
                    portableladder=false
                    fixedtreehouse=true
                    echo "(Keegan places the ladder near the tree.)"
                    pause
                    echo "Keegan: Perfect."
                else
                    echo "Keegan: I don't need to use this yet."
                fi
            else
                echo "Keegan: I don't need to use this yet."
            fi
            ;;
        *)
            echo "Keegan: I don't need to use this yet."
            ;;
    esac

    pause
}

# Pauses the Game
pause() {
    echo ""
    echo "Press any key to continue..."
    ./pausefunction
}

# 7
town1() {
    while :
    do
        clear
        echo "~~|   |~~"
        echo "~~| ^ |~~"
        echo "|--   --|"
        echo "|       -------"
        echo "|   K    >     "
        echo "|       -------"
        echo "|   v   |"
        echo "#########"
        echo ""

        input=$(gum choose "Move Up" "Move Down" "Move Right" "Examine Area" "Inventory")
    
        case $input in
            "Move Up")
                break
                ;;
            "Move Right")
                echo "Keegan: There's no point in looking for a needle in that stack of hay."
                pause
                ;;
            "Move Down")
                echo "Keegan: If I move through there, the guard will get me. It doesn't seem like he wants to turn towards the enterance, so I'll be fine here."
                pause
                ;;
            "Examine Area")
                echo "Keegan: Well, it's a split path."
                pause
                ;;
            "Inventory")
                viewinv 7
                ;;
        esac
        done
}

# Town Cutscene
jumpingintotowncutscene() {
    clear
    echo "*Keegan leaped into the air, over the wall, into a stack of hay.*"
    pause
    echo "*Keegan walks to the left, and finds a bridge leading into the town.*"
    pause
    echo "Keegan: Well, that was a somewhat easy way in. Now it's time to find Kameron."
    pause
    town1
}

# 6
insidetreehouse() {
    while :
    do
    clear
    echo
    echo "[]   :::::::"
    echo "[]  :::::::::"
    echo "[]  [K][=]"
    echo "[]     [v]  "
    echo "[]-------------"
    echo "  G            "
    echo "[]-------------"
    echo "[]             "
    echo ""

    input=$(gum choose "Jump into Town" "Exit Tree House")

    case $input in
        "Jump into Town")
            break
            ;;
        "Exit Tree House")
            break
            ;;
    esac
    done

    case $input in
        "Exit Tree House")
            p1left
            ;;
        "Jump into Town")
            jumpingintotowncutscene
            ;;
    esac
}

# 5
p1left() {
    while :
    do
    clear

    if [ "$sawtown" = false ]; then
        sawtown=true
        echo "Keegan: Huh, there is a town here. Maybe the guards will let me enter."
        pause
    fi

    clear
    echo
    echo "[]   :::::::"
    echo "[]  :::::::::"
    echo "[]  [ ][=]"
    echo "[]     [E]  "
    echo "[]-------------"
    echo "  G     K     >"
    echo "[]-------------"
    echo "[]             "
    echo ""

    input=$(gum choose "Enter Town" "Move Right" "Talk to Guard" "Examine Tree" "Inventory")

    case $input in
        "Enter Town")
            if [ "$didbreakintotown" = true ]; then
                echo "Keegan: Best not to talk to him or else he might imprison me."
                pause
            else
                echo "Keegan: I would but there is a guard in the way."
                pause
            fi

            ;;
        "Talk to Guard")
            if [ "$didbreakintotown" = true ]; then
                echo "Keegan: Nope, that's not a good idea."
            elif [ "$talkedtoguard" = false ]; then
                talkedtoguard=true
                echo "Keegan: Hello, sir. May I please enter?"
                pause
                echo "Guard: Sorry, no one is allowed in. King's orders."
                pause
                echo "Keegan: Well, have you seen my brother? He's about this high and...(explains Kameron's looks)"
                pause
                echo "Guard: Um, well he entered the town even though I said he can't, so he's in captivity."
                pause
                echo "Keegan: ...oh."
                pause
                echo "Guard: You're probably like that troublemaker, so shoo!"
                pause
                echo "Keegan: Ok! Jeez."
            else
                echo "Keegan: He doesn't want me to go into town. Maybe there is another way in."
            fi

            pause
            ;;
        "Examine Tree")
            if [ "$fixedtreehouse" = false ]; then
                echo "Keegan: It looks like it leads to a tree house. The ladder is broken though."
                pause
            else
                echo "Keegan: Looks like I can enter the tree house."
                if gum confirm "Would you like to enter the tree house?" ; then
                    input="movetree"
                    break
                fi
            fi
            ;;
        "Move Right")
            break
            ;;
        "Inventory")
            viewinv 5
            ;;
    esac
    done

    case $input in
        "Move Right")
            introm3
            ;;
        "movetree")
            insidetreehouse
            ;;
    esac
}

# 4
p1right() {
    while :
    do
    clear
    echo "              -------"
    echo "------------- [     ]"
    echo "<     K     $cesmsymbol [  $homelessguysprite  ] Shack"
    echo "------------- [     ]"
    echo "              -------"
    echo ""
    case $talkedtohomelessguy in
        false)
            input=$(gum choose "Move Left" "Examine Shack" "Inventory") 
            ;;
        true)
            input=$(gum choose "Move Left" "Examine Shack" "Talk to Homeless Man" "Inventory") 
            ;;
    esac
    
    case $input in
        "Move Left")
            break
            ;;
        "Examine Shack")
            if [ "$talkedtohomelessguy" = false ]; then
            talkedtohomelessguy=true
            canexamineshackmore=true
            cesmsymbol="E"
            homelessguysprite="T"
            echo "(Keegan examines into the shack, and sees an old man inside.)"
            pause
            echo "Keegan: Hello?"
            pause
            echo "Old Man: Wah?! Who's there?!"
            pause
            echo "Keegan: Uh, hi."
            pause
            echo "Old Man: What do you want? I got no money!"
            pause
            echo "Keegan: I don't want your money, I was just seeing what was going on."
            pause
            echo "Old Man: Well, it would really help if you could give me some money. Like, \$10. I'm really poor after 5 robbers robbed my little house here."
            pause
            echo "Keegan: Let me think about it."
            pause
            elif [ "$canexamineshackmore" = true ]; then
            if [ "$gotportladder" = false ]; then
            canexamineshackmore=false
            cesmsymbol=" "
            portableladder=true
            gotportladder=true
            echo "Keegan: Looks like there is a portable ladder on the side of this shack. I will take that."
            echo ""
            echo "*You got a Portable Ladder!*"
            pause
            fi
            else
            echo "Keegan: There is nothing else to look at here."
            fi
            ;;
        "Talk to Homeless Man")
            if [ "$gavemoneytohomelessguy" = true ]; then
                echo "Old Man: You can go on your way now."
            else
                getrandom=$(./randomoldman)
                echo ""

                if [ "$getrandom" = 1 ]; then
                    echo "Old Man: Ugh, I could really use some food..."
                elif [ "$getrandom" = 2 ]; then
                    echo "Old Man: Please, sir! I really need some money."
                elif [ "$getrandom" = 3 ]; then
                    echo "Old Man: I think I'm going to die..."
                elif [ "$getrandom" = 4 ]; then
                    echo "Old Man: ..."
                else
                    echo "Old Man: My stomach hurts so much! Agh!"
                fi
            fi

            pause
            ;;
        "Inventory")
            viewinv 4
            ;;
    esac

    done
    
    introm3
}

# 3
introm3() {
    while :
    do
    clear
    echo "-------------"
    echo "<     K     >"
    echo "---       ---"
    echo "  [       ]"
    echo "  [       ]"
    echo "  [       ]"
    echo "  [   v   ]"
    echo ""
    input=$(gum choose "Move Left" "Move Right" "Move Down" "Examine Area" "Inventory")
    
    case $input in
        "Move Left")
            break
            ;;
        "Move Right")
            break
            ;;
        "Move Down")
            break
            ;;
        "Examine Area")
            echo "Keegan: Well, it's a split path."
            pause
            ;;
        "Inventory")
            viewinv 3
            ;;
    esac
    done
    
    case $input in
        "Move Left")
            p1left
            ;;
        "Move Right")
            p1right
            ;;
    esac
}

# 2
introm2() {
    while :
    do
    clear
    echo "[   ^   ]"
    echo "[       ]"
    echo "[    _  ]"
    echo "[   / \ ] Camp"
    echo "[  /   \] Site"
    echo "[   K   ]"
    echo "[       ]"
    echo "[   v   ]"
    echo ""
    input=$(gum choose "Move Up" "Move Down" "Examine Area" "Inventory")
    
    case $input in
        "Move Up")
            break
            ;;
        "Move Down")
            break
            ;;
        "Examine Area")
            case $gotcanofbeans in
                true)
                    echo "Keegan: Nothing else here to find."
                    ;;
                false)
                    echo "Keegan: This camp site has been abandoned, but all there is left is a dented can of beans."
                    echo ""
                    echo "*You got a can of beans!*"
                    gotcanofbeans=true
                    canofbeans=true
                    ;;
            esac
            pause
            ;;
        "Inventory")
            viewinv 2
            ;;
    esac
    done
    
    case $input in
        "Move Up")
            introm3
            ;;
        "Move Down")
            introm1
            ;;
    esac
}

# 1
introm1() {
    while :
    do
    clear
    echo "[  ^  ]"
    echo "[     ]"
    echo "[     ]"
    echo "[  K  ]"
    echo "-------"
    echo ""
    input=$(gum choose "Move Up" "Examine Area" "Inventory")
    
    case $input in
        "Move Up")
            break
            ;;
        "Examine Area")
            echo "Keegan: There is nothing to look at here."
            pause
            ;;
        "Inventory")
            viewinv 1
            ;;
    esac
    done
    
    introm2
}

game_intro() {
    clear
    echo "One day, at Fort Bradley, Keegan and Kameron were fighting each other in a game of Super Slap Dudes."
    pause
    echo "Keegan: You are finished!"
    pause
    echo "Kameron: Nuh uh!"
    pause
    echo "(Kameron activates a button combo, and slaps Keegan out of the map)"
    pause
    echo "TV: GAME! Kameron wins!"
    pause
    echo "Keegan: FUCK!"
    pause
    echo "Kameron: Haha."
    pause
    echo "(A soldier walks in)"
    pause
    echo "Soldier: Kameron and Keegan, you are needed in the server room!"
    pause
    echo "Kameron: Ugh, alright Keeg, let's go."
    pause
    echo "Keegan: Alright."
    pause
    clear
    echo "(They go through the elevator and enter the server room)"
    pause
    echo "Kameron: What seems to be the problem?"
    pause
    echo "Engineer: The servers have been acting funky. Can you hop on the terminal over there and reboot the systems?"
    pause
    echo "Kameron: I though I told you guys how to do that."
    pause
    echo "Engineer: Well, it didn't work."
    pause
    echo "Kameron: Alright, let me handle this."
    pause
    echo "Keegan: No, I can handle it."
    pause
    echo "Kameron: Keegan, I'm the tech guy, I can do this."
    pause
    echo "No Kameron, I can do it! I know things about computers."
    pause
    echo "Kameron: NO!"
    pause
    echo "(Keegan and Kameron start fighting each other about who fixes the servers.)"
    pause
    echo "Engineer: You guys shouldn't be fighting in a room full of expensive hardware!"
    pause
    echo "(Keegan shoves Kameron into the terminal, breaking it a bit)"
    echo "(Loud noises start erupting from it)"
    pause
    echo "Kameron: Ow, shit! What did you do?!"
    pause
    echo "(The terminal starts shaking the room, then makes a portal that start vacuuming up the room)"
    pause
    echo "(Kameron gets sucked in)"
    pause
    echo "Keegan: Oh shit!"
    pause
    echo "(Keegan grabs onto a nearby pillar, struggling to keep his grip)"
    pause
    echo "Keegan: For God's sake! How do you stop it?!"
    pause
    echo "(Keegan gets sucked in)"
    pause
    echo "Keegan: Ahhhhhhh!"
    pause
    clear
    echo "Objective 1: Find Kameron"
    echo ""
    echo "(Keegan wakes up, in a weird world full of numbers, symbols, and other things.)"
    pause
    echo "Keegan: Ughhh...Where am I? Kameron? You here?"
    pause
    echo "(...no response)"
    pause
    echo "Keegan: Dammit, I gotta find him."
    pause
    clear
    gum spin -s points --title "Loading Awesomeness..." sleep 3
    introm1
}

clear
gum style --padding "1 5" --border double --border-foreground "#2635ff" "Ghost Team: Computer Trouble"

if gum confirm "Do you want to play?"; then
    game_intro
else
    echo ":("
fi
