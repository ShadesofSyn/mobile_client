extends Node

var team_selected: int 
var special_ability_selected: String 


const SPEED_OF_PAGE_CHANGE: float = 0.225
const TIME_TO_SPAWN_ALLY: int = 10
const INVISIBILITY_LENGTH: float = 5.0

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
	
}}


var characters = {
	"BASHER": {
		"class": "BRAWLER",
		"description": "A single-target swordsman with moderate speed and health.",
		"attributes": {
		  "HEALTH": 150,
		  "ENERGY": 15,
		  "DPS": 35,
		  "ERange": 3,
		  "DDR": 0.15,
		  "ERS": 2.5
		}
	},
	"BRUISER": {
		"class": "JUGGERNAUT",
		"description": "A robust character with slow speed and moderate damage.",
		"attributes": {
		  "HEALTH": 300,
		  "ENERGY": 20,
		  "DPS": 30,
		  "ERange": 1.5,
		  "DDR": 0.25,
		  "ERS": 1.5
		}
	 },
	"CYPHER" : {
		"class": "TECHNOMANCER",
		"description": "Coming soon...",
		"attributes": {
		  "HEALTH": 100,
		  "ENERGY": 35,
		  "DPS": 40,
		  "ERange": 8,
		  "DDR": 0.1,
		  "ERS": 4
		}
	},
	"ROGUE" : {
		"class": "INFILTRATOR",
		"description": "Coming soon...",
		"attributes": {
		  "HEALTH": 100,
		  "ENERGY": 25,
		  "DPS": 60,
		  "ERange": 1,
		  "DDR": 0.35,
		  "ERS": 3
		}
	},
	"HEALER" : {
		"class": "NANOMEDIC",
		"description": "A non-lethal soldier that heals troops within its radius.",
		"attributes": {
		  "HEALTH": 250,
		  "ENERGY": 50,
		  "DPS": 15,
		  "ERange": 6,
		  "DDR": 0.1,
		  "ERS": 5
		}
	},
	"MARKSMAN" : {
		"class": "SNIPER",
		"description": "A ranged shooter with low health.",
		"attributes": {
		  "HEALTH": 175,
		  "ENERGY": 20,
		  "DPS": 50,
		  "ERange": 10,
		  "DDR": 0.05,
		  "ERS": 3
		}
	}
}

