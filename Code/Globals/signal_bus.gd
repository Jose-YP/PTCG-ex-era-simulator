extends Node

#HAND SIGNALS
signal show_starting(can_select: bool, message: String, looking_at: String, list: Array[Base_Card])
signal show_hand(whose_hand: String, hand: Array[Base_Card])
#CARD DISPLAY SIGNALS
signal show_other_card(showing: Base_Card)
signal show_pokemon_card(showing: PokeSlot)
signal show_options(button: Button, card: Base_Card)
#EFFECT SIGNALS
