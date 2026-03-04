-- chunkname: @scripts/settings/dlcs/morris/morris_ai_breed_snippets.lua

AiBreedSnippets.on_greed_pinata_spawned = function (arg_1_0, arg_1_1)
	ScriptUnit.extension(arg_1_0, "buff_system"):add_buff("curse_greed_pinata_drops")
end
