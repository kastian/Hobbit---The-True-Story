#!/bin/bash

# Copyright 1993, 2001 Fredrik Ramsberg, Johan Berntsson
# Copyright 2015 Konstantin Shakhnov

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

########################################################################

# Initially original MS-DOS "Hobbit - The True Story" was shareware
# program, but for this port authors gave permissions to public it
# under GPL.

# > I asked Johan about your project, and we both agree that you
# > can make it GPL, as long as you mention us as the original
# > authors.
# >                                                Fredrik Ramsberg

########################################################################

ask() {
    if [[ "$3" == "the" ]]; then
	ask $1 $2 $4
    elif [[ "$2" == "about" ]]; then
	talkhelp $1 $3
    else
	talkhelp $1 $2
    fi
}

clue() {
    if [[ "$hbr" == "clearing" ]]; then
	echo "Trolls are not known to stand sunlight very well. It may be wise to wait a"
	echo "while before confronting them."
    else
	echo "Try examining things!"
    fi
}

cut() {
    case "$1" in
	"the" )
	    cut $2
	    ;;
	"cigar" )
	    if [[ "$hbr" != "den" ]]; then
		echo "There are no cigars around."
	    elif [[ "$hb6" != "me" ]]; then
		echo "You havn't got anything to cut with."
	    else
		echo "You run towards the mighty dragon and cut off his cigar. The dragon:"
		echo "exclaims, \"Hey, what are you doing!\". You explain that the cigar will"
		echo "be easier to smoke now, and after some experimenting, Smaug agrees with you."
		echo "He trades your sword for a treasure and offers you transport to Rivendell."
		hb7="me"
		hbr="rivendell"
		hb6="den"
		echo ""
		read -sn 1 # pause
		look
	    fi
	    ;;
	"dragon" | "gandalf" | "thorin" | "elrond" | "troll" | "trolls" )
	    kill $1
	    ;;
	* )
	    echo "You can't cut that!"
    esac
}


drop() {
    case "$1" in
	"torch" )
	    if [[ "$hb1" != "me" ]]; then
		echo "You are not holding that."
	    else
		hb1="$hbr"
		echo "You drop the $1."
	    fi
	    ;;
	"lunch" )
	    if [[ "$hb2" != "me" ]]; then
		echo "You are not holding that."
	    else
		hb2="$hbr"
		echo "You drop the $1."
	    fi
	    ;;
	"map" )
	    if [[ "$hb3" != "me" ]]; then
		echo "You are not holding that."
	    else
		hb3="$hbr"
		echo "You drop the $1."
	    fi
	    ;;
	"sword" )
	    if [[ "$hb6" != "me" ]]; then
		echo "You are not holding that."
	    else
		hb6="$hbr"
		echo "You drop the $1."
	    fi
	    ;;
	"treasure" )
	    if [[ "$hb7" != "me" ]]; then
		echo "You are not holding that."
	    else
		hb7="$hbr"
		echo "You drop the $1."
	    fi
	    ;;
	"the" )
	    drop $2
	    ;;
	* )
	    echo "You are not holding that."
    esac
}

eat() {
    case "$1" in
	"the" )
	    eat $2
	    ;;
	"lunch" )
	    if [[ "$hb2" != "me" ]]; then
		echo "But you don't have any lunch!"
	    else
		echo "You feel much refreshed."
		hb2="nil"
	    fi
	    ;;
	"" )
	    echo "What do you want to eat?"
	    ;;
	* )
	    echo "You can't eat that!"
    esac
}

enter() {
    if [[ "$1" == "the" ]]; then
	go $2
    else
	go $1
    fi
}

