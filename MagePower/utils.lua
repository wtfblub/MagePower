local UnitAura = LibStub("LibClassicDurations").UnitAuraWrapper

local function UnitBuff(unit, index)
    local name, _, _, _, duration, expirationTime, _, _, _, spellId = UnitAura(unit, index, "HELPFUL")
    if name then
        return {
            name = name,
            duration = duration,
            expirationTime = expirationTime,
            spellId = spellId,
        }
    end

    return nil
end

MagePower.Utils = {}

function MagePower.Utils:ShortenString(str, length)
    if #str > length then
        return string.sub(str, 1, length)
    else
        return str
    end
end

function MagePower.Utils:ShortenPlayerName(str)
    return self:ShortenString(str, 11)
end

function MagePower.Utils:GetUnitBuffs(unitId)
    local auras = {}
    local i = 1
    local aura = UnitBuff(unitId, i)
    while aura do
        auras[aura.spellId] = aura
        i = i + 1
        aura = UnitBuff(unitId, i)
    end

    return auras
end

function MagePower.Utils:GetBuffDurationLeft(aura)
    return math.max(0, aura.expirationTime - GetTime())
end

function MagePower.Utils:FormatExpiration(expirationTime)
    return self:FormatDuration(math.max(0, expirationTime - GetTime()))
end

function MagePower.Utils:FormatDuration(duration)
    if duration == 0 then
        return "00:00"
    end

    local mins = math.floor(duration / 60)
    local secs = math.floor(duration % 60)
    return string.format("%02d:%02d", mins, secs)
end

function MagePower.Utils:DurationColor(duration, maxDuration)
    local percent = math.max(0, math.min(1, duration / maxDuration))
    if percent > 0.5 then
        return MagePower.optionsDb.profile.colors.buffDurationGood
    else
        return MagePower.optionsDb.profile.colors.buffDurationBad
    end
end

local buffOfInterestCache = {}
function MagePower.Utils:IsBuffOfInterest(spellId)
    local cacheValue = buffOfInterestCache[spellId]
    if cacheValue == false then
        return false
    end

    if cacheValue ~= nil then
        return true, cacheValue
    end

    local buffIndex = self:GetBuffIndexFromSpellId(spellId)
    if buffIndex then
        buffOfInterestCache[spellId] = buffIndex
        return true, buffIndex
    end

    buffOfInterestCache[spellId] = false
    return false
end

function MagePower.Utils:GetBuffIndexFromSpellId(spellId)
    for buffIndex, allBuffRanks in pairs(MagePower.Constants.Buffs) do
        for _, buff in pairs(allBuffRanks) do
            if buff == spellId then
                return buffIndex
            end
        end
    end

    return nil
end

function MagePower.Utils:GetMaxRankSpell(buffIndex)
    local spells = MagePower.Constants.BuffSpellInfos[buffIndex]
    local spell = nil
    for i = #spells, 1, -1 do
        if IsSpellKnown(spells[i].spellId) then
            return spells[i]
        end
    end

    return nil
end

function MagePower.Utils:PerformanceProfile(name)
    local t = {
        name = name,
        startTime = 0,
        totalTime = 0,
    }
    if MagePower.debugPerf then
        t.startTime = GetTimePreciseSec() * 1000
    end

    function t:Elapsed()
        if not MagePower.debugPerf then
            return 0
        end
        return (GetTimePreciseSec() * 1000) - self.startTime
    end

    function t:Report()
        if MagePower.debugPerf then
            MagePower:Print("PROFILE <" .. t.name .. "> " .. self:Elapsed() .. "ms")
        end
    end

    function t:ReportTotal()
        if MagePower.debugPerf then
            MagePower:Print("PROFILE <" .. t.name .. "> " .. self.totalTime .. "ms")
        end
    end

    function t:Restart()
        if MagePower.debugPerf then
            self.startTime = GetTimePreciseSec() * 1000
        end
    end

    function t:Add()
        self.totalTime = self.totalTime + self:Elapsed()
    end

    function t:TotalTime()
        return self.totalTime
    end

    return t
end

function MagePower.Utils:CloneTable(src)
    if type(src) == "table" then
        local copy = {}
        for key, value in next, src, nil do
            copy[key] = MagePower.Utils:CloneTable(value)
        end

        return copy
    end

    return src
end
