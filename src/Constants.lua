WINDOW_WIDTH, WINDOW_HEIGHT = 500, 500

math.randomseed(os.time())

gFonts = {
    small = love.graphics.newFont(12),
    medium = love.graphics.newFont(20),
    large = love.graphics.newFont(30),
    default = love.graphics.setNewFont("assets/font/arcadeclassic.ttf", 36),
    default_small = love.graphics.newFont("assets/font/arcadeclassic.ttf", 28)
}

gTextures = {
    buttons = {
        go = {
            selected = love.graphics.newImage("assets/buttons/title screen/go selected.png"),
            deselected = love.graphics.newImage("assets/buttons/title screen/go deselected.png")
        },
        quit = {
            selected = love.graphics.newImage("assets/buttons/title screen/quit selected.png"),
            deselected = love.graphics.newImage("assets/buttons/title screen/quit deselected.png")
        },
        start = {
            selected = love.graphics.newImage("assets/buttons/start selected.png"),
            deselected = love.graphics.newImage("assets/buttons/start deselected.png")
        },
        about = {
            selected = love.graphics.newImage("assets/buttons/about selected.png"),
            deselected = love.graphics.newImage("assets/buttons/about deselected.png")
        },
        option = {
            selected = love.graphics.newImage("assets/buttons/option selected.png"),
            deselected = love.graphics.newImage("assets/buttons/option deselected.png")
        },
        menu_quit = {
            selected = love.graphics.newImage("assets/buttons/quit selected.png"),
            deselected = love.graphics.newImage("assets/buttons/quit deselected.png")
        },
        oneplayer = {
            deselected = love.graphics.newImage("assets/buttons/1 player deselected.png"),
            selected = love.graphics.newImage("assets/buttons/1 player selected.png")
        },
        twoplayer = {
            deselected = love.graphics.newImage("assets/buttons/2 players deselected.png"),
            selected = love.graphics.newImage("assets/buttons/2 players selected.png")
        },
        back = {
            deselected = love.graphics.newImage("assets/buttons/back deselected.png"),
            selected = love.graphics.newImage("assets/buttons/back selected.png")
        },
        dog = {
            deselected = love.graphics.newImage("assets/buttons/dog deselected.png"),
            selected = love.graphics.newImage("assets/buttons/dog selected.png")
        },
        cat = {
            deselected = love.graphics.newImage("assets/buttons/cat deselected.png"),
            selected = love.graphics.newImage("assets/buttons/cat selected.png")
        },
        next = {
            deselected = love.graphics.newImage("assets/buttons/next deselected.png"),
            selected = love.graphics.newImage("assets/buttons/next selected.png")
        },
        prev = {
            deselected = love.graphics.newImage("assets/buttons/previous deselected.png"),
            selected = love.graphics.newImage("assets/buttons/previous selected.png")
        },
        ok = {
            deselected = love.graphics.newImage("assets/buttons/ok deselected.png"),
            selected = love.graphics.newImage("assets/buttons/ok selected.png")
        },
        reset = {
            deselected = love.graphics.newImage("assets/buttons/reset deselected.png"),
            selected = love.graphics.newImage("assets/buttons/reset selected.png")
        },
        pause = {
            deselected = love.graphics.newImage("assets/buttons/pause deselected.png"),
            selected = love.graphics.newImage("assets/buttons/pause selected.png")
        },
        restart = {
            deselected = love.graphics.newImage("assets/buttons/restart deselected.png"),
            selected = love.graphics.newImage("assets/buttons/restart selected.png")
        },
        music = {
            off = love.graphics.newImage("assets/buttons/music off.png"),
            on = love.graphics.newImage("assets/buttons/music on.png")
        },
        sound = {
            off = love.graphics.newImage("assets/buttons/sound off.png"),
            on = love.graphics.newImage("assets/buttons/sound on.png")
        }
    },
    titles = {
        menu = love.graphics.newImage("assets/titles/menu.png"),
        mode = love.graphics.newImage("assets/titles/game mode.png"),
        animalselect = love.graphics.newImage("assets/titles/animal select.png"),
        win = love.graphics.newImage("assets/titles/win.png"),
        lose = love.graphics.newImage("assets/titles/lose.png"),
        player1 = love.graphics.newImage("assets/game over/player 1.png"),
        player2 = love.graphics.newImage("assets/game over/player 2.png"),
        option = love.graphics.newImage("assets/titles/option.png"),
        about = love.graphics.newImage("assets/titles/about.png")
    },
    pet_emotes = {
        pet1 = {
            selected = love.graphics.newImage("assets/menu/pet 1 selected.png"),
            deselected = love.graphics.newImage("assets/menu/pet 1 deselected.png")
        },
        pet2 = {
            selected = love.graphics.newImage("assets/menu/pet 2 selected.png"),
            deselected = love.graphics.newImage("assets/menu/pet 2 deselected.png")
        }
    },
    mode_emotes = {
        oneplayer = {
            deselected = love.graphics.newImage("assets/select mode/1 player deselected.png"),
            selected = love.graphics.newImage("assets/select mode/1 player selected.png")
        },
        twoplayer = {
            deselected = love.graphics.newImage("assets/select mode/2 players deselected.png"),
            selected = love.graphics.newImage("assets/select mode/2 players selected.png")
        }
    },
    animal_emotes = {
        dog = {
            deselected = love.graphics.newImage("assets/select animal/1 player pet 1 deselected.png"),
            selected = love.graphics.newImage("assets/select animal/1 player pet 1 selected.png"),
            happy = love.graphics.newImage("assets/game over/dog happy.png"),
            sad = love.graphics.newImage("assets/game over/dog sad.png")
        },
        cat = {
            deselected = love.graphics.newImage("assets/select animal/1 player pet 2 deselected.png"),
            selected = love.graphics.newImage("assets/select animal/1 player pet 2 selected.png"),
            happy = love.graphics.newImage("assets/game over/cat happy.png"),
            sad = love.graphics.newImage("assets/game over/cat sad.png")
        }
    },
    blocks = {
        cat = {
            L1 = love.graphics.newImage("assets/blocks/cat/L.png"),
            L2 = love.graphics.newImage("assets/blocks/cat/L.png"),
            I = love.graphics.newImage("assets/blocks/cat/I.png"),
            O = love.graphics.newImage("assets/blocks/cat/O.png"),
            T = love.graphics.newImage("assets/blocks/cat/T.png"),
            Z1 = love.graphics.newImage("assets/blocks/cat/Z.png"),
            Z2 = love.graphics.newImage("assets/blocks/cat/Z.png")
        },
        dog = {
            L1 = love.graphics.newImage("assets/blocks/dog/L.png"),
            L2 = love.graphics.newImage("assets/blocks/dog/L.png"),
            I = love.graphics.newImage("assets/blocks/dog/I.png"),
            O = love.graphics.newImage("assets/blocks/dog/O.png"),
            T = love.graphics.newImage("assets/blocks/dog/T.png"),
            Z = love.graphics.newImage("assets/blocks/dog/Z.png"),
            Z1 = love.graphics.newImage("assets/blocks/dog/Z.png"),
            Z2 = love.graphics.newImage("assets/blocks/dog/Z.png")
        }
    },
    preview_blocks = {
        L = love.graphics.newImage("assets/preview blocks/L.png"),
        I = love.graphics.newImage("assets/preview blocks/I.png"),
        O = love.graphics.newImage("assets/preview blocks/O.png"),
        T = love.graphics.newImage("assets/preview blocks/T.png"),
        Z = love.graphics.newImage("assets/preview blocks/Z.png")
    },
    score_boards = {
        one_player = love.graphics.newImage("assets/score boards/one player.png"),
        p1 = love.graphics.newImage("assets/score boards/P1.png"),
        p2 = love.graphics.newImage("assets/score boards/P2.png")
    },
    small_avatar_inmatch = {
        cat_normal = love.graphics.newImage("assets/food effects/cat normal.png"),
        cat_sad = love.graphics.newImage("assets/food effects/cat sad.png"),
        cat_happy = love.graphics.newImage("assets/food effects/cat happy.png"),
        dog_normal = love.graphics.newImage("assets/food effects/dog normal.png"),
        dog_sad = love.graphics.newImage("assets/food effects/dog sad.png"),
        dog_happy = love.graphics.newImage("assets/food effects/dog happy.png"),
        beefsteak = love.graphics.newImage("assets/food effects/beefsteak.png"),
        fish = love.graphics.newImage("assets/food effects/fish.png")
    },
    option_state = {
        player1 = love.graphics.newImage("assets/option/player 1.png"),
        player2 = love.graphics.newImage("assets/option/player 2.png"),
        button_names = love.graphics.newImage("assets/option/button names.png"),
        spaceads_settings = love.graphics.newImage("assets/option/keypad settings 1.png"),
        updownleftright_settings = love.graphics.newImage("assets/option/keypad settings 2.png"),
        time_limit_setting = love.graphics.newImage("assets/option/time limit setting.png")
    },
    ["background"] = love.graphics.newImage("assets/background.png"),
    ["title-screen"] = love.graphics.newImage("assets/title screen.png"),
    ["pause-background"] = love.graphics.newImage("assets/pause/pause background.png"),
    ["background-large"] = love.graphics.newImage("assets/background large.png"),
    ["screenplay-border"] = love.graphics.newImage("assets/screenplay border.png"),
    ["preview-board"] = love.graphics.newImage("assets/preview board.png"),
    ["preview-board-2-players"] = love.graphics.newImage("assets/preview board 2 players.png"),
    ["time_board"] = love.graphics.newImage("assets/time board.png")
}

TITLE_TOP_SPACING = 20
CAPPED_FPS = 60
