extends Control

@onready var firestore_collection: FirestoreCollection = Firebase.Firestore.collection("scores")
@onready var score = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/PanelContainer2/HBoxContainer/Label

func get_top10():
	var query = FirestoreQuery.new()
	query = query.from("scores")
	query = query.where("score", FirestoreQuery.OPERATOR.GREATER_THAN, 0)
	query = query.order_by("score", FirestoreQuery.DIRECTION.DESCENDING)
	query = query.limit(10)

	var query_task = Firebase.Firestore.query(query)
	var result = await query_task.task_finished
	return result


func insert_score(name: String, score: int):
	if name.length() < 1:
		return

	if score < 1:
		return

	firestore_collection.add(
		"",
		{
			"name": name,
			"score": score,
			"user_id": "",
			"created_at": str(int(Time.get_unix_time_from_system()))
		}
	)


func update():
	$MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Panel2/BoxContainer/MarginContainer2/LeaderboardText.text = "Loading..."
	score.text = str(Global.score)
	var data = await get_top10()
	if data == null or data.error:
		return

	var rows: Array = data.data
	var text = ""
	for i in rows.size():
		var row = rows[i]
		text += (
			str(i + 1) + " " + row.doc_fields["name"] + ": " + str(row.doc_fields["score"]) + "\n"
		)
	$MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Panel2/BoxContainer/MarginContainer2/LeaderboardText.text = text


func _ready():
	update()
