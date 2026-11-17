print("[FirstHub] Loading...")
task.wait(0.5)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui", 10)
if not pg then return end

-- ============ CONFIG ============
local DESTINO = Vector3.new(15946.39, 72.07, -773.51)
local INTERVALO_WINS = 1
local INTERVALO_REBIRTH = 2
local VELOCIDAD_DEFECTO = 80
local VELOCIDAD_MAX = 1000
local DISCORD_LINK = "https://discord.gg/4gwAeR9uUz"
local ROSCRIPT_LINK = "https://roscripts.io/s/speed-click-for-owner-v2-premium-no-key"

local JUEGOS = {
    { nombre = "Speed Click for Owner v2", siglas = "SC", link = ROSCRIPT_LINK },
}

-- ============ IDIOMA ============
local function detectarIdioma()
    local playerLocale = player.LocaleId
    if type(playerLocale) == "string" and playerLocale ~= "" then
        local l = playerLocale:lower()
        if l:sub(1, 2) == "es" then return "es" end
        if l:sub(1, 2) == "en" then return "en" end
    end
    local ok, robloxLocale = pcall(function() return LocalizationService.RobloxLocaleId end)
    if ok and type(robloxLocale) == "string" and robloxLocale ~= "" then
        local l = robloxLocale:lower()
        if l:sub(1, 2) == "es" then return "es" end
        if l:sub(1, 2) == "en" then return "en" end
    end
    return "en"
end

local idioma = detectarIdioma()
warn("[FirstHub] Idioma: " .. idioma .. " | Player.LocaleId=" .. tostring(player.LocaleId) .. " | RobloxLocaleId=" .. tostring(LocalizationService.RobloxLocaleId))

local textos = {
    es = {
        wins = "Auto Wins", winsDesc = "Teleport autom\u{00E1}tico a la meta",
        fly = "Fly", flyDescPc = "Vuela con WASD, Espacio y Ctrl", flyDescMovil = "Vuela con el joystick y los botones",
        vel = "Velocidad", velDesc = "Velocidad del fly (m\u{00E1}x 1000)",
        rebirth = "Auto Rebirth", rebirthDesc = "Renace solo cuando se pueda",
        rebirthBuscando = "Buscando el remote de rebirth...", rebirthSin = "No se encontr\u{00F3} el remote de rebirth",
        rebirthActivo = "Activo, renaciendo autom\u{00E1}ticamente",
        ocultar = "RightShift para ocultar o mostrar el men\u{00FA}",
        discordLabel = "Discord First Hub",
        discordCopiado = "\u{00A1}Link copiado! P\u{00E9}galo en Discord",
        subir = "SUBIR", bajar = "BAJAR", masJuegos = "\u{00A1}M\u{00E1}s Juegos!", nuevo = "NUEVO",
        volver = "Volver", juegosTitulo = "M\u{00E1}s Juegos", play = "PLAY", sinKey = "NO KEY",
        playCopiado = "Link copiado",
        modalTitulo = "Antes de jugar",
        modalMensaje = "Copia el link y p\u{00E9}galo en el navegador para ir a la p\u{00E1}gina oficial de RoScript.",
        copiarLink = "Copiar Link",
        linkCopiado = "\u{00A1}Link copiado! P\u{00E9}galo en el navegador",
        copiaFalla = "No se pudo copiar, el link est\u{00E1} en la consola",
    },
    en = {
        wins = "Auto Wins", winsDesc = "Automatic teleport to the goal",
        fly = "Fly", flyDescPc = "Fly with WASD, Space and Ctrl", flyDescMovil = "Fly with the joystick and the buttons",
        vel = "Speed", velDesc = "Fly speed (max 1000)",
        rebirth = "Auto Rebirth", rebirthDesc = "Rebirths by itself when possible",
        rebirthBuscando = "Looking for the rebirth remote...", rebirthSin = "Rebirth remote not found",
        rebirthActivo = "Active, rebirthing automatically",
        ocultar = "RightShift to hide or show the menu",
        discordLabel = "Discord First Hub",
        discordCopiado = "Link copied! Paste it in Discord",
        subir = "UP", bajar = "DOWN", masJuegos = "More Games!", nuevo = "NEW",
        volver = "Back", juegosTitulo = "More Games", play = "PLAY", sinKey = "NO KEY",
        playCopiado = "Link copied",
        modalTitulo = "Before you play",
        modalMensaje = "Copy the link and paste it in the browser to go to the official RoScript page.",
        copiarLink = "Copy Link",
        linkCopiado = "Link copied! Paste it in the browser",
        copiaFalla = "Could not copy, the link is in the console",
    },
}

local function t(clave)
    local v = textos[idioma][clave]
    if v == nil then
        warn("[FirstHub] Falta clave: " .. tostring(clave) .. " en " .. idioma)
        return tostring(clave)
    end
    return v
end

