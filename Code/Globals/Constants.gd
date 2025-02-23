extends Node

const supporter_text: String = "You can play only one Supporter card each turn. When you play this card, put it next to your Active Pokémon. When your turn ends, discard this card."
const tool_text: String = "to 1 of your Pokémon that doesn't already have a Pokémon Tool attached to it. If that Pokémon is Knocked Out, discard this card."
const tm_text: String = "Attach this card to 1 of your Evolved Pokémon (excluding Pokémon-ex and Pokémon that has an owner in its name) in play. That Pokémon may use this card's attack instead of its own. At the end of your turn, discard "
const stadium_text: String = "This card stays in play when you play it. Discard this card if another Stadium card comes into play."

const expansion_counts: Array[int] = [109, -1, -1, 97, 102, -1, -1, 108]

const energy_types: Array[String] = ["Grass", "Fire", "Water", "Lightning", "Psychic", 
"Fighting", "Darkness", "Metal", "Colorless", "Rainbow", "Magma", "Aqua", "Dark Metal",
 "FF", "GL", "WP", "React"]
const energy_colors: Array[Color] = [Color.GREEN, Color.RED, Color.AQUA,
 Color.YELLOW, Color.PURPLE, Color.ORANGE_RED, Color.DARK_SLATE_GRAY,
Color.GRAY, Color.WHITE_SMOKE]

const playing_list_item = preload("res://Scenes/UI/Lists/PlayingListItem.tscn")
const playing_list = preload("res://Scenes/UI/Lists/NewPlayingList.tscn")
const attack_list = preload("res://Scenes/UI/Lists/attack_list.tscn")
const cursor = preload("res://Scenes/UI/UIComponents/cursor.tscn")