examine() {
    case "$1" in
	"" ) look
	     ;;
	"torch" )
	    if [[ "$hb1" != "me" && "$hb1" != "$hbr" ]]; then
		echo "It is nowhere to be seen."
	    else
		echo "It is currently providing light."
	    fi
	    ;;
	"lunch" )
	    if [[ "$hb2" != "me" && "$hb2" != "$hbr" ]]; then
		echo "It is nowhere to be seen."
	    else
		echo "It's edible."
	    fi
	    ;;
	"map" )
	    if [[ "$hb3" == "gandalf" && "$hbr" == "home" ]]; then
		echo "Gandalf has it. You should ask him about it. Maybe he doesn't need it anyway."
	    elif [[ "$hb3" != "me" && "$hb3" != "$hbr" ]]; then
		echo "It is nowhere to be seen."
	    else
		echo "The curious map must obviously have been drawn by hand, at great effort. "
		echo "It shows the mysterious surroundings of Rivendell, home of the elves."
	    fi
	    ;;
	"chest" )
	    if [[ "$hbr" != "home" ]]; then
		echo "It is nowhere to be seen."
	    else
		echo "It's a nice piece of wooden workmanship."
		if [[ "$hb1" == "chest" ]]; then
		    echo "There's a burning torch inside it. You decide to pick it up."
		    hb1="me"
		fi
	    fi
	    ;;
	"elrond" )
	    if [[ "$hbr" != "rivendell" ]]; then
		echo "Elrond isn't here!"
	    else
		echo "Elrond has turned pretty nasty lately. Better not mess with him, considering"
		echo "his plans to enslave all Hobbits. "
	    fi
	    ;;
	"gandalf" )
	    if [[ "$hbr" != "home" ]]; then
		echo "Gandalf isn't here!"
	    else
		echo "Gandalf, the old magician, is still working with his new spell."
		if [[ "$hb3" == "gandalf" ]]; then
		    echo "He is carrying a map."
		fi
	    fi
	    ;;
	"spell" )
	    if [[ "$hbr" != "home" ]]; then
		echo "It is nowhere to be seen."
	    else
		echo "It's a piece of beautiful yellowed paper, with magical symbols arranged"
		echo "in groups. Several symbols resemble Hobbits exploding."
	    fi
	    ;;
	"thorin" )
	    echo "Thorin, your old friend, is no longer the proud dwarf he once was. All the"
	    echo "drugs have turned him into a drooling good-for-nothing idiot. The only reason"
	    echo "that he has come along is to get more treasures for drugs, as always."
	    case "$hbr" in
		"home" )
		    echo "He doesn't seem too happy about leaving the house."
		    ;;
		"rivendell" )
		    echo "Thorin takes another beer from the fridge. Elrond slaps him."
		    ;;
		"den" )
		    echo "Thorin is negotiating with the dragon about taking some rare drugs home,"
		    ;;
		"den" )
		    echo "provided that Smaug gets to keep your body."
		    ;;
		"woods" )
		    echo "Thorin says \"We're lost! Abandon all hope. We'll never get out of here alive!\"."
		    ;;
		"clearing")
		    if [[ "$hbs" == "NO" ]]; then
			echo "Thorin participates in the chanting."
		    else
			echo "Thorin is talking to the trolls. He doesn't notice that they are dead. "
		    fi
		    ;;
		"cave" )
		    echo "Thorin is writing a song. I shall call it \"Let's roll another one\", he remarks."
		    ;;
		esac
	    ;;
	"naked" | "woman" )
	    if [[ "$hbr" != "foul" ]]; then
		echo" She is nowhere to be seen."
	    else
		echo "She looks cold and tired, and pretty far from sensual. As you peek at her,"
		echo "Thorin remarks that she's the only dwarf woman alive at the moment. He seems"
		echo "to find her attractive."
	    fi
	    ;;
	"smaug" | "dragon" )
	    if [[ "$hbr" != "den" ]]; then
		echo "Smaug is not around, as far as I can see."
	    else
		echo "Smaug's red dragon body is filling the eastern part of the cave. As he can't"
		echo "get out of the cave anymore, he seems to have settled with just lying here,"
		echo "eating any adventurers that drop by. Every now and then he enjoys a big"
		echo "cigar, but he obviously doesn't know quite how to do it right. The cigar in"
		echo "his mouth hasn't been cut properly. Smaug coughs, but luckily you're out of"
		echo "the deadly range."
	    fi
	    ;;
	"treasure" )
	    if [[ "$hb7" != "me" && "$hb7" != "$hbr" ]]; then
		echo "It is nowhere to be seen."
	    else
		echo "It is just the kind of treasure you'd expect to find in a dragon's den. It does"
		echo "seem mighty valuable."
	    fi
	    ;;
	"painting" | "paintings" )
	    if [[ "$hbr" != "den" ]]; then
		echo "It is nowhere to be seen."
	    else
		echo "Among the paintings you recognize works of Picasso, da Vinci and Rembrandt. "
	    fi
	    ;;
	"cigar" )
	    if [[ "$hbr" != "den" ]]; then
		echo "It is nowhere to be seen."
	    else
		echo "The cigar doesn't seem to be properly cut."
	    fi
	    ;;
	"the" )
	    examine $2
	    ;;
	*)
	    echo "There is nothing special about the $1."
    esac
}