-- ============ COLORES ============
local NEGRO = Color3.fromRGB(12, 12, 16)
local NEGRO_2 = Color3.fromRGB(22, 22, 29)
local NEGRO_3 = Color3.fromRGB(28, 28, 36)
local GRIS_OFF = Color3.fromRGB(56, 56, 68)
local ORO = Color3.fromRGB(255, 195, 60)
local ORO_CLARO = Color3.fromRGB(255, 225, 130)
local ORO_OSCURO = Color3.fromRGB(180, 130, 30)
local NARANJA = Color3.fromRGB(255, 140, 40)
local ROSA = Color3.fromRGB(255, 90, 140)
local TEXTO = Color3.fromRGB(240, 235, 220)
local TEXTO_GRIS = Color3.fromRGB(150, 146, 134)
local ROJO = Color3.fromRGB(210, 60, 60)
local VERDE = Color3.fromRGB(46, 160, 67)
local VERDE_CLARO = Color3.fromRGB(120, 220, 140)
local AMBAR = Color3.fromRGB(240, 180, 120)
local BLURPLE = Color3.fromRGB(88, 101, 242)
local BLURPLE_CLARO = Color3.fromRGB(120, 133, 255)
local BLURPLE_GRAD = Color3.fromRGB(114, 137, 218)
local BOTON_BASE = Color3.fromRGB(42, 42, 52)

-- ============ HELPERS ============
local function crear(clase, props, padre)
    local obj = Instance.new(clase)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = padre
    return obj
end

local function redondear(obj, radio)
    return crear("UICorner", { CornerRadius = UDim.new(0, radio) }, obj)
end

local function borde(obj, color, grosor, transparencia)
    return crear("UIStroke", {
        Color = color, Thickness = grosor, Transparency = transparencia,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, obj)
end

local function copiarAlPortapapeles(texto)
    return (pcall(function()
        if setclipboard then setclipboard(texto)
        elseif toclipboard then toclipboard(texto)
        else error("sin portapapeles") end
    end))
end

local viejo = pg:FindFirstChild("FirstHubBeta")
if viejo then viejo:Destroy() end

local esTactil = UIS.TouchEnabled
local esMovil = UIS.TouchEnabled and not UIS.KeyboardEnabled

local infoRapida = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local infoSlide = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TWEEN_HOVER = TweenInfo.new(0.12, Enum.EasingStyle.Quad)
local TWEEN_COLOR = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
local conexiones = {}
local tweensInfinitos = {}

local function conectar(senal, fn)
    local c = senal:Connect(fn)
    table.insert(conexiones, c)
    return c
end

local function tweenInfinito(obj, duracion, props, estilo, revertir)
    local tw = TweenService:Create(obj, TweenInfo.new(duracion, estilo or Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, revertir or false), props)
    tw:Play()
    table.insert(tweensInfinitos, tw)
    return tw
end

-- ============ BOTÓN ANIMADO ============
local function setupBoton(btn, sinBorde)
    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = btn
    local stroke = (not sinBorde) and btn:FindFirstChildOfClass("UIStroke") or nil
    local baseT = stroke and stroke.Transparency or 0
    local hover = false
    local press = false

    local function aplicar()
        local s = press and 0.95 or (hover and 1.05 or 1)
        TweenService:Create(scale, TWEEN_HOVER, {Scale = s}):Play()
        if stroke then
            TweenService:Create(stroke, TWEEN_HOVER, {Transparency = hover and math.max(0, baseT - 0.25) or baseT}):Play()
        end
    end

    if not esMovil then
        btn.MouseEnter:Connect(function() hover = true; aplicar() end)
        btn.MouseLeave:Connect(function() hover = false; press = false; aplicar() end)
    end

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            press = true
            aplicar()
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            press = false
            aplicar()
        end
    end)
end

local ANCHO = 320
local ALTO_MAX = 540
local ALTO_BARRA = 58

local minimizado = false
local escalaActual = 1
local anchoActual = ANCHO
local altoActual = ALTO_MAX

local function viewport()
    local cam = workspace.CurrentCamera
    if cam then return cam.ViewportSize end
    return Vector2.new(1280, 720)
end

local function calcularEscala()
    local vp = viewport()
    return math.clamp(math.min(vp.X / 400, vp.Y / 420), 0.6, 1)
end

local function calcularTamano(escala)
    local vp = viewport()
    return math.min(ANCHO, math.floor(vp.X * 0.94 / escala)), math.min(ALTO_MAX, math.floor(vp.Y * 0.92 / escala))
end

-- ============ GUI ============
local gui = crear("ScreenGui", {
    Name = "FirstHubBeta", ResetOnSpawn = false, DisplayOrder = 999,
    IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, pg)

local main = crear("Frame", {
    Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, ANCHO, 0, ALTO_MAX), BackgroundColor3 = NEGRO, BorderSizePixel = 0,
    Active = true, ClipsDescendants = true,
}, gui)
redondear(main, 14)
borde(main, ORO, 1.5, 0.45)

local mainEscala = crear("UIScale", { Scale = 1 }, main)

local barra = crear("Frame", {
    Name = "Barra", Size = UDim2.new(1, 0, 0, ALTO_BARRA), BackgroundColor3 = NEGRO_3, BorderSizePixel = 0,
}, main)

