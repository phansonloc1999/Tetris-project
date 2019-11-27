---@class GameOverState
GameOverState = Class {__includes = BaseState}

function GameOverState:init()
    self._numOfPlayers = nil

    self._buttons = {}

    self._buttons.restart =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.restart.deselected:getWidth() / 2,
        350,
        function()
            if (self._numOfPlayers == 1) then
                gStateMachine:change(
                    "play",
                    {numOfPlayers = self._numOfPlayers, animal = self._player1.animal, timer = MATCH_TIMER}
                )
            else
                gStateMachine:change(
                    "play",
                    {
                        numOfPlayers = self._numOfPlayers,
                        player1Animal = self._player1.animal,
                        player2Animal = self._player2.animal,
                        timer = MATCH_TIMER
                    }
                )
            end
        end,
        {
            deselected = gTextures.buttons.restart.deselected,
            selected = gTextures.buttons.restart.selected
        },
        "deselected"
    )

    self._buttons.quit =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.menu_quit.deselected:getWidth() / 2,
        self._buttons.restart:getY() + gTextures.buttons.restart.deselected:getHeight() + 10,
        function()
            gStateMachine:change("menu")
        end,
        {
            deselected = gTextures.buttons.menu_quit.deselected,
            selected = gTextures.buttons.menu_quit.selected
        },
        "deselected"
    )
end

function GameOverState:render()
    love.graphics.draw(gTextures.background, WINDOW_WIDTH / 2 - WINDOW_WIDTH / 2)

    local EMOTE_Y = 100

    if (self._numOfPlayers == 1) then
        love.graphics.draw(
            self._player1.textures[self._player1.currentTexture],
            WINDOW_WIDTH / 2 - gTextures.animal_emotes[self._player1.animal].deselected:getWidth() / 2,
            EMOTE_Y
        )

        love.graphics.draw(
            self._player1Score,
            WINDOW_WIDTH / 2 - self._player1Score:getWidth() / 2,
            EMOTE_Y + gTextures.animal_emotes[self._player1.animal].deselected:getWidth() + 80
        )
    else
        love.graphics.draw(
            gTextures.titles.player1,
            WINDOW_WIDTH / 2 - gTextures.animal_emotes[self._player1.animal].deselected:getWidth() / 2 - 80 -
                gTextures.titles.player1:getWidth() / 2,
            EMOTE_Y - 50
        )

        love.graphics.draw(
            self._player1.textures[self._player1.currentTexture],
            WINDOW_WIDTH / 2 - gTextures.animal_emotes[self._player1.animal].deselected:getWidth() - 80,
            EMOTE_Y
        )

        love.graphics.draw(
            self._player1Score,
            WINDOW_WIDTH / 2 - gTextures.animal_emotes[self._player1.animal].deselected:getWidth() / 2 - 80 -
                self._player1Score:getWidth() / 2,
            EMOTE_Y + gTextures.animal_emotes[self._player1.animal].deselected:getWidth() + 50
        )

        love.graphics.draw(
            gTextures.titles.player2,
            WINDOW_WIDTH / 2 + 80 + gTextures.animal_emotes[self._player1.animal].deselected:getWidth() / 2 -
                gTextures.titles.player2:getWidth() / 2,
            EMOTE_Y - 50
        )

        love.graphics.draw(self._player2.textures[self._player2.currentTexture], WINDOW_WIDTH / 2 + 80, EMOTE_Y)

        love.graphics.draw(
            self._player2Score,
            WINDOW_WIDTH / 2 + 80 + gTextures.animal_emotes[self._player2.animal].deselected:getWidth() / 2 -
                self._player2Score:getWidth() / 2,
            EMOTE_Y + gTextures.animal_emotes[self._player2.animal].deselected:getWidth() + 50
        )
    end

    for key, button in pairs(self._buttons) do
        button:render()
    end
end

function GameOverState:update(dt)
    for key, button in pairs(self._buttons) do
        if (button:collidesWithMouse()) then
            button:onSelect()

            if (love.mouse.wasPressed(1)) then
                button:onClick()
            end
        elseif (button._selected) then
            button:onDeselect()
        end
    end
end

function GameOverState:enter(params)
    self._numOfPlayers = params.numOfPlayers
    if (params.numOfPlayers == 1) then
        self._player1Score = love.graphics.newText(gFonts.default, params.score)
        self._player1 = {
            animal = params.animal,
            textures = {normal = gTextures.animal_emotes.cat.deselected},
            currentTexture = "normal"
        }
    else
        love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

        self._player1Score = love.graphics.newText(gFonts.default, params.player1Score)
        self._player1 = {animal = params.player1Animal}
        self._player2Score = love.graphics.newText(gFonts.default, params.player2Score)
        self._player2 = {animal = params.player2Animal}

        if (params.player1Score > params.player2Score) then
            self._player1.textures = {
                normal = gTextures.animal_emotes[self._player1.animal].deselected,
                happy = gTextures.animal_emotes[self._player1.animal].happy
            }
            self._player1.currentTexture = "normal"

            self._player2.textures = {
                normal = gTextures.animal_emotes[self._player2.animal].deselected,
                sad = gTextures.animal_emotes[self._player2.animal].sad
            }
            self._player2.currentTexture = "normal"

            self._player1Animation =
                Timer.every(
                1,
                function()
                    self._player1.currentTexture = self._player1.currentTexture == "normal" and "happy" or "normal"
                end
            )

            self._player2Animation =
                Timer.every(
                1,
                function()
                    self._player2.currentTexture = self._player2.currentTexture == "normal" and "sad" or "normal"
                end
            )
        elseif (params.player1Score < params.player2Score) then
            self._player1.textures = {
                normal = gTextures.animal_emotes[self._player1.animal].deselected,
                sad = gTextures.animal_emotes[self._player1.animal].sad
            }
            self._player1.currentTexture = "normal"

            self._player2.textures = {
                normal = gTextures.animal_emotes[self._player2.animal].deselected,
                happy = gTextures.animal_emotes[self._player2.animal].happy
            }
            self._player2.currentTexture = "normal"

            self._player1Animation =
                Timer.every(
                0.5,
                function()
                    self._player1.currentTexture = self._player1.currentTexture == "normal" and "sad" or "normal"
                end
            )

            self._player2Animation =
                Timer.every(
                0.5,
                function()
                    self._player2.currentTexture = self._player2.currentTexture == "normal" and "happy" or "normal"
                end
            )
        else
            self._player1.textures = {
                normal = gTextures.animal_emotes[self._player1.animal].deselected
            }
            self._player1.currentTexture = "normal"

            self._player2.textures = {
                normal = gTextures.animal_emotes[self._player2.animal].deselected
            }
            self._player2.currentTexture = "normal"
        end
    end
end

function GameOverState:exit()
    if (self._player1Animation and self._player2Animation) then
        self._player1Animation:remove()
        self._player2Animation:remove()
    end
end
