-- AABB collision check
function checkCollision(x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

-- Keyboard input handler
function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

-- Mouse input handler
function love.mousepressed(x, y, button, istouch, presses)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

-- Merge 2 tables (with numeric keys)
function table.merge(destination, source)
    for i = 1, #source do
        table.insert(destination, source[i])
    end
end