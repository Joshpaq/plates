local addonTable = select(2, ...)

local CreateFrame = CreateFrame
local UnitName = UnitName

--
-- MIXIN
--

local UnitNameTextMixin = {}

function UnitNameTextMixin:UpdateUnitName()
  print(self.unit .. ".UnitNameText.UpdateUnitName")
  self.fontString:SetText(UnitName(self.unit))
end

function UnitNameTextMixin:OnEvent(event)
  print(self.unit .. ".UnitNameText.OnEvent")

  if event == "UNIT_NAME_UPDATE" then
    self:UpdateUnitName()
  else 
    print("Unhandled UnitNameText Event", self.unit, event)
  end
end

function UnitNameTextMixin:Initialize(unit)
  self.unit = unit

  self:RegisterUnitEvent("UNIT_NAME_UPDATE", self.unit)

  self:UpdateUnitName()
end

function UnitNameTextMixin:Deinitialize()
  self:UnregisterAllEvents()
end

--
-- CREATE
--

function addonTable.CreateUnitNameText(parent)
  local unitNameText = CreateFrame("Frame", nil, parent)
  unitNameText:SetAllPoints()

  local fontString = unitNameText:CreateFontString(nil, "ARTWORK")
  fontString:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE") -- TODO: config
  --fontString:SetPoint("LEFT")
  fontString:SetDrawLayer("OVERLAY", 1)

  PixelUtil.SetPoint(fontString, "LEFT", unitNameText, "LEFT", 2, 0)

  unitNameText.fontString = fontString

  Mixin(unitNameText, UnitNameTextMixin)
  unitNameText:SetScript("OnEvent", unitNameText.OnEvent)

  return unitNameText
end
