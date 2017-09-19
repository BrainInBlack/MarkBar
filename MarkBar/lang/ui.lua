-- ColorAlias ->
	COLOR_RED = "|cffff0000";
	COLOR_GREEN = "|cff00ff00";
	COLOR_BLUE = "|cff0000ff";
	COLOR_PURPLE = "|cff700090";
	COLOR_YELLOW = "|cffffff00";
	COLOR_ORANGE = "|cffff6d00";
	COLOR_GREY = "|cff808080";
	COLOR_GOLD = "|cffcfb52b";
	COLOR_WHITE = "|cffffffff";
	COLOR_NEON_BLUE = "|cff4d4dff";
	COLOR_END = "|r";

-- deDE ->
if(GetLocale == "deDE") then

	-- General ->
		MarkBar_FIRSTR_RUN = "Dies ist das erste mal, das Du MarkBar verwendest. Bitte nimm Dir ein wenig Zeit und schau Dir die Einstellungen ein wenig an (/mb config)";
		MarkBar_LOCKED = "Gesperrt";
		MarkBar_UNLOCKED = "Entsperrt";
		MarkBar_UNKNOWN_COMMAND = "Unbekannter Befehl";

	-- Marks ->
		MarkBar_MARK_PARAM_MISSING = "Kein Parameter engegeben. Bitte verwenden /mb mark [MarkNummer].";
		MarkBar_MARK_WRONG_NUMBER = "Ungültige Marknummer. Bitte verwende eine Zahl zwischen 0 und 8";
		MarkBar_MARK_NO_PLAYER = "Ziel ist kein Spieler.";
		MarkBar_MARK_NO_LEAD = "Du bist kein Gruppenleiter, oder Assistent.";
		MarkBar_MARK_NO_PARTY = "Du bist in keiner Gruppe oder Raid.";
		MarkBar_MARK_ALLREADY_SET = " wird schon verwendet. Bitte benutze ein anderes Symbol";
		MarkBar_MARK_PLAYER_ALLREADY_SET = "Dieser Spieler hat schon ";
		MarkBar_MARK_RESET = "PermaMarks gelöscht.";
		MarkBar_MARK_RUN_STOP = "PermaMarks angehalten.";
		MarkBar_MARK_RUN_START = "PermaMarks gestartet.";

	-- RaidTargetAlias ->
		MarkBar_RT = {
			COLOR_YELLOW.."Stern"..COLOR_END,
			COLOR_ORANGE.."Kreis"..COLOR_END,
			COLOR_PURPLE.."Diamand"..COLOR_END,
			COLOR_GREEN.."Dreieck"..COLOR_END,
			COLOR_NEON_BLUE.."Mond"..COLOR_END,
			COLOR_BLUE.."Quadrat"..COLOR_END,
			COLOR_RED.."Kreuz"..COLOR_END,
			COLOR_WHITE.."Totenkopf"..COLOR_END
		}

	-- Tooltips ->
		MarkBar_TIP_START_PERMA_MARK = "Starte PermaMarks";
		MarkBar_TIP_STOP_PERMA_MARK = "Stoppe PermaMarks";
		MarkBar_TIP_RESET_PERMA_MARK = "Lösche PermaMarks";
		MarkBar_TIP_SETTINGS = "MarkBar Einstellungen";
		MarkBar_TIP_CLOSE = "Schließe MarkBar";
		MarkBar_TIP_MARKED = COLOR_WHITE.."Markierter Spieler: "..COLOR_END;
		MarkBar_TIP_UNKNOWN = " (Tot/Offline)";
		MarkBar_TIP_MARK_NOTSET = "Mark ist nicht gesetzt";

-- Default ->
else

	-- General ->
		MarkBar_FIRST_RUN = "This is the first time you use MarkBar. Please take a little time and check out the settings (/mb config).";
		MarkBar_LOCKED = "Locked";
		MarkBar_UNLOCKED = "Unlocked";
		MarkBar_UNKNOWN_COMMAND = "Invalid slashcommand";

	-- Marks ->
		MarkBar_MARK_PARAM_MISSING = "Parameter is missing. Please use /mb mark [MarkNumber] instead.";
		MarkBar_MARK_WRONG_NUMBER = "Invalid marknumber. Use a number in range of 0 to 8.";
		MarkBar_MARK_NO_PLAYER = "Target is no player.";
		MarkBar_MARK_NO_LEAD = "You must be raidofficer at least.";
		MarkBar_MARK_NO_PARTY = "You must be in a party or raid.";
		MarkBar_MARK_ALLREADY_SET = " is allready set. Please use another one.";
		MarkBar_MARK_PLAYER_ALLREADY_SET = "This player is allready assinged to ";
		MarkBar_MARK_RESET = "PermaMarks deleted.";
		MarkBar_MARK_RUN_STOP = "PermaMarks stopped.";
		MarkBar_MARK_RUN_START = "PermaMarks started";

	-- RaidTargetAlias ->
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

	-- Tooltips ->
		MarkBar_TIP_START_PERMA_MARK = "Start PermaMarks";
		MarkBar_TIP_STOP_PERMA_MARK = "Stop PermaMarks";
		MarkBar_TIP_RESET_PERMA_MARK = "Delete PermaMarks";
		MarkBar_TIP_SETTINGS = "MarkBar Settings";
		MarkBar_TIP_CLOSE = "Close MarkBar";
		MarkBar_TIP_MARKED = COLOR_WHITE.."Marked player: "..COLOR_END;
		MarkBar_TIP_UNKNOWN = " (Dead/Offline)";
		MarkBar_TIP_MARK_NOTSET = "Mark not set";

end