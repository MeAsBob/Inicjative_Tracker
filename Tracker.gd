extends Node

# Zmienna do przechowywania listy postaci i ich inicjatyw
var current_version = "v0.1.0" 
var character_list = []
var Edit
var current_index = -1
#-------------------------------------Sortowanie
func partition(arr, low, high):
	var _pivot = arr[high]["initiative"]  # Pivot jako ostatni element
	var i = low - 1  # Indeks mniejszego elementu
	
	for j in range(low, high):
		# Jeśli aktualny element jest mniejszy lub równy pivotowi
		if arr[j]["initiative"] >= _pivot:
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
		
func _on_sort_pressed():
	var n = character_list.size()
	quick_sort(character_list, 0, n - 1)
	update_character_list()



#------------------------------------ Funkcja do aktualizowania wyświetlanej listy postaci
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
		
		var edit_button = Button.new()
		edit_button.text = "Edytuj"
		edit_button.connect("pressed", Callable(self, "_on_edit_pressed").bind(i))
		entry.add_child(edit_button)
		
		
		# Dodajemy wiersz (entry) do kontenera
		list_container.add_child(entry)
		if character_list.size() <= 0:
			get_node("VBoxContainer/Next_Turn").set_disabled(true)
			get_node("VBoxContainer/Sort").set_disabled(true)
			get_node("VBoxContainer/Reset").set_disabled(true)
		else:
			get_node("VBoxContainer/Next_Turn").set_disabled(false)
			get_node("VBoxContainer/Sort").set_disabled(false)
			get_node("VBoxContainer/Reset").set_disabled(false)

#--------------------------------------- Funkcja do resetowania listy
func _on_reset_pressed():
	character_list.clear()
	update_character_list()
	
	
#--------------------------------------- Funkcja do Edytowania elementu z listy
func _on_edit_pressed(index):
	# Zapisz indeks edytowanego elementu, aby później zaktualizować dane
	Edit = index
	
	# Wyciągnij dane postaci do edycji
	var character = character_list[index]
	
	# Ustaw wartości w okienku do edycji
	$Edit/Box/Name_Edit.text = character["name"]
	$Edit/Box/Inicjative_Edit.value = character["initiative"]
	
	# Pokaż okienko
	$Edit.popup_centered()

# Funkcja zapisująca zmiany po naciśnięciu przycisku "Zapisz" w okienku
func _on_save_pressed():
	# Sprawdź, czy indeks jest prawidłowy
	if Edit != -1:
		# Pobierz zaktualizowane wartości z okienka
		var new_name = $Edit/Box/Name_Edit.text
		var new_initiative = $Edit/Box/Inicjative_Edit.value
		# Zaktualizuj listę postaci
		character_list[Edit]["name"] = new_name
		character_list[Edit]["initiative"] = new_initiative
		
		# Zamknij okienko
		$Edit.hide()
		
		# Zaktualizuj wyświetlaną listę
		update_character_list()
	
	# Resetuj indeks po zapisaniu zmian
	Edit = -1


#--------------------------------------- Funkcja do usuwanie elementu z listy
func _on_delete_pressed(index):
	character_list.remove_at(index)
	update_character_list()

#-------------------------------------- Funkcja do dodawanie elementu do listy
func _on_add_pressed():
	var name_input = $VBoxContainer/HBoxContainer/Name.text
	var initiative_input = int($VBoxContainer/HBoxContainer/Inicjative.value)
	
	if name_input == "":
		print("Imię postaci nie może być puste!")
		return
	
	
	character_list.append({"name": name_input, "initiative": initiative_input})
	update_character_list()
#-------------------------------------- Funkcja która podkreśla czyja tura teraz jest
func _on_next_turn_pressed():
	current_index += 1
	if current_index >= character_list.size():
		current_index = 0
	
	koloruj(current_index)
	
func koloruj(index):
	var list_container = $VBoxContainer/ScrollContainer/VBoxContainer
	# Resetowanie kolorów wszystkich postaci
	for i in range(list_container.get_child_count()):
		var child = list_container.get_child(i)
		var name_label = child.get_child(0)
		name_label.modulate = Color(1, 1, 1)
	# Ustawienie koloru aktywnej postaci
	var active_child = list_container.get_child(index)
	var active_name_label = active_child.get_child(0)  # Pierwsze dziecko to Label
	active_name_label.modulate = Color(1, 0, 0)  # Kolor na czerwono

func _on_scroll_container_ready():
	set_deferred("scroll_horzintal",2)
	set_deferred("scroll_vertical",3)



