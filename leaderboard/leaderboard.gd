extends Node2D

@onready var firestore_collection: FirestoreCollection = Firebase.Firestore.collection("scores")


func get_top10():
	var query = FirestoreQuery.new()
	query = query.from("scores")
	query = query.where("score", FirestoreQuery.OPERATOR.GREATER_THAN, 0)
	query = query.order_by("score", FirestoreQuery.DIRECTION.DESCENDING)
	query = query.limit(10)

	var query_task = Firebase.Firestore.query(query)
	var result = await query_task.task_finished
	if is_instance_of(result, TYPE_ARRAY):
		return result
	return null


func get_top10_own():
	var _user_id = OS.get_unique_id()
	var query = FirestoreQuery.new()
	query = query.from("scores")
	query = query.where("score", FirestoreQuery.OPERATOR.GREATER_THAN, 0)
	query = query.where("user_id", FirestoreQuery.OPERATOR.EQUAL, _user_id)
	query = query.order_by("score", FirestoreQuery.DIRECTION.DESCENDING)
	query = query.limit(10)

	var query_task = Firebase.Firestore.query(query)
	var result = await query_task.task_finished
	if is_instance_of(result, TYPE_ARRAY):
		return result
	return null


func insert_score(name, score):
	var _user_id = OS.get_unique_id()
	firestore_collection.add(
		"",
		{
			"name": name,
			"score": score,
			"user_id": _user_id,
			"created_at": str(int(Time.get_unix_time_from_system()))
		}
	)
