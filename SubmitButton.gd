extends TextureButton

@onready var logic = $"../../../../../../../../../../.."
@onready var text_edit = $"../LineEdit"
@onready var firestore_collection: FirestoreCollection = Firebase.Firestore.collection("scores")

func insert_score(name, score):
	var task = firestore_collection.add(
		"",
		{
			"name": name,
			"score": score,
			"user_id": "",
			"created_at": str(int(Time.get_unix_time_from_system()))
		}
	)
	await task.task_finished


func _on_pressed():
	text_edit.editable = false
	var submitable_score = Global.score
	var submitable_username = text_edit.text
	await insert_score(submitable_username, submitable_score)
	visible = false
	logic.update()
	
