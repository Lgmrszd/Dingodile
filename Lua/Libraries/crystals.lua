local maxhp=4
Crystal = {}

function Crystal:New()
  local obj = {}
  obj.hp = maxhp
  obj.sprite = 'crystals/crystal_'..tostring(1+maxhp-obj.hp)
  obj.already_got_hurt = false
  obj.destroyed = false
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Crystal:SetSprite(spritename)
  self.sprite = spritename
end

function Crystal:GotHurt()
  if not self.already_got_hurt then
    self.hp = self.hp - 1
    DEBUG(self.hp)
    self.already_got_hurt = true
    self.sprite = 'crystals/crystal_'..tostring(1+maxhp-self.hp)
    if self.hp == 0 then
      self.destroyed = true
    end
    return self.destroyed, true, self.sprite
  else
    return self.destroyed, false, self.sprite
  end
end

function Crystal:EraseGotHurt()
  if not self.destroyed then
    self.already_got_hurt = false
  end
end

ShadowCrystal = {}
