MagePower.Constants = {}

MagePower.Constants.DefaultMagePowerDB = {
    profile = {
        showAnchor = true,
        colors = {
            buffStateGood = { 0.0, 0.7, 0.0, 0.7 },
            buffStateSome = { 1.0, 1.0, 0.5, 0.7 },
            buffStateBad = { 1.0, 0.0, 0.0, 0.7 },
            buffDurationGood = { 0.0, 1.0, 0.0, 1.0 },
            buffDurationBad = { 1.0, 0.81, 0.29, 1.0 },
            unitInRange = { 0.0, 1.0, 0.0, 1.0 },
            unitVisible = { 1.0, 0.81, 0.29, 1.0 },
            unitOutOfRange = { 1.0, 0.0, 0.0, 1.0 },
            unitStatus = { 1.0, 0.0, 0.0, 1.0 },
        },
        gui = {
            showNumMissing = true,
            showGroupNumber = true,
            position = {
                point = "CENTER",
                x = 0,
                y = 0
            },
            style = {
                font = "Friz Quadrata TT",
                border = {
                    texture = "Blizzard Dialog",
                    size = 3,
                    color = { 1.0, 1.0, 1.0, 1.0 },
                },
                background = {
                    texture = "Blizzard Raid Bar",
                }
            },
        },
    }
}

MAGEPOWER_BUFFINDEX_AI = 1
MAGEPOWER_BUFFINDEX_AB = 2

MagePower.Constants.Buffs = {
    [MAGEPOWER_BUFFINDEX_AI] = {
        1459, -- Arcane Intellect Rank 1
        1460, -- Arcane Intellect Rank 2
        1461, -- Arcane Intellect Rank 3
        10156, -- Arcane Intellect Rank 4
        10157, -- Arcane Intellect Rank 5
    },
    [MAGEPOWER_BUFFINDEX_AB] = {
        23028, -- Arcane Brilliance Rank 1
    },
}

MagePower.Constants.BuffSpellInfos = {}

for buffIndex, buffs in ipairs(MagePower.Constants.Buffs) do
    for i, spellId in ipairs(buffs) do
        if not MagePower.Constants.BuffSpellInfos[buffIndex] then
            MagePower.Constants.BuffSpellInfos[buffIndex] = {}
        end
        local name = GetSpellInfo(spellId)
        local rank = C_Spell.GetSpellSubtext(spellId)
        MagePower.Constants.BuffSpellInfos[buffIndex][i] = {
            spellId = spellId,
            name = name,
            rank = rank,
        }
    end
end

MagePower.Constants.BuffDurationThreshold = {
    [MAGEPOWER_BUFFINDEX_AI] = 20 * 60,   -- 20 minutes
    [MAGEPOWER_BUFFINDEX_AB] = 20 * 60,   -- 20 minutes
}
