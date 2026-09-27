-- chunkname: @scripts/settings/dlcs/morris/morris_potion_settings.lua

local deus_potions = DLCSettings.morris.pickups.deus_potions

local function fn(arg_1_0)
	-- function 1
	local tbl = {
		actions = {
			action_one = {
				default = {
					damage_window_start = 0.05,
					anim_end_event = "attack_finished",
					ammo_usage = 1,
					kind = "buff",
					damage_window_end = 0.2,
					weapon_action_hand = "left",
					block_pickup = true,
					uninterruptible = true,
					anim_event = "attack_heal",
					total_time = 1.3,
					anim_end_event_condition_func = function (arg_2_0, arg_2_1)
						-- function 2
						return arg_2_1 == "new_interupting_action" or arg_2_1 ~= "action_complete"
					end,
					condition_func = function (arg_3_0)
						-- function 3
						local extension = ScriptUnit.extension(arg_3_0, "buff_system")
						local has_buff_type = extension:has_buff_type(arg_1_0 .. "_potion")
						local has_buff_type_2 = extension:has_buff_type(arg_1_0 .. "_potion_increased")

						return not (has_buff_type or has_buff_type_2)
					end,
					allowed_chain_actions = {},
					buff_template = arg_1_0 .. "_potion"
				}
			},
			action_two = {
				default = ActionTemplates.give_item_on_defend
			},
			action_instant_drink_potion = {
				default = {
					kind = "dummy",
					weapon_action_hand = "left",
					total_time = 0,
					allowed_chain_actions = {}
				},
				instant_drink = {
					damage_window_end = 0.2,
					ammo_usage = 1,
					anim_end_event = "attack_finished",
					kind = "buff",
					damage_window_start = 0.05,
					weapon_action_hand = "left",
					interaction_priority = 2,
					block_pickup = true,
					uninterruptible = true,
					anim_event = "attack_heal",
					auto_validate_on_gamepad = true,
					total_time = 1.3,
					anim_end_event_condition_func = function (arg_4_0, arg_4_1)
						-- function 4
						return arg_4_1 == "new_interupting_action" or arg_4_1 ~= "action_complete"
					end,
					allowed_chain_actions = {},
					buff_template = arg_1_0 .. "_potion",
					condition_func = function (arg_5_0)
						-- function 5
						return true
					end
				}
			},
			action_instant_give_item = ActionTemplates.instant_give_item,
			action_inspect = ActionTemplates.action_inspect_left,
			action_career_skill = ActionTemplates.career_skill_dummy,
			action_wield = ActionTemplates.wield_left,
			action_instant_grenade_throw = ActionTemplates.instant_grenade_throw,
			action_instant_heal_self = ActionTemplates.instant_equip_and_heal_self
		},
		ammo_data = {
			ammo_hand = "left",
			destroy_when_out_of_ammo = true,
			max_ammo = 1,
			ammo_per_clip = 1,
			reload_time = 0,
			ignore_ammo_pickup = true
		}
	}

	tbl.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"
	tbl.left_hand_attachment_node_linking = AttachmentNodeLinking.potion
	tbl.wield_anim = "to_potion"
	tbl.state_machine = "units/beings/player/first_person_base/state_machines/common"
	tbl.load_state_machine = false
	tbl.gui_texture = "hud_consumable_icon_potion"
	tbl.max_fatigue_points = 4
	tbl.can_give_other = true
	tbl.buffs = {
		change_dodge_distance = {
			external_optional_multiplier = 1
		},
		change_dodge_speed = {
			external_optional_multiplier = 1
		}
	}
	tbl.pickup_data = {
		pickup_name = arg_1_0 .. "_potion"
	}
	tbl.material_settings_name = deus_potions[arg_1_0 .. "_potion"].material_settings_name

	return tbl
end

return {
	liquid_bravado_potion = fn("liquid_bravado"),
	vampiric_draught_potion = fn("vampiric_draught"),
	moot_milk_potion = fn("moot_milk"),
	friendly_murderer_potion = fn("friendly_murderer"),
	killer_in_the_shadows_potion = fn("killer_in_the_shadows"),
	pockets_full_of_bombs_potion = fn("pockets_full_of_bombs"),
	hold_my_beer_potion = fn("hold_my_beer"),
	poison_proof_potion = fn("poison_proof")
}
