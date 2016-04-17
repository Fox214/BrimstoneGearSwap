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
    state.Buff.Sentinel = buffactive.sentinel or false
    state.Buff.Cover = buffactive.cover or false
    state.Buff.Doom = buffactive.Doom or false
	state.WeaponMode = M{['description']='Weapon Mode', 'Sword', 'GreatSword', 'Staff', 'Club', 'Polearm'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	get_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('Sword')
	state.Stance:set('Defensive')
	state.SubMode:set('Shield')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Reraise', 'Charm')
    state.MagicalDefenseMode:options('MDT', 'HP', 'Reraise', 'Charm')
    
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP', 'Knockback', 'MP_Knockback'}
    state.EquipShield = M(false, 'Equip Shield w/Defense')

    update_defense_mode()
    
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')

 	pick_tp_weapon()
    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	-- Idle sets
	sets.idle = {head="Twilight Helm",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
			body="Twilight Mail",hands="Umuthi Gloves",ring1="Rajas Ring",ring2="Ulthalam's Ring",
			back="Atheling Mantle",waist="Zoran's Belt",legs="Crimson Cuisses",feet="Scamp's Sollerets"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

		-- Normal melee group
	sets.engaged = {ammo="Potestas Bomblet",
			head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Miki. Breastplate",hands="Miki. Gauntlets",ring1="Rajas Ring",ring2="Cho'j Band",
			back="Atheling Mantle",waist="Zoran's Belt",legs="Crimson Cuisses",feet="Scamp's Sollerets"}
	sets.engaged.GreatSword = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Polearm = {}
	sets.engaged.Club = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Yaoyotl Helm",neck="Iqabi Necklace",ear1="Heartseeker Earring",ear2="Steelflash Earring",
			body="Miki. Breastplate",hands="Buremte Gloves",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			waist="Nu Sash",feet="Scamp's Sollerets"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Mekira-oto +1",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Rheic Korazin +3",hands="Miki. Gauntlets",ring1="Excelsis Ring",ring2="Cho'j Band",
			back="Atheling Mantle",waist="Zoran's Belt",legs="Miki. Cuisses",feet="Mikinaak Greaves"})
	sets.Mode.Crit = set_combine(sets.engaged, {})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Otomi Helm",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Porthos Byrnie",
			feet="Ejekamal Boots"})
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Otomi Helm",ear1="Heartseeker Earring",ear2="Dudgeon Earring",
			body="Porthos Byrnie",hands="Umuthi Gloves",
			waist="Zoran's Belt",feet="Ejekamal Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Brutal Earring",
			hands="Cizin Mufflers",ring1="Rajas Ring",ring2="K'ayres Ring",
			legs="Phorcys Dirs",feet="Mikinaak Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, {
			head="Otomi Helm",
			body="Miki. Breastplate",hands="Miki. Gauntlets",ring1="Rajas Ring",ring2="Aife's Ring",
			waist="Wanion Belt",feet="Scamp's Sollerets"})
			
	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Kumbhakarna"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Viking Shield"})
	sets.engaged.Grip.GreatSword = set_combine(sets.engaged, {main="Algol",sub="Pole Grip"})
	sets.engaged.Grip.Polearm = set_combine(sets.engaged, {main="Gondo-Shizunori", sub="Pole Grip"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Chatoyant Staff", sub="Pole Grip"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Usonmunku",sub="Kumbhakarna"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Usonmunku",sub="Viking Shield"})

	sets.engaged.Grip.GreatSword.Acc = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Acc)
	sets.engaged.Grip.GreatSword.Att = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Att)
	sets.engaged.Grip.GreatSword.Crit = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Crit)
	sets.engaged.Grip.GreatSword.DA = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.DA)
	sets.engaged.Grip.GreatSword.Haste = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Haste)
	sets.engaged.Grip.GreatSword.Skill = set_combine(sets.engaged.Grip.GreatSword, {})
	sets.engaged.Grip.GreatSword.sTP = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.sTP)
	sets.engaged.Grip.GreatSword.STR = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.STR)
	
	
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.DW.Club.Att = set_combine(sets.engaged.DW.Club, sets.Mode.Att)
	sets.engaged.DW.Club.Crit = set_combine(sets.engaged.DW.Club, sets.Mode.Crit)
	sets.engaged.DW.Club.DA = set_combine(sets.engaged.DW.Club, sets.Mode.DA)
	sets.engaged.DW.Club.Haste = set_combine(sets.engaged.DW.Club, sets.Mode.Haste)
	sets.engaged.DW.Club.Skill = set_combine(sets.engaged.DW.Club, {})
	sets.engaged.DW.Club.sTP = set_combine(sets.engaged.DW.Club, sets.Mode.sTP)
	sets.engaged.DW.Club.STR = set_combine(sets.engaged.DW.Club, sets.Mode.STR)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Att = set_combine(sets.engaged.Shield.Club, sets.Mode.Att)
	sets.engaged.Shield.Club.Crit = set_combine(sets.engaged.Shield.Club, sets.Mode.Crit)
	sets.engaged.Shield.Club.DA = set_combine(sets.engaged.Shield.Club, sets.Mode.DA)
	sets.engaged.Shield.Club.Haste = set_combine(sets.engaged.Shield.Club, sets.Mode.Haste)
	sets.engaged.Shield.Club.Skill = set_combine(sets.engaged.Shield.Club, {})
	sets.engaged.Shield.Club.sTP = set_combine(sets.engaged.Shield.Club, sets.Mode.sTP)
	sets.engaged.Shield.Club.STR = set_combine(sets.engaged.Shield.Club, sets.Mode.STR)

	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.Haste = set_combine(sets.engaged.DW.Sword, sets.Mode.Haste)
	sets.engaged.DW.Sword.Skill = set_combine(sets.engaged.DW.Sword, {})
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	sets.engaged.Shield.Sword.Haste = set_combine(sets.engaged.Shield.Sword, sets.Mode.Haste)
	sets.engaged.Shield.Sword.Skill = set_combine(sets.engaged.Shield.Sword, {})
	sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)

	sets.engaged.Grip.Polearm.Acc = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Acc)
	sets.engaged.Grip.Polearm.Att = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Att)
	sets.engaged.Grip.Polearm.Crit = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Crit)
	sets.engaged.Grip.Polearm.DA = set_combine(sets.engaged.Grip.Polearm, sets.Mode.DA)
	sets.engaged.Grip.Polearm.Haste = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Haste)
	sets.engaged.Grip.Polearm.Skill = set_combine(sets.engaged.Grip.Polearm, {
			neck="Love Torque",ear1="Tripudio Earring",
			body="Fazheluo R. Mail",ring2="Portus Ring",
			feet="Etamin Gambieras"})
	sets.engaged.Grip.Polearm.sTP = set_combine(sets.engaged.Grip.Polearm, sets.Mode.sTP)
	sets.engaged.Grip.Polearm.STR = set_combine(sets.engaged.Grip.Polearm, sets.Mode.STR)

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)

	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {}
	sets.WSDayBonus = {head="Mekira-oto +1"} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {head="Yaoyotl Helm"})

	-- Earth, STR 40% DEX 40%
	sets.precast.WS['Fast Blade'] = set_combine(sets.precast.WS, {})

	-- Fire, STR 40% INT 40%
	sets.precast.WS['Burning Blade'] = set_combine(sets.precast.WS, {})

	-- Fire/Wind, STR 40% INT 40%
	sets.precast.WS['Red Lotus Blade'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})

	-- Thunder, STR 100%
	sets.precast.WS['Flat Blade'] = set_combine(sets.precast.WS, {})

	-- Earth, STR 40% MND 40%
	sets.precast.WS['Shining Blade'] = set_combine(sets.precast.WS, {})

	-- Earth, STR 40% MND 40%
	sets.precast.WS['Seraph Blade'] = set_combine(sets.precast.WS, {})

	-- Water/Thunder, STR 100%
	sets.precast.WS['Circle Blade'] = set_combine(sets.precast.WS, {waist="Aqua Belt"})

	-- HP
	sets.precast.WS['Spirits Within'] = set_combine(sets.precast.WS, {})

	-- Earth/Thunder, STR 60%
	sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS, sets.Mode.Crit, {})

	-- Earth/Thunder/Wind, STR 50% MND 50%
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})

	-- dark?, STR 30% MND 50% - use MAB
	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, sets.engaged.MAB)

	-- Dark/Earth, MND 73%
	sets.precast.WS['Rquiescat'] = set_combine(sets.precast.WS, {})
	
	-- Dark/Earth, STR 50% MND 50%
	sets.precast.WS['Swift Blade'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
	
	-- Light/Fire/Water, Enmity
    sets.precast.WS['Atonement'] = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Light Gorget",ear1="Creed Earring",ear2="Steelflash Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Rajas Ring",ring2="Vexer Ring",
        back="Fierabras's Mantle",waist="Light Belt",legs="Reverence Breeches +1",feet="Caballarius Leggings"}

		-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})

	-- Earth/Wind/Thunder, STR 73%
	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})

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

	
    --------------------------------------
    -- Precast sets
    --------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = {legs="Caballarius Breeches"}
    sets.precast.JA['Holy Circle'] = {feet="Reverence Leggings +1"}
    sets.precast.JA['Shield Bash'] = {hands="Caballarius Gauntlets"}
    sets.precast.JA['Sentinel'] = {feet="Caballarius Leggings"}
    sets.precast.JA['Rampart'] = {head="Caballarius Coronet"}
    sets.precast.JA['Fealty'] = {body="Caballarius Surcoat"}
    sets.precast.JA['Divine Emblem'] = {feet="Creed Sabatons +2"}
    sets.precast.JA['Cover'] = {head="Reverence Coronet +1"}

    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
        head="Reverence Coronet +1",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Leviathan Ring",ring2="Aquasoul Ring",
        back="Weard Mantle",legs="Reverence Breeches +1",feet="Whirlpool Greaves"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Reverence Coronet +1",
        body="Gorney Haubert +1",hands="Reverence Gauntlets +1",ring2="Asklepian Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Reverence Breeches +1",feet="Whirlpool Greaves"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Incantor Stone",
        head="Cizin Helm",ear2="Loquacious Earring",ring2="Prolix Ring",legs="Enif Cosciales"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

       
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head="Reverence Coronet +1",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",
        waist="Zoran's Belt",legs="Enif Cosciales",feet="Reverence Leggings +1"}
        
    sets.midcast.Enmity = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Invidia Torque",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Vexer Ring",
        back="Fierabras's Mantle",waist="Goading Belt",legs="Reverence Breeches +1",feet="Caballarius Leggings"}

    sets.midcast.Flash = set_combine(sets.midcast.Enmity, {legs="Enif Cosciales"})
    
    sets.midcast.Stun = sets.midcast.Flash
    
    sets.midcast.Cure = {ammo="Iron Gobbet",
        head="Adaman Barbuta",neck="Invidia Torque",ear1="Hospitaler Earring",ear2="Bloodgem Earring",
        body="Reverence Surcoat +1",hands="Buremte Gloves",ring1="Kunaji Ring",ring2="Asklepian Ring",
        back="Fierabras's Mantle",waist="Chuq'aba Belt",legs="Reverence Breeches +1",feet="Caballarius Leggings"}

    sets.midcast['Enhancing Magic'] = {neck="Colossus's Torque",waist="Olympus Sash",legs="Reverence Breeches +1"}
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    sets.Reraise = {head="Twilight Helm", body="Twilight Mail"}
    
     
    sets.Kiting = {legs="Crimson Cuisses"}

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.Knockback = {back="Repulse Mantle"}
    sets.MP = {neck="Creed Collar",waist="Flume Belt"}
    sets.MP_Knockback = {neck="Creed Collar",waist="Flume Belt",back="Repulse Mantle"}
    
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    sets.PhysicalShield = {main="Anahera Sword",sub="Killedar Shield"} -- Ochain
    sets.MagicalShield = {main="Anahera Sword",sub="Beatific Shield +1"} -- Aegis

    -- Basic defense sets.
        
    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Creed Earring",ear2="Buckler Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Flume Belt",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    sets.defense.HP = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Creed Earring",ear2="Bloodgem Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2="Meridian Ring",
        back="Weard Mantle",waist="Creed Baudrier",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    sets.defense.Reraise = {ammo="Iron Gobbet",
        head="Twilight Helm",neck="Twilight Torque",ear1="Creed Earring",ear2="Bloodgem Earring",
        body="Twilight Mail",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Weard Mantle",waist="Nierenschutz",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    sets.defense.Charm = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Lavalier +1",ear1="Creed Earring",ear2="Buckler Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Flume Belt",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT = {ammo="Demonry Stone",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Creed Earring",ear2="Bloodgem Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2="Shadow Ring",
        back="Engulfer Cape",waist="Creed Baudrier",legs="Osmium Cuisses",feet="Reverence Leggings +1"}


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Doom = {ring2="Saida Ring"}
    sets.buff.Cover = {head="Reverence Coronet +1", body="Caballarius Surcoat"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
    if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
        handle_equipping_gear(player.status)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    
    return meleeSet
end

function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
    
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
    
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
    
    return defenseSet
end


function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
    
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_defense_mode()
    if player.equipment.main == 'Kheshig Blade' and not classes.CustomDefenseGroups:contains('Kheshig Blade') then
        classes.CustomDefenseGroups:append('Kheshig Blade')
    end
    
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(5, 13)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 13)
    elseif player.sub_job == 'RDM' then
        set_macro_page(3, 13)
    else
        set_macro_page(1, 13)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end
 

function get_combat_form()
	set_combat_form()
end

function pick_tp_weapon()
	-- add_to_chat(122,' pick tp weapon '..state.WeaponMode.value)
	set_combat_weapon()
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end