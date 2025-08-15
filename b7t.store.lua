-- 🟦 دالة تنبيه بديلة
function MachoNotify(title, message, type)
    print("[Notify] " .. title .. " - " .. message)
end

-- 🟦 حالة عرض الأيدي
local showPlayerIds = false

-- 🟥 إعداد تقسيم المنيو
local MenuSize        = vec2(750, 450)
local MenuStartCoords = vec2(500, 500)
local TabsBarWidth    = 0
local SectionsPadding = 10

local SectionOneRatio   = 0.3
local SectionThreeRatio = 0.7

local SectionOneWidth   = (MenuSize.x - TabsBarWidth - SectionsPadding * 3) * SectionOneRatio
local SectionThreeWidth = (MenuSize.x - TabsBarWidth - SectionsPadding * 3) * SectionThreeRatio

local SectionOneStart   = vec2(TabsBarWidth + SectionsPadding, SectionsPadding)
local SectionOneEnd     = vec2(SectionOneStart.x + SectionOneWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(SectionOneEnd.x + SectionsPadding, SectionsPadding)
local SectionThreeEnd   = vec2(SectionThreeStart.x + SectionThreeWidth, MenuSize.y - SectionsPadding)

local ThirdInnerPadding = 10
local ThirdInnerSplit   = (SectionThreeWidth - ThirdInnerPadding * 3) / 2

local ThirdPartOneStart = vec2(SectionThreeStart.x + ThirdInnerPadding, SectionThreeStart.y + ThirdInnerPadding)
local ThirdPartOneEnd   = vec2(ThirdPartOneStart.x + ThirdInnerSplit, SectionThreeEnd.y - ThirdInnerPadding)

local ThirdPartTwoStart = vec2(ThirdPartOneEnd.x + ThirdInnerPadding, ThirdPartOneStart.y)
local ThirdPartTwoEnd   = vec2(ThirdPartTwoStart.x + ThirdInnerSplit, ThirdPartOneEnd.y)

-- 🟩 إنشاء المنيو
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 220, 220, 220)

-- 🟥 القسم الأول
local SectionOne = MachoMenuGroup(MenuWindow, "b7t store beta", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
MachoMenuButton(SectionOne, "general", function()
    MachoNotify("General Clicked", "راجع القسم الثالث للخيارات", "info")
end)

-- 🟨 القسم الثالث - الجزء الأول: إجراءات
local SectionThreeGroup = MachoMenuGroup(MenuWindow, "Actions", ThirdPartOneStart.x, ThirdPartOneStart.y, ThirdPartOneEnd.x, ThirdPartOneEnd.y)

MachoMenuButton(SectionThreeGroup, "self revive", function()
    TriggerEvent("hospital:client:Revive", PlayerPedId())
end, { r = 34, g = 177, b = 76 })

-- 🟪 قسم ESX مستقل
local SectionESX = MachoMenuGroup(MenuWindow, "ESX", ThirdPartOneStart.x, ThirdPartOneStart.y, ThirdPartOneEnd.x, ThirdPartOneEnd.y)

-- 📝 إدخال اسم السلاح
local weaponBox = MachoMenuInputbox(SectionESX, "weapon name", "type weapon here")

-- 🔫 زر إعطاء السلاح
MachoMenuButton(SectionESX, "give wepans", function()
    local weaponName = MachoMenuGetInputbox(weaponBox)
    if not weaponName or weaponName == "" then
        MachoNotify("Error", "اكتب اسم السلاح أولاً", "error")
        return
    end
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), 100, false, true)
    MachoNotify("Weapon", "✅ تم إعطاؤك السلاح: " .. weaponName, "success")
end, { r = 150, g = 150, b = 255 })

-- ♻ أزرار ESX القديمة
MachoMenuButton(SectionESX, "Revive ESX", function()
    TriggerEvent('esx_ambulancejob:revive')
    MachoNotify("Revive", "✅ تم تنفيذ ريفاير ESX بنجاح", "success")
end, { r = 0, g = 200, b = 100 })

MachoMenuButton(SectionESX, "Give Money Esx", function()
    MachoIsolatedInject(MachoWebRequest("https://raw.githubusercontent.com/btaall/b7t-store/refs/heads/main/fls_ESX.lua"))
    MachoNotify("كرز Blob", "✅ تم تشغيل السكربت بنجاح", "success")
end, { r = 200, g = 200, b = 50 })

