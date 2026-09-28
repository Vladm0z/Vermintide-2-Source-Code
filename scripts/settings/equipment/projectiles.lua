-- chunkname: @scripts/settings/equipment/projectiles.lua

require("scripts/settings/equipment/projectile_units")
require("scripts/settings/explosion_templates")

ProjectileGravitySettings = {
	bounty_hunter_shot = -0.01,
	default = -9.82,
	drakegun = -9.82,
	bolts = -5,
	spark = -0.5,
	drake_pistols = 0,
	arrows = -9.82,
	fireball = -9.82,
	sniper_arrows = -12.82,
	staff = -9.82,
	gaze_fireball = -0.01
}

DLCUtils.merge("projectile_gravity_settings", ProjectileGravitySettings)

Projectiles = {}
Projectiles.normal_arrow = {
	projectile_unit_template_name = "player_projectile_unit",
	gravity_settings = "arrows",
	impact_type = "raycast",
	trajectory_template_name = "throw_trajectory",
	projectile_units_template = "we_arrow"
}

local Projectiles = Projectiles
local create_copy = table.create_copy(Projectiles.normal_arrow, Projectiles.normal_arrow)

create_copy = not not create_copy or not not table.clone(Projectiles.normal_arrow)
Projectiles.default = create_copy

local Projectiles_2 = Projectiles
local create_copy_2 = table.create_copy(Projectiles.normal_arrow, Projectiles.normal_arrow)

create_copy_2 = not not create_copy_2 or not not table.clone(Projectiles.default)
Projectiles_2.normal_arrow = create_copy_2
Projectiles.machinegun_arrow = {
	projectile_unit_template_name = "player_projectile_unit",
	static_impact_type = "raycast",
	impact_type = "sphere_sweep",
	radius = 0.05,
	trajectory_template_name = "throw_trajectory",
	gravity_settings = "arrows",
	projectile_units_template = "we_arrow"
}

local Projectiles_3 = Projectiles
local clone = table.clone(Projectiles.machinegun_arrow)

clone = not not clone or not not table.clone(Projectiles.default)
Projectiles_3.machinegun_arrow = clone
Projectiles.carbine_arrow = {
	projectile_unit_template_name = "player_projectile_unit",
	static_impact_type = "raycast",
	gravity_settings = "arrows",
	impact_type = "sphere_sweep",
	trajectory_template_name = "throw_trajectory",
	radius = 0.075,
	projectile_units_template = "we_arrow"
}

local Projectiles_4 = Projectiles
local clone_2 = table.clone(Projectiles.carbine_arrow)

clone_2 = not not clone_2 or not not table.clone(Projectiles.default)
Projectiles_4.carbine_arrow = clone_2
Projectiles.sniper_arrow = {
	projectile_unit_template_name = "player_projectile_unit",
	static_impact_type = "raycast",
	gravity_settings = "sniper_arrows",
	impact_type = "sphere_sweep",
	trajectory_template_name = "throw_trajectory",
	radius = 0.05,
	projectile_units_template = "we_arrow"
}

local Projectiles_5 = Projectiles
local clone_3 = table.clone(Projectiles.sniper_arrow)

clone_3 = not not clone_3 or not not table.clone(Projectiles.default)
Projectiles_5.sniper_arrow = clone_3
Projectiles.machinegun_poison_arrow = {
	projectile_unit_template_name = "player_projectile_unit",
	radius = 0.1,
	impact_type = "sphere_sweep",
	gravity_settings = "arrows",
	trajectory_template_name = "throw_trajectory",
	projectile_units_template = "we_poison_arrow"
}

local Projectiles_6 = Projectiles
local clone_4 = table.clone(Projectiles.machinegun_poison_arrow)

clone_4 = not not clone_4 or not not table.clone(Projectiles.default)
Projectiles_6.machinegun_poison_arrow = clone_4
Projectiles.carbine_poison_arrow = {
	projectile_unit_template_name = "player_projectile_unit",
	radius = 0.1,
	impact_type = "sphere_sweep",
	gravity_settings = "arrows",
	trajectory_template_name = "throw_trajectory",
	projectile_units_template = "we_poison_arrow"
}

local Projectiles_7 = Projectiles
local clone_5 = table.clone(Projectiles.carbine_poison_arrow)

