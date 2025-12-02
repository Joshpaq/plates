local addonTable = select(2, ...)

local Scale = addonTable.Scale

local NameTextMixin = {}

function NameTextMixin:OnUnitNameUpdate()
  self.fontString:SetText(UnitName(self.unit))
end

function NameTextMixin:Enable(unit)
  self.unit = unit;

  self:RegisterUnitEvent("UNIT_NAME_UPDATE", self.unit)

  self:OnUnitNameUpdate()
end

function NameTextMixin:Disable()
  self.unit = nil;

  self:UnregisterEvent("UNIT_NAME_UPDATE")
end


function NameTextMixin:OnEvent(event, ...)
  if event == "UNIT_NAME_UPDATE" then
      self:OnUnitNameUpdate()
  end
end

function addonTable.CreateNameText(nameplate)
  local nameText = CreateFrame("Frame", nil, nameplate)
  nameText:SetAllPoints()

  local fontString = nameText:CreateFontString(nil, "ARTWORK")
  fontString:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE") -- TODO: config
  fontString:SetPoint("LEFT", nameText, "LEFT", Scale(2), 0)--Scale(2), 0)
  --PixelUtil.SetPoint(fontString, "LEFT", unitNameText, "LEFT", 2, 0)
  fontString:SetDrawLayer("OVERLAY", 1)

  nameText.fontString = fontString

  Mixin(nameText, NameTextMixin)

  nameText:SetScript("OnEvent", nameText.OnEvent)

  return nameText
end