local linea = crear("Frame", {
    Name = "Linea", Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 0, ALTO_BARRA),
    BackgroundColor3 = ORO, BorderSizePixel = 0,
}, main)
crear("UIGradient", {
    Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, ORO), ColorSequenceKeypoint.new(1, NARANJA) }),
}, linea)

local titulo1 = crear("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 8), Size = UDim2.new(1, -96, 0, 22),
    Text = "+1 Flying Car Obby", TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
    TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
}, barra)
crear("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ORO_CLARO), ColorSequenceKeypoint.new(0.5, ORO), ColorSequenceKeypoint.new(1, NARANJA),
    }),
}, titulo1)

local fila2 = crear("Frame", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 31), Size = UDim2.new(1, -96, 0, 18),
}, barra)
crear("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8),
}, fila2)

crear("TextLabel", {
    BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0),
    Text = "FIRST HUB", TextColor3 = ORO_CLARO, Font = Enum.Font.GothamBold, TextSize = 12, LayoutOrder = 1,
}, fila2)

local insignia = crear("Frame", {
    Size = UDim2.new(0, 38, 0, 16), BackgroundColor3 = ORO, BackgroundTransparency = 0.82,
    BorderSizePixel = 0, LayoutOrder = 2,
}, fila2)
redondear(insignia, 8)
borde(insignia, ORO, 1, 0.4)
crear("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "BETA", TextColor3 = ORO, Font = Enum.Font.GothamBold, TextSize = 9 }, insignia)

local function crearBotonBarra(texto, posX, colorHover)
    local b = crear("TextButton", {
        Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, posX, 0.5, -15),
        BackgroundColor3 = BOTON_BASE, Text = texto, TextColor3 = TEXTO, Font = Enum.Font.GothamBold,
        TextSize = 14, AutoButtonColor = false, BorderSizePixel = 0,
    }, barra)
    redondear(b, 8)
    b.MouseEnter:Connect(function() TweenService:Create(b, infoRapida, { BackgroundColor3 = colorHover }):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, infoRapida, { BackgroundColor3 = BOTON_BASE }):Play() end)
    return b
end

local cerrarBtn = crearBotonBarra("X", -44, ROJO)
local minimizarBtn = crearBotonBarra("-", -80, GRIS_OFF)

local lista = crear("ScrollingFrame", {
    Name = "Lista", BackgroundTransparency = 1, BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, ALTO_BARRA + 2), Size = UDim2.new(1, 0, 1, -(ALTO_BARRA + 2)),
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 3, ScrollBarImageColor3 = ORO, ScrollingDirection = Enum.ScrollingDirection.Y,
}, main)
crear("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }, lista)
crear("UIPadding", {
    PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
}, lista)

local function crearTarjeta(orden, nombre, descripcion, reservado)
    local tarjeta = crear("Frame", {
        Size = UDim2.new(1, 0, 0, 62), BackgroundColor3 = NEGRO_2, BorderSizePixel = 0, LayoutOrder = orden,
    }, lista)
    redondear(tarjeta, 10)
    local trazo = borde(tarjeta, ORO, 1, 0.85)
    crear("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, -(reservado or 86), 0, 20),
        Position = UDim2.new(0, 14, 0, 8), Text = nombre, TextColor3 = TEXTO,
        Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
    }, tarjeta)
    local desc = crear("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, -(reservado or 86), 0, 28),
        Position = UDim2.new(0, 14, 0, 28), Text = descripcion, TextColor3 = TEXTO_GRIS,
        Font = Enum.Font.Gotham, TextSize = 11, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    }, tarjeta)
    return tarjeta, desc, trazo
end

local POS_OFF = UDim2.new(0, 3, 0.5, -10)
local POS_ON = UDim2.new(0, 25, 0.5, -10)

local function crearInterruptor(tarjeta, trazo, alPulsar)
    local pista = crear("Frame", {
        Size = UDim2.new(0, 48, 0, 26), Position = UDim2.new(1, -62, 0.5, -13),
        BackgroundColor3 = GRIS_OFF, BorderSizePixel = 0,
    }, tarjeta)
    redondear(pista, 13)
    local perilla = crear("Frame", {
        Size = UDim2.new(0, 20, 0, 20), Position = POS_OFF, BackgroundColor3 = TEXTO, BorderSizePixel = 0,
    }, pista)
    redondear(perilla, 10)
    local estado = false
    local function poner(valor)
        estado = valor
        TweenService:Create(pista, infoRapida, { BackgroundColor3 = valor and ORO or GRIS_OFF }):Play()
        TweenService:Create(perilla, infoRapida, {
            Position = valor and POS_ON or POS_OFF, BackgroundColor3 = valor and NEGRO or TEXTO,
        }):Play()
    end
    local boton = crear("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5,
    }, tarjeta)
    boton.MouseButton1Click:Connect(function() alPulsar(not estado) end)
    boton.MouseEnter:Connect(function() TweenService:Create(trazo, infoRapida, { Transparency = 0.5 }):Play() end)
    boton.MouseLeave:Connect(function() TweenService:Create(trazo, infoRapida, { Transparency = 0.85 }):Play() end)
    return { poner = poner, obtener = function() return estado end }