get() {
    take $1 $2 $3
}

go() {
    case "$hbr" in
	"woods" )
	    if [[ "$1" == "raft" && "$hb5" == "woods" ]]; then
		echo "Not knowing what is about to happen, you fearlessly enter the raft. You follow"
		echo "the river downstream for a while, as you don't have any means of manouvering"
		echo "the little dingy. When hitting land, you are cold and starving. You soon find"
		echo "a trail leading to a little village. The natives feed you and treat you well,"
		echo "so you are soon healthy enough to go hunting on your own. On one of your trips"
		echo "up into the mountains, you are suddenly brought back to your original mission,"
		echo "as you step on a loose rock, which gives way. You slide down a long tunnel"
		echo "which has many bends and little light. Eventually you leave the tunnel, only"
		echo "to come into..."
		hb5="nil"
		hbr="den"
		echo ""
		read -sn 1 # pause
		look
		echo "Thorin, whom you haven't seen since you were in the forest together, enters"
		echo "from a side door, singing about peace. He greets you with a laugh."
		return
	    elif [[ "$1" == "south" ]]; then
		hbr="woods"
	    elif [[ "$1" == "west" ]]; then
		hbr="foul"
	    elif [[ "$1" == "north" ]]; then
		hbr="rivendell"
	    else
		echo "You can't go $1."
		return
	    fi
	    ;;
	"foul" )
	    if [[ "$1" != "east" ]]; then
		echo "You can't go $1."
		return
	    else
		hbr="woods"
	    fi
	    ;;
	"cave" )
	    if [[ "$1" == "south" ]]; then
		hbr="clearing"
	    else
		echo "You can't go $1."
		return
	    fi
	    ;;
	"clearing" )
	    if [[ "$1" == "east" ]]; then
		hbr="rivendell"
	    elif [[ "$1" == "north" ]]; then
		if [[ "$hbs" == "YES" ]]; then
		    hbr="cave"
		else
		    echo "The trolls won't let you."
		    return
		fi
	    elif [[ "$1" == "west" ]]; then
		hbr="home"
		if [[ "$hb7" == "me" ]]; then
		    echo "You go west."
		    look
		    echo ""
		    echo "As you enter your home again, Gandalf leaps to his feet. He comes forward, as"
		    echo "if to greet and congratulate you, but instead he asks, \"Did you bring any"
		    echo "tobacco?\". You decide to do what you should have done a long time ago. You"
		    echo "show the old wizard to the door, and kindly ask him to leave. Thorin follows"
		    echo "Gandalf out through the door."
		    echo ""
		    echo "Without any wizards or dwarves pestering you all the time, your life gets very"
		    echo "pleasant, and with the treasure it stays that way. You have won!!!"
		    echo ""
		    read -sn 1 # pause
		    exit 0
		fi
	    else
		echo "You can't go $1."
		return
	    fi
	    ;;
	"home" )
	    if [[ "$1" == "east" ]]; then
		hbr="clearing"
	    else
		echo "You can't go $1."
		return
	    fi
	    ;;
	"rivendell" )
	    if [[ "$1" == "north" ]]; then
		if [[ "$hb2" == "me" ]]; then
		    echo "Just as you leave, Elrond grabs your lunch. He looks annoyed."
		    hb2="rivendell"
		fi
		if [[ "$hb3" == "me" ]]; then
		    echo "Using the curious map that Gandalf gave you, you soon find your way to the"
		    echo "pleasant lush of the woods."
		    hbr="woods"
		else
		    echo "You stagger off into the surrounding hills, but find nothing of interest."
		    echo "Disappointed you return back to Elrond's party."
		    return
		fi
	    elif [[ "$1" == "west" ]]; then
		if [[ "$hb2" == "me" ]]; then
		    echo "Just as you leave, Elrond grabs your lunch. He looks annoyed."
		    hb2="rivendell"
		fi
		hbr="clearing"
	    else
		echo "You can't go $1."
		return
	    fi
	    ;;
	"den" )
	    echo "You can't go $1."
	    return
	    ;;
	* )
	    echo "Error: Undefined room!"
	    return
    esac

    # success
    echo "You walk $1."
    look
    case "$1" in
	"north" )
	    echo "Thorin is already here.";
	    ;;
	"south" )
	    echo "Thorin comes running after you.";
	    ;;
	"east" )
	    echo "Thorin enters from the west.";
	    ;;
	"west" )
	    echo "Thorin follows your trail.";
	    ;;
    esac
}

