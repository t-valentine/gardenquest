extends Resource

onready var random = RandomNumberGenerator.new()

export(String) var name = "Bug"
export(int) var health = 30
export(int) var damage = random.randi_range(0, 12)