end

--  Wins(1), Rebirth(2), Fly(3), Vel(4)
local tarjetaWins, _, trazoWins = crearTarjeta(1, t("wins"), t("winsDesc"))
local tarjetaRebirth, rebirthDesc, trazoRebirth = crearTarjeta(2, t("rebirth"), t("rebirthDesc"))
local tarjetaFly, _, trazoFly = crearTarjeta(3, t("fly"), esMovil and t("flyDescMovil") or t("flyDescPc"))
local tarjetaVel = crearTarjeta(4, t("vel"), t("velDesc"), 110)

local velBox = crear("TextBox", {
    Size = UDim2.new(0, 84, 0, 32), Position = UDim2.new(1, -98, 0.5, -16),
    BackgroundColor3 = NEGRO_3, BorderSizePixel = 0, Text = tostring(VELOCIDAD_DEFECTO),
    PlaceholderText = tostring(VELOCIDAD_DEFECTO), TextColor3 = ORO, PlaceholderColor3 = TEXTO_GRIS,
    Font = Enum.Font.GothamBold, TextSize = 14, ClearTextOnFocus = false,
}, tarjetaVel)
redondear(velBox, 8)
local velBorde = borde(velBox, ORO, 1, 0.6)

if not esMovil then
    crear("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Text = t("ocultar"),
        TextColor3 = TEXTO_GRIS, Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true, LayoutOrder = 5,
    }, lista)
end

-- ============ DISCORD BTN============
local discordBtn = nil
local discordCopiandoToken = 0
if idioma ~= "en" then
    discordBtn = crear("TextButton", {
        Name = "Discord", Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = BLURPLE,
        Text = "", TextColor3 = TEXTO, Font = Enum.Font.GothamBold,
        TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = 6,
    }, lista)
    redondear(discordBtn, 12)

    -- Gradiente 
    crear("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, BLURPLE_GRAD),
            ColorSequenceKeypoint.new(1, BLURPLE),
        }),
        Rotation = 90,
    }, discordBtn)

    borde(discordBtn, BLURPLE_CLARO, 2, 0.5)

    -- Icono D
    local discordIcon = crear("Frame", {
        Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 10, 0.5, -12),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.15,
        BorderSizePixel = 0, ZIndex = 4,
    }, discordBtn)
    redondear(discordIcon, 6)

    crear("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
        Text = "D", TextColor3 = BLURPLE, Font = Enum.Font.GothamBold,
        TextSize = 15, ZIndex = 5,
    }, discordIcon)

    -- Label normal "Discord First Hub"
    local discordLabel = crear("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 42, 0, 0),
        Size = UDim2.new(1, -48, 1, 0), Text = t("discordLabel"),
        TextColor3 = TEXTO, Font = Enum.Font.GothamBold, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
    }, discordBtn)

    local discordCopiado = crear("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 42, 0, 0),
        Size = UDim2.new(1, -48, 1, 0), Text = t("discordCopiado"),
        TextColor3 = VERDE_CLARO, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, ZIndex = 4,
    }, discordBtn)

    -- Animación hover/press
    setupBoton(discordBtn)

    -- Click con animación de éxito/fallo
    discordBtn.MouseButton1Click:Connect(function()
        discordCopiandoToken += 1
        local miToken = discordCopiandoToken

        local exito = copiarAlPortapapeles(DISCORD_LINK)

        if exito then
            TweenService:Create(discordLabel, TWEEN_COLOR, {TextTransparency = 1}):Play()
            TweenService:Create(discordCopiado, TWEEN_COLOR, {TextTransparency = 0}):Play()
            TweenService:Create(discordBtn, TWEEN_COLOR, {BackgroundColor3 = VERDE}):Play()

            task.delay(2, function()
                if miToken ~= discordCopiandoToken then return end
                TweenService:Create(discordLabel, TWEEN_COLOR, {TextTransparency = 0}):Play()
                TweenService:Create(discordCopiado, TWEEN_COLOR, {TextTransparency = 1}):Play()
                TweenService:Create(discordBtn, TWEEN_COLOR, {BackgroundColor3 = BLURPLE}):Play()
            end)
        else
            discordLabel.Text = DISCORD_LINK
            discordLabel.TextSize = 9
            TweenService:Create(discordBtn, TWEEN_COLOR, {BackgroundColor3 = ROJO}):Play()
            task.delay(4, function()
                if miToken ~= discordCopiandoToken then return end
                discordLabel.Text = t("discordLabel")
                discordLabel.TextSize = 13
                TweenService:Create(discordBtn, TWEEN_COLOR, {BackgroundColor3 = BLURPLE}):Play()
            end)
            print("[First Hub] Discord: " .. DISCORD_LINK)
        end
    end)
end

local masEnvoltorio = crear("Frame", {
    Name = "MasJuegosEnvoltorio", Size = UDim2.new(1, 0, 0, 62), BackgroundTransparency = 1, LayoutOrder = 7,
}, lista)

