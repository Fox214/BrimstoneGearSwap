include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Footwork = buffactive.Footwork or false
    state.Buff.Impetus = buffactive.Impetus or false

    state.FootworkWS = M(false, 'Footwork on WS')

    info.impetus_hit_count = 0
    windower.raw_register_event('action', on_action_for_impetus)
	state.WeaponMode = M{['description']='Weapon Mode', 'H2H', 'Staff', 'Club'}
 	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}

	pick_tp_weapon()
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
    state.WeaponskillMode:options('Normal', 'SomeAcc', 'Acc', 'Fodder')
	state.DefenseMode:options('None', 'Physical', 'Magical')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Evasion', 'Counter')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('H2H')
	state.Stance:set('Offensive')

    update_combat_form()
    update_melee_groups()

	send_command('bind ^` gs c cycle WeaponMode')
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	organizer_items = {
		new1="Apate Ring",
		new2="Sanctity Necklace",
		new3="Amar Cluster",
		new4="Ginsen",
		new5="Assuage Earring",
		new6="Hetairoi Ring",
		new7="Count's Cuffs",
		new8="Laic Mantle",
		new9="Limbo Trousers",
		new10="Lilitu Headpiece",
		new11="Herculean Gloves",
		new12="Clotharius Torque",
		new13="Herculean Boots",
		new14="Herculean Helm",
		new15="Perception Ring",
		new16="Herculean Vest",
		new17="Phalangite Mantle",
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}

    -- Idle sets
    sets.idle = {ammo="Amar Cluster",
        head="Felistris Mask",neck="Wiglen Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Mel. Cyclas +2",hands="Hesychast's Gloves +1",ring1="Vengeful Ring",ring2="Paguroidea Ring",
        back="Iximulew Cape",waist="Black Belt",legs="Qaaxo Tights",feet="Herald's Gaiters"}

    sets.idle.Town = set_combine(sets.idle, {})
    
    sets.idle.Weak = set_combine(sets.idle, {})

    -- Resting sets
    sets.resting = set_combine(sets.idle, {head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
        body="Hesychast's Cyclas",ring1="Sheltered Ring",ring2="Paguroidea Ring"})
		
    -- Normal melee group
    sets.engaged = {ammo="Potestas Bomblet",
        head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness",hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Atheling Mantle",waist="Black Belt",legs="Wukong's Haka. +1",feet="Otronif Boots"}
	sets.engaged.H2H = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, { ammo="Honed Tathlum",
			head="Whirlpool Mask",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Mextli Harness",hands="Hes. Gloves +1",ring2="Ulthalam's Ring",
			back="Anchoret's Mantle",waist="Olseni Belt",legs="Wukong's Haka. +1",feet="Tantra Gaiters +2"})
	sets.Mode.Att= set_combine(sets.engaged, {ammo="Potestas Bomblet",
			head="Whirlpool Mask",neck="Lacono Neck. +1",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			hands="Hes. Gloves +1",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Atheling Mantle",legs="Quiahuiz Trousers",feet="Thaumas Nails"})
	sets.Mode.Crit = set_combine(sets.engaged, {
			head="Uk'uxkaj Cap",
			body="Mextli Harness"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Tantra Crown +2",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Tantra Cyclas +2",hands="Tantra Gloves +2",
			back="Atheling Mantle",legs="Quiahuiz Trousers",feet="Thaumas Nails"})
	sets.Mode.Haste = set_combine(sets.engaged, {ammo="Hasty Pinion",
			head="Ejekamal Mask",
			body="Tantra Cyclas +2",hands="Otronif Gloves +1",ring2="Blitz Ring",
			back="Grounded Mantle",waist="Black Belt",legs="Kaabnax Trousers",feet="Otronif Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Tantra Crown +2",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Digni. Earring",
			hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Anchoret's Mantle",waist="Olseni Belt",legs="Mel. Hose +2",feet="Otronif Boots"})
	sets.Mode.STR = set_combine(sets.engaged, {ammo="Amar Cluster",
			head="Whirlpool Mask",neck="Lacono Neck. +1",
			body="Anchorite's Cyclas",hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="Aife's Ring",
			back="Buquwik Cape",waist="Black Belt",legs="Herculean Trousers",feet="Otronif Boots"})

	sets.engaged.H2H = set_combine(sets.engaged, {main="Eshus"})
	sets.engaged.H2H.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.H2H.Att = set_combine(sets.engaged.H2H, sets.Mode.Att)
	sets.engaged.H2H.Crit = set_combine(sets.engaged.H2H, sets.Mode.Crit)
	sets.engaged.H2H.DA = set_combine(sets.engaged.H2H, sets.Mode.DA)
	sets.engaged.H2H.Haste = set_combine(sets.engaged.H2H, sets.Mode.Haste)
	sets.engaged.H2H.Skill = set_combine(sets.engaged.H2H, { ammo="Tantra Tathlum",
			head="Brisk Mask",neck="Faith Torque",ear1="Kemas Earring",
			hands="Tantra Gloves +2",ring2="Portus Ring",
			back="Belenos' Mantle"})
	sets.engaged.H2H.sTP = set_combine(sets.engaged.H2H, sets.Mode.sTP)
	sets.engaged.H2H.STR = set_combine(sets.engaged.H2H, sets.Mode.STR)
	sets.engaged.Staff = set_combine(sets.engaged, {main="Eminent Staff",sub="Pole Grip"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.Staff.Skill = set_combine(sets.engaged.H2H, sets.Mode.Skill)
	sets.engaged.Club = set_combine(sets.engaged, {main="Warp Cudgel"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.Club.Skill = set_combine(sets.engaged.H2H, sets.Mode.Skill)
			
    -- Precast Sets
    
    -- Precast sets to enhance JAs on use
    sets.precast.JA['Hundred Fists'] = {legs="Mel. Hose +2"}
    sets.precast.JA['Boost'] = {hands="Anchorite's Gloves +1"}
    sets.precast.JA['Dodge'] = {feet="Tpl. Gaiters +1"}
    sets.precast.JA['Focus'] = {head="Anchorite's Crown"}
    sets.precast.JA['Counterstance'] = {feet="Mel. Gaiters +2"}
    sets.precast.JA['Footwork'] = {feet="Tantra Gaiters +2"}
    sets.precast.JA['Formless Strikes'] = {body="Mel. Cyclas +2"}
    sets.precast.JA['Mantra'] = {feet="Mel. Gaiters +2"}

	-- MND
    sets.precast.JA['Chi Blast'] = {
        head="Mel. Crown +2",neck="Faith Torque",
        body="Otronif Harness +1",hands="Hesychast's Gloves +1",
        back="Tuilha Cape",legs="Hesychast's Hose +1",feet="Anchorite's Gaiters +1"}

	-- VIT
    sets.precast.JA['Chakra'] = {ammo="Iron Gobbet",
        head="Whirlpool Mask",
        body="Anchorite's Cyclas",hands="Hes. Gloves +1",ring1="Spiral Ring",
        back="Anchoret's Mantle",waist="Caudata Belt",legs="Nahtirah Trousers",feet="Thurandaut Boots"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Uk'ukaj Cap",
        body="Otronif Harness",hands="Otronif Gloves +1",ring1="Spiral Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Nahtirah Trousers",feet="Otronif Boots"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}


    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Impatiens",head="Haruspex hat",ear2="Loquacious Earring",hands="Thaumas Gloves"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",waist="Fotia Belt"})    
    sets.precast.WSAcc = {ammo="Honed Tathlum",body="Manibozho Jerkin",back="Letalis Mantle",feet="Qaaxo Leggings"}
    sets.precast.WSMod = {ammo="Tantra Tathlum",head="Felistris Mask",legs="Hesychast's Hose +1",feet="Daihanshi Habaki"}
    sets.precast.MaxTP = {ear1="Bladeborn Earring",ear2="Steelflash Earring"}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, sets.precast.WSAcc)
    sets.precast.WS.Mod = set_combine(sets.precast.WS, sets.precast.WSMod)

    -- Specific weaponskill sets.
	-- Thunder, STR 30% DEX 30%
	sets.precast.WS['Combo'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",waist="Thunder Belt"})
	
	-- Thunder/Water, VIT 100%
	sets.precast.WS['Shoulder Tackle'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",waist="Thunder Belt"})
	
	-- Dark, VIT 100%
	sets.precast.WS['One Inch Punch'] = set_combine(sets.precast.WS, {neck="Dark Gorget",waist="Dark Belt"})
	
	-- Wind, STR 50% DEX 50%
	sets.precast.WS['Backhand Blow'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})

	-- Thunder, STR 30% DEX 30%
	sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",waist="Thunder Belt"})
	
	-- Thunder/Fire, STR 100%
	sets.precast.WS['Spinning Attack'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",waist="Thunder Belt"})
 
	-- Light/Thunder, STR 20% DEX 50%
    sets.precast.WS['Howling Fist']    = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt",legs="Manibozho Brais",feet="Daihanshi Habaki"})
    
	-- Wind/Thunder, STR 50% DEX 50%
    sets.precast.WS['Dragon Kick']     = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt",feet="Daihanshi Habaki"})
	
	-- Dark/Earth/Fire, STR 15% VIT 15%
	sets.precast.WS['Asuran Fists']    = set_combine(sets.precast.WS, {neck="Dark Gorget",
        ear1="Bladeborn Earring",ring2="Spiral Ring",back="Buquwik Cape",waist="Dark Belt"})
    
	-- Wind/Thunder/Ice, STR 40% VIT 40%
    sets.precast.WS['Tornado Kick']    = set_combine(sets.precast.WS, {ammo="Tantra Tathlum", neck="Breeze Gorget",ring1="Spiral Ring",waist="Breeze Belt"})
	
	-- Fire/Light/Water, DEX 73%
    sets.precast.WS['Shijin Spiral']   = set_combine(sets.precast.WS, {
		head="Uk'uxkaj Cap",neck="Light Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Otronif Harness",hands="Otronif Gloves +1",ring1="Rajas Ring",
        waist="Light Belt",legs="Manibozho Brais",feet="Otronif Boots"})
	
	-- Light/Wind/Thunder, STR 80% 
    sets.precast.WS["Victory Smite"]   = set_combine(sets.precast.WS, {neck="Light Gorget",back="Buquwik Cape",waist="Light Belt",feet="Qaaxo Leggings"})

	-- Light/Fire, STR 50% VIT 50%
    sets.precast.WS["Ascetic's Fury"]  = set_combine(sets.precast.WS, { ammo="Tantra Tathlum",
	    neck="Light Gorget",ring1="Spiral Ring",back="Buquwik Cape",waist="Light Belt",feet="Qaaxo Leggings"})
 
    sets.precast.WS["Raging Fists"].Acc = set_combine(sets.precast.WS["Raging Fists"], sets.precast.WSAcc)
    sets.precast.WS["Howling Fist"].Acc = set_combine(sets.precast.WS["Howling Fist"], sets.precast.WSAcc)
    sets.precast.WS["Asuran Fists"].Acc = set_combine(sets.precast.WS["Asuran Fists"], sets.precast.WSAcc)
    sets.precast.WS["Ascetic's Fury"].Acc = set_combine(sets.precast.WS["Ascetic's Fury"], sets.precast.WSAcc)
    sets.precast.WS["Victory Smite"].Acc = set_combine(sets.precast.WS["Victory Smite"], sets.precast.WSAcc)
    sets.precast.WS["Shijin Spiral"].Acc = set_combine(sets.precast.WS["Shijin Spiral"], sets.precast.WSAcc)
    sets.precast.WS["Dragon Kick"].Acc = set_combine(sets.precast.WS["Dragon Kick"], sets.precast.WSAcc)
    sets.precast.WS["Tornado Kick"].Acc = set_combine(sets.precast.WS["Tornado Kick"], sets.precast.WSAcc)

    sets.precast.WS["Raging Fists"].Mod = set_combine(sets.precast.WS["Raging Fists"], sets.precast.WSMod)
    sets.precast.WS["Howling Fist"].Mod = set_combine(sets.precast.WS["Howling Fist"], sets.precast.WSMod)
    sets.precast.WS["Asuran Fists"].Mod = set_combine(sets.precast.WS["Asuran Fists"], sets.precast.WSMod)
    sets.precast.WS["Ascetic's Fury"].Mod = set_combine(sets.precast.WS["Ascetic's Fury"], sets.precast.WSMod)
    sets.precast.WS["Victory Smite"].Mod = set_combine(sets.precast.WS["Victory Smite"], sets.precast.WSMod)
    sets.precast.WS["Shijin Spiral"].Mod = set_combine(sets.precast.WS["Shijin Spiral"], sets.precast.WSMod)
    sets.precast.WS["Dragon Kick"].Mod = set_combine(sets.precast.WS["Dragon Kick"], sets.precast.WSMod)
    sets.precast.WS["Tornado Kick"].Mod = set_combine(sets.precast.WS["Tornado Kick"], sets.precast.WSMod)

	-- Dark/Water, STR 30% INT 30%
    sets.precast.WS['Cataclysm'] = {
        head="Wayfarer Circlet",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Wayfarer Robe",hands="Otronif Gloves +1",ring2="Demon's Ring",
        back="Toro Cape",waist="Thunder Belt",legs="Nahtirah Trousers",feet="Qaaxo Leggings"}
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Whirlpool Mask",ear2="Loquacious Earring",
        body="Otronif Harness +1",hands="Thaumas Gloves",
        waist="Black Belt",feet="Otronif Boots +1"}
        
    -- Specific spells
    sets.midcast.Utsusemi = {
        head="Whirlpool Mask",ear2="Loquacious Earring",
        body="Otronif Harness +1",hands="Thaumas Gloves",
        waist="Black Belt",legs="Qaaxo Tights",feet="Otronif Boots +1"}
    
    -- Sets to return to when not performing an action.
    
    -- Defense sets
    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Uk'uxkaj Cap",neck="Twilight Torque",
        body="Otronif Harness +1",hands="Otronif Gloves +1",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Black Belt",legs="Qaaxo Tights",feet="Otronif Boots +1"}

    sets.defense.HP = {ammo="Iron Gobbet",
        head="Uk'uxkaj Cap",neck="Lavalier +1",ear1="Brutal Earring",ear2="Bloodgem Earring",
        body="Hesychast's Cyclas",hands="Hesychast's Gloves +1",ring1="K'ayres Ring",ring2="Meridian Ring",
        back="Shadow Mantle",waist="Black Belt",legs="Hesychast's Hose +1",feet="Hesychast's Gaiters +1"}

    sets.defense.MDT = {ammo="Demonry Stone",
        head="Uk'uxkaj Cap",neck="Twilight Torque",
        body="Otronif Harness +1",hands="Otronif Gloves +1",ring1="Vengeful Ring",ring2="Shadow Ring",
        back="Engulfer Cape",waist="Black Belt",legs="Qaaxo Tights",feet="Daihanshi Habaki"}

    sets.defense.Counter = {ammo="Amar Cluster",
        head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves +1",ring1="K'ayres Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Windbuffet Belt",legs="Anchorite's Hose",feet="Otronif Boots +1"}

    sets.Kiting = {feet="Herald's Gaiters"}

    sets.ExtraRegen = {head="Ocelomeh Headpiece +1"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    

    -- Hundred Fists/Impetus melee set mods
    sets.engaged.HF = set_combine(sets.engaged)
    sets.engaged.HF.Impetus = set_combine(sets.engaged, {body="Tantra Cyclas +2"})
    sets.defense.Counter.HF = set_combine(sets.defense.Counter)
    sets.defense.Counter.HF.Impetus = set_combine(sets.defense.Counter, {body="Tantra Cyclas +2"})

    -- Footwork combat form
    sets.engaged.Footwork = {ammo="Amar Cluster",
        head="Felistris Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Qaaxo Harness",hands="Hesychast's Gloves +1",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Windbuffet Belt",legs="Hesychast's Hose +1",feet="Anchorite's Gaiters +1"}
    sets.engaged.Footwork.Acc = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Hesychast's Gloves +1",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Letalis Mantle",legs="Hesychast's Hose +1",feet="Anchorite's Gaiters +1"}
        
    -- Quick sets for post-precast adjustments, listed here so that the gear can be Validated.
    sets.impetus_body = {body="Tantra Cyclas +2"}
    sets.footwork_kick_feet = {feet="Anchorite's Gaiters +1"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Don't gearswap for weaponskills when Defense is on.
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        eventArgs.handled = true
    end
	if spell.type == 'WeaponSkill' and spell.target.distance > 5.1 then
		cancel_spell()
		add_to_chat(123, 'WeaponSkill Canceled: [Out of Range]')
	end
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        if state.Buff.Impetus and (spell.english == "Ascetic's Fury" or spell.english == "Victory Smite") then
            -- Need 6 hits at capped dDex, or 9 hits if dDex is uncapped, for Tantra to tie or win.
            if (state.OffenseMode.current == 'Fodder' and info.impetus_hit_count > 5) or (info.impetus_hit_count > 8) then
                equip(sets.impetus_body)
            end
        elseif state.Buff.Footwork and (spell.english == "Dragon's Kick" or spell.english == "Tornado Kick") then
            equip(sets.footwork_kick_feet)
        end
        
        -- Replace Moonshade Earring if we're at cap TP
        if player.tp == 3000 then
            equip(sets.precast.MaxTP)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and not spell.interrupted and state.FootworkWS and state.Buff.Footwork then
        send_command('cancel Footwork')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Set Footwork as combat form any time it's active and Hundred Fists is not.
    if buff == 'Footwork' and gain and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    elseif buff == "Hundred Fists" and not gain and buffactive.footwork then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
    
    -- Hundred Fists and Impetus modify the custom melee groups
    if buff == "Hundred Fists" or buff == "Impetus" then
        classes.CustomMeleeGroups:clear()
        
        if (buff == "Hundred Fists" and gain) or buffactive['hundred fists'] then
            classes.CustomMeleeGroups:append('HF')
        end
        
        if (buff == "Impetus" and gain) or buffactive.impetus then
            classes.CustomMeleeGroups:append('Impetus')
        end
    end

    -- Update gear if any of the above changed
    if buff == "Hundred Fists" or buff == "Impetus" or buff == "Footwork" then
        handle_equipping_gear(player.status)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
    if player.hpp < 75 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	if areas.Assault:contains(world.area) then
			classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()

    update_combat_form()
    update_melee_groups()
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if buffactive.footwork and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()
    
    if buffactive['hundred fists'] then
        classes.CustomMeleeGroups:append('HF')
    end
    
    if buffactive.impetus then
        classes.CustomMeleeGroups:append('Impetus')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 10)
		send_command('exec mnkdnc.txt')
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 10)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 10)
    elseif player.sub_job == 'RUN' then
        set_macro_page(4, 10)
    else
        set_macro_page(1, 10)
    end
	send_command('exec mnk.txt')
end


-------------------------------------------------------------------------------------------------------------------
-- Custom event hooks.
-------------------------------------------------------------------------------------------------------------------

-- Keep track of the current hit count while Impetus is up.
function on_action_for_impetus(action)
    if state.Buff.Impetus then
        -- count melee hits by player
        if action.actor_id == player.id then
            if action.category == 1 then
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- Reactions (bitset):
                        -- 1 = evade
                        -- 2 = parry
                        -- 4 = block/guard
                        -- 8 = hit
                        -- 16 = JA/weaponskill?
                        -- If action.reaction has bits 1 or 2 set, it missed or was parried. Reset count.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 1
                        end
                    end
                end
            elseif action.category == 3 then
                -- Missed weaponskill hits will reset the counter.  Can we tell?
                -- Reaction always seems to be 24 (what does this value mean? 8=hit, 16=?)
                -- Can't tell if any hits were missed, so have to assume all hit.
                -- Increment by the minimum number of weaponskill hits: 2.
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- This will only be if the entire weaponskill missed or was parried.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 2
                        end
                    end
                end
            end
        elseif action.actor_id ~= player.id and action.category == 1 then
            -- If mob hits the player, check for counters.
            for _,target in pairs(action.targets) do
                if target.id == player.id then
                    for _,action in pairs(target.actions) do
                        -- Spike effect animation:
                        -- 63 = counter
                        -- ?? = missed counter
                        if action.has_spike_effect then
                            -- spike_effect_message of 592 == missed counter
                            if action.spike_effect_message == 592 then
                                info.impetus_hit_count = 0
                            elseif action.spike_effect_animation == 63 then
                                info.impetus_hit_count = info.impetus_hit_count + 1
                            end
                        end
                    end
                end
            end
        end
        
        --add_to_chat(123,'Current Impetus hit count = ' .. tostring(info.impetus_hit_count))
    else
        info.impetus_hit_count = 0
    end
    
end
