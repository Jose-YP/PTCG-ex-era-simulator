@icon("res://Art/ProjectSpecific/car.png")
extends Resource
class_name Comparator

##[enum Return] Return the result of the first counter only[br]
##[enum Return] Return the result of the first minus the second counter[br]
##[enum Equals] Return a boolean if the first counter equals the second[br]
##[enum Not Equal] Return a boolean if the first counter doesn't equal the second[br]
##[enum Greater] Return a boolean if the first counter is greater than the second[br]
##[enum Lesser] Return a boolean if the first counter is lesser than the second[br]
@export_enum("Return", "Difference", "Equals", "Not Equal",
 "Greater", "Lesser") var comparision_type: String = "Return"

@export var first_comparison: IndvCounter
@export_enum("None", "Const", "Second") var compare_to: String = "None"
@export_group("Compare To Vars")
@export var second_constant: int = 0
@export var second_counter: IndvCounter

func start_comparision() -> Variant:
	var first_return = first_comparison.evaluate()
	match compare_to:
		"None":
			return first_return
		"Const":
			print(first_return, second_constant)
			return make_comparision(first_return, second_constant)
		"Second":
			print(first_return, second_counter.evaluate())
			return make_comparision(first_return, second_counter.evaluate())
	return false

func make_comparision(first: int, second: int) -> Variant:
	match comparision_type:
		"Return": return "How did I get here?"
		"Difference": return first - second
		"Equals": return first == second
		"Not Equal": return first != second
		"Greater": return first > second
		"Lesser": return first < second
	return ":("