local masBtn = crear("TextButton", {
    Name = "MasJuegos", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(1, -8, 0, 52), BackgroundColor3 = Color3.new(1, 1, 1), Text = "",
    AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true,
}, masEnvoltorio)
redondear(masBtn, 14)

local masGrad = crear("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ORO), ColorSequenceKeypoint.new(0.5, NARANJA), ColorSequenceKeypoint.new(1, ROSA),
    }),
    Rotation = 0,
}, masBtn)
local masTrazo = borde(masBtn, ORO_CLARO, 2, 0.1)
local masEscala = crear("UIScale", { Scale = 1 }, masBtn)
local masBrillo = crear("Frame", {
    Size = UDim2.new(0.3, 0, 1.6, 0), Position = UDim2.new(-0.5, 0, -0.3, 0),
    BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Rotation = 20,
}, masBtn)
crear("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.45), NumberSequenceKeypoint.new(1, 1),
    }),
}, masBrillo)
crear("TextLabel", {
    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = t("masJuegos"),
    TextColor3 = NEGRO, Font = Enum.Font.GothamBold, TextSize = 18, ZIndex = 3,
}, masBtn)

local nuevoTag = crear("Frame", {
    Size = UDim2.new(0, 44, 0, 15), Position = UDim2.new(1, -52, 0, 6),
    BackgroundColor3 = ROJO, BorderSizePixel = 0, ZIndex = 4,
}, masBtn)
redondear(nuevoTag, 8)
crear("TextLabel", {
    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = t("nuevo"),
    TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 9, ZIndex = 5,
}, nuevoTag)

tweenInfinito(masGrad, 4, { Rotation = 360 })
tweenInfinito(masEscala, 0.8, { Scale = 1.04 }, Enum.EasingStyle.Sine, true)
tweenInfinito(masTrazo, 0.8, { Transparency = 0.65 }, Enum.EasingStyle.Sine, true)
tweenInfinito(nuevoTag, 0.6, { BackgroundTransparency = 0.35 }, Enum.EasingStyle.Sine, true)

-- Panel de juegos
local panelJuegos = crear("Frame", {
    Name = "PanelJuegos", Position = UDim2.new(1, 0, 0, ALTO_BARRA + 2),
    Size = UDim2.new(1, 0, 1, -(ALTO_BARRA + 2)), BackgroundColor3 = NEGRO,
    BorderSizePixel = 0, Visible = false, ZIndex = 10,
}, main)

local volverBtn = crear("TextButton", {
    Size = UDim2.new(0, 84, 0, 32), Position = UDim2.new(0, 14, 0, 12),
    BackgroundColor3 = NEGRO_3, Text = t("volver"), TextColor3 = ORO,
    Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0,
}, panelJuegos)
redondear(volverBtn, 10)
borde(volverBtn, ORO, 1.5, 0.4)

crear("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 108, 0, 12), Size = UDim2.new(1, -122, 0, 32),
    Text = t("juegosTitulo"), TextColor3 = ORO, Font = Enum.Font.GothamBold, TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panelJuegos)

local listaJuegos = crear("ScrollingFrame", {
    BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 54),
    Size = UDim2.new(1, 0, 1, -54), CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
    ScrollBarImageColor3 = ORO, ScrollingDirection = Enum.ScrollingDirection.Y,
}, panelJuegos)
crear("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }, listaJuegos)
crear("UIPadding", {
    PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
}, listaJuegos)

-- ============ MODAL (ventana del PLAY) ============
local modalFondo = crear("TextButton", {
    Name = "ModalFondo", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Visible = false, ZIndex = 50,
}, gui)

local modal = crear("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 300, 0, 240), BackgroundColor3 = NEGRO_2, BorderSizePixel = 0,
}, modalFondo)
redondear(modal, 14)
borde(modal, ORO, 1.5, 0.35)

local modalEscala = crear("UIScale", { Scale = 0.01 }, modal)

crear("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 14), Size = UDim2.new(1, -60, 0, 22),
    Text = t("modalTitulo"), TextColor3 = ORO, Font = Enum.Font.GothamBold, TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
}, modal)

local modalCerrar = crear("TextButton", {
    Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -40, 0, 12),
    BackgroundColor3 = BOTON_BASE, Text = "X", TextColor3 = TEXTO,
    Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0,
}, modal)
redondear(modalCerrar, 8)

crear("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 48), Size = UDim2.new(1, -32, 0, 90),
    Text = t("modalMensaje"), TextColor3 = TEXTO, Font = Enum.Font.Gotham, TextSize = 13,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
}, modal)

local copiarModal = crear("TextButton", {
    Position = UDim2.new(0, 16, 0, 148), Size = UDim2.new(1, -32, 0, 44),
    BackgroundColor3 = ORO, Text = t("copiarLink"), TextColor3 = NEGRO,
    Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false, BorderSizePixel = 0,
}, modal)
redondear(copiarModal, 10)

local modalFeedback = crear("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 200), Size = UDim2.new(1, -32, 0, 16),
    Text = "", TextColor3 = VERDE_CLARO, Font = Enum.Font.GothamMedium, TextSize = 11,
    TextWrapped = true,
}, modal)

