local ADDON_NAME = "TurtleOverpowerAlert"

local function Print(msg)
  if DEFAULT_CHAT_FRAME then
    DEFAULT_CHAT_FRAME:AddMessage("|cFF33FF99" .. ADDON_NAME .. "|r: " .. msg)
  end
end

local function IsWarrior()
  local _, class = UnitClass("player")
  return class == "WARRIOR"
end

local function InBattleStance()
  return GetShapeshiftForm() == 1
end

local scanTip = CreateFrame("GameTooltip", "TurtleOverpowerAlertScanTip", UIParent, "GameTooltipTemplate")
scanTip:SetOwner(UIParent, "ANCHOR_NONE")

local function FindOverpowerActionSlot()
  for slot = 1, 120 do
    if HasAction(slot) then
      scanTip:ClearLines()
      scanTip:SetAction(slot)
      local name = TurtleOverpowerAlertScanTipTextLeft1 and TurtleOverpowerAlertScanTipTextLeft1:GetText()
      if name == "Overpower" then
        return slot
      end
    end
  end
  return nil
end

local function ActionReadyAndUsable(slot)
  if not slot then return false end

  local usable = IsUsableAction(slot)
  if not usable then return false end

  local start, duration, enable = GetActionCooldown(slot)
  if enable == 1 and duration and duration > 0 then
    return false
  end

  local inRange = IsActionInRange(slot)
  if inRange == 0 then
    return false
  end

  return true
end

local alert = CreateFrame("Frame", "TurtleOverpowerAlertFrame", UIParent)
alert:SetFrameStrata("HIGH")
alert:SetWidth(600)
alert:SetHeight(80)
alert:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
alert:Hide()

local text = alert:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text:SetPoint("CENTER", alert, "CENTER", 0, 0)
text:SetText("OVERPOWER NOW")
text:SetTextColor(1, 0.82, 0)

local f = CreateFrame("Frame")
local overpowerSlot = nil
local lastShown = false
local elapsed = 0

local function UpdateState()
  if not IsWarrior() then
    if alert:IsShown() then alert:Hide() end
    return
  end

  if not overpowerSlot then
    overpowerSlot = FindOverpowerActionSlot()
    if not overpowerSlot then
      if alert:IsShown() then alert:Hide() end
      return
    end
  end

  local ok = InBattleStance() and ActionReadyAndUsable(overpowerSlot)

  if ok and not lastShown then
    alert:Show()
    lastShown = true
  elseif (not ok) and lastShown then
    alert:Hide()
    lastShown = false
  end
end

f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
f:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
f:RegisterEvent("SPELLS_CHANGED")

f:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGIN" then
    if not IsWarrior() then
      Print("Loaded (not a warrior).")
      return
    end
    overpowerSlot = FindOverpowerActionSlot()
    if overpowerSlot then
      Print("Loaded. Overpower found on action slot " .. overpowerSlot .. ".")
    else
      Print("Loaded. Put Overpower on an action bar to enable alerts.")
    end
  elseif event == "SPELLS_CHANGED" then
    overpowerSlot = FindOverpowerActionSlot()
  end

  UpdateState()
end)

f:SetScript("OnUpdate", function(_, dt)
  elapsed = elapsed + dt
  if elapsed >= 0.10 then
    elapsed = 0
    UpdateState()
  end
end)

SLASH_TURTLEOVERPOWERALERT1 = "/opalert"
SlashCmdList["TURTLEOVERPOWERALERT"] = function(cmd)
  cmd = (cmd or ""):lower()
  if cmd == "scan" then
    overpowerSlot = FindOverpowerActionSlot()
    if overpowerSlot then
      Print("Overpower found on action slot " .. overpowerSlot .. ".")
    else
      Print("Overpower not found. Put it on an action bar and try again.")
    end
  elseif cmd == "test" then
    alert:Show()
  else
    Print("Commands: /opalert scan , /opalert test")
  end
end
