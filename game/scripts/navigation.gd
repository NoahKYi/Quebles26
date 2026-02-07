extends TileMapLayer

@onready var astarGrid : AStarGrid2D = AStarGrid2D.new();

func _ready() -> void:
	
	#setup the astarGrid for navigation
	astarGrid.region = self.get_used_rect()
	astarGrid.cell_size = Vector2i(8,8) #this should match the tile size of the "Waklable" 
	astarGrid.update()
	
	#populate the walkable cells based on which parts of the "Walkable" tilemaplayer are used
	#first make all cells "solid"
	for x in range(astarGrid.region.position.x, astarGrid.region.position.x + astarGrid.region.size.x):
		for y in range(astarGrid.region.position.y, astarGrid.region.position.y + astarGrid.region.size.y):
			astarGrid.set_point_solid(Vector2i(x,y), true)
	
	#then make the walkable ones not "solid"
	var cellID = 1;
	for cell : Vector2i in self.get_used_cells():
		print(cell)
		astarGrid.set_point_solid(cell, false)
		cellID += 1
	
	

func get_ideal_path(a: Vector2, b: Vector2):

	print(a,b)
	#convert input coordinates to local coordinate system to calculate path
	a = Vector2i(self.to_local(a).x / astarGrid.cell_size.x, self.to_local(a).y / astarGrid.cell_size.y)
	b = Vector2i(self.to_local(b).x / astarGrid.cell_size.x, self.to_local(b).y / astarGrid.cell_size.y)
	
	#calculate path
	var path = astarGrid.get_point_path(a,b, true)
	print(path)
	#convert back to global coordinates
	var output : PackedVector2Array = PackedVector2Array()
	for point : Vector2 in path:
		output.push_back(to_global(point))
	print(output)
	#return output path that is now using global coordinates
	return output
	
