extends TextureButton

@onready var logic = $"../../../../../../../../../../.."
@onready var text_edit = $"../LineEdit"
@onready var firestore_collection: FirestoreCollection = Firebase.Firestore.collection("scores")


func _on_pressed():
	text_edit.editable = false
	var submitable_score = Global.score
	var submitable_username = text_edit.text
	await logic.insert_score(submitable_username, submitable_score)
	visible = false
	await logic.update()
