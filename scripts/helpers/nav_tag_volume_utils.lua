-- chunkname: @scripts/helpers/nav_tag_volume_utils.lua

NavTagVolumeUtils = NavTagVolumeUtils or {}

NavTagVolumeUtils.nav_tags_from_position = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = arg_1_4 and LAYER_ID_MAPPING[arg_1_4]
	local var_1_1 = GwNavQueries.tag_volumes_from_position(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_2

	if var_1_1 then
		local var_1_3 = GwNavQueries.nav_tag_volume_count(var_1_1)

		for iter_1_0 = 1, var_1_3 do
			local var_1_4 = GwNavQueries.nav_tag_volume(var_1_1, iter_1_0)
			local var_1_5, var_1_6, var_1_7, var_1_8, var_1_9 = GwNavTagVolume.navtag(var_1_4)

			if not var_1_0 or var_1_0 == var_1_7 then
				var_1_2 = var_1_2 or {}
				var_1_2[#var_1_2 + 1] = {
					is_exclusive = var_1_5,
					color = var_1_6,
					layer_id = var_1_7,
					smart_object_id = var_1_8,
					user_data_id = var_1_9
				}
			end
		end

		GwNavQueries.destroy_query_dynamic_output(var_1_1)
	end

	return var_1_2
end

NavTagVolumeUtils.inside_nav_tag_layer = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = LAYER_ID_MAPPING[arg_2_4]
	local var_2_1 = GwNavQueries.tag_volumes_from_position(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_2

	if var_2_1 then
		local var_2_3 = GwNavQueries.nav_tag_volume_count(var_2_1)

		for iter_2_0 = 1, var_2_3 do
			local var_2_4 = GwNavQueries.nav_tag_volume(var_2_1, iter_2_0)
			local var_2_5, var_2_6, var_2_7, var_2_8, var_2_9 = GwNavTagVolume.navtag(var_2_4)

			if var_2_0 == var_2_7 then
				var_2_2 = true

				break
			end
		end

		GwNavQueries.destroy_query_dynamic_output(var_2_1)
	end

	return var_2_2
end

NavTagVolumeUtils.inside_level_volume_layer = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_1.level_volumes_by_layer[arg_3_3]

	if not var_3_0 then
		return
	end

	for iter_3_0 = 1, #var_3_0 do
		if Level.is_point_inside_volume(arg_3_0, var_3_0[iter_3_0], arg_3_2) then
			return true
		end
	end
end
