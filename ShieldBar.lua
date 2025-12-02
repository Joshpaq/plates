local addonTable = select(2, ...)

local ShieldBarMixin = {}

function ShieldBarMixin:UpdateShield()
  print(self.unit .. ".ShieldBar.UpdateShield")

  local totalAbsorbs = UnitGetTotalAbsorbs(self.unit)
  local shieldPercent = 20--totalAbsorbs / UnitHealthMax(unit)
  local healthPercent = 100 --UnitHealth(unit) / UnitHealthMax(unit)

  self.shieldTexture:SetWidth(40)-- :SetValue(shieldPercent, healthPercent)

  if totalAbsorbs > 0 then
    print("HAS ABSORBS")
  end
end

function ShieldBarMixin:Enable(unit)
  self.unit = unit;

  self:RegisterUnitEvent("UNIT_HEALTH", self.unit)
  self:RegisterUnitEvent("UNIT_MAXHEALTH", self.unit)
  self:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", self.unit)

  self:UpdateShield()
end

function ShieldBarMixin:Disable()
  self.unit = nil;

  self:UnregisterEvent("UNIT_HEALTH")
  self:UnregisterEvent("UNIT_MAXHEALTH")
  self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
end


function ShieldBarMixin:OnEvent(event, ...)
  print(self.unit .. "ShieldBar.OnEvent")

  if event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "UNIT_ABSORB_AMOUNT_CHANGED" then
    self:UpdateShield()
  else 
    print("Unhandled ShieldBar Event", self.unit, event)
  end
end

function addonTable.CreateShieldBar(nameplate)
  local shieldBar = CreateFrame("Frame", nil, nameplate) -- TODO: name? JPlates_Nameplate_{{index}}_HealthBar
  shieldBar:SetAllPoints()

  local shieldTexture = shieldBar:CreateTexture(nil, "ARTWORK", nil, 3)
  shieldTexture:SetTexture("Interface\\Buttons\\WHITE8X8")
  shieldTexture:SetAllPoints()
  shieldTexture:SetVertexColor(1, 1, 1)
  shieldTexture:SetSnapToPixelGrid(false)
  shieldTexture:SetTexelSnappingBias(0)

  shieldBar.shieldTexture = shieldTexture

  Mixin(shieldBar, ShieldBarMixin)
  
  shieldBar:SetScript("OnEvent", shieldBar.OnEvent)

  return shieldBar
end