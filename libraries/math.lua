function lerp(a, b, x) return a + ((b - a) * x) end

function approach(a, b, x)
  if (a < b) then
    return math.min(a + x, b)
  else
    return math.max(a - x, b)
  end
end

function rand_from(a, b)
  local diff = b - a
  return a + math.random(diff)
end

function clamp(val, lw, up)
    if lw > up then lw, up = up, lw end
    return math.max(lw, math.min(up, val))
end

function rot_x(rotation) return math.cos(math.rad(rotation)) end

function rot_y(rotation) return -math.sin(math.rad(rotation)) end

function get_direction(x1, y1, x2, y2)
  local dir = {}
  local d = call_function("point_direction", {x1, y1, x2, y2})
  dir.x = rot_x(d)
  dir.y = rot_y(d)
  return dir
end

function sign(number)
  return number > 0 and 1 or (number == 0 and 0 or -1)
end

function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end