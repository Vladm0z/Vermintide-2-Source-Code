-- chunkname: @scripts/settings/equipment/weapon_templates/we_thornsister_career_skill.lua

local num = -9.82
local num_2 = 15
local num_3 = 4
local num_4 = 1
local tbl = {
	actions = {
		action_career_hold = {
			default = {
				anim_end_event = "thorn_ability_cancel",
				kind = "career_we_thornsister_target_wall",
				weapon_action_hand = "left",
				uninterruptible = true,
				anim_event = "thorn_ability_start",
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					-- function 1
					return arg_1_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				target_sim_gravity = num,
				target_sim_speed = num_2,
				target_width = num_3,
				target_thickness = num_4,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						force_release_input = "action_two_hold",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_career_release",
						input = "action_career_not_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_career_release",
						input = "action_career_release"
					},
					{
						sub_action = "thorn_wall_target_flip",
						start_time = 0.1,
						action = "action_career_hold",
						input = "action_one"
					}
				},
				enter_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					-- function 2
					arg_2_1:clear_input_buffer()
					arg_2_1:reset_release_input()
					arg_2_3:change_synced_state("targeting", true)
				end
			},
			thorn_wall_target_flip = {
				vertical_rotation = true,
				anim_end_event = "ability_finished",
				kind = "career_we_thornsister_target_wall",
				weapon_action_hand = "left",
				uninterruptible = true,
				anim_event = "thorn_ability_flip",
				anim_end_event_condition_func = function (arg_3_0, arg_3_1)
					-- function 3
					return arg_3_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				target_sim_gravity = num,
				target_sim_speed = num_2,
				target_width = num_3,
				target_thickness = num_4,
				target_bend_angle = wall_bend_angle,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						force_release_input = "action_two_hold",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_career_release",
						input = "action_career_not_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_career_release",
						input = "action_career_release"
					},
					{
						sub_action = "thorn_wall_target_flip_back",
						start_time = 0.1,
						action = "action_career_hold",
						input = "action_one"
					}
				},
				enter_function = function (arg_4_0, arg_4_1)
					-- function 4
					arg_4_1:clear_input_buffer()

					return arg_4_1:reset_release_input()
				end
			},
			thorn_wall_target_flip_back = {
				anim_end_event = "thorn_ability_cancel",
				kind = "career_we_thornsister_target_wall",
				weapon_action_hand = "left",
				uninterruptible = true,
				anim_event = "thorn_ability_flip_back",
				anim_end_event_condition_func = function (arg_5_0, arg_5_1)
					-- function 5
					return arg_5_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				target_sim_gravity = num,
				target_sim_speed = num_2,
				target_width = num_3,
				target_thickness = num_4,
				target_bend_angle = wall_bend_angle,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						force_release_input = "action_two_hold",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_career_release",
						input = "action_career_not_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_career_release",
						input = "action_career_release"
					},
					{
						sub_action = "thorn_wall_target_flip",
						start_time = 0.1,
						action = "action_career_hold",
						input = "action_one"
					}
				},
				enter_function = function (arg_6_0, arg_6_1)
					-- function 6
					arg_6_1:clear_input_buffer()

					return arg_6_1:reset_release_input()
				end
			}
		},
		action_two = {
			default = {
				kind = "career_dummy",
				anim_end_event = "ability_finished",
				anim_event = "thorn_ability_cancel",
				weapon_action_hand = "left",
				total_time = 0.21,
				anim_end_event_condition_func = function (arg_7_0, arg_7_1)
					-- function 7
					return arg_7_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {},
				enter_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					-- function 8
					arg_8_1:clear_input_buffer()
					arg_8_1:reset_release_input()
					arg_8_3:change_synced_state(nil, true)
				end
			}
		},
		action_career_release = {
			default = {
				kind = "action_selector",
				weapon_action_hand = "left",
				conditional_actions = {
					{
						sub_action = "thorn_wall",
						action = "spells",
						condition = function (arg_9_0, arg_9_1, arg_9_2)
							-- function 9
							return not arg_9_2 and arg_9_2:get_mode()
						end
					}
				},
				default_action = {
					action = "action_two",
					sub_action = "default"
				}
			}
		},
		spells = {
			thorn_wall = {
				anim_end_event = "ability_finished",
				weapon_action_hand = "left",
				kind = "career_we_thornsister_wall",
				uninterruptible = true,
				anim_event = "thorn_ability_cast",
				total_time = 0.75,
				anim_end_event_condition_func = function (arg_10_0, arg_10_1)
					-- function 10
					return arg_10_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {},
				enter_function = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					-- function 11
					arg_11_1:clear_input_buffer()
					arg_11_1:reset_release_input()
					arg_11_3:change_synced_state(nil, true)
				end
			}
		},
		action_inspect = ActionTemplates.action_inspect
	}
}