hint() {
    clue $1 $2
}

inventory() {
    echo "You are carrying:"
    if [[ "$hb1" == "me" ]]; then
	echo " A Torch"
    fi
    if [[ "$hb2" == "me" ]]; then
	echo " Some Lunch"
    fi
    if [[ "$hb3" == "me" ]]; then
	echo " A Curious Map"
    fi
    if [[ "$hb6" == "me" ]]; then
	echo " A Sword"
    fi
    if [[ "$hb7" == "me" ]]; then
	echo " A Treasure"
    fi
}

kill() {
    echo "Violence is not very likely to solve your problems. Better stay calm."
}

load() {
    restore $1 $2 $3 $4 $5
}

look() {
    echo ""
    case "$hbr" in
	"woods" )
	    echo "Deep Forest"
	    echo "You are standing in the deep forest. Paths lead off in all directions but east,"
	    echo "where a mighty river is floating by. You feel lost and hungry."
	    echo "Thorin sits down and starts singing about drugs. He offers you a joint."
	    ;;
	"foul" )
	    echo "Foul Smelling Cave"
	    echo "You are in a vast cave, with a foul smell filling your nostrils. Light is"
	    echo "coming in through the wide entrance to the east, and it's just enough for you"
	    echo "to make out the walls of the cave."
	    ;;
	"cave" )
	    echo "Trolls' Cave"
	    if [[ "$hb1" == "cavern" || "$hb1" == "me" ]]; then
		echo "You are in a hardly even lit cavern with a doorway leading south."
		echo "Thorin is mumbling to himself and fails to notice your presence."
	    else
		echo "It's dark. You can't see anything."
		return
	    fi
	    ;;
	"clearing" )
	    echo "Trolls' Clearing"
	    echo "You are standing in a vast clearing, with paths leading off to the east and "
	    echo "west. A yellow brick road leads north. Trolls are standing all around you,"
	    echo "fiercely watching every move of your limbs."
	    if [[ "$hbs" == "YES" ]]; then
		echo "The trolls seem to be stoned. They probably don't like the sunlight."
	    else
		echo "The trolls are chanting ancient rhymes. They tend to do that just before dawn."
	    fi
	    ;;
	"home" )
	    echo "Tunnel Like Hall"
	    echo "You are in your comfortable tunnel like hall. Infact, it's just a dirty hole in"
	    echo "the ground, but to you it's home. Gandalf is working on a nasty spell. There"
	    echo "is a round, green door set in the eastern wall."
	    ;;
	"rivendell" )
	    echo "Rivendell"
	    echo "This is Rivendell, the last homelike house. At least, that's the name of it."
	    echo "Elrond is sitting at a round table together with his generals, discussing his "
	    echo "plans for a coming conquest and enslavement of the Hobbits. Paths lead off to"
	    echo "the north and west."
	    echo "Elrond hesitatingly offers you some food. He gives your fairly thick legs a"
	    echo "greedy look. He drools."
	    echo "Thorin announces: \"If you're attacking the Hobbits, count me in!\""
	    hb2="me"
	    ;;
	"den" )
	    echo "Smaug's Den"
	    echo "You are in a great cave. Gold and jewelry cover the floor. Precious paintings"
	    echo "are hanging on all the walls. Smaug is lying on a big heap of silver bars,"
	    echo "smoking a huge cigar. He looks at you and yawns loudly. "
	    ;;
	*)
	    echo "Error: Undefined room!"
    esac

    echo "You can see:"
    case "$hbr" in
	"$hb1" ) echo " A Torch" ;;
	"$hb2" ) echo " Some Lunch" ;;
	"$hb3" ) echo " A Curious Map" ;;
	"home" ) echo " A Wooden Chest" ;;
	"foul" ) echo " A Naked Dwarf Woman" ;;
	"$hb5" ) echo " A Raft" ;;
	"$hb6" ) echo " A Sword" ;;
	"$hb7" ) echo " A Treasure" ;;
    esac
    echo " Thorin, the dwarf."
}