local modalToken = 0

local function abrirModal()
    modalToken += 1
    modalFeedback.Text = ""
    modalFondo.BackgroundTransparency = 1
    modalFondo.Visible = true
    modalEscala.Scale = 0.01
    TweenService:Create(modalFondo, infoRapida, { BackgroundTransparency = 0.45 }):Play()
    TweenService:Create(modalEscala, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = escalaActual,
    }):Play()
end

local function cerrarModal()
    modalToken += 1
    local miToken = modalToken
    TweenService:Create(modalFondo, infoRapida, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(modalEscala, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Scale = 0.01,
    }):Play()
    task.delay(0.17, function()
        if modalToken == miToken then
            modalFondo.Visible = false
        end
    end)
end

modalCerrar.MouseButton1Click:Connect(cerrarModal)

copiarModal.MouseButton1Click:Connect(function()
    if copiarAlPortapapeles(ROSCRIPT_LINK) then
        modalFeedback.Text = t("linkCopiado")
        modalFeedback.TextColor3 = VERDE_CLARO
    else
        modalFeedback.Text = t("copiaFalla")
        modalFeedback.TextColor3 = AMBAR
        print("[First Hub] Link: " .. ROSCRIPT_LINK)
    end
end)

-- Controles de fly (mobile)
local controlesFly = crear("Frame", {
    Name = "ControlesFly", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -18, 0.5, 0),
    Size = UDim2.new(0, 72, 0, 152), BackgroundTransparency = 1, Visible = false,
}, gui)
crear("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }, controlesFly)
local controlesEscala = crear("UIScale", { Scale = 1 }, controlesFly)

local flyArriba = false
local flyAbajo = false

local function crearBotonFly(texto, orden, alCambiar)
    local b = crear("TextButton", {
        Size = UDim2.new(0, 72, 0, 70), BackgroundColor3 = NEGRO, BackgroundTransparency = 0.15,
        Text = texto, TextColor3 = ORO, Font = Enum.Font.GothamBold, TextSize = 14,
        AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = orden,
    }, controlesFly)
    redondear(b, 14)
    borde(b, ORO, 1.5, 0.3)
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            alCambiar(true)
        end
    end)
    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            alCambiar(false)
        end
    end)
    return b
end

crearBotonFly(t("subir"), 1, function(v) flyArriba = v end)
crearBotonFly(t("bajar"), 2, function(v) flyAbajo = v end)

-- Velocidad
local velocidad = VELOCIDAD_DEFECTO
conectar(velBox.Focused, function()
    TweenService:Create(velBorde, infoRapida, { Transparency = 0, Thickness = 2 }):Play()
end)
conectar(velBox.FocusLost, function()
    TweenService:Create(velBorde, infoRapida, { Transparency = 0.6, Thickness = 1 }):Play()
    local val = tonumber(velBox.Text)
    if not val or val <= 0 then val = VELOCIDAD_DEFECTO
    elseif val > VELOCIDAD_MAX then val = VELOCIDAD_MAX end
    velocidad = val
    velBox.Text = tostring(val)
end)

local function obtenerPersonaje()
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    return char, char:FindFirstChild("HumanoidRootPart"), hum
end

-- Auto Wins
local winsSwitch, flySwitch, rebirthSwitch
local winsActivo = false
local winsToken = 0

local function activarWins(valor)
    winsActivo = valor
    winsToken += 1
    local miToken = winsToken
    if winsSwitch then winsSwitch.poner(valor) end
    if not valor then return end
    task.spawn(function()
        while winsActivo and winsToken == miToken and gui.Parent do
            local _, hrp = obtenerPersonaje()
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(DESTINO)
            end
            task.wait(INTERVALO_WINS)
        end
    end)
end

-- Fly
local flyActivo = false
local flyBV, flyBG, flyConn, controlModule = nil, nil, nil, nil

task.spawn(function()
    pcall(function()
        local ps = player:WaitForChild("PlayerScripts", 10)
        if not ps then return end
        local pm = require(ps:WaitForChild("PlayerModule", 10))
        if pm then controlModule = pm:GetControls() end
    end)
end)

local function detenerFly(sinInterfaz)
    flyActivo = false
    flyArriba = false
    flyAbajo = false
    controlesFly.Visible = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
    if not sinInterfaz and flySwitch then flySwitch.poner(false) end
end

local function iniciarFly()
    local char, hrp, hum = obtenerPersonaje()
    if not char or not hrp or not hum then return end
    detenerFly(true)
    flyActivo = true
    hum.PlatformStand = true
    flyBV = crear("BodyVelocity", { MaxForce = Vector3.new(1e5, 1e5, 1e5), Velocity = Vector3.zero }, hrp)
    flyBG = crear("BodyGyro", { P = 9000, MaxTorque = Vector3.new(1e5, 1e5, 1e5), CFrame = hrp.CFrame }, hrp)
    flySwitch.poner(true)
    controlesFly.Visible = esTactil
    flyConn = RunService.RenderStepped:Connect(function()
        if not flyActivo or not hrp.Parent or hum.Health <= 0 then detenerFly(); return end
        local camera = workspace.CurrentCamera
        if not camera then return end
        local dir = Vector3.zero
        if controlModule then
            local ok, mv = pcall(function() return controlModule:GetMoveVector() end)
            if ok and typeof(mv) == "Vector3" then
                dir = camera.CFrame.RightVector * mv.X + camera.CFrame.LookVector * (-mv.Z)
            end
        else
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) or flyArriba then dir = dir + Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or flyAbajo then dir = dir - Vector3.yAxis end
        if dir.Magnitude > 0 then dir = dir.Unit end
        flyBV.Velocity = dir * velocidad
        flyBG.CFrame = camera.CFrame
    end)
