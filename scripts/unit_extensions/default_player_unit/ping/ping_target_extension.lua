-- chunkname: @scripts/unit_extensions/default_player_unit/ping/ping_target_extension.lua

PingTargetExtension = class(PingTargetExtension)

PingTargetExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._unit = arg_1_2
	self._pinged = 0
	self._outline_ids = {}

	if arg_1_3.always_pingable == nil then
		self.always_pingable = Unit.get_data(arg_1_2, "ping_data", "always_pingable")
	else
		self.always_pingable = arg_1_3.always_pingable
	end
end

PingTargetExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._outline_extension = ScriptUnit.has_extension(arg_2_2, "outline_system")
	self._buff_extension = ScriptUnit.has_extension(arg_2_2, "buff_system")
	self._locomotion_extension = ScriptUnit.has_extension(arg_2_2, "locomotion_system")
end

PingTargetExtension.set_pinged = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local _unit = self._unit

	arg_3_4 = arg_3_4 ~= nil or not true or arg_3_4

	if not arg_3_1 then
		self._pinged = self._pinged + 1
	else
		self._pinged = self._pinged - 1
	end

	if not self._outline_extension then
		if not arg_3_4 then
			if not arg_3_1 then
				local shallow_copy = table.shallow_copy(OutlineSettings.templates.ping_unit, true)

				shallow_copy.method = self._outline_extension.pinged_method

				local add_outline = self._outline_extension:add_outline(shallow_copy)

				self._outline_ids[arg_3_3] = add_outline
			else
				local var_3_3 = self._outline_ids[arg_3_3]

				self._outline_extension:remove_outline(var_3_3)

				self._outline_ids[arg_3_3] = nil
			end
		end

		if not arg_3_1 then
			self:_add_witch_hunter_buff(arg_3_3)
		end
	end

	if not Unit.alive(_unit) then
		if not Unit.get_data(_unit, "breed") then
			local has_extension = ScriptUnit.has_extension(_unit, "proximity_system")

			if not has_extension then
				has_extension.has_been_seen = true
			end
		end

		local has_extension_2 = ScriptUnit.has_extension(arg_3_3, "buff_system")

		if not has_extension_2 then
			has_extension_2:trigger_procs("on_pinged", _unit, arg_3_3, arg_3_1)
		end

		Managers.state.event:trigger_referenced(_unit, "on_pinged", arg_3_3, arg_3_1)
	end
end

PingTargetExtension.pinged = function (self)
	-- function 4
	return self._pinged > 0
end

PingTargetExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	return
end

PingTargetExtension.destroy = function (arg_6_0)
	-- function 6
	return
end

PingTargetExtension._add_witch_hunter_buff = function (self, arg_7_1)
	-- function 7
	if not Managers.state.network.is_server then
		return
	end

	local _buff_extension = self._buff_extension

	if not _buff_extension then
		local str = "defence_debuff_enemies"
		local var_7_2 = Managers.state.side.side_by_unit[arg_7_1]

		if not var_7_2 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_7_2.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for i = 1, count do
			local var_7_5 = PLAYER_AND_BOT_UNITS[i]
			local has_extension = ScriptUnit.has_extension(var_7_5, "career_system")
			local has_extension_2 = ScriptUnit.has_extension(var_7_5, "talent_system")

			if (not has_extension and has_extension:career_name()) == "wh_captain" then
				_buff_extension:add_buff(str)

				if not has_extension_2:has_talent("victor_witchhunter_improved_damage_taken_ping") then
					_buff_extension:add_buff("victor_witchhunter_improved_damage_taken_ping")
				end
			end
		end
	end
end
