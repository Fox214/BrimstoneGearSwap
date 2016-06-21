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
    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
	state.WeaponMode = M{['description']='Weapon Mode', 'GreatKatana', 'Polearm'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Bow'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}

	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('GreatKatana')
	state.Stance:set('Offensive')
	state.RWeaponMode:set('Stats') 
 	flag.sekka = true
	flag.med = true
	flag.berserk = true
	flag.defender = true
	flag.aggressor = true
	flag.warcry = true
	flag.thirdeye = true

	pick_tp_weapon()

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	organizer_items = {
		new1="Hiza. Sune-Ate +1",
		new2="Hizamaru Kote +1",
		new3="Hizamaru Somen +1",
		new4="Hiza. Hizayoroi +1",
		new5="Kari. Brayettes +1",
		new6="Hiza. Haramaki +1",
		new7="",
		new8="",
		new9="",
		new10="",
		new11="",
		new12="Otronif Gloves +1",
		new13="Olseni Belt",
		new14="Apate Ring",
		new15="Sanctity Necklace",
		new16="Valor. Hose",
		new17="Valorous Mitts",
		new18="Valorous Greaves",
		new19="Valorous Mask",
		new20="Unkai Kabuto +2",
		new21="Amar Cluster",
		new22="",
		new23="",
		new24="Ginsen",
		new25="Savas Jawshan",
		new26="Assuage Earring",
		new27="Hetairoi Ring",
		new28="Count's Cuffs",
		new29="Laic Mantle",
		new30="Sarissapho. Belt",
		new31="Limbo Trousers",
		new32="Perception Ring",
		new33="Phalangite Mantle",
		new34="Yemaya Belt",
		new35="Baetyl Pendant",
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
    -- Sets to return to when not performing an action.
	-- Idle sets
	sets.idle = {head="Twilight Helm",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
			body="Twilight Mail",hands="Umuthi Gloves",ring1="Rajas Ring",ring2="Vengeful Ring",
			back="Atheling Mantle",waist="Wanion Belt",legs="Xaddi Cuisses",feet="Scamp's Sollerets"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})
    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {
        head="Valorous Mask",neck="Ganesha's Mala",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness",hands="Valorous Mitts",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Takaha Mantle",waist="Wanion Belt",legs="Unkai Haidate +2",feet="Scamp's Sollerets"}
   
	sets.engaged.Polearm = {}
	sets.engaged.GreatKatana = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Gavialis Helm",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Miki. Breastplate",hands="Buremte Gloves",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Grounded Mantle",waist="Nu Sash",legs="Wukong's Haka. +1",feet="Scamp's Sollerets"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Valorous Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Rheic Korazin +3",hands="Miki. Gauntlets",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Atheling Mantle",legs="Miki. Cuisses",feet="Mikinaak Greaves"})
	sets.Mode.Crit = set_combine(sets.engaged, {})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Otomi Helm",neck="Ganesha's Mala",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Porthos Byrnie",
			back="Atheling Mantle",legs="Xaddi Cuisses",feet="Ejekamal Boots"})
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Gavialis Helm",
			body="Porthos Byrnie",hands="Umuthi Gloves",
			back="Grounded Mantle",legs="Wukong's Haka. +1",feet="Ejekamal Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Digni. Earring",
			body="Unkai Domaru +2",hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Takaha Mantle",legs="Unkai Haidate +2",feet="Otronif Boots"})
	sets.Mode.STR = set_combine(sets.engaged, {
			head="Valorous Mask",neck="Lacono Neck. +1",
			body="Miki. Breastplate",hands="Miki. Gauntlets",ring1="Rajas Ring",ring2="Aife's Ring",
			back="Buquwik Cape",waist="Wanion Belt",legs="Wukong's Haka. +1",feet="Scamp's Sollerets"})
			
	--Initialize Main Weapons
	-- sets.engaged.GreatKatana = set_combine(sets.engaged, {main="Umaru",sub="Bloodrain Strap"})
	sets.engaged.GreatKatana = set_combine(sets.engaged, {main="Ichigohitofuri",sub="Bloodrain Strap"})
	sets.engaged.Polearm = set_combine(sets.engaged, {main="Gondo-Shizunori", sub="Bloodrain Strap"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {ranged="",ammo="Amar Cluster"}
	sets.ranged.Bow = {ranged="Velocity Bow",ammo="Sleep Arrow"}
	
	sets.engaged.GreatKatana.Stats = set_combine(sets.engaged.GreatKatana, sets.ranged.Stats)
	sets.engaged.GreatKatana.Bow = set_combine(sets.engaged.GreatKatana, sets.ranged.Bow)

	sets.engaged.GreatKatana.Acc = set_combine(sets.engaged.GreatKatana, sets.Mode.Acc)
	sets.engaged.GreatKatana.Att = set_combine(sets.engaged.GreatKatana, sets.Mode.Att)
	sets.engaged.GreatKatana.Crit = set_combine(sets.engaged.GreatKatana, sets.Mode.Crit)
	sets.engaged.GreatKatana.DA = set_combine(sets.engaged.GreatKatana, sets.Mode.DA)
	sets.engaged.GreatKatana.Haste = set_combine(sets.engaged.GreatKatana, sets.Mode.Haste)
	sets.engaged.GreatKatana.Skill = set_combine(sets.engaged.GreatKatana, sets.Mode.Skill, {})
	sets.engaged.GreatKatana.sTP = set_combine(sets.engaged.GreatKatana, sets.Mode.sTP)
	sets.engaged.GreatKatana.STR = set_combine(sets.engaged.GreatKatana, sets.Mode.STR)

	sets.engaged.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.Polearm.Att = set_combine(sets.engaged.Polearm, sets.Mode.Att)
	sets.engaged.Polearm.Crit = set_combine(sets.engaged.Polearm, sets.Mode.Crit)
	sets.engaged.Polearm.DA = set_combine(sets.engaged.Polearm, sets.Mode.DA)
	sets.engaged.Polearm.Haste = set_combine(sets.engaged.Polearm, sets.Mode.Haste)
	sets.engaged.Polearm.Skill = set_combine(sets.engaged.Polearm, {
			neck="Maskirova Torque",ear1="Tripudio Earring",
			body="Fazheluo R. Mail",ring2="Portus Ring",
			feet="Etamin Gambieras"})
	sets.engaged.Polearm.sTP = set_combine(sets.engaged.Polearm, sets.Mode.sTP)
	sets.engaged.Polearm.STR = set_combine(sets.engaged.Polearm, sets.Mode.STR)

 	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {}
	sets.WSDayBonus = {head="Gavialis Helm"} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",body="Rheic Korazin +3",waist="Fotia Belt"})
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {back="Letalis Mantle"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
 	-- Light/Earth, STR 60%
	sets.precast.WS['Tachi: Enpi'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})
 	
	-- Ice, STR 60%
	sets.precast.WS['Tachi: Hobaku'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Rheic Korazin +3",waist="Snow Belt"})
 
  	-- Light/Thunder, STR 60%
	sets.precast.WS['Tachi: Goten'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})
  	
	-- Fire, STR 75%
	sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS, {neck="Flame Gorget",body="Rheic Korazin +3",waist="Flame Belt"})
	
	-- Earth/Wind, STR 30%
	sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {})
 
   	-- Water/Thunder, STR 50% MND 30%
	sets.precast.WS['Tachi: Koki'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",body="Rheic Korazin +3",waist="Thunder Belt"})
 
	-- Ice/Wind,, STR 75%
    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {})

	-- Water/Ice, STR 75%
    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Rheic Korazin +3",waist="Snow Belt"})

	-- Fire/Light/Dark, STR 75%
    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Dark/Earth, STR 40% CHR 60%
    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
    
	-- Wind/Thunder/Dark, STR 73%
    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Tachi: Shoha'].Acc = set_combine(sets.precast.WS.Acc, {neck="Thunder Gorget"})
    sets.precast.WS['Tachi: Shoha'].Mod = set_combine(sets.precast.WS['Tachi: Shoha'], {waist="Thunder Belt"})

	-- Light/Water/Ice, STR 80%
	sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})
    sets.precast.WS['Tachi: Fudo'].Acc = set_combine(sets.precast.WS.Acc, {neck="Snow Gorget"})
    sets.precast.WS['Tachi: Fudo'].Mod = set_combine(sets.precast.WS['Tachi: Fudo'], {waist="Snow Belt"})

	-- Ice/Earth/Dark, STR 50%
    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {neck="Snow Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",})
    sets.precast.WS['Tachi: Rana'].Acc = set_combine(sets.precast.WS.Acc, {neck="Snow Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",})
    sets.precast.WS['Tachi: Rana'].Mod = set_combine(sets.precast.WS['Tachi: Rana'], {waist="Snow Belt"})

 	-- Light, STR 30% DEX 30%
	sets.precast.WS['Double Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})
		
	-- Light/Thunder, STR 40% INT 40%
	sets.precast.WS['Thunder Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Light/Thunder, STR 40% INT 40% 
	sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Thunder, STR 100%
	sets.precast.WS['Leg Sweep'] = set_combine(sets.precast.WS, {body="Rheic Korazin +3"})

	-- Darkness, STR 20% DEX 20% 
	sets.precast.WS['Penta Thrust'] = set_combine(sets.precast.WS, {neck="Shadow Gorget",body="Rheic Korazin +3",waist="Shadow Belt"})

	-- Light/Water, STR 50% AGI 50% 
	sets.precast.WS['Vorpal Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Dark/Earth/Ice, STR 100% -->
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {body="Rheic Korazin +3"})

	-- Light/Earth, STR 40% DEX 40%-->
	sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Dark/Earth/Light, STR 85% -->
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",back="Atheling Mantle",waist="Light Belt"})


    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {head="Myochin Kabuto",hands="Sakonji Kote",back="Takaha Mantle"}
    sets.precast.JA['Warding Circle'] = {head="Myochin Kabuto"}
    sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Yaoyotl Helm",
        body="Otronif Harness +1",hands="Buremte Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Yaoyotl Helm",
        body="Otronif Harness +1",hands="Otronif Gloves +1",
        legs="Phorcys Dirs",feet="Otronif Boots +1"}
     
    -- Defense sets
    sets.defense.PDT = {
        head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves +1",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Flume Belt",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}

    sets.defense.Reraise = {
        head="Twilight Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Twilight Mail",hands="Buremte Gloves",ring1="Defending Ring",ring2="Paguroidea Ring",
        back="Shadow Mantle",waist="Flume Belt",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}

    sets.defense.MDT = {
        head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Engulfer Cape",waist="Flume Belt",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}

    sets.Kiting = {feet="Danzo Sune-ate"}

    sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}

    sets.buff.Sekkanoki = {hands="Unkai Kote +2"}
    sets.buff.Sengikori = {feet="Unkai Sune-ate +2"}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        -- Change any GK weaponskills to polearm weaponskill if we're using a polearm.
        if player.equipment.main=='Quint Spear' or player.equipment.main=='Quint Spear' then
            if spell.english:startswith("Tachi:") then
                send_command('@input /ws "Penta Thrust" '..spell.target.raw)
                eventArgs.cancel = true
            end
        end
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
        if state.Buff.Sekkanoki then
            equip(sets.buff.Sekkanoki)
        end
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
        end
    end
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end


-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end
end


function job_buff_change(buff, gain)
	handle_sam_ja()
	if player.sub_job == 'WAR' then
		handle_war_ja()
	end
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
		classes.CustomMeleeGroups:append('Adoulin')
	end
	if areas.Assault:contains(world.area) then
		classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	handle_twilight()
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 9)
	elseif player.sub_job == 'DNC' then
		set_macro_page(2, 9)
	elseif player.sub_job == 'THF' then
		set_macro_page(3, 9)
	elseif player.sub_job == 'NIN' then
		set_macro_page(4, 9)
	else
		set_macro_page(1, 9)
	end
	send_command('exec sam.txt')
end

function job_self_command(cmdParams, eventArgs)
	handle_flags(cmdParams, eventArgs)
end