end

-- Auto Rebirth
local rebirthActivo = false
local rebirthToken = 0
local rebirthRemotes = {}

local function buscarRemotesRebirth()
    local encontrados = {}
    for _, obj in ipairs(RS:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local nombre = obj.Name:lower()
            if nombre:find("rebirth") or nombre:find("renac") or nombre:find("reborn") then
                table.insert(encontrados, obj)
            end
        end
    end
    return encontrados
end

local function dispararRebirth()
    local enviados = 0
    for _, r in ipairs(rebirthRemotes) do
        if r.Parent then
            enviados += 1
            if r:IsA("RemoteEvent") then
                pcall(function() r:FireServer() end)
            else
                task.spawn(function() pcall(function() r:InvokeServer() end) end)
            end
        end
    end
    if enviados == 0 then rebirthRemotes = {} end
    return enviados
end

local function activarRebirth(valor)
    rebirthActivo = valor
    rebirthToken += 1
    local miToken = rebirthToken
    if rebirthSwitch then rebirthSwitch.poner(valor) end
    if not valor then
        rebirthDesc.Text = t("rebirthDesc")
        rebirthDesc.TextColor3 = TEXTO_GRIS
        return
    end
    rebirthDesc.Text = t("rebirthBuscando")
    rebirthDesc.TextColor3 = AMBAR
    task.spawn(function()
        local ultimaBusqueda = nil
        while rebirthActivo and rebirthToken == miToken and gui.Parent do
            if #rebirthRemotes == 0 and (not ultimaBusqueda or os.clock() - ultimaBusqueda >= 3) then
                rebirthRemotes = buscarRemotesRebirth()
                ultimaBusqueda = os.clock()
            end
            local enviados = 0
            if #rebirthRemotes > 0 then enviados = dispararRebirth() end
            if enviados > 0 then
                rebirthDesc.Text = t("rebirthActivo")
                rebirthDesc.TextColor3 = VERDE_CLARO
            else
                rebirthDesc.Text = t("rebirthSin")
                rebirthDesc.TextColor3 = AMBAR
            end
            task.wait(INTERVALO_REBIRTH)
        end
    end)
end

winsSwitch = crearInterruptor(tarjetaWins, trazoWins, activarWins)
flySwitch = crearInterruptor(tarjetaFly, trazoFly, function(v) if v then iniciarFly() else detenerFly() end end)
rebirthSwitch = crearInterruptor(tarjetaRebirth, trazoRebirth, activarRebirth)

-- Abrir/cerrar panel de juegos
local panelAbierto = false
local panelOcupado = false

local function abrirPanel()
    if panelAbierto or panelOcupado then return end
    panelOcupado = true
    panelAbierto = true
    panelJuegos.Position = UDim2.new(1, 0, 0, ALTO_BARRA + 2)
    panelJuegos.Visible = true
    local tw = TweenService:Create(panelJuegos, infoSlide, { Position = UDim2.new(0, 0, 0, ALTO_BARRA + 2) })
    tw:Play(); tw.Completed:Wait()
    panelOcupado = false
end

local function cerrarPanel()
    if not panelAbierto or panelOcupado then return end
    panelOcupado = true
    local tw = TweenService:Create(panelJuegos, infoSlide, { Position = UDim2.new(1, 0, 0, ALTO_BARRA + 2) })
    tw:Play(); tw.Completed:Wait()
    panelJuegos.Visible = false
    panelAbierto = false
    panelOcupado = false
end

masBtn.MouseButton1Click:Connect(function() task.spawn(abrirPanel) end)
volverBtn.MouseButton1Click:Connect(function() task.spawn(cerrarPanel) end)

-- ============ TARJETA DE JUEGO (con logo SC estilo Speed Click) ============
local function crearTarjetaJuego(juego, orden)
    local tarjeta = crear("Frame", {
        Size = UDim2.new(1, 0, 0, 96), BackgroundColor3 = NEGRO_2, BorderSizePixel = 0, LayoutOrder = orden,
    }, listaJuegos)
    redondear(tarjeta, 12)
    borde(tarjeta, ORO, 1, 0.7)

    local marco = crear("Frame", {
        Size = UDim2.new(0, 72, 0, 72), Position = UDim2.new(0, 10, 0.5, -36),
        BackgroundColor3 = ORO, BorderSizePixel = 0, ClipsDescendants = true,
    }, tarjeta)
    redondear(marco, 12)

    crear("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ORO_CLARO),
            ColorSequenceKeypoint.new(0.5, ORO),
            ColorSequenceKeypoint.new(1, ORO_OSCURO),
        }),
        Rotation = 45,
    }, marco)

    borde(marco, ORO_CLARO, 3, 0.2)
    borde(marco, NEGRO, 1, 0.6)

    local textoSC = crear("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = juego.siglas,
        TextColor3 = NEGRO, Font = Enum.Font.GothamBold, TextSize = 24, ZIndex = 2,
    }, marco)
    crear("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 40, 10)),
            ColorSequenceKeypoint.new(1, NEGRO),
        }),
        Rotation = 90,
    }, textoSC)

    crear("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 92, 0, 14), Size = UDim2.new(1, -176, 0, 34),
        Text = juego.nombre, TextColor3 = TEXTO, Font = Enum.Font.GothamBold, TextSize = 13,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    }, tarjeta)

    local insigniaKey = crear("Frame", {
        Position = UDim2.new(0, 92, 0, 56), Size = UDim2.new(0, 64, 0, 20),
        BackgroundColor3 = VERDE, BorderSizePixel = 0,
    }, tarjeta)
    redondear(insigniaKey, 10)
    borde(insigniaKey, VERDE_CLARO, 1, 0.3)
    crear("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = t("sinKey"),
        TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 10,
    }, insigniaKey)

    local playBtn = crear("TextButton", {
        Position = UDim2.new(1, -78, 0.5, -18), Size = UDim2.new(0, 66, 0, 36),
        BackgroundColor3 = VERDE, Text = t("play"), TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0,
    }, tarjeta)
    redondear(playBtn, 10)
    borde(playBtn, VERDE_CLARO, 1.5, 0.35)

    playBtn.MouseEnter:Connect(function() TweenService:Create(playBtn, infoRapida, { BackgroundColor3 = Color3.fromRGB(60, 190, 85) }):Play() end)
    playBtn.MouseLeave:Connect(function() TweenService:Create(playBtn, infoRapida, { BackgroundColor3 = VERDE }):Play() end)
    playBtn.MouseButton1Click:Connect(function() abrirModal() end)
