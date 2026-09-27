-- chunkname: @scripts/settings/dlcs/woods/action_career_we_thornsister_wall.lua

ActionCareerWEThornsisterWall = class(ActionCareerWEThornsisterWall, ActionBase)

local str = "thornsister_thorn_wall_unit"
local num = 0.1
local num_2 = 0.05
local num_3 = 0.5

ActionCareerWEThornsisterWall.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerWEThornsisterWall.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._wall_index = 0
end

ActionCareerWEThornsisterWall.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerWEThornsisterWall.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local var_2_0 = arg_2_3
	local num_segments

	if not var_2_0 then
		num_segments = var_2_0.num_segments

		if not num_segments then
			-- Nothing
		end
	end

	num_segments = 0

	::label_2_0::

	if num_segments > 0 then
		self:_play_vo()

		local unbox = var_2_0.position:unbox()
		local unbox_2 = var_2_0.rotation:unbox()
		local segments = var_2_0.segments
		local str = "we_thornsister_career_skill_wall_explosion"
		local num_3 = 1
		local career_extension = self.career_extension
		local get_career_power_level = career_extension:get_career_power_level()
		local system = Managers.state.entity:system("area_damage_system")

		if not self.talent_extension:has_talent("kerillian_thorn_sister_debuff_wall") then
			if not self.talent_extension:has_talent("kerillian_thorn_sister_double_poison") then
				str = "we_thornsister_career_skill_explosive_wall_explosion_improved"
			else
				str = "we_thornsister_career_skill_explosive_wall_explosion"
			end
		elseif not self.talent_extension:has_talent("kerillian_thorn_sister_wall_push") then
			str = nil
		end

		if not str then
			self:_spawn_wall(num_segments, segments, unbox_2)
			system:create_explosion(self.owner_unit, unbox, unbox_2, str, num_3, "career_ability", get_career_power_level, false)
		else
			local str_2 = "thornsister_thorn_wall_push"
			local var_2_11 = NetworkLookup.damage_wave_templates[str_2]
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(self.owner_unit)
			local forward = Quaternion.forward(unbox_2)
			local right = Quaternion.right(unbox_2)
			local tbl = {}

			for i = 1, num_segments do
				tbl[i] = segments[i]:unbox() + forward * (math.random() * num * 2 - num) + right * (math.random() * num_2 * 2 - num_2)
			end

			local _get_next_wall_index = self:_get_next_wall_index()

			network.network_transmit:send_rpc_server("rpc_create_thornsister_push_wave", unit_game_object_id, POSITION_LOOKUP[self.owner_unit], unbox, var_2_11, get_career_power_level, tbl, _get_next_wall_index)
		end

		career_extension:start_activated_ability_cooldown()
	end
end

ActionCareerWEThornsisterWall.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

ActionCareerWEThornsisterWall.finish = function (self, arg_4_1)
	-- function 4
	self.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerWEThornsisterWall._play_vo = function (self)
	-- function 5
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

ActionCareerWEThornsisterWall._get_next_wall_index = function (self)
	-- function 6
	local num = self._wall_index % 16 + 1

	self._wall_index = num

	return num
end

ActionCareerWEThornsisterWall._spawn_wall = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local _get_next_wall_index = self:_get_next_wall_index()
	local owner_unit = self.owner_unit
	local forward = Quaternion.forward(arg_7_3)
	local right = Quaternion.right(arg_7_3)

	for i = 1, arg_7_1 do
		local unbox = arg_7_2[i]:unbox()
		local var_7_5 = arg_7_3
		local num_3 = unbox + forward * (math.random() * num * 2 - num) + right * (math.random() * num_2 * 2 - num_2)

		Managers.state.unit_spawner:request_spawn_template_unit(str, num_3, var_7_5, owner_unit, _get_next_wall_index, i)
	end
end