restart() {
    # rem ***  The first known attempt at MS-DOS adventuring    ***
    # rem *** Launched by Johbe and Frera on 30:th of March '93 ***
    # rem ***             Updated in December 2001              ***
    # rem ***       Ported to BASH by Kastian in May 2015       ***

    hbr="home"
    hb1="chest"
    hb2="rivendell"
    hb3="gandalf"
    hb5="woods"
    hb6="cave"
    hb7="den"
    hbs="NO"

    clear
    echo "      Hobbit - The True Story - redux, Director's Cut.      "
    echo ""
    echo " An MS-DOS adventure released by Milbus Software (tm) 1993. "
    echo "redux, Director's Cut released by Milbus Software (tm) 2001."
    echo "              BASH port released by #kstn 2015.             "
    echo ""

    look
}

restore() {
    if [[ ! "${1}" ]]; then
	echo "You must supply a save-name with RESTORE. \"RESTORE xyz\" will restore a saved"
	echo "game from a save-file called \"HSxyz.BAT\"."
    elif [[ ! -f "HS${1}.BAT" ]]; then
	echo "Error: No file called \"HS${1}.BAT\" was found."
    else
	. "HS${1}.BAT"
	echo "Game restored."
	look
    fi
}

save() {
    if [[ ! "${1}" ]]; then
	echo "You must supply a save-name with SAVE. \"SAVE xyz\" will create a file called"
	echo "\"HSxyz.BAT\". The filename should be at least 1 and at most 5 characters long."
    elif [[ -f "HS${1}.BAT" ]]; then
	echo "Error: A file called \"HS${1}.BAT\" already exists."
    else
	echo "hb1=\"$hb1\"" >> "HS${1}.BAT"
	echo "hb2=\"$hb2\"" >> "HS${1}.BAT"
	echo "hb3=\"$hb3\"" >> "HS${1}.BAT"
	echo "hb5=\"$hb5\"" >> "HS${1}.BAT"
	echo "hb6=\"$hb6\"" >> "HS${1}.BAT"
	echo "hb7=\"$hb7\"" >> "HS${1}.BAT"
	echo "hbr=\"$hbr\"" >> "HS${1}.BAT"
	echo "hbs=\"$hbs\"" >> "HS${1}.BAT"
	echo "Game saved."
    fi
}