end

for i, juego in ipairs(JUEGOS) do
    crearTarjetaJuego(juego, i)
end

-- Brillo del botón Más Juegos
task.spawn(function()
    while gui.Parent do
        if gui.Enabled and not minimizado and not panelAbierto then
            masBrillo.Position = UDim2.new(-0.5, 0, -0.3, 0)
            TweenService:Create(masBrillo, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Position = UDim2.new(1.2, 0, -0.3, 0),
            }):Play()
            task.wait(2.4)
        else
            task.wait(0.5)
        end
    end
end)

local function aplicarTamano()
    escalaActual = calcularEscala()
    local ancho, alto = calcularTamano(escalaActual)
    anchoActual = ancho
    altoActual = alto
    mainEscala.Scale = escalaActual
    controlesEscala.Scale = escalaActual
    if modalFondo.Visible then
        modalEscala.Scale = escalaActual
    end
    main.Size = UDim2.new(0, ancho, 0, minimizado and (ALTO_BARRA + 2) or alto)
end

aplicarTamano()

if workspace.CurrentCamera then
    conectar(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), aplicarTamano)
end

-- Minimizar
minimizarBtn.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    minimizarBtn.Text = minimizado and "+" or "-"
    local oldSizeY = main.Size.Y.Offset
    local newSizeY = minimizado and (ALTO_BARRA + 2) or altoActual
    local newOffsetY = main.Position.Y.Offset - 0.5 * escalaActual * (oldSizeY - newSizeY)
    TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, anchoActual, 0, newSizeY),
        Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, newOffsetY),
    }):Play()
end)

cerrarBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Arrastrar
local arrastrando = false
local inicioArrastre
local inicioPosicion

conectar(barra.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        arrastrando = true
        inicioArrastre = input.Position
        inicioPosicion = main.Position
    end
end)

conectar(UIS.InputChanged, function(input)
    if arrastrando and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - inicioArrastre
        main.Position = UDim2.new(
            inicioPosicion.X.Scale,
            inicioPosicion.X.Offset + delta.X / escalaActual,
            inicioPosicion.Y.Scale,
            inicioPosicion.Y.Offset + delta.Y / escalaActual
        )
    end
end)

conectar(UIS.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        arrastrando = false
    end
end)

conectar(UIS.InputBegan, function(input, procesado)
    if procesado then return end
    if input.KeyCode == Enum.KeyCode.RightShift then gui.Enabled = not gui.Enabled end
end)

gui.Destroying:Connect(function()
    winsActivo = false; winsToken += 1
    rebirthActivo = false; rebirthToken += 1
    detenerFly(true)
    for _, c in ipairs(conexiones) do c:Disconnect() end
    for _, tw in ipairs(tweensInfinitos) do tw:Cancel() end
end)

main.Position = UDim2.new(0.5, 0, 0.5, 24)
TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
}):Play()

print("[FirstHub] Ready. Idioma: " .. idioma)