tbl.left_hand_unit = ""
tbl.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
tbl.wield_anim = "thorn_ability_start"
tbl.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_thornsister"
tbl.load_state_machine = false
tbl.display_unit = "units/weapons/weapon_display/display_2h_swords_executioner"
tbl.crosshair_style = "default"
tbl.buff_type = "RANGED_ABILITY"
tbl.weapon_type = "RANGED_ABILITY"
tbl.dodge_count = 2
tbl.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

local tbl_2 = {
	"ep_r_index",
	"ep_r_middle",
	"ep_r_ring",
	"ep_r_pinky",
	"ep_r_thumb"
}
local tbl_3 = {
	"ep_l_index",
	"ep_l_middle",
	"ep_l_ring",
	"ep_l_pinky",
	"ep_l_thumb"
}

local function fn(self, arg_12_1)
	-- function 12
	if not self.particle_ids then
		table.clear(self.particle_ids)
	else
		self.particle_ids = {}
	end

	if not self.nodes then
		self.nodes = {}

		local get_first_person_mesh_unit = ScriptUnit.has_extension(arg_12_1, "first_person_system"):get_first_person_mesh_unit()

		for i = 1, #tbl_3 do
			local var_12_1 = tbl_3[i]

			self.nodes[var_12_1] = Unit.node(get_first_person_mesh_unit, var_12_1)
		end

		for j = 1, #tbl_2 do
			local var_12_2 = tbl_2[j]

			self.nodes[var_12_2] = Unit.node(get_first_person_mesh_unit, var_12_2)
		end
	end
end

tbl.synced_states = {
	targeting = {
		enter = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			-- function 13
			if not arg_13_4 then
				return
			end

			fn(arg_13_3, arg_13_1)

			arg_13_3.delay = 0.1
			arg_13_3.spawned = false
		end,
		update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			-- function 14
			if not arg_14_4 then
				return
			end

			if not arg_14_3.spawned then
				return
			end

			arg_14_3.delay = arg_14_3.delay - arg_14_6

			if arg_14_3.delay > 0 then
				return
			end

			arg_14_3.spawned = true

			local get_first_person_mesh_unit = ScriptUnit.extension(arg_14_1, "first_person_system"):get_first_person_mesh_unit()

			for i = 1, #tbl_2 do
				local var_14_1 = arg_14_3.nodes[tbl_2[i]]

				arg_14_3.particle_ids[var_14_1] = ScriptWorld.create_particles_linked(arg_14_5, "fx/magic_thorn_sister_finger_trail", get_first_person_mesh_unit, var_14_1, "destroy")
			end

			for j = 1, #tbl_3 do
				local var_14_2 = arg_14_3.nodes[tbl_3[j]]

				arg_14_3.particle_ids[var_14_2] = ScriptWorld.create_particles_linked(arg_14_5, "fx/magic_thorn_sister_finger_trail", get_first_person_mesh_unit, var_14_2, "destroy")
			end
		end,
		leave = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
			-- function 15
			if not arg_15_4 then
				return
			end

			for k in pairs(arg_15_3.particle_ids) do
				local var_15_0 = arg_15_3.particle_ids[k]

				World.stop_spawning_particles(arg_15_5, var_15_0)
			end
		end
	}
}

return {
	we_thornsister_career_skill_weapon = table.clone(tbl)
}