clone_5 = not not clone_5 or not not table.clone(Projectiles.default)
Projectiles_7.carbine_poison_arrow = clone_5
Projectiles.crossbow_bolt = {
	projectile_unit_template_name = "player_projectile_unit",
	static_impact_type = "raycast",
	gravity_settings = "bolts",
	impact_type = "sphere_sweep",
	trajectory_template_name = "throw_trajectory",
	radius = 0.05,
	projectile_units_template = "bolt"
}

local Projectiles_8 = Projectiles
local clone_6 = table.clone(Projectiles.crossbow_bolt)

clone_6 = not not clone_6 or not not table.clone(Projectiles.default)
Projectiles_8.crossbow_bolt = clone_6

local Projectiles_9 = Projectiles
local clone_7 = table.clone(Projectiles.crossbow_bolt)

clone_7 = not not clone_7 or not not table.clone(Projectiles.default)
Projectiles_9.repeating_crossbow_bolt = clone_7
Projectiles.brace_of_drake_pistols_shot = {
	projectile_unit_template_name = "player_projectile_unit",
	radius = 0.15,
	impact_type = "sphere_sweep",
	gravity_settings = "drakegun",
	trajectory_template_name = "throw_trajectory",
	projectile_units_template = "drake_pistol_shot"
}

local Projectiles_10 = Projectiles
local clone_8 = table.clone(Projectiles.brace_of_drake_pistols_shot)

clone_8 = not not clone_8 or not not table.clone(Projectiles.default)
Projectiles_10.brace_of_drake_pistols_shot = clone_8
Projectiles.fireball = {
	impact_type = "sphere_sweep",
	static_impact_type = "raycast",
	fire_from_muzzle = false,
	gaze_override_gravity_settings = "gaze_fireball",
	trajectory_template_name = "throw_trajectory",
	muzzle_name = "fx_01",
	radius = 0.15,
	gravity_settings = "drakegun",
	projectile_unit_template_name = "player_projectile_unit",
	projectile_units_template = "fireball"
}

local Projectiles_11 = Projectiles
local clone_9 = table.clone(Projectiles.fireball)

clone_9 = not not clone_9 or not not table.clone(Projectiles.default)
Projectiles_11.fireball = clone_9
Projectiles.fireball_charged = {
	impact_type = "sphere_sweep",
	static_impact_type = "sphere_sweep",
	fire_from_muzzle = false,
	radius_max = 0.75,
	trajectory_template_name = "throw_trajectory",
	muzzle_name = "fx_01",
	radius_min = 0.2,
	forced_hitzone = "torso",
	gravity_settings = "drakegun",
	times_bigger = 4,
	projectile_unit_template_name = "player_projectile_unit",
	projectile_units_template = "fireball_charged"
}

local Projectiles_12 = Projectiles
local clone_10 = table.clone(Projectiles.fireball_charged)

clone_10 = not not clone_10 or not not table.clone(Projectiles.default)
Projectiles_12.fireball_charged = clone_10
Projectiles.spark = {
	projectile_unit_template_name = "player_projectile_unit",
	radius = 0.075,
	impact_type = "sphere_sweep",
	gravity_settings = "spark",
	trajectory_template_name = "throw_trajectory",
	projectile_units_template = "spark"
}

local Projectiles_13 = Projectiles
local clone_11 = table.clone(Projectiles.spark)

clone_11 = not not clone_11 or not not table.clone(Projectiles.default)
Projectiles_13.spark = clone_11
Projectiles.spear = {
	projectile_unit_template_name = "player_projectile_unit",
	gravity_settings = "spark",
	impact_type = "sphere_sweep",
	radius_max = 0.1,
	trajectory_template_name = "throw_trajectory",
	radius_min = 0.1,
	projectile_units_template = "spear"
}

local Projectiles_14 = Projectiles
local clone_12 = table.clone(Projectiles.spear)

clone_12 = not not clone_12 or not not table.clone(Projectiles.default)
Projectiles_14.spear = clone_12
Projectiles.burning_head = {
	projectile_unit_template_name = "player_projectile_unit",
	gravity_settings = "spark",
	impact_type = "sphere_sweep",
	radius_max = 0.1,
	trajectory_template_name = "throw_trajectory",
	radius_min = 0.1,
	projectile_units_template = "burning_head"
}

local Projectiles_15 = Projectiles
local clone_13 = table.clone(Projectiles.burning_head)