MachoMenuButton(SectionESX, "XP ESX", function()
    local script = MachoWebRequest("https://raw.githubusercontent.com/btaall/b7t-store/refs/heads/main/XP_ESX.lua")
    if script then
        MachoIsolatedInject(script)
        MachoNotify("خبرة", "✅ تم تنفيذ سكربت الفلوس بنجاح", "success")
    else
        MachoNotify("خطأ", "❌ فشل تحميل السكربت", "error")
    end
end, { r = 255, g = 230, b = 0 })

-- 🟦 القسم الثالث - الجزء الثاني: إضافي (قسم الآيدي)
local SectionThreeExtra = MachoMenuGroup(MenuWindow, "Extra (IDs & Actions)", ThirdPartTwoStart.x, ThirdPartTwoStart.y, ThirdPartTwoEnd.x, ThirdPartTwoEnd.y)

-- 🆔 إدخال رقم اللاعب
local idBox = MachoMenuInputbox(SectionThreeExtra, "player id", "type id here")

local function ValidateID(id)
    if not id or id == "" or not tonumber(id) then
        MachoNotify("Error", "Invalid or missing player ID", "error")
        return false
    end
    return true
end

-- 👝 فتح إنفنتوري لاعب آخر
MachoMenuButton(SectionThreeExtra, "open inventory (by id)", function()
    local id = MachoMenuGetInputbox(idBox)
    if ValidateID(id) then
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", tonumber(id))
    end
end, { r = 0, g = 200, b = 100 })

-- ❤️‍🩹 ريفاير لاعب آخر
MachoMenuButton(SectionThreeExtra, "revive player (by id)", function()
    local id = MachoMenuGetInputbox(idBox)
    if ValidateID(id) then
        TriggerServerEvent("hospital:server:RevivePlayer", tonumber(id))
    end
end, { r = 34, g = 177, b = 76 })

-- 🔒 كلبشة/فك كلبشة لاعب
MachoMenuButton(SectionThreeExtra, "cuff player (by id)", function()
    local id = MachoMenuGetInputbox(idBox)
    if ValidateID(id) then
        TriggerServerEvent('police:server:CuffPlayer', tonumber(id), true)
    end
end, { r = 200, g = 0, b = 0 })

MachoMenuButton(SectionThreeExtra, "uncuff player (by id)", function()
    local id = MachoMenuGetInputbox(idBox)
    if ValidateID(id) then
        TriggerServerEvent('police:server:CuffPlayer', tonumber(id), false)
    end
end, { r = 220, g = 120, b = 0 })

-- ────────────── 🔹 فاصل بصري 🔹 ──────────────
MachoMenuSeparator(SectionThreeExtra, { r = 255, g = 255, b = 255 })

-- 👤 تفعيل/إيقاف عرض آيدي فوق اللاعبين
MachoMenuButton(SectionThreeExtra, "show player ids (toggle)", function()
    showPlayerIds = not showPlayerIds
    MachoNotify("Show Player IDs", showPlayerIds and "Enabled" or "Disabled", "info")
end, { r = 120, g = 120, b = 255 })

-- ────────────── 🔹 فاصل بصري 🔹 ──────────────
MachoMenuSeparator(SectionThreeExtra, { r = 255, g = 255, b = 255 })

-- ✅ تمت الإضافة هنا: أزرار self revive و open shop داخل قسم Extra
-- 💚 زر Self Revive (لنفسك)
MachoMenuButton(SectionThreeExtra, "self revive", function()
    TriggerEvent("hospital:client:Revive", PlayerPedId())
end, { r = 34, g = 177, b = 76 })