show() {
    # rem show (the) map to elrond
    # rem show elrond (the) map

    if [[ "$1" == "the" ]]; then
	show $2 $3 $4
    elif [[ "$2" == "the" ]]; then
	show $1 $3
    elif [[ "$2" == "to" ]]; then
	talkhelp $3 $1
    else
	talkhelp $1 $2
    fi
}

take() {
    case "$1" in
	"torch" )
	    if [[ "$hb1" == "me" ]]; then
		echo "You are already carrying that."
	    elif [[ "$hb1" != "$hbr" ]]; then
		echo "You can't see it here."
	    else
		hb1="me"
		echo "You take the $1."
	    fi
	    ;;
	"lunch" )
	    if [[ "$hb2" == "me" ]]; then
		echo "You are already carrying that."
	    elif [[ "$hb2" != "$hbr" ]]; then
		echo "You can't see it here."
	    else
		hb2="me"
		echo "You take the $1."
	    fi
	    ;;
	"map" )
	    if [[ "$hb3" == "me" ]]; then
		echo "You are already carrying that."
	    elif [[ "$hb3" != "$hbr" ]]; then
		echo "You can't see it here."
	    else
		hb3="me"
		echo "You take the $1."
	    fi
	    ;;
	"chest" )
	    if [[ "$hbr" != "home" ]]; then
		echo "You can't see it here."
	    else
		echo "You can't take that."
	    fi
	    ;;
	"raft" )
	    if [[ "$hb5" != "$hbr" ]]; then
		echo "You can't see it here."
	    else
		echo "You can't take that."
	    fi
	    ;;
	"sword" )
	    if [[ "$hb6" == "me" ]]; then
		echo "You are already carrying that."
	    elif [[ "$hb6" != "$hbr" ]]; then
		echo "You can't see it here."
	    else
		hb6="me"
		echo "You take the $1."
	    fi
	    ;;
	"treasure" )
	    if [[ "$hb7" == "me" ]]; then
		echo "You are already carrying that."
	    elif [[ "$hb7" != "$hbr" ]]; then
		echo "You can't see it here."
	    else
		hb7="me"
		echo "You take the $1."
	    fi
	    ;;
        "the" )
	    take $2
	    ;;
	* )
	    echo "You can't take that."
    esac
}

talk() {
    # rem talk to gandalf about (the) map
    # rem talk gandalf (the) map
    # rem talk to gandalf

    if [[ "$4" == "the" ]]; then
	talk $1 $2 $3 $5 $6
    elif [[ "$2" == "the" ]]; then
	talk $1 $3 $4 $5 $6
    elif [[ "$5" ]]; then
	echo "There are too many words in that sentence."
    elif [[ "$1" == "to" && "$3" == "about" ]]; then
	talkhelp $2 $4
    elif [[ "$1" == "to" ]]; then
	talkhelp $2
    elif [[ !"$3" ]]; then
	talkhelp $1 $2
    else
	echo "I don't understand that sentence."
    fi
}

