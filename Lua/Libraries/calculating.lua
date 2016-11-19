function angleFromVector(x,y)
  local angle = math.atan(y/x)
  if x < 0 then
    angle = angle + math.pi
  end
  return angle
end