-- 🛒 زر Open Shop (لنفسك)
MachoMenuButton(SectionThreeExtra, "open shop", function()
    TriggerServerEvent('inventory:server:OpenInventory', 'shop', 'Police', {
        items = {
                 -- الأسلحة الأساسية
            {amount = 1, name = "ziptie", price = 0, slot = 1, type = "weapon"},
            {amount = 1, name = "weapon_pistol50", price = 0, slot = 2, type = "weapon"},
            {amount = 1, name = "weapon_heavypistol", price = 0, slot = 3, type = "weapon"},
            {amount = 1, name = "weapon_pistol_mk2", price = 0, slot = 4, type = "weapon"},
            {amount = 1, name = "weapon_carbinerifle", price = 0, slot = 5, type = "weapon"},
            {amount = 1, name = "weapon_assaultrifle", price = 0, slot = 6, type = "weapon"},
            {amount = 1, name = "weapon_smg", price = 0, slot = 7, type = "weapon"},
            {amount = 1, name = "weapon_microsmg", price = 0, slot = 8, type = "weapon"},
            {amount = 1, name = "weapon_carbinerifle_mk2", price = 0, slot = 9, type = "weapon"},
            {amount = 1, name = "weapon_pumpshotgun_mk2", price = 0, slot = 10, type = "weapon"},

            -- الذخائر
            {amount = 50, name = "pistol_ammo", price = 0, slot = 11, type = "item"},
            {amount = 50, name = "rifle_ammo", price = 0, slot = 12, type = "item"},
            {amount = 50, name = "mg_ammo", price = 0, slot = 13, type = "item"},
            {amount = 50, name = "shotgun_ammo", price = 0, slot = 14, type = "item"},

            -- معدات الشرطة
            {amount = 50, name = "heavy_armor", price = 0, slot = 15, type = "item"},
            {amount = 50, name = "breaker", price = 0, slot = 16, type = "item"},
            {amount = 50, name = "hacking_device", price = 0, slot = 17, type = "item"},
            {amount = 100, name = "faberge-egg", price = 0, slot = 18, type = "item"},
            {amount = 50, name = "weapon_stungun", price = 0, slot = 19, type = "weapon"},
            {amount = 50, name = "weapon_fireextinguisher", price = 0, slot = 20, type = "weapon"},
            {amount = 50, name = "weapon_flashlight", price = 0, slot = 21, type = "weapon"},

            -- إسعافات ومستلزمات
            {amount = 50, name = "firstaid", price = 0, slot = 22, type = "item"},
            {amount = 50, name = "bandage", price = 0, slot = 23, type = "item"},
            {amount = 50, name = "painkillers", price = 0, slot = 24, type = "item"},

            -- معدات متنوعة
            {amount = 50, name = "parachute", price = 0, slot = 25, type = "item"},
            {amount = 50, name = "radio", price = 0, slot = 26, type = "item"},
            {amount = 50, name = "nos", price = 0, slot = 27, type = "item"},
            {amount = 50, name = "binoculars", price = 0, slot = 28, type = "item"},
            {amount = 50, name = "diving_gear", price = 0, slot = 29, type = "item"},

            -- معدات السرقات
            {amount = 50, name = "advancedlockpick", price = 0, slot = 30, type = "item"},
            {amount = 50, name = "lockpick", price = 0, slot = 31, type = "item"},
            {amount = 50, name = "screwdriverset", price = 0, slot = 32, type = "item"},
            {amount = 50, name = "electronickit", price = 0, slot = 33, type = "item"},
            {amount = 50, name = "gatecrack", price = 0, slot = 34, type = "item"},
            {amount = 50, name = "trojan_usb", price = 0, slot = 35, type = "item"},

            -- موارد
            {amount = 10000, name = "refined_aluminium", price = 0, slot = 36, type = "item"},
            {amount = 10000, name = "refined_copper", price = 0, slot = 37, type = "item"},
            {amount = 10000, name = "refined_glass", price = 0, slot = 38, type = "item"},
            {amount = 10000, name = "refined_plastic", price = 0, slot = 39, type = "item"},
            {amount = 10000, name = "refined_rubber", price = 0, slot = 40, type = "item"},
            {amount = 10000, name = "refined_scrap", price = 0, slot = 41, type = "item"},
            {amount = 10000, name = "refined_steel", price = 0, slot = 42, type = "item"},
            {amount = 10000, name = "metalscrap", price = 0, slot = 43, type = "item"},

            -- عناصر متناقضة (يمكنك تعديلها أو حذفها حسب سياستك)
            {amount = 50, name = "joint", price = 0, slot = 44, type = "item"},
            {amount = 50, name = "beer", price = 0, slot = 45, type = "item"},
            {amount = 50, name = "sandwich", price = 0, slot = 46, type = "item"},
            {amount = 111, name = "tenkgoldchain", price = 0, slot = 47, type = "item"},
            {amount = 10000, name = "head_bag", price = 0, slot = 48, type = "item"},
            {amount = 10000, name = "crack_baggy", price = 0, slot = 49, type = "item"},

            -- إضافات تقنية
            {amount = 50, name = "phone", price = 0, slot = 50, type = "item"},
            {amount = 50, name = "repairkit", price = 0, slot = 51, type = "item"},
            {amount = 50, name = "cleaningkit", price = 0, slot = 52, type = "item"}


        },
        label = "Police",
        slots = 20
    })
end, { r = 0, g = 120, b = 255 })

-- 🟫 دالة العرض ثلاثي الأبعاد للنص
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- 🎯 ثريد تشغيل الرسم حسب التفعيل
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIds then
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                if DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local playerName = GetPlayerName(player)
                    local playerId = GetPlayerServerId(player)
                    DrawText3D(coords.x, coords.y, coords.z + 1.0, playerName .. " [" .. playerId .. "]")
                end
            end
        end
    end
end)
