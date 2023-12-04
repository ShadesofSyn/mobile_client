extends Node

var team_selected: int 
var special_ability_selected: String 

const MIN_PLACE_OBJECT_DISTANCE: float = 400

const SPEED_OF_PAGE_CHANGE: float = 0.225
const TIME_TO_SPAWN_ALLY: int = 10
const INVISIBILITY_LENGTH: float = 5.0

const DASH_LENGTH = 0.5
const DASH_SPEED_INCREASE = 4.0
const DASH_ACCEL_INCREASE = 6.0

enum player_state {
	IDLE,
	WALK,
	ATTACK,
	DEATH,
}



func return_damage_inflicted(hitbox_name:String,war_cry_active:bool,unstable_core_active:bool) -> int:
	var damage = return_hitbox_damage(hitbox_name)
	
	if war_cry_active:
		damage *= 1.2 # increase damage by 20%
	
	if unstable_core_active:
		damage += 30.0  # increase damage by 30
		
	return damage


func return_hitbox_damage(hitbox_name:String) -> int:
	return 10

var character_data = {
	"valkyrie": {
		"class": "Warrior",
		"description": "Melee swordsmith master, of an ancient race.",
		"stats": {
			"health": 350,
			"basicAttackDamage": 30,
			"attackSpeed": 0.8,
			"movementSpeed": 14,
			"attackRange": 3
		},
		"abilities": {
			"chargedAttack": {
				"description": "Every 6th Basic Attack does +100% Basic Attack Damage",
				"chargedAttackDamage": "Basic Damage + (Basic Damage*1.0)"
			},
		"ultimate": {
			"name": "Bladefury",
			"type": "Action",
			"description": "Spin around 3 times dealing damage each rotation to anything within range",
			"damagePerRotation": 60,
			"range": 5,
			"cooldown": 10
		}
	},
	"technomancer": {
		"class": "Unknown",
		"description": "Placeholder description for Technomancer.",
		"baseStats": {
			"healthPoints": 330,
			"basicAttackDamage": 42,
			"attackSpeed": 1.0,
			"movementSpeed": 13,
			"attackRange": 8
		},
		"chargedAttack": {
			"description": "Triggers every 6th hit, dealing double damage.",
			"damage": 84
		},
		"ultimate": {
			"name": "Placeholder Ultimate Name",
			"type": "Placeholder Type",
			"description": "Placeholder description for the Ultimate Ability.",
			"totalDamage": 300,
			"damagePerAction": 100.0,  ## Individual damage per action
			"range": 10,
			"cooldown": 9
		}
	},
	"magmaul": {
		"class": "Unknown",
		"description": "Placeholder description for Magmaul.",
		"baseStats": {
			"healthPoints": 800,
			"basicAttackDamage": 25,
			"attackSpeed": 1.2,
			"movementSpeed": 9,
			"attackRange": 2
		},
	"chargedAttack": {
		"description": "Triggers every 6th hit, dealing double damage.",
		"damage": 50
		},
	"ultimate": {
		"name": "Placeholder Ultimate Name",
		"type": "Placeholder Type",
		"description": "Placeholder description for the Ultimate Ability.",
		"totalDamage": 180,
		"damagePerAction": 60.0,  ## Assuming the total damage is split into 3 actions
		"range": 4,
		"cooldown": 12
		}
	},
	"steelthorn": {
		"class": "Unknown",
		"description": "Placeholder description for Steelthorn.",
		"baseStats": {
			"healthPoints": 700,
			"basicAttackDamage": 25,
			"attackSpeed": 1.0,
			"movementSpeed": 11,
			"attackRange": 3
		},
		"chargedAttack": {
			"description": "Triggers every 6th hit, dealing double damage.",
			"damage": 50
		},
		"ultimate": {
			"name": "Placeholder Ultimate Name",
			"type": "Defense",
			"description": "Blocks a percentage of incoming damage for 3 seconds.",
			"damageBlock": "60.0%",
			"duration": 3,  ## Duration in seconds
			"range": 6,
			"cooldown": 9
		},
	},
	"canix": {
		"class": "Unknown",
		"description": "Placeholder description for Canix.",
		"baseStats": {
			"healthPoints": 360,
			"basicAttackDamage": 30,
			"attackSpeed": 0.7,
			"movementSpeed": 16,
			"attackRange": 3
		},
		"chargedAttack": {
			"description": "Triggers every 6th hit, dealing double damage.",
			"damage": 60
		},
		"ultimate": {
			"name": "Placeholder Ultimate Name",
			"type": "Action",
			"description": "Two-action attack: First, lunges forward and bites an enemy causing 100 damage. Second, drags the enemy back to the starting point causing 50 damage.",
			"actionOneDamage": 100,
			"actionTwoDamage": 50,
			"totalDamage": 150,  ## Total damage combining both actions
			"range": 6,
			"cooldown": 11
		}
	},
	"mariselle": {
		"class": "Unknown",
		"description": "Placeholder description for Mariselle.",
		"baseStats": {
			"healthPoints": 420,
			"basicAttackDamage": 27,
			"attackSpeed": 0.9,
			"movementSpeed": 13,
			"attackRange": 6
		},
		"chargedAttack": {
			"description": "Triggers every 6th hit, dealing double damage.",
			"damage": 54
		},
		"ultimate": {
			"name": "Placeholder Ultimate Name",
			"type": "Support",
			"description": "Heals all friendlies within range for 26% of their total health, occurring over three actions.",
			"healPercentagePerAction": 26,
			"totalHealPercentage": 78,
			"range": 8,
			"cooldown": 8
		}
	}
}}