clone_13 = not not clone_13 or not not table.clone(Projectiles.default)
Projectiles_15.burning_head = clone_13
Projectiles.kerillian_ability_true_flight = {
	projectile_unit_template_name = "player_projectile_unit",
	static_impact_type = "raycast",
	gravity_settings = "arrows",
	impact_type = "sphere_sweep",
	trajectory_template_name = "throw_trajectory",
	radius = 0.075,
	projectile_units_template = "we_trueflight_arrow"
}

local Projectiles_16 = Projectiles
local clone_14 = table.clone(Projectiles.kerillian_ability_true_flight)

clone_14 = not not clone_14 or not not table.clone(Projectiles.default)
Projectiles_16.kerillian_ability_true_flight = clone_14
Projectiles.kerillian_ability_true_flight_piercing = {
	projectile_unit_template_name = "player_projectile_unit",
	static_impact_type = "raycast",
	gravity_settings = "bounty_hunter_shot",
	impact_type = "sphere_sweep",
	trajectory_template_name = "throw_trajectory",
	radius = 0.1,
	projectile_units_template = "we_trueflight_arrow"
}

local Projectiles_17 = Projectiles
local clone_15 = table.clone(Projectiles.kerillian_ability_true_flight_piercing)

clone_15 = not not clone_15 or not not table.clone(Projectiles.default)
Projectiles_17.kerillian_ability_true_flight_piercing = clone_15
Projectiles.victor_bounty_hunter = {
	projectile_unit_template_name = "player_projectile_unit",
	static_impact_type = "raycast",
	gravity_settings = "bounty_hunter_shot",
	impact_type = "sphere_sweep",
	trajectory_template_name = "throw_trajectory",
	radius = 0.05,
	projectile_units_template = "bullet_temp"
}

local Projectiles_18 = Projectiles
local clone_16 = table.clone(Projectiles.victor_bounty_hunter)

clone_16 = not not clone_16 or not not table.clone(Projectiles.default)
Projectiles_18.victor_bounty_hunter = clone_16
Projectiles.necromancer_trapped_soul = {
	projectile_unit_template_name = "ai_true_flight_projectile_unit",
	static_impact_type = "raycast",
	gravity_settings = "drake_pistols",
	impact_type = "sphere_sweep",
	trajectory_template_name = "throw_trajectory",
	radius = 0.05,
	projectile_units_template = "necromancer_trapped_soul"
}
Projectiles.bw_necromancy_staff = {
	impact_type = "sphere_sweep",
	static_impact_type = "raycast",
	fire_from_muzzle = false,
	gaze_override_gravity_settings = "gaze_fireball",
	trajectory_template_name = "throw_trajectory",
	muzzle_name = "fx_01",
	radius = 0.15,
	friendly_fire_grace_period = 0.05,
	gravity_settings = "bounty_hunter_shot",
	projectile_unit_template_name = "player_projectile_unit",
	projectile_units_template = "necromancer_curse_spirit"
}

local Projectiles_19 = Projectiles
local clone_17 = table.clone(Projectiles.victor_bounty_hunter)

clone_17 = not not clone_17 or not not table.clone(Projectiles.default)
Projectiles_19.pistol_shot = clone_17
Projectiles.pistol_shot.radius = 0.05
Projectiles.grenade = {
	impact_type = "sphere_sweep",
	radius = 0.1,
	show_warning_icon = true,
	life_time = 3,
	trajectory_template_name = "throw_trajectory",
	pickup_name = "grenade",
	rotation_speed = 10,
	gravity_settings = "drakegun",
	projectile_unit_template_name = "player_projectile_unit",
	projectile_units_template = "grenade"
}
Projectiles.grenade_fire = {
	impact_type = "sphere_sweep",
	radius = 0.1,
	show_warning_icon = true,
	life_time = 3,
	trajectory_template_name = "throw_trajectory",
	pickup_name = "grenade",
	rotation_speed = 10,
	gravity_settings = "drakegun",
	projectile_unit_template_name = "player_projectile_unit",
	projectile_units_template = "grenade_fire"
}

for _, dlc in pairs(DLCSettings) do
	local projectiles = dlc.projectiles

	if projectiles then
		for name, data in pairs(projectiles) do
			Projectiles[name] = table.clone(data)
		end
	end
end

for name, data in pairs(Projectiles) do
	data.name = name
end
