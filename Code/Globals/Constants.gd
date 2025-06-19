extends Node

#--------------------------------------
#region TEXT
const supporter_text: String = "You can play only one Supporter card each turn. When you play this card, put it next to your Active Pokémon. When your turn ends, discard this card."
const tool_text: String = "to 1 of your Pokémon that doesn't already have a Pokémon Tool attached to it. If that Pokémon is Knocked Out, discard this card."
const tm_text: String = "Attach this card to 1 of your Evolved Pokémon (excluding Pokémon-ex and Pokémon that has an owner in its name) in play. That Pokémon may use this card's attack instead of its own. At the end of your turn, discard "
const stadium_text: String = "This card stays in play when you play it. Discard this card if another Stadium card comes into play."
const trainer_classes: Array[String] = ["Item", "Supporter", "Tool", "Stadium", "TM",
"Rocket's Secret Machine"]
#Items and RSM don't have class text
const class_texts: Array[String] = ["", supporter_text, tool_text, stadium_text, tm_text, ""]
#endregion
#--------------------------------------

#--------------------------------------
#region EXPANSIONS
#Order goes from the 16 ex expansions, 5 POP Series then Black star
const expansion_abbreviations: Array[String] = ["RS","SS","DR","MA","HL",
"RG","TRR","DX","EM","UF","DS","LM","HP","CG","DF","PK",
"POP1","POP2","POP3","POP4","POP5","NP"]
const expansion_counts: Array[int] = [109, 100, 97, 95, 101, 112, 109, 107,
106, 115, 113, 92, 110, 110, 101, 108, 17, 17, 17, 17, 17, 40]
const expansion_secrets: Array[int] = [0,0,3,2,1,4,2,1,1,2,1,1,1,0,0,0,0,0,0,0,0,0]
const unknown_number: int = 28
#endregion
#--------------------------------------

#--------------------------------------
#region ENERGY
const energy_types: Array[String] = ["Grass", "Fire", "Water", "Lightning", "Psychic", 
"Fighting", "Darkness", "Metal", "Colorless", "Rainbow", "Magma", "Aqua", "Dark Metal",
 "FF", "GL", "WP", "React"]
const energy_icons = ["res://Art/Energy/48px-Grass-attack.png", "res://Art/Energy/48px-Fire-attack.png",
"res://Art/Energy/48px-Water-attack.png","res://Art/Energy/48px-Lightning-attack.png", 
"res://Art/Energy/48px-Psychic-attack.png", "res://Art/Energy/48px-Fighting-attack.png", 
"res://Art/Energy/48px-Darkness-attack.png","res://Art/Energy/48px-Metal-attack.png",
"res://Art/Energy/48px-Colorless-attack.png"]
const energy_colors: Array[Color] = [Color.GREEN, Color.RED, Color.AQUA,
 Color.YELLOW, Color.PURPLE, Color.ORANGE_RED, Color.DARK_SLATE_GRAY,
Color.GRAY, Color.WHITE_SMOKE]
#endregion
#--------------------------------------

#--------------------------------------
#region SCENES
const playing_list: PackedScene = preload("res://Scenes/UI/Lists/NewPlayingList.tscn")
const attack_list_comp: PackedScene = preload("res://Scenes/UI/Lists/attack_scroll_box.tscn")
#const attack_list = preload("res://Scenes/UI/Lists/attack_list.tscn")
const poke_card = preload("res://Scenes/UI/CardDisplay/PokemonCard.tscn")
const trainer_card: PackedScene = preload("res://Scenes/UI/CardDisplay/TrainerCard.tscn")
const energy_card: PackedScene = preload("res://Scenes/UI/CardDisplay/EnergyCard.tscn")
const cursor: PackedScene = preload("res://Scenes/UI/UIComponents/cursor.tscn")
const tutor_box: PackedScene = preload("res://Scenes/UI/Lists/tutor_box.tscn")
#endregion
#--------------------------------------

#--------------------------------------
#region ENUMS
enum PLAYER_TYPES{PLAYER1, ##HUMAN CONTROLLED AT THE BOTTOM
 PLAYER2, ##HUMAN CONTROLLED AT THE TOP
 CPU1, ## CPU CONTROLLED AT THE BOTTOM
 CPU2 ##CPU CONTROLLED AT THE TOP
}
enum SIDES {NONE, ##IGNORE FIELD AND TAKE DEFAULT
 ATTACKING,##IS FOR THE PLAYER WHOSE TURN IT IS
 DEFENDING,##IS THE OTHER GUY
 BOTH, ##TAKE IN EVERY SLOT THAT FITS SPECIFIERS
 SOURCE, ##ONLY TAKE IN WHOEVER CALLED EFFECT NO MATTER SIDE
 OTHER, ##WHICHEVER SIDE DIDN'T CALL THE EFFECT
} 
enum SLOTS {NONE,##Ignore and use the default
 TARGET,##Refers to  pokemon involved in atacks and effects
 ACTIVE,##Refers to the pokemon in the Active Slot
 BENCH,##Refers to pokemon in the bench
 ALL##Refers to any pokemon in the dedicated side
}
enum STACKS{HAND, ##CARDS HERE CAN BE PLAYED UNDER THE RIGHT CONDITIONS
DECK, ##CARDS MUST EITHER BE DRAWN OR TUTORED. ALL CRADS BEGIN HERE
DISCARD, ##AFTER A CARD IS USED, KO'd OR PAYS FOR ANY DISCARD COSTS
PRIZE, ##AFTER SETTING UP, PUT X PRIZE CARDS HERE TO TAKE AFTER KO
PLAY, ##ANY CARD THAT ISN'T IN A STACK
LOST, ##THE LOST ZONE, NOT LIKELY TO BE IMPLEMENTED BUT NICE TO HAVE FOR NOW. ANY CARD THAT CANNOT BE RETRIEVED FOR FUTURE USE
ANY,
NONE
}
enum STACK_ACT{PLAY,##ALLOWED CARDS CAN BE PLAYED ONTO THE BOARD
	TUTOR, ##ALLOWED CARDS WILL BE SENT TO ANOTHER DESTINATION
	DISCARD, ##ALLOWED CARDS WILL BE SENT TO DISCARD PILE
	LOOK, ##NOT ALLOWED TO INTERACT WITH CARDS
	REORDER ##REARRANGE CARDS AS NECESSARY
}
#endregion
#--------------------------------------

#--------------------------------------
#region ETC
const rarity: Array[String] = ["Common", "Uncommon", "Rare",
 "Holofoil Rare", "ex Rare", "Ultra Rare", "Star Rare", "Promo Rare"]
const allowed_list_flags: Array[String] = ["Basic", "Evolution",
 "Item", "Supporter","Stadium", "Tool", "TM", "RSM", "Fossil", "Energy"]

#endregion
#--------------------------------------
