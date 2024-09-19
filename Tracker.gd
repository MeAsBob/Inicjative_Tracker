extends Node

# Zmienna do przechowywania listy postaci i ich inicjatyw
var character_list = []

func partition(arr, low, high):
	var _pivot = arr[high]["initiative"]  # Pivot jako ostatni element
	var i = low - 1  # Indeks mniejszego elementu
	
	for j in range(low, high):
		# Jeśli aktualny element jest mniejszy lub równy pivotowi
		if arr[j]["initiative"] <= _pivot:
			i += 1
			# Zamiana elementów
			var temp = arr[i]
			arr[i] = arr[j]
			arr[j] = temp
	
	# Zamiana pivotu na odpowiednie miejsce
	var temp = arr[i + 1]
	arr[i + 1] = arr[high]
	arr[high] = temp
	return i + 1

func quick_sort(arr, low, high):
	if low < high:
		# Znalezienie pivotu i podzielenie listy na dwie części
		var pivot_index = partition(arr, low, high)
		# Sortowanie części przed pivotem
		quick_sort(arr, low, pivot_index - 1)
		# Sortowanie części po pivocie
		quick_sort(arr, pivot_index + 1, high)


class Comparator:
	static func compare_initiative(a, b):
		return b.initiative - a.initiative


# Funkcja do aktualizowania wyświetlanej listy postaci
func update_character_list():
	var list_container = $VBoxContainer/ScrollContainer/VBoxContainer
	
	for child in list_container.get_children():
		list_container.remove_child(child)
		child.queue_free()  # Usuwamy nod z pamięci
	
	
	for i in range(len(character_list)):
		var character = character_list[i]
		# Tworzymy nowy HBoxContainer dla każdego wpisu
		var entry = HBoxContainer.new()
		
		# Tworzymy Label do wyświetlenia imienia postaci
		var name_label = Label.new()
		name_label.text = character["name"]
		entry.add_child(name_label)
		
		# Tworzymy Label do wyświetlenia inicjatywy
		var initiative_label = Label.new()
		initiative_label.text = str(character["initiative"])
		entry.add_child(initiative_label)
		
		var delete_button = Button.new()
		delete_button.text = "Usuń"
		delete_button.connect("pressed", Callable(self, "_on_delete_pressed").bind(i))
		entry.add_child(delete_button)
		
		
		# Dodajemy wiersz (entry) do kontenera
		list_container.add_child(entry)

# Funkcja do resetowania listy (opcjonalnie)
func reset_list():
	character_list.clear()
	update_character_list()


func _on_delete_pressed(index):
	character_list.remove_at(index)
	print("delete")
	update_character_list()


func _on_add_pressed():
	var name_input = $VBoxContainer/HBoxContainer/LineEdit.text
	var initiative_input = int($VBoxContainer/HBoxContainer/SpinBox.value)
	
	if name_input == "":
		print("Imię postaci nie może być puste!")
		return
	
	
	character_list.append({"name": name_input, "initiative": initiative_input})
	update_character_list()  



func _on_sort_pressed():
	var n = character_list.size()
	quick_sort(character_list, 0, n - 1)
	update_character_list()

func _on_scroll_container_ready():
	set_deferred("scroll_horzintal",600)
	set_deferred("scroll_vertical",600)



