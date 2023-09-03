extends Node
#impliments a linked list into gdscript
#using the built in arrays

#is this cursed, yes, do I care, no
class_name LinkedList

#data,prev,next
var data = [null,null,null]
var last_node = data
func add_data_to_list(data)->void:
	self.add_node_to_list([data,null,null])
#convinence function to add a node to the end of the linked list
func add_node_to_list(node)->void:
	print("adding node " + str(node[0]))
	last_node[2] = node 
	node[1] = last_node
	last_node = node 
	print(last_node[0])
func remove_node_from_list(node)->void:
	print("removing " + str(node[0]))
	if node == last_node:
		last_node = node[1]
	node[1][2] = node[2]

#convinence higher order function to loop through the list and perform a given operation
func foreach(f : Callable)->void:
		var current = data[2]
		while current != null:
			print("looping over " + str(current[0]))
			f.call(current)
			current = current[2]
