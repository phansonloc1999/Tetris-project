require("src/Dependencies")

function love.load()
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

    gStateMachine =
        StateMachine {
        ["title-screen"] = function()
            return TitleScreenState()
        end,
        ["menu"] = function()
            return MenuState()
        end,
        ["select-mode"] = function()
            return SelectModeState()
        end,
        ["select-animal"] = function()
            return SelectAnimalState()
        end,
        ["play"] = function()
            return PlayState()
        end,
        ["pause"] = function()
            return PauseState()
        end,
        ["game_over"] = function()
            return GameOverState()
        end,
        ["option"] = function()
            return OptionState()
        end,
        ["about"] = function()
            return AboutState()
        end
    }
    gStateMachine:change("title-screen")

    gGamePaused = false

    gFPSCounter = love.graphics.newText(gFonts.small)

    gSettingsButtons = {}
    gSettingsButtons.sound = {
        x = 0,
        y = WINDOW_HEIGHT - gTextures.buttons.music.on:getWidth(),
        current = "on",
        textures = {
            off = gTextures.buttons.sound.off,
            on = gTextures.buttons.sound.on
        },
        onClick = function()
            if (gSettingsButtons.sound.current == "off") then
                AudioManager.unmuteSound()
            else
                AudioManager.muteSound()
            end
            gSettingsButtons.sound.current = gSettingsButtons.sound.current == "off" and "on" or "off"
        end
    }

    gSettingsButtons.music = {
        x = gSettingsButtons.sound.x + gTextures.buttons.sound.off:getWidth() + 5,
        y = gSettingsButtons.sound.y,
        current = "on",
        textures = {
            off = gTextures.buttons.music.off,
            on = gTextures.buttons.music.on
        },
        onClick = function()
            if (gSettingsButtons.music.current == "off") then
                AudioManager.unmuteMusic()
            else
                AudioManager.muteMusic()
            end
            gSettingsButtons.music.current = gSettingsButtons.music.current == "off" and "on" or "off"
        end
    }
end

function love.draw()
    gStateMachine:render()

    for key, button in pairs(gSettingsButtons) do
        love.graphics.draw(button.textures[button.current], button.x, button.y)
    end
end

function love.update(dt)
    if dt < 1 / (CAPPED_FPS / 2) then
        love.timer.sleep(1 / (CAPPED_FPS / 2) - dt)
    end

    if (not gGamePaused) then
        if (gStateMachine.current._name ~= "Pause State") then
            Timer.update(dt)
        end

        --- Game logic update code here
        gStateMachine:update(dt)

        for key, button in pairs(gSettingsButtons) do
            if
                (checkCollision(
                    button.x,
                    button.y,
                    button.textures.on:getWidth(),
                    button.textures.on:getHeight(),
                    love.mouse.getX(),
                    love.mouse.getY(),
                    1,
                    1
                ) and love.mouse.wasPressed(1))
             then
                button.onClick()
            end
        end
    end

    if (love.keyboard.wasPressed("p")) then
        gGamePaused = not gGamePaused
    end

    -- Reset input
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end
