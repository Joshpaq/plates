local addonTable = select(2, ...)

local SetHeight = PixelUtil.SetHeight
local SetPoint = PixelUtil.SetPoint
local SetWidth = PixelUtil.SetWidth

local HealthBarBorderMixin = {}

function HealthBarBorderMixin:SetSize(size, minimumPixels)--, upwardExtendingSize, upwardExtendingSizeMinimumPixels)
  SetWidth(self.left, size, minimumPixels)
  SetPoint(self.left, "TOPRIGHT", self, "TOPLEFT", 0, size, 0, minimumPixels)--upwardExtendingSize, 0, upwardExtendingSizeMinimumPixels)
  SetPoint(self.left, "BOTTOMRIGHT", self, "BOTTOMLEFT", 0, -size, 0, minimumPixels)

  SetWidth(self.right, size, minimumPixels)
  SetPoint(self.right, "TOPLEFT", self, "TOPRIGHT", 0, size, 0, minimumPixels) --upwardExtendingSize, 0, upwardExtendingSizeMinimumPixels)
  SetPoint(self.right, "BOTTOMLEFT", self, "BOTTOMRIGHT", 0, -size, 0, minimumPixels)

  SetHeight(self.top, size, minimumPixels)
  SetPoint(self.top, "BOTTOMLEFT", self, "TOPLEFT", 0, 0)
  SetPoint(self.top, "BOTTOMRIGHT", self, "TOPRIGHT", 0, 0)

  SetHeight(self.bottom, size, minimumPixels)
  SetPoint(self.bottom, "TOPLEFT", self, "BOTTOMLEFT", 0, 0)
  SetPoint(self.bottom, "TOPRIGHT", self, "BOTTOMRIGHT", 0, 0)
end

function HealthBarBorderMixin:SetColor(r, g, b, a)
  self.left:SetColorTexture(r, g, b, a)
  self.right:SetColorTexture(r, g, b, a)
  self.top:SetColorTexture(r, g, b, a)
  self.bottom:SetColorTexture(r, g, b, a)
end

function HealthBarBorderMixin:OnPlayerTargetChanged()
  print(self.unit .. "HealthBarBorder.OnPlayerTargetChanged")

  local isTarget = UnitIsUnit("target", self.unit)
  if isTarget and not self.isTarget then
    self:SetColor(1, 1, 1, 1)
    self:SetSize(1.5, 2)
    self.isTarget = true
  elseif not isTarget and self.isTarget then
    self:SetColor(0, 0, 0, 1)
    self:SetSize(.5, 1)
    self.isTarget = false
  else 
    --print("DO NOTHING")
  end
end 

function HealthBarBorderMixin:OnEvent(event)
    print(self.unit .. ".HealthBarBorder.OnEvent")

  if event == "PLAYER_TARGET_CHANGED" then
    self:OnPlayerTargetChanged()
  else 
    print("Unhandled HealthBarBorder Event", self.unit, event)
  end
end

function HealthBarBorderMixin:Initialize(unit)
  self.unit = unit

  self:RegisterUnitEvent("PLAYER_TARGET_CHANGED")

  self:SetColor(0, 0, 0, 1)
  self:SetSize(.5, 1)

  self:OnPlayerTargetChanged()
end

function HealthBarBorderMixin:Deinitialize()
  self:UnregisterAllEvents()
end

function addonTable.CreateHealthBarBorder(plate)
  local borderFrame = CreateFrame("Frame", nil, plate, "BackdropTemplate")
  borderFrame:SetAllPoints()
  borderFrame:SetIgnoreParentScale(true)

  local left = borderFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
  local right = borderFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
  local top = borderFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
  local bottom = borderFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
  
  borderFrame.left = left
  borderFrame.right = right
  borderFrame.top = top
  borderFrame.bottom = bottom

  Mixin(borderFrame, HealthBarBorderMixin)
  borderFrame:SetScript("OnEvent", borderFrame.OnEvent)

  return borderFrame
end