-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combat_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCombatIdleAction = class(BTCombatIdleAction, BTNode)

BTCombatIdleAction.init = function (arg_1_0, ...)
	-- function 1
	BTCombatIdleAction.super.init(arg_1_0, ...)
end

BTCombatIdleAction.name = "BTCombatIdleAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTCombatIdleAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self:_check_if_should_idle(arg_3_1, arg_3_2)
	arg_3_2.navigation_extension:set_enabled(true)
end

BTCombatIdleAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.combat_idling = nil
end

local num = 0.0001

BTCombatIdleAction._check_if_should_idle = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_2.combat_idling then
		local locomotion_extension = arg_5_2.locomotion_extension

		if Vector3.length_squared(locomotion_extension:current_velocity()) < num then
			arg_5_2.combat_idling = true

			self:_init_idle_anim(arg_5_1, arg_5_2)
		end
	end
end

BTCombatIdleAction._init_idle_anim = function (self, arg_6_1, arg_6_2)
	-- function 6
	local network = Managers.state.network
	local str = "idle"
	local action_data = self._tree_node.action_data

	arg_6_2.action = action_data

	if not action_data and not action_data.alerted_anims and not arg_6_2.confirmed_player_sighting then
		str = action_data.alerted_anims[math.random(1, #action_data.alerted_anims)]
	elseif not action_data and not action_data.idle_animation then
		str = fn(action_data.idle_animation)
	elseif not (not arg_6_2.is_passive and arg_6_2.spawn_type == "horde" or arg_6_2.spawn_type == "horde_hidden") then
		if not action_data and not action_data.animations then
			local animations = action_data.animations
			local num = action_data.anim_cycle_index % #animations + 1

			str = animations[num]
			action_data.anim_cycle_index = num
		end
	elseif not action_data and not action_data.combat_animations then
		local combat_animations = action_data.combat_animations
		local num_2 = action_data.anim_cycle_index % #combat_animations + 1

		str = combat_animations[num_2]
		action_data.anim_cycle_index = num_2
	end

	local optional_spawn_data = arg_6_2.optional_spawn_data
	local flag = not optional_spawn_data and optional_spawn_data.idle_animation

	if not (not flag and flag == "") then
		str = flag
	end

	if arg_6_2.move_state ~= "idle" or not action_data or not action_data.force_idle_animation then
		network:anim_event(arg_6_1, str)

		arg_6_2.move_state = "idle"
	end

	arg_6_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

local alive = Unit.alive

BTCombatIdleAction.run = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	self:_check_if_should_idle(arg_7_1, arg_7_2)

	local target_unit = arg_7_2.target_unit

	if not alive(target_unit) then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, target_unit)

		arg_7_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	end

	return "running"
end
