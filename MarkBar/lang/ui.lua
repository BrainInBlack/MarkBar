-- ColorAlias ->
	COLOR_RED = "|cffff0000";
	COLOR_GREEN = "|cff00ff00";
	COLOR_BLUE = "|cff3333ff";
	COLOR_PURPLE = "|cff700090";
	COLOR_YELLOW = "|cffffff00";
	COLOR_ORANGE = "|cffff6d00";
	COLOR_GREY = "|cff808080";
	COLOR_GOLD = "|cffcfb52b";
	COLOR_WHITE = "|cffffffff";
	COLOR_NEON_BLUE = "|cff5d5dff";
	COLOR_END = "|r";

	COLOR_CLASS = {
		DEATHKNIGHT = "|cffc41f3b",
		DRUID = "|cffff7d0a",
		HUNTER = "|cffabd473",
		MAGE = "|cff69ccf0",
		PALADIN = "|cfff58cba",
		PRIEST = "|cffffffff",
		ROGUE = "|cfffff569",
		SHAMAN = "|cff0070de",
		WARLOCK = "|cff9482c9",
		WARRIOR = "|cffc79c6e"
	}

-- enGB/enUS (default) ->

	-- General ->
		MarkBar_GENERAL_FIRST_RUN = "This is the first time you use MarkBar. Please take a little time and check out the settings (/mb config)."; -- OK
		MarkBar_GENERAL_WELCOME_PART1 = "Welcome to ";
		MarkBar_GENERAL_WELCOME_PART2 = "  by ";

	-- Error ->
		MarkBar_ERROR_CONFIG_LOAD = "MarkBarConfig is disabled or out of date.";
		MarkBar_ERROR_NO_PARTY = "You must be in a party or raid.";

	-- Toolbar ->
		MarkBar_TOOLBAR_LOCKED = "Locked";
		MarkBar_TOOLBAR_UNLOCKED = "Unlocked";

	-- Command ->
		MarkBar_COMMAND_UNKNOWN = "Unknown command";
		MarkBar_COMMAND_MARK_INVALID = "Invalid mark number. Use a range 0-8";
		MarkBar_COMMAND_MARK_MISSING = "Missing argument. Use /mb mark [0-8].";
		MarkBar_COMMAND_PMARK_DELETE = "PermaMarks deleted.";
		MarkBar_COMMAND_PMARK_START = "PermaMarking started.";
		MarkBar_COMMAND_PMARK_STOP = "PermaMarks stopped.";

	-- Marks ->
		MarkBar_MARK_NO_LEADER = "You must at least be raid assistant.";
		MarkBar_MARK_ALREADY_SET_TO = " is already set to ";
		MarkBar_MARK_PLAYER_ALREADY_SET_TO = " is already set to ";
		MarkBar_MARK_TARGET_NOT_IN_RAID = " is not in your party/raid.";
		MarkBar_MARK_TARGET_NO_PLAYER = " is not a player.";

	-- Tooltips ->
		MarkBar_TOOLTIP_SETTINGS = "Settings";
		MarkBar_TOOLTIP_SETTINGS_HINT = "Leftclick: "..COLOR_WHITE.."Open Settings"..COLOR_END;

		MarkBar_TOOLTIP_CLOSE = "Close";
		MarkBar_TOOLTIP_CLOSE_HINT = "Leftclick: "..COLOR_WHITE.."Hide Toolbar"..COLOR_END;

		MarkBar_TOOLTIP_PMARK_ASSIGNED_TO = "Assigned to: ";
		MarkBar_TOOLTIP_PMARK_OFFLINE = " (Offline)";
		MarkBar_TOOLTIP_PMARK_HINT_SOLO = "Leftclick: "..COLOR_WHITE.."Set Mark"..COLOR_END;
		MarkBar_TOOLTIP_PMARK_HINT_RAID = "Rightclick: "..COLOR_WHITE.."Set PermaMark"..COLOR_END;
		MarkBar_TOOLTIP_PMARK_HINT_NO_LEADER = "You must at least be raid assistant.";
		MarkBar_TOOLTIP_PMARK_START = "Start";
		MarkBar_TOOLTIP_PMARK_START_HINT = "Leftclick: "..COLOR_WHITE.."Do the magic!"..COLOR_END;
		MarkBar_TOOLTIP_PMARK_STOP = "Stop";
		MarkBar_TOOLTIP_PMARK_STOP_HINT = "Leftclick: "..COLOR_WHITE.."Stop the magic!"..COLOR_END;
		MarkBar_TOOLTIP_PMARK_DELETE = "Delete";
		MarkBar_TOOLTIP_PMARK_DELETE_HINT = "Leftclick: "..COLOR_WHITE.."Delete all PermaMarks"..COLOR_END;
		MarkBar_TOOLTIP_PMARK_PROFILE = "Profiles";
		MarkBar_TOOLTIP_PMARK_PROFILE_HINT = "Not yet available!";

	-- RaidTargets ->
		MarkBar_RT = {
			COLOR_YELLOW.."Star"..COLOR_END,
			COLOR_ORANGE.."Circle"..COLOR_END,
			COLOR_PURPLE.."Diamond"..COLOR_END,
			COLOR_GREEN.."Triangle"..COLOR_END,
			COLOR_NEON_BLUE.."Moon"..COLOR_END,
			COLOR_BLUE.."Square"..COLOR_END,
			COLOR_RED.."Cross"..COLOR_END,
			COLOR_WHITE.."Skull"..COLOR_END
		}