talkhelp() {
    case "$1" in
	"gandalf" )
	    if [[ "$hbr" != "home" ]]; then
		echo "You can't see him here."
	    elif [[ "$2" == "map" ]]; then
		if [[ "$hb3" != "gandalf" ]]; then
		    echo "Gandalf yells, \"I already gave it to you, didn't I!!!\"."
		else
		    echo "\"Oh, that map. There is absolutely nothing special about it at all. I guess"
		    echo "you could have it, if you want it.\", Gandalf declares and hands you the map. "
		    hb3="me"
		fi
	    elif [[ "$2" == "spell" ]]; then
		echo "\"This will be a great spell. I shall name it 'HOBOFF', no doubt.\", Gandalf"
		echo "chuckles."
	    elif [[ "$2" == "hoboff" ]]; then
		echo "Gandalf gives you a mean smile, showing all his teeth. \"Any Hobbit of my"
		echo "choice will be turned into a pile of dirt.\", he laughs, \"Only a few minor"
		echo "adjustments left, and it will produce a great fertilizer.\". His eyes open"
		echo "wide as he reaches the end of the sentence. He then looks at you for a good"
		echo "fifteen seconds before he slowly turns away."
	    elif [[ "$2" == "thorin" ]]; then
		echo "\"It's a sordid story, really. He hasn't been himself in a long time. Or perhaps"
		echo "he wasn't himself before, and now he is. Or maybe we haven't even seen his real"
		echo "self. Let's talk about something else, shall we?\" says Gandalf and looks tired."
	    else
		echo "\"Yes, that's probably so\", he says."
	    fi
	    ;;
	"elrond" )
	    if [[ "$hbr" != "rivendell" ]]; then
		echo "You can't see him here."
	    elif [[ "$2" == "map" ]]; then
		if [[ "$hb3" != "rivendell" && "$hb3" != "me" ]]; then
		    echo "\"What map are you talking about, you little prat? You must be delirious!\","
		    echo "Elrond snarls. He slaps you in the face."
		else
		    echo "\"That's a fine map you've got there. We wouldn't want anything to HAPPEN to it,"
		    echo "now would we?\", Elrond hisses. He continues; \"Whatever you do, don't show it to"
		    echo "that crazy dwarf!\"."
		fi
	    elif [[ "$2" == "plans" ]]; then
		echo "\"They are top secret. If you reveal anything you're dead meat, pipsqueak!\","
		echo "Elrond whispers. He look as though he meant it."
	    else
		echo "Elrond laughs at your silly question. He pats your head."
	    fi
	    ;;
	"thorin" )
	    if [[ "$2" == "map" ]]; then
		if [[ "$hb3" != "$hbr" &&  "$hb3" != "me" ]]; then
		    echo "Thorin eyes you suspiciously. \"Don't try any tricks, boy. We both know that"
		    echo "there is no map here, now don't we?\", he asks. He doesn't seem too sure about"
		    echo "it himself."
		else
		    echo "Thorin takes a quick look at the map. His eyes widen in rage as he reaches for"
		    echo "his battle axe. \"It was you all the time, wasn't it?!\", he cries out. With one"
		    echo "well placed blow he cleaves your skull. All is dark..."
		    echo""
		    read -sn 1 # pause
		    restart
		fi
	    elif [[ "$2" == "naked" || "$2" == "woman" ]]; then
		if [[ "$hbr" != "foul" ]]; then
		    echo "Thorin glances around. \"Whoa, where is she? Where's this woman you're talking"
		    echo "about?\" he says. You are forced to disappoint him."
		else
		    echo "Thorin looks embarrased. \"I'd rather not talk about it. She's...She's...Never"
		    echo "mind, it's none of your business anyway,\" he says. He briefly touches the"
		    echo "handle of his axe, as if to make it clear that you had better leave it at that."
		fi
	    else
		case "$hbr" in
		    "clearing" )
			echo "Thorin gets a serious look on his face. \"Don't push your luck, kid!\", he says."
			;;
		    "woods" )
			echo "\"Have you ever tried picking up your teeth with broken fingers?\",Thorin replies."
			;;
		    "cave" )
			echo "\"I'm tired of killing for money. Let's go home!\", Thorin sighs."
			;;
		    "rivendell" )
			echo "Thorin is too absorbed by Elronds plans to pay attention."
			;;
		    "den" )
			echo "\"Hell, this is a fortune!\", Thorin states as he walks around the cave."
			;;
		    "foul" )
			echo "Thorin sees nothing except woman."
			;;
		    "home" )
			echo "\"Did your mom ever talk to you about death?\", Thorin asks you."
			;;
		esac
	    fi
	    ;;
	"naked" | "woman" )
	    if [[ "$hbr" != "foul" ]]; then
		echo "You can't see her here."
	    elif [[ "$2" == "map" ]]; then
		if [[ "$hb3" != "foul" && "$hb3" != "me" ]]; then
		    echo "She doesn't seem to understand what you are referring to."
		else
		    echo "She looks at your map and laughs heartily. You seem to have made her day."
		fi
	    elif [[ "$2" == "thorin" ]]; then
		echo "She says something that sounds like an insult. Since the two of you don't seem"
		echo "to have any language in common, you can't tell for sure though. She pats"
		echo "Thorin's head. Thorin slaps you."
	    else
		echo "She shudders and looks nervous."
	    fi
	    ;;
	* )
	    echo "Action speaks louder than words!"
    esac
}

