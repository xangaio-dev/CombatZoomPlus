local f = CreateFrame("Frame")

-- Valores "Default" (entre 1–34) -- 10 = 1x
local defaults = {
    idle = 11,       -- 1.1x
    mounted = 22,    -- 2.2x
    combat = 26,     -- 2.6x
    instance = 20    -- 2.0x
}

CombatZoomPlusDB = CombatZoomPlusDB or {}

for k,v in pairs(defaults) do
    if CombatZoomPlusDB[k] == nil then
        CombatZoomPlusDB[k] = v
    end
end

local lastState = ""

-- função para alterar o zoom de forma estavel (evita erros)
local function SetZoom(targetZoom)
    SetCVar("cameraDistanceMaxZoomFactor", 2.6) -- desbloqueia o Maxzoom sem ter de correr Macro
    local currentZoom = GetCameraZoom()
    local diff = targetZoom - currentZoom

    if math.abs(diff) < 0.1 then return end

    if diff > 0 then
        CameraZoomOut(math.ceil(diff))
    else
        CameraZoomIn(math.ceil(math.abs(diff)))
    end
end

-- validar se estamos numa instance (dungeon, raid, scenario, PvP, etc.)
local function IsInZoomableInstance()
    local inInstance, instanceType = IsInInstance()
    return inInstance and instanceType ~= "none"
end

-- Get o player State atual
local function GetState()
    if InCombatLockdown() then
        return "combat"
    elseif IsMounted() then
        return "mounted"
    elseif IsInZoomableInstance() then
        return "instance"
    else
        return "idle"
    end
end

--aplica os valores de zoom para cada State
local function UpdateZoom()
    local state = GetState()
    if state == lastState then return end
    lastState = state

    if state == "combat" then
        SetZoom(CombatZoomPlusDB.combat)
    elseif state == "mounted" then
        SetZoom(CombatZoomPlusDB.mounted)
    elseif state == "instance" then
        SetZoom(CombatZoomPlusDB.instance)
    else
        SetZoom(CombatZoomPlusDB.idle)
    end
end

-- Event handler
f:SetScript("OnEvent", function(_, event, arg1)
    if event == "UNIT_AURA" and arg1 ~= "player" then return end
    C_Timer.After(0.1, UpdateZoom)
end)

-- Register events
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterUnitEvent("UNIT_AURA", "player")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")

-- Slash command print functions
local function PrintHelp()
    print("|cff00ff00CombatZoomPlus commands:|r")
    print("|cffffff00/czp help|r - Show this help")
    print("|cffffff00/czp show|r - Show current values")
    print("|cffffff00/czp reset|r - Reset to default values")
    print("|cffffff00/czp idle <value 1–34>|r - Set idle zoom")
    print("|cffffff00/czp mounted <value 1–34>|r - Set mounted zoom")
    print("|cffffff00/czp combat <value 1–34>|r - Set combat zoom")
    print("|cffffff00/czp instance <value 1–34>|r - Set instance zoom")
end

local function PrintCurrentSettings()
    print("|cff00ff00CombatZoomPlus current settings:|r")
    print("|cffffff00Idle:|r", CombatZoomPlusDB.idle)
    print("|cffffff00Mounted:|r", CombatZoomPlusDB.mounted)
    print("|cffffff00Combat:|r", CombatZoomPlusDB.combat)
    print("|cffffff00Instance:|r", CombatZoomPlusDB.instance)
end

-- Slash commands
SLASH_COMBAT_ZOOM_PLUS1 = "/czp"

SlashCmdList["COMBAT_ZOOM_PLUS"] = function(msg)

    msg = msg:lower()

    if msg == "" then
  	print("|cff00ff00CombatZoomPlus:|r Use |cffffff00/czp help|r to show available slash commands")
    PrintCurrentSettings()
        return
    end

    if msg == "help" then
        PrintHelp()
        return
    end

    if msg == "show" then
        PrintCurrentSettings()
        return
    end

    if msg == "reset" then
        for k,v in pairs(defaults) do
            CombatZoomPlusDB[k] = v
        end
        print("|cff00ff00CombatZoomPlus:|r settings reset to default.")
        UpdateZoom()
        return
    end

    local state, value = msg:match("(%S+)%s*(%S*)")
    value = tonumber(value)

    if state and value then
        if CombatZoomPlusDB[state] ~= nil then
            CombatZoomPlusDB[state] = value
            print("|cff00ff00CombatZoomPlus:|r", state, "set to", value)
            UpdateZoom()
        else
            print("|cff00ff00CombatZoomPlus:|r Unknown state.")
            PrintHelp()
        end
    else
        PrintHelp()
    end

end