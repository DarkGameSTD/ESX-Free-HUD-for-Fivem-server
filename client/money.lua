ESX, FrameWork = GetCore()
local lastMoney = {
    lastcash = 0,
    lastblack_money = 0,
    lastbank = 0,
    lastboss_money = 0
}

function LoadPlayerMoney(type, amount)
    if amount == nil then amount = 0 end  -- جلوگیری از undefined
    if lastMoney["last"..type] == nil then lastMoney["last"..type] = 0 end

    nuiMessage("LOAD_PLAYER_MONEY", {
        type = type,
        amount = amount
    })

    if lastMoney["last"..type] ~= amount then
        local change = amount - lastMoney["last"..type]
        TriggerEvent('RV_HuD:OnMoneyChange', math.abs(change), change < 0, type)
    end

    lastMoney["last"..type] = amount
end

RegisterNetEvent("RV_HuD:OnMoneyChange")
AddEventHandler("RV_HuD:OnMoneyChange", function(amount, minus, moneyType)
    nuiMessage("MONEY_CHANGE", {
        amount = amount,
        minus = minus,
        moneyType = moneyType
    })
end)

function LoadPlayerId()
    if Config and Config.PlayerServerId then
        nuiMessage("LOAD_PLAYER_ID", Config.PlayerServerId() or "Unknown")
    end
end

function LoadPlayerName(name)
    nuiMessage("LOAD_PLAYER_NAME", name or "Unknown")
end

function LoadPlayerJob(job_label, job_grade_label)
    nuiMessage("LOAD_PLAYER_JOB", {
        job_label = job_label or "Unknown",
        job_grade_label = job_grade_label or "N/A"
    })
end

function LoadPlayerSecJob()
    if Config and Config.SecondJob and Config.SecondJob.func then
        Config.SecondJob.func()
    end
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    WaitNUI()
    LoadPlayerJob(job.label or "Unknown", job.grade_label or "N/A")
end)

local bankMoney = 0
RegisterNetEvent('Hz_BlackMoneyUpdate')
AddEventHandler('Hz_BlackMoneyUpdate', function(m)
    ESX.PlayerData.black_money = m or 0
    LoadPlayerMoney("black_money", m)
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(m)
    ESX.PlayerData.money = m or 0
    LoadPlayerMoney("cash", m)
end)

RegisterNetEvent('bankUpdate')
AddEventHandler('bankUpdate', function(m)
    ESX.PlayerData.bank = m or 0
    bankMoney = ESX.PlayerData.bank
    LoadPlayerMoney("bank", bankMoney)
end)

function LoadPlayerInformations()
    WaitCore()
    WaitPlayer()
    WaitNUI()

    local cash = 0
    local bank = 0
    local job_label = "Unknown"
    local job_grade_label = "N/A"
    local playerName = "Unknown"

    local PlayerData = ESX.GetPlayerData()
    if PlayerData and PlayerData.name then
        playerName = string.gsub(PlayerData.name, "_", " ")
    end

    local esxCash = TriggerCallback("RV_HuD:GetCash") or 0
    local esxBank = TriggerCallback("RV_HuD:GetBank") or 0

    if PlayerData and PlayerData.job then
        job_label = PlayerData.job.label or "Unknown"
        job_grade_label = PlayerData.job.grade_label or "N/A"
    end

    LoadPlayerName(playerName)
    LoadPlayerId()
    LoadPlayerMoney("cash", esxCash)
    LoadPlayerMoney("bank", esxBank)
    LoadPlayerJob(job_label, job_grade_label)
    LoadPlayerSecJob()
end

CreateThread(function()
    WaitCore()
    WaitNUI()

    if Config and Config.MoneyHud then
        if Config.MoneyHud.cash then
            ForceAccountVisibility("cash", Config.MoneyHud.cash.show or false)
        end
        if Config.MoneyHud.bank then
            ForceAccountVisibility("bank", Config.MoneyHud.bank.show or false)
        end
        if Config.MoneyHud.black_money then
            ForceAccountVisibility("black_money", Config.MoneyHud.black_money.show or false)
            if Config.MoneyHud.black_money.getMoney then
                Config.MoneyHud.black_money.getMoney(Config.MoneyHud.black_money)
            end
        end
        if Config.MoneyHud.vip_money then
            ForceAccountVisibility("vip_money", Config.MoneyHud.vip_money.show or false)
            if Config.MoneyHud.vip_money.getMoney then
                Config.MoneyHud.vip_money.getMoney(Config.MoneyHud.vip_money)
            end
        end
        if Config.MoneyHud.boss_money and Config.MoneyHud.boss_money.getMoney then
            Config.MoneyHud.boss_money.getMoney(Config.MoneyHud.boss_money)
        end
    end
end)

function ForceAccountVisibility(type, value)
    nuiMessage("FORCE_ACCOUNT_VISIBILITY", {
        type = type,
        value = value or false
    })
end