wait() {
    if [[ "$hbr" == "clearing" && "$hbs" != "YES" ]]; then
	echo "A new day dawns. The trolls seem rather surprised, and rigid with fear."
	hbs="YES"
    else
	echo "Time passes..."
    fi
}

x() {
    examine $1 $2
}

parse() {
    clear
    case "$1" in
	"ask" )
	    shift;
	    ask "$@";
	    ;;
	"clue" )
	    clue;
	    ;;
	"cut" )
	    shift;
	    cut "$@";
	    ;;
	"drop" )
	    shift;
	    drop "$@";
	    ;;
	"eat" )
	    shift;
	    eat "$@";
	    ;;
	"e" )
	    go "east";
	    ;;
	"enter" )
	    shift;
	    enter "$@";
	    ;;
	"examine" )
	    shift;
	    examine "$@";
	    ;;
	"get" )
	    shift;
	    get "$@";
	    ;;
	"go" )
	    shift;
	    go "$@";
	    ;;
	"hint" )
	    shift;
	    hint "$@";
	    ;;
	"i" | "inventor" | "inventory" )
	    inventory;
	    ;;
	"kill" )
	    shift;
	    kill "$@";
	    ;;
	"load" )
	    shift;
	    load "$@";
	    ;;
	"l" | "look" )
	    look;
	    ;;
	"n" )
	    go "north";
	    ;;
	"q" | "quit" )
	    exit 0;
	    ;;
	"restart" )
	    restart;
	    ;;
	"restore" )
	    shift;
	    restore "$@";
	    ;;
	"save" )
	    shift;
	    save "$@";
	    ;;
	"s" )
	    go "south";
	    ;;
	"show" )
	    shift;
	    show "$@";
	    ;;
	"take" )
	    shift;
	    take "$@";
	    ;;
	"talk" )
	    shift;
	    talk "$@";
	    ;;
	"wait" )
	    wait;
	    ;;
	"w" )
	    go "west";
	    ;;
	"x" )
	    shift;
	    examine $1 $2;
	    ;;
	* )
	    look;
	    # TODO make some sentence for unknown command
	    ;;
    esac
}

### Parse command line args ############################################
if [[ "$1" ]]; then
    case "$1" in
	-v | --version)
	    echo "hobbit v1.0"
	    echo "Copyright 1993, 2001 Fredrik Ramsberg, Johan Berntsson (Milbus"
	    echo " Software) - original code"
	    echo "Copyright 2015 Konstantin Shakhnov - BASH port"
	    echo ""
	    echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
	    echo "This is free software: you are free to change and redistribute it."
	    echo "There is NO WARRANTY, to the extent permitted by law."
	    exit 0;
	    ;;
	-h | --help )
	    echo "hobbit - BASH port of old MS-DOS adventure \"Hobbit - The True"
	    echo "Story\" written by Fredrik Ramsberg and Johan Berntsson."
	    echo ""
	    echo "Usage: $0 [OPTION]"
	    echo "  -h  --help       display this help and exit"
	    echo "  -v  --version    output version information and exit"
	    echo ""
	    echo "hobbit home page: <https://github.com/kastian/Hobbit---The-True-Story>"
	    echo "Report bugs to: <kastian@mail.ru>"
	    exit 0;
	    ;;
	* )
	    echo "$0: unrecognized option '$1'";
	    echo "$0: use the --help option for more information";
	    exit 1
	    ;;
    esac
fi
### Set game variables #################################################
restart
### Run game loop ######################################################
while (true); do
    read var
    parse $var # NO "" !!!
done
