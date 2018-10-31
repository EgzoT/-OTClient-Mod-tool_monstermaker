----------------------------------------------------------------------------------------------------------------------------------
--Based on monster maker tutorial: https://otland.net/threads/xml-how-to-make-a-monster-fully-explained-new.235454/#post-2272138--
--Support: https://otland.net/----------------------------------------------------------------------------------------------------
--Or https://github.com/EgzoT-----------------------------------------------------------------------------------------------------
--Author: Egzo--------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------
--New UIComboBox feature-------------------------
-------------------------------------------------

function UIComboBox:isOption(text)
	if not self.options then return false end
		for i,v in ipairs(self.options) do
			if v.text == text then
				return true
			end
		end
	return false
end

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

monsterMakerButton = nil
monsterMakerWindow = nil

--help values
allTabs = nil

monsterPanel = nil
flagsPanel = nil
scriptPanel = nil
attacksPanel = nil
defensesPanel = nil
elementsPanel = nil
immunitiesPanel = nil
summonsPanel = nil
voicesPanel = nil
lootPanel = nil
ioPanel = nil

monsterTab = nil
flagsTab = nil
scriptTab = nil
attacksTab = nil
defensesTab = nil
elementsTab = nil
immunitiesTab = nil
summonsTab = nil
voicesTab = nil
lootTab = nil
ioTab = nil

--table with data
valuesTable = {}

function init()
  monsterMakerButton = modules.client_topmenu.addRightToggleButton('monsterMakerButton', tr('Monster Maker'), '/tool_monstermaker/img_tool_monstermaker/tool_monstermaker_img', toggle)
  monsterMakerButton:setOn(false)

  monsterMakerWindow = g_ui.displayUI('tool_monstermaker')
  monsterMakerWindow:setVisible(false)

  --get help values
  allTabs = monsterMakerWindow:recursiveGetChildById('allTabs')
  allTabs:setContentWidget(monsterMakerWindow:getChildById('optionsTabContent'))

  monsterPanel = g_ui.loadUI('monster')
  flagsPanel = g_ui.loadUI('flags')
  scriptPanel = g_ui.loadUI('script')
  attacksPanel = g_ui.loadUI('attacks')
  defensesPanel = g_ui.loadUI('defenses')
  elementsPanel = g_ui.loadUI('elements')
  immunitiesPanel = g_ui.loadUI('immunities')
  summonsPanel = g_ui.loadUI('summons')
  voicesPanel = g_ui.loadUI('voices')
  lootPanel = g_ui.loadUI('loot')
  ioPanel = g_ui.loadUI('io')

  --Monster
  monsterTab = allTabs:addTab('Monster', monsterPanel, nil)
  monsterTab:setWidth(56)

  --MonsterTab values--
  valuesTable.name = monsterPanel:recursiveGetChildById('nameText')
  valuesTable.nameDescription = monsterPanel:recursiveGetChildById('nameDescriptionText')
  valuesTable.race = monsterPanel:recursiveGetChildById('raceComboBox')
  valuesTable.experience = monsterPanel:recursiveGetChildById('experienceText')
  valuesTable.skull = monsterPanel:recursiveGetChildById('skullComboBox')
  valuesTable.speed = monsterPanel:recursiveGetChildById('speedText')
  valuesTable.manacost = monsterPanel:recursiveGetChildById('manacostText')
  valuesTable.healthnow = monsterPanel:recursiveGetChildById('healthnowText')
  valuesTable.healthmax = monsterPanel:recursiveGetChildById('healthmaxText')
  valuesTable.looktypeCheckBox = monsterPanel:recursiveGetChildById('lookTypeCheckBox')
  valuesTable.looktypeExCheckBox = monsterPanel:recursiveGetChildById('lookTypeExCheckBox')
  valuesTable.looktype = monsterPanel:recursiveGetChildById('lookTypeText')
  valuesTable.head = monsterPanel:recursiveGetChildById('headText')
  valuesTable.body = monsterPanel:recursiveGetChildById('bodyText')
  valuesTable.legs = monsterPanel:recursiveGetChildById('legsText')
  valuesTable.feet = monsterPanel:recursiveGetChildById('feetText')
  valuesTable.addons = monsterPanel:recursiveGetChildById('addonsText')
  valuesTable.mount = monsterPanel:recursiveGetChildById('mountText')
  valuesTable.corpse = monsterPanel:recursiveGetChildById('corpseText')
  valuesTable.interval = monsterPanel:recursiveGetChildById('intervalText')
  valuesTable.chance = monsterPanel:recursiveGetChildById('chanceText')
  valuesTable.strategyCheck = monsterPanel:recursiveGetChildById('strategyCheckBox')
  valuesTable.strategy = monsterPanel:recursiveGetChildById('strategyScrollbar')
  valuesTable.monsterPreview = monsterPanel:recursiveGetChildById('monsterPreview')
  --MonsterTab values END--

  --Set values--
  --RACE
  valuesTable.race:addOption('blood')
  valuesTable.race:addOption('venom')
  valuesTable.race:addOption('undead')
  valuesTable.race:addOption('fire')
  valuesTable.race:addOption('energy')
  --SKULL
  valuesTable.skull:addOption('none')
  valuesTable.skull:addOption('yellow')
  valuesTable.skull:addOption('black')
  valuesTable.skull:addOption('red')
  valuesTable.skull:addOption('white')
  valuesTable.skull:addOption('orange')
  valuesTable.skull:addOption('green')
  --LOOK TYPE
  valuesTable.looktypeOption = UIRadioGroup.create()
  valuesTable.looktypeOption:addWidget(valuesTable.looktypeCheckBox)
  valuesTable.looktypeOption:addWidget(valuesTable.looktypeExCheckBox)
  valuesTable.looktypeOption:selectWidget(valuesTable.looktypeCheckBox)
  --OTHER
  valuesTable.experience:setText('1000', true)
  valuesTable.speed:setText('100', true)
  valuesTable.manacost:setText('0', true)
  valuesTable.healthnow:setText('500', true)
  valuesTable.healthmax:setText('500', true)
  valuesTable.looktype:setText('1', true)
  valuesTable.head:setText('0', true)
  valuesTable.body:setText('0', true)
  valuesTable.legs:setText('0', true)
  valuesTable.feet:setText('0', true)
  valuesTable.addons:setText('0', true)
  valuesTable.mount:setText('0', true)
  valuesTable.interval:setText('2000', true)
  valuesTable.chance:setText('5', true)
  valuesTable.strategy:setValue(50)
  monsterPanel:recursiveGetChildById('strategyattackLabel'):setEnabled(false)
  monsterPanel:recursiveGetChildById('strategydefenseLabel'):setEnabled(false)
  --Set values END--

  --Connect
  valuesTable.looktype.onValueChange = setMonsterPreview
  valuesTable.head.onValueChange = setMonsterPreview
  valuesTable.body.onValueChange = setMonsterPreview
  valuesTable.legs.onValueChange = setMonsterPreview
  valuesTable.feet.onValueChange = setMonsterPreview
  valuesTable.addons.onValueChange = setMonsterPreview
  valuesTable.mount.onValueChange = setMonsterPreview

  --Flags
  flagsTab = allTabs:addTab('Flags', flagsPanel, nil)
  flagsTab:setWidth(40)

  valuesTable.flagsSummonable = flagsPanel:recursiveGetChildById('summonableCheckBox')
  valuesTable.flagsAttackable = flagsPanel:recursiveGetChildById('attackableCheckBox')
  valuesTable.flagsHostile = flagsPanel:recursiveGetChildById('hostileCheckBox')
  valuesTable.flagsIllusionable = flagsPanel:recursiveGetChildById('illusionableCheckBox')
  valuesTable.flagsConvinceable = flagsPanel:recursiveGetChildById('convinceableCheckBox')
  valuesTable.flagsPushable = flagsPanel:recursiveGetChildById('pushableCheckBox')
  valuesTable.flagsCanpushitems = flagsPanel:recursiveGetChildById('canpushitemsCheckBox')
  valuesTable.flagsCanpushcreatures = flagsPanel:recursiveGetChildById('canpushcreaturesCheckBox')
  valuesTable.flagsTargetdistance = flagsPanel:recursiveGetChildById('targetdistanceText')
  valuesTable.flagsStaticattack = flagsPanel:recursiveGetChildById('staticattackScrollbar')
  valuesTable.flagsHidehealth = flagsPanel:recursiveGetChildById('hidehealthCheckBox')
  valuesTable.flagsLightcolor = flagsPanel:recursiveGetChildById('lightcolorText')
  valuesTable.flagsLightlevel = flagsPanel:recursiveGetChildById('lightlevelText')
  valuesTable.flagsRunonhealth = flagsPanel:recursiveGetChildById('runonhealthScrollbar')

  --Other
  valuesTable.flagsStaticattack:setValue(90)
  valuesTable.flagsLightcolor:setText(0)
  flagsPanel:recursiveGetChildById('lightlevelLabel'):setEnabled(false)
  flagsPanel:recursiveGetChildById('lightlevelText'):setEnabled(false)
  valuesTable.flagsRunonhealth:setValue(5)

  --Script
  scriptTab = allTabs:addTab('Script', scriptPanel, nil)
  scriptTab:setWidth(42)

  valuesTable.scriptOnscript = scriptPanel:recursiveGetChildById('onscriptCheckBox')
  valuesTable.scriptAddscript = scriptPanel:recursiveGetChildById('addscriptText')

  --Other
  scriptPanel:recursiveGetChildById('addscriptLabel'):setEnabled(false)
  scriptPanel:recursiveGetChildById('addscriptText'):setEnabled(false)

  --Attacks
  attacksTab = allTabs:addTab('Attacks', attacksPanel, nil)
  attacksTab:setWidth(55)

  valuesTable.attacksAttackslist = attacksPanel:recursiveGetChildById('attackslistTextList')
  valuesTable.attacksNametype = attacksPanel:recursiveGetChildById('nametypeComboBox')
  valuesTable.attacksNameelemental = attacksPanel:recursiveGetChildById('nameelementalComboBox')
  valuesTable.attacksNameconditions = attacksPanel:recursiveGetChildById('nameconditionsComboBox')
  valuesTable.attacksNamefields = attacksPanel:recursiveGetChildById('namefieldsComboBox')
  valuesTable.attacksNamerunes = attacksPanel:recursiveGetChildById('namerunesComboBox')
  valuesTable.attacksNamespells = attacksPanel:recursiveGetChildById('namespellsComboBox')
  valuesTable.attacksNameother = attacksPanel:recursiveGetChildById('nameotherText')
  valuesTable.attacksMin = attacksPanel:recursiveGetChildById('minText')
  valuesTable.attacksMax = attacksPanel:recursiveGetChildById('maxText')
  valuesTable.attacksSkillCheckBox = attacksPanel:recursiveGetChildById('skillCheckBox')
  valuesTable.attacksSkillText = attacksPanel:recursiveGetChildById('skillText')
  valuesTable.attacksAttackText = attacksPanel:recursiveGetChildById('attackText')
  valuesTable.attacksInterval = attacksPanel:recursiveGetChildById('intervalText')
  valuesTable.attacksChance = attacksPanel:recursiveGetChildById('chanceText')
  valuesTable.attacksLengthCheckBox = attacksPanel:recursiveGetChildById('lengthCheckBox')
  valuesTable.attacksLength = attacksPanel:recursiveGetChildById('lengthText')
  valuesTable.attacksSpreadCheckBox = attacksPanel:recursiveGetChildById('spreadCheckBox')
  valuesTable.attacksSpread = attacksPanel:recursiveGetChildById('spreadText')
  valuesTable.attacksRadiusCheckBox = attacksPanel:recursiveGetChildById('radiusCheckBox')
  valuesTable.attacksRadius = attacksPanel:recursiveGetChildById('radiusText')
  valuesTable.attacksPoisonCheckBox = attacksPanel:recursiveGetChildById('poisonCheckBox')
  valuesTable.attacksPoison = attacksPanel:recursiveGetChildById('poisonText')
  valuesTable.attacksTargetCheckBox = attacksPanel:recursiveGetChildById('targetCheckBox')
  valuesTable.attacksRange = attacksPanel:recursiveGetChildById('rangeText')
  valuesTable.attacksAreaEffectCheckBox = attacksPanel:recursiveGetChildById('areaEffectCheckBox')
  valuesTable.attacksAreaEffectComboBox = attacksPanel:recursiveGetChildById('areaEffectComboBox')
  valuesTable.attacksShootEffectCheckBox = attacksPanel:recursiveGetChildById('shootEffectCheckBox')
  valuesTable.attacksShootEffectComboBox = attacksPanel:recursiveGetChildById('shootEffectComboBox')

  --Set values
  --Name
  valuesTable.attacksNametype:addOption('melee')
  valuesTable.attacksNametype:addOption('elemental')
  valuesTable.attacksNametype:addOption('conditions')
  valuesTable.attacksNametype:addOption('fields')
  valuesTable.attacksNametype:addOption('runes')
  valuesTable.attacksNametype:addOption('spells')
  valuesTable.attacksNametype:addOption('other')

  --Elemental
  valuesTable.attacksNameelemental:addOption('physical')
  valuesTable.attacksNameelemental:addOption('energy')
  valuesTable.attacksNameelemental:addOption('earth')
  valuesTable.attacksNameelemental:addOption('fire')
  valuesTable.attacksNameelemental:addOption('lifedrain')
  valuesTable.attacksNameelemental:addOption('manadrain')
  valuesTable.attacksNameelemental:addOption('healing')
  valuesTable.attacksNameelemental:addOption('drown')
  valuesTable.attacksNameelemental:addOption('ice')
  valuesTable.attacksNameelemental:addOption('holy')
  valuesTable.attacksNameelemental:addOption('death')

  --Conditions
  valuesTable.attacksNameconditions:addOption('physicalcondition')
  valuesTable.attacksNameconditions:addOption('firecondition')
  valuesTable.attacksNameconditions:addOption('energycondition')
  valuesTable.attacksNameconditions:addOption('earthcondition')
  valuesTable.attacksNameconditions:addOption('icecondition')
  valuesTable.attacksNameconditions:addOption('deathcondition')
  valuesTable.attacksNameconditions:addOption('holycondition')
  valuesTable.attacksNameconditions:addOption('drowncondition')

  --Fields
  valuesTable.attacksNamefields:addOption('firefield')
  valuesTable.attacksNamefields:addOption('poisonfield')
  valuesTable.attacksNamefields:addOption('energyfield')

  --Runes
  valuesTable.attacksNamerunes:addOption('sudden death')
  valuesTable.attacksNamerunes:addOption('')

  --Spells
  valuesTable.attacksNamespells:addOption('great energy beam')
  valuesTable.attacksNamespells:addOption('')

  --AreaEffect
  valuesTable.attacksAreaEffectComboBox:addOption("redspark")
  valuesTable.attacksAreaEffectComboBox:addOption("bluebubble")
  valuesTable.attacksAreaEffectComboBox:addOption("poff")
  valuesTable.attacksAreaEffectComboBox:addOption("yellowspark")
  valuesTable.attacksAreaEffectComboBox:addOption("explosionarea")
  valuesTable.attacksAreaEffectComboBox:addOption("explosion")
  valuesTable.attacksAreaEffectComboBox:addOption("firearea")
  valuesTable.attacksAreaEffectComboBox:addOption("yellowbubble")
  valuesTable.attacksAreaEffectComboBox:addOption("greenbubble")
  valuesTable.attacksAreaEffectComboBox:addOption("blackspark")
  valuesTable.attacksAreaEffectComboBox:addOption("teleport")
  valuesTable.attacksAreaEffectComboBox:addOption("energy")
  valuesTable.attacksAreaEffectComboBox:addOption("blueshimmer")
  valuesTable.attacksAreaEffectComboBox:addOption("redshimmer")
  valuesTable.attacksAreaEffectComboBox:addOption("greenshimmer")
  valuesTable.attacksAreaEffectComboBox:addOption("fire")
  valuesTable.attacksAreaEffectComboBox:addOption("greenspark")
  valuesTable.attacksAreaEffectComboBox:addOption("mortarea")
  valuesTable.attacksAreaEffectComboBox:addOption("greennote")
  valuesTable.attacksAreaEffectComboBox:addOption("rednote")
  valuesTable.attacksAreaEffectComboBox:addOption("poison")
  valuesTable.attacksAreaEffectComboBox:addOption("yellownote")
  valuesTable.attacksAreaEffectComboBox:addOption("purplenote")
  valuesTable.attacksAreaEffectComboBox:addOption("bluenote")
  valuesTable.attacksAreaEffectComboBox:addOption("whitenote")
  valuesTable.attacksAreaEffectComboBox:addOption("bubbles")
  valuesTable.attacksAreaEffectComboBox:addOption("dice")
  valuesTable.attacksAreaEffectComboBox:addOption("giftwraps")
  valuesTable.attacksAreaEffectComboBox:addOption("yellowfirework")
  valuesTable.attacksAreaEffectComboBox:addOption("redfirework")
  valuesTable.attacksAreaEffectComboBox:addOption("bluefirework")
  valuesTable.attacksAreaEffectComboBox:addOption("stun")
  valuesTable.attacksAreaEffectComboBox:addOption("sleep")
  valuesTable.attacksAreaEffectComboBox:addOption("watercreature")
  valuesTable.attacksAreaEffectComboBox:addOption("groundshaker")
  valuesTable.attacksAreaEffectComboBox:addOption("hearts")
  valuesTable.attacksAreaEffectComboBox:addOption("fireattack")
  valuesTable.attacksAreaEffectComboBox:addOption("energyarea")
  valuesTable.attacksAreaEffectComboBox:addOption("smallclouds")
  valuesTable.attacksAreaEffectComboBox:addOption("holydamage")
  valuesTable.attacksAreaEffectComboBox:addOption("bigclouds")
  valuesTable.attacksAreaEffectComboBox:addOption("icearea")
  valuesTable.attacksAreaEffectComboBox:addOption("icetornado")
  valuesTable.attacksAreaEffectComboBox:addOption("iceattack")
  valuesTable.attacksAreaEffectComboBox:addOption("stones")
  valuesTable.attacksAreaEffectComboBox:addOption("smallplants")
  valuesTable.attacksAreaEffectComboBox:addOption("carniphila")
  valuesTable.attacksAreaEffectComboBox:addOption("purpleenergy")
  valuesTable.attacksAreaEffectComboBox:addOption("yellowenergy")
  valuesTable.attacksAreaEffectComboBox:addOption("holyarea")
  valuesTable.attacksAreaEffectComboBox:addOption("bigplants")
  valuesTable.attacksAreaEffectComboBox:addOption("cake")
  valuesTable.attacksAreaEffectComboBox:addOption("giantice")
  valuesTable.attacksAreaEffectComboBox:addOption("watersplash")
  valuesTable.attacksAreaEffectComboBox:addOption("plantattack")
  valuesTable.attacksAreaEffectComboBox:addOption("tutorialarrow")
  valuesTable.attacksAreaEffectComboBox:addOption("tutorialsquare")
  valuesTable.attacksAreaEffectComboBox:addOption("mirrorhorizontal")
  valuesTable.attacksAreaEffectComboBox:addOption("mirrorvertical")
  valuesTable.attacksAreaEffectComboBox:addOption("skullhorizontal")
  valuesTable.attacksAreaEffectComboBox:addOption("skullvertical")
  valuesTable.attacksAreaEffectComboBox:addOption("assassin")
  valuesTable.attacksAreaEffectComboBox:addOption("stepshorizontal")
  valuesTable.attacksAreaEffectComboBox:addOption("bloodysteps")
  valuesTable.attacksAreaEffectComboBox:addOption("stepsvertical")
  valuesTable.attacksAreaEffectComboBox:addOption("yalaharighost")
  valuesTable.attacksAreaEffectComboBox:addOption("bats")
  valuesTable.attacksAreaEffectComboBox:addOption("smoke")
  valuesTable.attacksAreaEffectComboBox:addOption("insects")
  valuesTable.attacksAreaEffectComboBox:addOption("dragonhead")
  valuesTable.attacksAreaEffectComboBox:addOption("orcshaman")
  valuesTable.attacksAreaEffectComboBox:addOption("orcshamanfire")
  valuesTable.attacksAreaEffectComboBox:addOption("thunder")
  valuesTable.attacksAreaEffectComboBox:addOption("ferumbras")
  valuesTable.attacksAreaEffectComboBox:addOption("confettihorizontal")
  valuesTable.attacksAreaEffectComboBox:addOption("confettivertical")
  valuesTable.attacksAreaEffectComboBox:addOption("blacksmoke")
  valuesTable.attacksAreaEffectComboBox:addOption("redsmoke")
  valuesTable.attacksAreaEffectComboBox:addOption("yellowsmoke")
  valuesTable.attacksAreaEffectComboBox:addOption("greensmoke")
  valuesTable.attacksAreaEffectComboBox:addOption("purplesmoke")

  --Shoot Effect
  valuesTable.attacksShootEffectComboBox:addOption("spear")
  valuesTable.attacksShootEffectComboBox:addOption("bolt")
  valuesTable.attacksShootEffectComboBox:addOption("arrow")
  valuesTable.attacksShootEffectComboBox:addOption("fire")
  valuesTable.attacksShootEffectComboBox:addOption("energy")
  valuesTable.attacksShootEffectComboBox:addOption("poisonarrow")
  valuesTable.attacksShootEffectComboBox:addOption("burstarrow")
  valuesTable.attacksShootEffectComboBox:addOption("throwingstar")
  valuesTable.attacksShootEffectComboBox:addOption("throwingknife")
  valuesTable.attacksShootEffectComboBox:addOption("smallstone")
  valuesTable.attacksShootEffectComboBox:addOption("death")
  valuesTable.attacksShootEffectComboBox:addOption("largerock")
  valuesTable.attacksShootEffectComboBox:addOption("snowball")
  valuesTable.attacksShootEffectComboBox:addOption("powerbolt")
  valuesTable.attacksShootEffectComboBox:addOption("poison")
  valuesTable.attacksShootEffectComboBox:addOption("infernalbolt")
  valuesTable.attacksShootEffectComboBox:addOption("huntingspear")
  valuesTable.attacksShootEffectComboBox:addOption("enchantedspear")
  valuesTable.attacksShootEffectComboBox:addOption("redstar")
  valuesTable.attacksShootEffectComboBox:addOption("greenstar")
  valuesTable.attacksShootEffectComboBox:addOption("royalspear")
  valuesTable.attacksShootEffectComboBox:addOption("sniperarrow")
  valuesTable.attacksShootEffectComboBox:addOption("onyxarrow")
  valuesTable.attacksShootEffectComboBox:addOption("piercingbolt")
  valuesTable.attacksShootEffectComboBox:addOption("whirlwindsword")
  valuesTable.attacksShootEffectComboBox:addOption("whirlwindaxe")
  valuesTable.attacksShootEffectComboBox:addOption("whirlwindclub")
  valuesTable.attacksShootEffectComboBox:addOption("etherealspear")
  valuesTable.attacksShootEffectComboBox:addOption("ice")
  valuesTable.attacksShootEffectComboBox:addOption("earth")
  valuesTable.attacksShootEffectComboBox:addOption("holy")
  valuesTable.attacksShootEffectComboBox:addOption("suddendeath")
  valuesTable.attacksShootEffectComboBox:addOption("flasharrow")
  valuesTable.attacksShootEffectComboBox:addOption("flammingarrow")
  valuesTable.attacksShootEffectComboBox:addOption("shiverarrow")
  valuesTable.attacksShootEffectComboBox:addOption("energyball")
  valuesTable.attacksShootEffectComboBox:addOption("smallice")
  valuesTable.attacksShootEffectComboBox:addOption("smallholy")
  valuesTable.attacksShootEffectComboBox:addOption("smallearth")
  valuesTable.attacksShootEffectComboBox:addOption("eartharrow")
  valuesTable.attacksShootEffectComboBox:addOption("explosion")
  valuesTable.attacksShootEffectComboBox:addOption("cake")
  valuesTable.attacksShootEffectComboBox:addOption("tarsalarrow")
  valuesTable.attacksShootEffectComboBox:addOption("vortexbolt")
  valuesTable.attacksShootEffectComboBox:addOption("prismaticbolt")
  valuesTable.attacksShootEffectComboBox:addOption("crystallinearrow")
  valuesTable.attacksShootEffectComboBox:addOption("drillbolt")
  valuesTable.attacksShootEffectComboBox:addOption("envenomedarrow")
  valuesTable.attacksShootEffectComboBox:addOption("gloothspear")
  valuesTable.attacksShootEffectComboBox:addOption("simplearrow")

  --Other
  hideAllAttacksNames()
  modules.tool_monstermaker.attacksPanel:recursiveGetChildById('skillLabel'):setEnabled(false)
  modules.tool_monstermaker.valuesTable.attacksSkillText:setEnabled(false)
  modules.tool_monstermaker.attacksPanel:recursiveGetChildById('attackLabel'):setEnabled(false)
  modules.tool_monstermaker.valuesTable.attacksAttackText:setEnabled(false)
  valuesTable.attacksInterval:setText('2000', true)
  valuesTable.attacksLength:setText('0', true)
  modules.tool_monstermaker.valuesTable.attacksLength:setEnabled(false)
  modules.tool_monstermaker.valuesTable.attacksSpread:setEnabled(false)
  modules.tool_monstermaker.valuesTable.attacksRadius:setEnabled(false)
  modules.tool_monstermaker.valuesTable.attacksPoison:setEnabled(false)
  modules.tool_monstermaker.attacksPanel:recursiveGetChildById('rangeLabel'):setEnabled(false)
  modules.tool_monstermaker.attacksPanel:recursiveGetChildById('rangeText'):setEnabled(false)
  valuesTable.attacksMin:setMinimum(-999999999)
  valuesTable.attacksMin:setText(-5)
  valuesTable.attacksMax:setMinimum(-999999999)
  valuesTable.attacksMax:setText(-10)

  --Defences
  defensesTab = allTabs:addTab('Defenses', defensesPanel, nil)
  defensesTab:setWidth(60)

  valuesTable.defensesArmor = defensesPanel:recursiveGetChildById('armorText')
  valuesTable.defensesDefense = defensesPanel:recursiveGetChildById('defenseText')
  valuesTable.defensesList = defensesPanel:recursiveGetChildById('defenseslistTextList')
  valuesTable.defensesName = defensesPanel:recursiveGetChildById('defenseComboBox')
  valuesTable.defensesInterval = defensesPanel:recursiveGetChildById('intervalText')
  valuesTable.defensesChance = defensesPanel:recursiveGetChildById('chanceText')
  valuesTable.defensesMinLabel = defensesPanel:recursiveGetChildById('minLabel')
  valuesTable.defensesMin = defensesPanel:recursiveGetChildById('minText')
  valuesTable.defensesMaxLabel = defensesPanel:recursiveGetChildById('maxLabel')
  valuesTable.defensesMax = defensesPanel:recursiveGetChildById('maxText')
  valuesTable.defensesIsRadius = defensesPanel:recursiveGetChildById('radiusCheckBox')
  valuesTable.defensesRadius = defensesPanel:recursiveGetChildById('radiusText')
  valuesTable.defensesAreaEffect = defensesPanel:recursiveGetChildById('areaEffectComboBox')
  valuesTable.defensesDurationLabel = defensesPanel:recursiveGetChildById('durationLabel')
  valuesTable.defensesDuration = defensesPanel:recursiveGetChildById('durationText')
  valuesTable.defensesSpeedchangeLabel = defensesPanel:recursiveGetChildById('speedchangeLabel')
  valuesTable.defensesSpeedchange = defensesPanel:recursiveGetChildById('speedchangeText')

  --Defense Name
  valuesTable.defensesName:addOption("healing")
  valuesTable.defensesName:addOption("speed")
  valuesTable.defensesName:addOption("invisible")

  --AreaEffect
  valuesTable.defensesAreaEffect:addOption("redspark")
  valuesTable.defensesAreaEffect:addOption("bluebubble")
  valuesTable.defensesAreaEffect:addOption("poff")
  valuesTable.defensesAreaEffect:addOption("yellowspark")
  valuesTable.defensesAreaEffect:addOption("explosionarea")
  valuesTable.defensesAreaEffect:addOption("explosion")
  valuesTable.defensesAreaEffect:addOption("firearea")
  valuesTable.defensesAreaEffect:addOption("yellowbubble")
  valuesTable.defensesAreaEffect:addOption("greenbubble")
  valuesTable.defensesAreaEffect:addOption("blackspark")
  valuesTable.defensesAreaEffect:addOption("teleport")
  valuesTable.defensesAreaEffect:addOption("energy")
  valuesTable.defensesAreaEffect:addOption("blueshimmer")
  valuesTable.defensesAreaEffect:addOption("redshimmer")
  valuesTable.defensesAreaEffect:addOption("greenshimmer")
  valuesTable.defensesAreaEffect:addOption("fire")
  valuesTable.defensesAreaEffect:addOption("greenspark")
  valuesTable.defensesAreaEffect:addOption("mortarea")
  valuesTable.defensesAreaEffect:addOption("greennote")
  valuesTable.defensesAreaEffect:addOption("rednote")
  valuesTable.defensesAreaEffect:addOption("poison")
  valuesTable.defensesAreaEffect:addOption("yellownote")
  valuesTable.defensesAreaEffect:addOption("purplenote")
  valuesTable.defensesAreaEffect:addOption("bluenote")
  valuesTable.defensesAreaEffect:addOption("whitenote")
  valuesTable.defensesAreaEffect:addOption("bubbles")
  valuesTable.defensesAreaEffect:addOption("dice")
  valuesTable.defensesAreaEffect:addOption("giftwraps")
  valuesTable.defensesAreaEffect:addOption("yellowfirework")
  valuesTable.defensesAreaEffect:addOption("redfirework")
  valuesTable.defensesAreaEffect:addOption("bluefirework")
  valuesTable.defensesAreaEffect:addOption("stun")
  valuesTable.defensesAreaEffect:addOption("sleep")
  valuesTable.defensesAreaEffect:addOption("watercreature")
  valuesTable.defensesAreaEffect:addOption("groundshaker")
  valuesTable.defensesAreaEffect:addOption("hearts")
  valuesTable.defensesAreaEffect:addOption("fireattack")
  valuesTable.defensesAreaEffect:addOption("energyarea")
  valuesTable.defensesAreaEffect:addOption("smallclouds")
  valuesTable.defensesAreaEffect:addOption("holydamage")
  valuesTable.defensesAreaEffect:addOption("bigclouds")
  valuesTable.defensesAreaEffect:addOption("icearea")
  valuesTable.defensesAreaEffect:addOption("icetornado")
  valuesTable.defensesAreaEffect:addOption("iceattack")
  valuesTable.defensesAreaEffect:addOption("stones")
  valuesTable.defensesAreaEffect:addOption("smallplants")
  valuesTable.defensesAreaEffect:addOption("carniphila")
  valuesTable.defensesAreaEffect:addOption("purpleenergy")
  valuesTable.defensesAreaEffect:addOption("yellowenergy")
  valuesTable.defensesAreaEffect:addOption("holyarea")
  valuesTable.defensesAreaEffect:addOption("bigplants")
  valuesTable.defensesAreaEffect:addOption("cake")
  valuesTable.defensesAreaEffect:addOption("giantice")
  valuesTable.defensesAreaEffect:addOption("watersplash")
  valuesTable.defensesAreaEffect:addOption("plantattack")
  valuesTable.defensesAreaEffect:addOption("tutorialarrow")
  valuesTable.defensesAreaEffect:addOption("tutorialsquare")
  valuesTable.defensesAreaEffect:addOption("mirrorhorizontal")
  valuesTable.defensesAreaEffect:addOption("mirrorvertical")
  valuesTable.defensesAreaEffect:addOption("skullhorizontal")
  valuesTable.defensesAreaEffect:addOption("skullvertical")
  valuesTable.defensesAreaEffect:addOption("assassin")
  valuesTable.defensesAreaEffect:addOption("stepshorizontal")
  valuesTable.defensesAreaEffect:addOption("bloodysteps")
  valuesTable.defensesAreaEffect:addOption("stepsvertical")
  valuesTable.defensesAreaEffect:addOption("yalaharighost")
  valuesTable.defensesAreaEffect:addOption("bats")
  valuesTable.defensesAreaEffect:addOption("smoke")
  valuesTable.defensesAreaEffect:addOption("insects")
  valuesTable.defensesAreaEffect:addOption("dragonhead")
  valuesTable.defensesAreaEffect:addOption("orcshaman")
  valuesTable.defensesAreaEffect:addOption("orcshamanfire")
  valuesTable.defensesAreaEffect:addOption("thunder")
  valuesTable.defensesAreaEffect:addOption("ferumbras")
  valuesTable.defensesAreaEffect:addOption("confettihorizontal")
  valuesTable.defensesAreaEffect:addOption("confettivertical")
  valuesTable.defensesAreaEffect:addOption("blacksmoke")
  valuesTable.defensesAreaEffect:addOption("redsmoke")
  valuesTable.defensesAreaEffect:addOption("yellowsmoke")
  valuesTable.defensesAreaEffect:addOption("greensmoke")
  valuesTable.defensesAreaEffect:addOption("purplesmoke")

  --Other
  modules.tool_monstermaker.valuesTable.defensesRadius:setEnabled(false)
  valuesTable.defensesDuration:setText('4000', true)
  valuesTable.defensesSpeedchange:setText('300', true)

  --Elements
  elementsTab = allTabs:addTab('Elements', elementsPanel, nil)
  elementsTab:setWidth(60)

  valuesTable.elementsHolyText = elementsPanel:recursiveGetChildById('holyText')
  valuesTable.elementsHolyScrollbar = elementsPanel:recursiveGetChildById('holyScrollbar')
  valuesTable.elementsDeathText = elementsPanel:recursiveGetChildById('deathText')
  valuesTable.elementsDeathScrollbar = elementsPanel:recursiveGetChildById('deathScrollbar')
  valuesTable.elementsIceText = elementsPanel:recursiveGetChildById('iceText')
  valuesTable.elementsIceScrollbar = elementsPanel:recursiveGetChildById('iceScrollbar')
  valuesTable.elementsFireText = elementsPanel:recursiveGetChildById('fireText')
  valuesTable.elementsFireScrollbar = elementsPanel:recursiveGetChildById('fireScrollbar')
  valuesTable.elementsEarthText = elementsPanel:recursiveGetChildById('earthText')
  valuesTable.elementsEarthScrollbar = elementsPanel:recursiveGetChildById('earthScrollbar')
  valuesTable.elementsEnergyText = elementsPanel:recursiveGetChildById('energyText')
  valuesTable.elementsEnergyScrollbar = elementsPanel:recursiveGetChildById('energyScrollbar')
  valuesTable.elementsPhysicalText = elementsPanel:recursiveGetChildById('physicalText')
  valuesTable.elementsPhysicalScrollbar = elementsPanel:recursiveGetChildById('physicalScrollbar')
  valuesTable.elementsLifedrainText = elementsPanel:recursiveGetChildById('lifedrainText')
  valuesTable.elementsLifedrainScrollbar = elementsPanel:recursiveGetChildById('lifedrainScrollbar')
  valuesTable.elementsDrownText = elementsPanel:recursiveGetChildById('drownText')
  valuesTable.elementsDrownScrollbar = elementsPanel:recursiveGetChildById('drownScrollbar')

  --Other
  valuesTable.elementsHolyText:setText(0)
  valuesTable.elementsHolyScrollbar:setValue(0)
  valuesTable.elementsDeathText:setText(0)
  valuesTable.elementsDeathScrollbar:setValue(0)
  valuesTable.elementsIceText:setText(0)
  valuesTable.elementsIceScrollbar:setValue(0)
  valuesTable.elementsFireText:setText(0)
  valuesTable.elementsFireScrollbar:setValue(0)
  valuesTable.elementsEarthText:setText(0)
  valuesTable.elementsEarthScrollbar:setValue(0)
  valuesTable.elementsEnergyText:setText(0)
  valuesTable.elementsEnergyScrollbar:setValue(0)
  valuesTable.elementsPhysicalText:setText(0)
  valuesTable.elementsPhysicalScrollbar:setValue(0)
  valuesTable.elementsLifedrainText:setText(0)
  valuesTable.elementsLifedrainScrollbar:setValue(0)
  valuesTable.elementsDrownText:setText(0)
  valuesTable.elementsDrownScrollbar:setValue(0)

  --Immunities
  immunitiesTab = allTabs:addTab('Immunities', immunitiesPanel, nil)
  immunitiesTab:setWidth(65)

  valuesTable.immunitiesHoly = immunitiesPanel:recursiveGetChildById('holyCheckBox')
  valuesTable.immunitiesDeath = immunitiesPanel:recursiveGetChildById('deathCheckBox')
  valuesTable.immunitiesIce = immunitiesPanel:recursiveGetChildById('iceCheckBox')
  valuesTable.immunitiesFire = immunitiesPanel:recursiveGetChildById('fireCheckBox')
  valuesTable.immunitiesEarth = immunitiesPanel:recursiveGetChildById('earthCheckBox')
  valuesTable.immunitiesEnergy = immunitiesPanel:recursiveGetChildById('energyCheckBox')
  valuesTable.immunitiesPhysical = immunitiesPanel:recursiveGetChildById('physicalCheckBox')
  valuesTable.immunitiesLifedrain = immunitiesPanel:recursiveGetChildById('lifedrainCheckBox')
  valuesTable.immunitiesDrown = immunitiesPanel:recursiveGetChildById('drownCheckBox')
  valuesTable.immunitiesParalyze = immunitiesPanel:recursiveGetChildById('paralyzeCheckBox')
  valuesTable.immunitiesDrunk = immunitiesPanel:recursiveGetChildById('drunkCheckBox')
  valuesTable.immunitiesInvisible = immunitiesPanel:recursiveGetChildById('invisibleCheckBox')
  valuesTable.immunitiesOutfit = immunitiesPanel:recursiveGetChildById('outfitCheckBox')

  --Summons
  summonsTab = allTabs:addTab('Summons', summonsPanel, nil)
  summonsTab:setWidth(60)

  valuesTable.summonsMaxSummons = summonsPanel:recursiveGetChildById('maxSummonsText')
  valuesTable.summonsList = summonsPanel:recursiveGetChildById('summonslistTextList')
  valuesTable.summonsName = summonsPanel:recursiveGetChildById('summonNameText')
  valuesTable.summonsInterval = summonsPanel:recursiveGetChildById('intervalText')
  valuesTable.summonsChance = summonsPanel:recursiveGetChildById('chanceText')
  valuesTable.summonsMax = summonsPanel:recursiveGetChildById('maxText')

  --Voices
  voicesTab = allTabs:addTab('Voices', voicesPanel, nil)
  voicesTab:setWidth(43)

  valuesTable.voicesInterval = voicesPanel:recursiveGetChildById('intervalText')
  valuesTable.voicesChance = voicesPanel:recursiveGetChildById('chanceText')
  valuesTable.voicesList = voicesPanel:recursiveGetChildById('voiceslistTextList')
  valuesTable.voicesSentence = voicesPanel:recursiveGetChildById('sentenceText')
  valuesTable.voicesYell = voicesPanel:recursiveGetChildById('yellCheckBox')

  --Loot
  lootTab = allTabs:addTab('Loot', lootPanel, nil)
  lootTab:setWidth(35)

  valuesTable.lootList = lootPanel:recursiveGetChildById('lootlistTextList')
  valuesTable.lootIdLabel = lootPanel:recursiveGetChildById('idLabel')
  valuesTable.lootId = lootPanel:recursiveGetChildById('idText')
  valuesTable.lootNameCheckbox = lootPanel:recursiveGetChildById('nameCheckBox')
  valuesTable.lootNameLabel = lootPanel:recursiveGetChildById('nameLabel')
  valuesTable.lootName = lootPanel:recursiveGetChildById('nameText')
  valuesTable.lootChance = lootPanel:recursiveGetChildById('chanceText')
  valuesTable.lootCountmaxCheckBox = lootPanel:recursiveGetChildById('countmaxCheckBox')
  valuesTable.lootCountmax = lootPanel:recursiveGetChildById('countmaxText')
  valuesTable.lootSubtypeCheckBox = lootPanel:recursiveGetChildById('subtypeCheckBox')
  valuesTable.lootSubtype = lootPanel:recursiveGetChildById('subtypeComboBox')
  valuesTable.lootActionidCheckBox = lootPanel:recursiveGetChildById('actionidCheckBox')
  valuesTable.lootActionid = lootPanel:recursiveGetChildById('actionidText')
  valuesTable.lootUniqueidCheckBox = lootPanel:recursiveGetChildById('uniqueidCheckBox')
  valuesTable.lootUniqueid = lootPanel:recursiveGetChildById('uniqueidText')
  valuesTable.lootTextCheckBox = lootPanel:recursiveGetChildById('textCheckBox')
  valuesTable.lootText = lootPanel:recursiveGetChildById('textText')
  valuesTable.lootCommentCheckBox = lootPanel:recursiveGetChildById('commentCheckBox')
  valuesTable.lootComment = lootPanel:recursiveGetChildById('commentText')

  --Subtype
  valuesTable.lootSubtype:addOption('water')
  valuesTable.lootSubtype:addOption('blood')
  valuesTable.lootSubtype:addOption('beer')
  valuesTable.lootSubtype:addOption('slime')
  valuesTable.lootSubtype:addOption('lemonade')
  valuesTable.lootSubtype:addOption('milk')
  valuesTable.lootSubtype:addOption('manafluid')
  valuesTable.lootSubtype:addOption('lifefluid')
  valuesTable.lootSubtype:addOption('oil')
  valuesTable.lootSubtype:addOption('urine')
  valuesTable.lootSubtype:addOption('coconut milk')
  valuesTable.lootSubtype:addOption('wine')
  valuesTable.lootSubtype:addOption('mud')
  valuesTable.lootSubtype:addOption('fruit juice')
  valuesTable.lootSubtype:addOption('lava')
  valuesTable.lootSubtype:addOption('rum')
  valuesTable.lootSubtype:addOption('swamp')
  valuesTable.lootSubtype:addOption('tea')
  valuesTable.lootSubtype:addOption('mead')

  --Other
  valuesTable.lootNameLabel:setEnabled(false)
  valuesTable.lootName:setEnabled(false)
  valuesTable.lootCountmax:setEnabled(false)
  valuesTable.lootSubtype:setEnabled(false)
  valuesTable.lootActionid:setEnabled(false)
  valuesTable.lootUniqueid:setEnabled(false)
  valuesTable.lootText:setEnabled(false)
  valuesTable.lootComment:setEnabled(false)

  --I/O
  ioTab = allTabs:addTab('I/O', ioPanel, nil)
  ioTab:setWidth(22)

  valuesTable.ioFilename = ioPanel:recursiveGetChildById('filenameText')
  valuesTable.ioActualname = ioPanel:recursiveGetChildById('actualNameLabel')
  valuesTable.ioOwnNameCheckBox = ioPanel:recursiveGetChildById('ownNameCheckBox')
  valuesTable.ioList = ioPanel:recursiveGetChildById('ioTextList')

  --Other
  valuesTable.ioFilename:setEnabled(false)

  --Add files to load list
  addCreatureFilesToList()
end

function terminate()
  monsterMakerButton:destroy()
  monsterMakerWindow:destroy()
end

function toggle()
  if monsterMakerButton:isOn() then
    monsterMakerWindow:setVisible(false)
    monsterMakerButton:setOn(false)
  else
    monsterMakerWindow:setVisible(true)
    monsterMakerButton:setOn(true)
  end
end

function onMiniWindowClose()
  monsterMakerButton:setOn(false)
end

function clear()
  --TODO
end

-------------------------------------------------
--Scripts----------------------------------------
-------------------------------------------------

function setMonsterPreview()
  local checkType = tonumber(valuesTable.looktype:getText())

  --Anty outfit crash (avoid danger checktype id)
  --Test on 8.6--
  if checkType == 1 or checkType == 135 or (checkType >= 161 and checkType <= 191) or checkType == 411 or checkType == 415 or checkType == 424 or
  checkType == 439 or checkType == 440 or checkType == 468 or checkType == 469 or (checkType >= 474 and checkType <= 485) or checkType == 501 or
  checkType == 518 or checkType == 519 or checkType == 520 or checkType == 524 or checkType == 525 or checkType == 536 or checkType == 543 or
  checkType == 549 or checkType == 576 or checkType == 581 or checkType == 582 or checkType == 597 or checkType == 616 or checkType == 623 or
  checkType == 625 or (checkType >= 638 and checkType <= 646) or (checkType >= 652 and checkType <= 664) or checkType == 678 or
  (checkType >= 700 and checkType <= 711) or checkType == 713 or checkType == 715 or checkType == 718 or checkType == 719 or checkType == 722 or
  checkType == 723 or checkType == 737 or (checkType >= 741 and checkType <= 744) or checkType == 748 or (checkType >= 751 and checkType <= 758) or
  (checkType >= 764 and checkType <= 801) --[[<-- Checked]] or (checkType >= 802 and checkType <= 841) --[[<-- not checked]] or checkType == 861 or
  (checkType >= 864 and checkType <= 867) or checkType == 871 or checkType == 872 or checkType == 880 or (checkType >= 891 and checkType <= 898) then
    checkType = 0
  end

  local outfit = nil

  if g_sprites.isLoaded() then
    if valuesTable.looktypeCheckBox:isChecked() then
      outfit = {type = checkType, feet = tonumber(valuesTable.feet:getText()), addons = tonumber(valuesTable.addons:getText()), legs = tonumber(valuesTable.legs:getText()), auxType = 0, head = tonumber(valuesTable.head:getText()), body = tonumber(valuesTable.body:getText()), mount = tonumber(valuesTable.mount:getText())}
    elseif valuesTable.looktypeExCheckBox:isChecked() then
      outfit = {type = 130, feet = tonumber(valuesTable.feet:getText()), addons = tonumber(valuesTable.addons:getText()), legs = tonumber(valuesTable.legs:getText()), auxType = tonumber(valuesTable.looktype:getText()), head = tonumber(valuesTable.head:getText()), body = tonumber(valuesTable.body:getText()), mount = tonumber(valuesTable.mount:getText())}
    end
    valuesTable.monsterPreview:setOutfit(outfit)
  else
    --TODO
  end
end

-------------------------------------------------
--UI Attacks-------------------------------------
-------------------------------------------------

function hideAllAttacksNames()
  valuesTable.attacksNameelemental:setVisible(false)
  valuesTable.attacksNameconditions:setVisible(false)
  valuesTable.attacksNamefields:setVisible(false)
  valuesTable.attacksNamerunes:setVisible(false)
  valuesTable.attacksNamespells:setVisible(false)
  valuesTable.attacksNameother:setVisible(false)
end

function showAttackName(attackName)
  hideAllAttacksNames()

  if attackName == 'melee' then
    modules.tool_monstermaker.valuesTable.attacksSkillCheckBox:setVisible(true)

    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('skillLabel'):setVisible(true)
    modules.tool_monstermaker.valuesTable.attacksSkillText:setVisible(true)
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('attackLabel'):setVisible(true)
    modules.tool_monstermaker.valuesTable.attacksAttackText:setVisible(true)
  else
    modules.tool_monstermaker.valuesTable.attacksSkillCheckBox:setChecked(false)
    modules.tool_monstermaker.valuesTable.attacksSkillCheckBox:setVisible(false)

    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('skillLabel'):setVisible(false)
    modules.tool_monstermaker.valuesTable.attacksSkillText:setVisible(false)
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('attackLabel'):setVisible(false)
    modules.tool_monstermaker.valuesTable.attacksAttackText:setVisible(false)
  end

  if attackName == 'elemental' then
    valuesTable.attacksNameelemental:setVisible(true)
  elseif attackName == 'conditions' then
    valuesTable.attacksNameconditions:setVisible(true)
  elseif attackName == 'fields' then
    valuesTable.attacksNamefields:setVisible(true)
  elseif attackName == 'runes' then
    valuesTable.attacksNamerunes:setVisible(true)
  elseif attackName == 'spells' then
    valuesTable.attacksNamespells:setVisible(true)
  elseif attackName == 'other' then
    valuesTable.attacksNameother:setVisible(true)
  end
end

function onSkillCheckBoxChange()
  if valuesTable.attacksSkillCheckBox:isChecked() then
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('minLabel'):setEnabled(false)
    modules.tool_monstermaker.valuesTable.attacksMin:setEnabled(false)
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('maxLabel'):setEnabled(false)
    modules.tool_monstermaker.valuesTable.attacksMax:setEnabled(false)
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('skillLabel'):setEnabled(true)
    modules.tool_monstermaker.valuesTable.attacksSkillText:setEnabled(true)
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('attackLabel'):setEnabled(true)
    modules.tool_monstermaker.valuesTable.attacksAttackText:setEnabled(true)
  else
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('minLabel'):setEnabled(true)
    modules.tool_monstermaker.valuesTable.attacksMin:setEnabled(true)
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('maxLabel'):setEnabled(true)
    modules.tool_monstermaker.valuesTable.attacksMax:setEnabled(true)
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('skillLabel'):setEnabled(false)
    modules.tool_monstermaker.valuesTable.attacksSkillText:setEnabled(false)
    modules.tool_monstermaker.attacksPanel:recursiveGetChildById('attackLabel'):setEnabled(false)
    modules.tool_monstermaker.valuesTable.attacksAttackText:setEnabled(false)
  end
end

local attacksTable = {}
local listUIAttacksTable = {}

function getAttackFromUI()
  --add to subtable
  local attackTable = {}

  --name
  if valuesTable.attacksNametype:getText() == 'melee' then
    attackTable.name = 'melee'
  elseif valuesTable.attacksNametype:getText() == 'elemental' then
    attackTable.name = valuesTable.attacksNameelemental:getText()
  elseif valuesTable.attacksNametype:getText() == 'conditions' then
    attackTable.name = valuesTable.attacksNameconditions:getText()
  elseif valuesTable.attacksNametype:getText() == 'fields' then
    attackTable.name = valuesTable.attacksNamefields:getText()
  elseif valuesTable.attacksNametype:getText() == 'runes' then
    attackTable.name = valuesTable.attacksNamerunes:getText()
  elseif valuesTable.attacksNametype:getText() == 'spells' then
    attackTable.name = valuesTable.attacksNamespells:getText()
  elseif valuesTable.attacksNametype:getText() == 'other' then
    attackTable.name = valuesTable.attacksNameother:getText()
  end
  --min/max/skill/attack
  if not valuesTable.attacksSkillCheckBox:isChecked() then
    attackTable.min = tonumber(valuesTable.attacksMin:getText())
    attackTable.max = tonumber(valuesTable.attacksMax:getText())
  else
    attackTable.skill = tonumber(valuesTable.attacksSkillText:getText())
    attackTable.attack = tonumber(valuesTable.attacksAttackText:getText())
  end
  --interval/chance
  attackTable.interval = tonumber(valuesTable.attacksInterval:getText())
  attackTable.chance = tonumber(valuesTable.attacksChance:getText())
  --length/spread/radius/poison
  if valuesTable.attacksLengthCheckBox:isChecked() then
    attackTable.length = tonumber(valuesTable.attacksLength:getText())
  end
  if valuesTable.attacksSpreadCheckBox:isChecked() then
    attackTable.spread = tonumber(valuesTable.attacksSpread:getText())
  end
  if valuesTable.attacksRadiusCheckBox:isChecked() then
    attackTable.radius = tonumber(valuesTable.attacksRadius:getText())
  end
  if valuesTable.attacksPoisonCheckBox:isChecked() then
    attackTable.poison = tonumber(valuesTable.attacksPoison:getText())
  end
  --target/range
  if valuesTable.attacksTargetCheckBox:isChecked() then
    attackTable.target = 1
    attackTable.range = tonumber(valuesTable.attacksRange:getText())
  end
  --area/shoot effect
  if valuesTable.attacksAreaEffectCheckBox:isChecked() then
    attackTable.areaEffect = valuesTable.attacksAreaEffectComboBox:getText()
  end
  if valuesTable.attacksShootEffectCheckBox:isChecked() then
    attackTable.shootEffect = valuesTable.attacksShootEffectComboBox:getText()
  end

  return attackTable
end

function generateXMLattack(table, indentation, firstIndentation)
  indentation = indentation or '  '
  firstIndentation = firstIndentation or ''

  local attack = ''
  attack = attack..firstIndentation..'<attack name="'..table.name..'" interval="'..table.interval..'"'
  if table.chance ~= nil then
    attack = attack..' chance="'..table.chance..'"'
  end
  if table.length ~= nil then
    attack = attack..' length="'..table.length..'"'
  end
  if table.spread ~= nil then
    attack = attack..' spread="'..table.spread..'"'
  end
  if table.radius ~= nil then
    attack = attack..' radius="'..table.radius..'"'
  end
  if table.range ~= nil then
    attack = attack..' range="'..table.range..'"'
  end
  if table.target ~= nil then
    attack = attack..' target="'..table.target..'"'
  end
  if table.min ~= nil and table.max ~= nil then
    attack = attack..' min="'..table.min..'" max="'..table.max..'"'
  elseif table.skill ~= nil and table.attack ~= nil then
    attack = attack..' skill="'..table.skill..'" attack="'..table.attack..'"'
  end
  if table.poison ~= nil then
    attack = attack..' poison="'..table.poison..'"'
  end
  if not (table.areaEffect ~= nil or table.shootEffect ~= nil) then
    attack = attack..'/>'
  else
    attack = attack..'>'

    if table.areaEffect ~= nil then
      attack = attack..'\n'..firstIndentation..indentation..'<attribute key="areaEffect" value="'..table.areaEffect..'"/>'
    end

    if table.shootEffect ~= nil then
      attack = attack..'\n'..firstIndentation..indentation..'<attribute key="shootEffect" value="'..table.shootEffect..'"/>'
    end

    attack = attack..'\n'..firstIndentation..'</attack>'
  end

  return attack
end

local attacksUINr = 1

function getAttackNumberUI()
  local returnNr = attacksUINr
  attacksUINr = attacksUINr + 1
  return returnNr
end

function addToUIAndTable(attackUITable)
  attackUITable = attackUITable or getAttackFromUI()
  local id = getAttackNumberUI()
  attacksTable[id] = attackUITable

  local _, newLine = string.gsub(generateXMLattack(attackUITable), '\n', '\n')

  listUIAttacksTable[id] = g_ui.createWidget('ChoiceListLabel', valuesTable.attacksAttackslist)
  listUIAttacksTable[id]:setText(generateXMLattack(attackUITable))
  listUIAttacksTable[id]:setId(id)
  listUIAttacksTable[id]:setHeight(14*(1 + newLine))
end

function showAttackFromTable()
  if valuesTable.attacksAttackslist:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.attacksAttackslist:getFocusedChild():getId())

  --name
  if attacksTable[selectedRow].name ~= nil then
    if attacksTable[selectedRow].name == 'melee' then
      valuesTable.attacksNametype:setOption('melee')
    elseif valuesTable.attacksNameelemental:isOption(attacksTable[selectedRow].name) then
      valuesTable.attacksNametype:setOption('elemental')
      valuesTable.attacksNameelemental:setOption(attacksTable[selectedRow].name)
    elseif valuesTable.attacksNameconditions:isOption(attacksTable[selectedRow].name) then
      valuesTable.attacksNametype:setOption('conditions')
      valuesTable.attacksNameconditions:setOption(attacksTable[selectedRow].name)
    elseif valuesTable.attacksNamefields:isOption(attacksTable[selectedRow].name) then
      valuesTable.attacksNametype:setOption('fields')
      valuesTable.attacksNamefields:setOption(attacksTable[selectedRow].name)
    elseif valuesTable.attacksNamerunes:isOption(attacksTable[selectedRow].name) then
      valuesTable.attacksNametype:setOption('runes')
      valuesTable.attacksNamerunes:setOption(attacksTable[selectedRow].name)
    elseif valuesTable.attacksNamespells:isOption(attacksTable[selectedRow].name) then
      valuesTable.attacksNametype:setOption('spells')
      valuesTable.attacksNamespells:setOption(attacksTable[selectedRow].name)
    else
      valuesTable.attacksNametype:setOption('other')
      valuesTable.attacksNameother:setText(attacksTable[selectedRow].name)
    end
  end

  --min/max/skill/attack
  if attacksTable[selectedRow].min or attacksTable[selectedRow].max then
    valuesTable.attacksMin:setText(attacksTable[selectedRow].min)
    valuesTable.attacksMax:setText(attacksTable[selectedRow].max)
    valuesTable.attacksSkillCheckBox:setChecked(false)
  elseif attacksTable[selectedRow].skill or attacksTable[selectedRow].attack then
    valuesTable.attacksSkillText:setText(attacksTable[selectedRow].skill)
    valuesTable.attacksAttackText:setText(attacksTable[selectedRow].attack)
    valuesTable.attacksSkillCheckBox:setChecked(true)
  end

  --interval/chance
  valuesTable.attacksInterval:setText(attacksTable[selectedRow].interval)
  valuesTable.attacksChance:setText(attacksTable[selectedRow].chance)
  
  --length/spread/radius/poison
  if attacksTable[selectedRow].length ~= nil then
    valuesTable.attacksLengthCheckBox:setChecked(true)
    valuesTable.attacksLength:setText(attacksTable[selectedRow].length)
  else
    valuesTable.attacksLengthCheckBox:setChecked(false)
  end
  if attacksTable[selectedRow].spread ~= nil then
    valuesTable.attacksSpreadCheckBox:setChecked(true)
    valuesTable.attacksSpread:setText(attacksTable[selectedRow].spread)
  else
    valuesTable.attacksSpreadCheckBox:setChecked(false)
  end
  if attacksTable[selectedRow].radius then
    valuesTable.attacksRadiusCheckBox:setChecked(true)
    valuesTable.attacksRadius:setText(attacksTable[selectedRow].radius)
  else
    valuesTable.attacksRadiusCheckBox:setChecked(false)
  end
  if attacksTable[selectedRow].poison then
    valuesTable.attacksPoisonCheckBox:setChecked(true)
    valuesTable.attacksPoison:setText(attacksTable[selectedRow].poison)
  else
    valuesTable.attacksPoisonCheckBox:setChecked(false)
  end

  --target/range
  if (attacksTable[selectedRow].target and attacksTable[selectedRow].range ~= nil) or (attacksTable[selectedRow].range ~= nil and attacksTable[selectedRow].range > 0) then
    valuesTable.attacksTargetCheckBox:setChecked(true)
    valuesTable.attacksRange:setText(attacksTable[selectedRow].range)
  else
    valuesTable.attacksTargetCheckBox:setChecked(false)
  end
  
  --area/shoot effect
  if attacksTable[selectedRow].areaEffect then
    valuesTable.attacksAreaEffectComboBox:setOption(attacksTable[selectedRow].areaEffect)
    valuesTable.attacksAreaEffectCheckBox:setChecked(true)
  else
    valuesTable.attacksAreaEffectCheckBox:setChecked(false)
  end
  if attacksTable[selectedRow].shootEffect then
    valuesTable.attacksShootEffectComboBox:setOption(attacksTable[selectedRow].shootEffect)
    valuesTable.attacksShootEffectCheckBox:setChecked(true)
  else
    valuesTable.attacksShootEffectCheckBox:setChecked(false)
  end
end

function editAttackFromTable()
  if valuesTable.attacksAttackslist:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.attacksAttackslist:getFocusedChild():getId())

  attacksTable[selectedRow] = getAttackFromUI()

  local _, newLine = string.gsub(generateXMLattack(getAttackFromUI()), '\n', '\n')

  listUIAttacksTable[selectedRow]:setText(generateXMLattack(getAttackFromUI()))
  listUIAttacksTable[selectedRow]:setHeight(14*(1 + newLine))
end

function deleteAttackFromTable()
  if valuesTable.attacksAttackslist:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.attacksAttackslist:getFocusedChild():getId())

  attacksTable[selectedRow] = nil
  listUIAttacksTable[selectedRow]:destroy()
  listUIAttacksTable[selectedRow] = nil
end

function deleteAllAttackFromTable()
  for _,child in pairs(valuesTable.attacksAttackslist:getChildren()) do
    attacksTable[tonumber(child:getId())] = nil
    listUIAttacksTable[tonumber(child:getId())]:destroy()
    listUIAttacksTable[tonumber(child:getId())] = nil
  end
end

-------------------------------------------------
--UI Defenses------------------------------------
-------------------------------------------------

function changeDefenseType(option)
  if option == 'healing' then
    --ON
    valuesTable.defensesMinLabel:setEnabled(true)
    valuesTable.defensesMin:setEnabled(true)
    valuesTable.defensesMaxLabel:setEnabled(true)
    valuesTable.defensesMax:setEnabled(true)
    valuesTable.defensesIsRadius:setEnabled(true)
    if valuesTable.defensesIsRadius:isChecked() then
      valuesTable.defensesRadius:setEnabled(true)
    end
    --OFF
    valuesTable.defensesDurationLabel:setEnabled(false)
    valuesTable.defensesDuration:setEnabled(false)
    valuesTable.defensesSpeedchangeLabel:setEnabled(false)
    valuesTable.defensesSpeedchange:setEnabled(false)
  elseif option == 'speed' then
    --ON
    valuesTable.defensesDurationLabel:setEnabled(true)
    valuesTable.defensesDuration:setEnabled(true)
    valuesTable.defensesSpeedchangeLabel:setEnabled(true)
    valuesTable.defensesSpeedchange:setEnabled(true)
    --OFF
    valuesTable.defensesMinLabel:setEnabled(false)
    valuesTable.defensesMin:setEnabled(false)
    valuesTable.defensesMaxLabel:setEnabled(false)
    valuesTable.defensesMax:setEnabled(false)
    valuesTable.defensesIsRadius:setEnabled(false)
    valuesTable.defensesRadius:setEnabled(false)
  elseif option == 'invisible' then
    --ON
    valuesTable.defensesDurationLabel:setEnabled(true)
    valuesTable.defensesDuration:setEnabled(true)
    --OFF
    valuesTable.defensesMinLabel:setEnabled(false)
    valuesTable.defensesMin:setEnabled(false)
    valuesTable.defensesMaxLabel:setEnabled(false)
    valuesTable.defensesMax:setEnabled(false)
    valuesTable.defensesIsRadius:setEnabled(false)
    valuesTable.defensesRadius:setEnabled(false)
    valuesTable.defensesSpeedchangeLabel:setEnabled(false)
    valuesTable.defensesSpeedchange:setEnabled(false)
  end 
end

local defensesTable = {}
local listUIDefensesTable = {}

function getDefenseFromUI()
  --add to subtable
  local defenseTable = {}

  --name
  if valuesTable.defensesName:getText() == 'healing' then
    defenseTable.name = 'healing'
    defenseTable.interval = tonumber(valuesTable.defensesInterval:getText())
    defenseTable.chance = tonumber(valuesTable.defensesChance:getText())
    defenseTable.min = tonumber(valuesTable.defensesMin:getText())
    defenseTable.max = tonumber(valuesTable.defensesMax:getText())
    if valuesTable.defensesIsRadius:isChecked() then
      defenseTable.radius = tonumber(valuesTable.defensesRadius:getText())
    end
    defenseTable.areaEffect = valuesTable.defensesAreaEffect:getText()
  elseif valuesTable.defensesName:getText() == 'speed' then
    defenseTable.name = 'speed'
    defenseTable.interval = tonumber(valuesTable.defensesInterval:getText())
    defenseTable.chance = tonumber(valuesTable.defensesChance:getText())
    defenseTable.areaEffect = valuesTable.defensesAreaEffect:getText()
    defenseTable.duration = tonumber(valuesTable.defensesDuration:getText())
    defenseTable.speedChange = tonumber(valuesTable.defensesSpeedchange:getText())
  elseif valuesTable.defensesName:getText() == 'invisible' then
    defenseTable.name = 'invisible'
    defenseTable.interval = tonumber(valuesTable.defensesInterval:getText())
    defenseTable.chance = tonumber(valuesTable.defensesChance:getText())
    defenseTable.areaEffect = valuesTable.defensesAreaEffect:getText()
    defenseTable.duration = tonumber(valuesTable.defensesDuration:getText())
  end

  return defenseTable
end

function generateXMLdefense(table, indentation, firstIndentation)
  indentation = indentation or '  '
  firstIndentation = firstIndentation or ''

  local defense = ''
  defense = defense..firstIndentation..'<defense name="'..table.name..'" interval="'..table.interval..'" chance="'..table.chance..'"'
  if table.name == 'healing' then
    defense = defense..' min="'..table.min..'" max="'..table.max..'"'
    if table.radius ~= nil then
      defense = defense..' radius="'..table.radius..'"'
    end
  elseif table.name == 'speed' then
    defense = defense..' duration="'..table.duration..'" speedchange="'..table.speedChange..'"'
  elseif table.name == 'invisible' then
    defense = defense..' duration="'..table.duration..'"'
  end
  defense = defense..'>'

  defense = defense..'\n'..firstIndentation..indentation..'<attribute key="areaEffect" value="'..table.areaEffect..'"/>'

  defense = defense..'\n'..firstIndentation..'</defense>'

  return defense
end

local defensesUINr = 1

function getDefenseNumberUI()
  local returnNr = defensesUINr
  defensesUINr = defensesUINr + 1
  return returnNr
end

function addDefenseToUIAndTable(defenseUITable)
  defenseUITable = defenseUITable or getDefenseFromUI()
  local id = getDefenseNumberUI()
  defensesTable[id] = defenseUITable

  local _, newLine = string.gsub(generateXMLdefense(defenseUITable), '\n', '\n')

  listUIDefensesTable[id] = g_ui.createWidget('ChoiceListLabel', valuesTable.defensesList)
  listUIDefensesTable[id]:setText(generateXMLdefense(defenseUITable))
  listUIDefensesTable[id]:setId(id)
  listUIDefensesTable[id]:setHeight(14*(1 + newLine))
end

function showDefenseFromTable()
  if valuesTable.defensesList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.defensesList:getFocusedChild():getId())

  if defensesTable[selectedRow].name ~= nil then
    if defensesTable[selectedRow].name == 'healing' then
      valuesTable.defensesName:setOption('healing')
      valuesTable.defensesInterval:setText(defensesTable[selectedRow].interval)
      valuesTable.defensesChance:setText(defensesTable[selectedRow].chance)
      valuesTable.defensesMin:setText(defensesTable[selectedRow].min)
      valuesTable.defensesMax:setText(defensesTable[selectedRow].max)
      if defensesTable[selectedRow].radius ~= nil then
        valuesTable.defensesIsRadius:setChecked(true)
        valuesTable.defensesRadius:setText(defensesTable[selectedRow].radius)
      else
        valuesTable.defensesIsRadius:setChecked(false)
      end
      valuesTable.defensesAreaEffect:setOption(defensesTable[selectedRow].areaEffect)
    elseif defensesTable[selectedRow].name == 'speed' then
      valuesTable.defensesName:setOption('speed')
      valuesTable.defensesInterval:setText(defensesTable[selectedRow].interval)
      valuesTable.defensesChance:setText(defensesTable[selectedRow].chance)
      valuesTable.defensesAreaEffect:setOption(defensesTable[selectedRow].areaEffect)
      valuesTable.defensesDuration:setText(defensesTable[selectedRow].duration)
      valuesTable.defensesSpeedchange:setText(defensesTable[selectedRow].speedChange)
    elseif defensesTable[selectedRow].name == 'invisible' then
      valuesTable.defensesName:setOption('invisible')
      valuesTable.defensesInterval:setText(defensesTable[selectedRow].interval)
      valuesTable.defensesChance:setText(defensesTable[selectedRow].chance)
      valuesTable.defensesAreaEffect:setOption(defensesTable[selectedRow].areaEffect)
      valuesTable.defensesDuration:setText(defensesTable[selectedRow].duration)
    end
  end
end

function editDefenseFromTable()
  if valuesTable.defensesList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.defensesList:getFocusedChild():getId())

  defensesTable[selectedRow] = getDefenseFromUI()

  local _, newLine = string.gsub(generateXMLdefense(getDefenseFromUI()), '\n', '\n')

  listUIDefensesTable[selectedRow]:setText(generateXMLdefense(getDefenseFromUI()))
  listUIDefensesTable[selectedRow]:setHeight(14*(1 + newLine))
end

function deleteDefenseFromTable()
  if valuesTable.defensesList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.defensesList:getFocusedChild():getId())

  defensesTable[selectedRow] = nil
  listUIDefensesTable[selectedRow]:destroy()
  listUIDefensesTable[selectedRow] = nil
end

function deleteAllDefenseFromTable()
  for _,child in pairs(valuesTable.defensesList:getChildren()) do
    defensesTable[tonumber(child:getId())] = nil
    listUIDefensesTable[tonumber(child:getId())]:destroy()
    listUIDefensesTable[tonumber(child:getId())] = nil
  end
end

-------------------------------------------------
--UI Summons-------------------------------------
-------------------------------------------------

local summonsTable = {}
local listUISummonsTable = {}

function getSummonFromUI()
  --add to subtable
  local summonTable = {}

  summonTable.name = valuesTable.summonsName:getText()
  summonTable.interval = tonumber(valuesTable.summonsInterval:getText())
  summonTable.chance = tonumber(valuesTable.summonsChance:getText())
  summonTable.max = tonumber(valuesTable.summonsMax:getText())

  return summonTable
end

function generateXMLsummon(table, indentation, firstIndentation)
  indentation = indentation or '  '
  firstIndentation = firstIndentation or ''

  local summon = ''
  summon = summon..firstIndentation..'<summon name="'..table.name..'" interval="'..table.interval..'" chance="'..table.chance..'" max="'..table.max..'"/>'

  return summon
end

local summonsUINr = 1

function getSummonNumberUI()
  local returnNr = summonsUINr
  summonsUINr = summonsUINr + 1
  return returnNr
end

function addSummonToUIAndTable(summonUITable)
  summonUITable = summonUITable or getSummonFromUI()
  local id = getSummonNumberUI()
  summonsTable[id] = summonUITable

  local _, newLine = string.gsub(generateXMLsummon(summonUITable), '\n', '\n')

  listUISummonsTable[id] = g_ui.createWidget('ChoiceListLabel', valuesTable.summonsList)
  listUISummonsTable[id]:setText(generateXMLsummon(summonUITable))
  listUISummonsTable[id]:setId(id)
  listUISummonsTable[id]:setHeight(14*(1 + newLine))
end

function showSummonFromTable()
  if valuesTable.summonsList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.summonsList:getFocusedChild():getId())

  if summonsTable[selectedRow].name ~= nil then
    valuesTable.summonsName:setText(summonsTable[selectedRow].name)
    valuesTable.summonsInterval:setText(summonsTable[selectedRow].interval)
    valuesTable.summonsChance:setText(summonsTable[selectedRow].chance)
    valuesTable.summonsMax:setText(summonsTable[selectedRow].max)
  end
end

function editSummonFromTable()
  if valuesTable.summonsList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.summonsList:getFocusedChild():getId())

  summonsTable[selectedRow] = getSummonFromUI()

  local _, newLine = string.gsub(generateXMLsummon(getSummonFromUI()), '\n', '\n')

  listUISummonsTable[selectedRow]:setText(generateXMLsummon(getSummonFromUI()))
  listUISummonsTable[selectedRow]:setHeight(14*(1 + newLine))
end

function deleteSummonFromTable()
  if valuesTable.summonsList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.summonsList:getFocusedChild():getId())

  summonsTable[selectedRow] = nil
  listUISummonsTable[selectedRow]:destroy()
  listUISummonsTable[selectedRow] = nil
end

function deleteAllSummonFromTable()
  for _,child in pairs(valuesTable.summonsList:getChildren()) do
    summonsTable[tonumber(child:getId())] = nil
    listUISummonsTable[tonumber(child:getId())]:destroy()
    listUISummonsTable[tonumber(child:getId())] = nil
  end
end

-------------------------------------------------
--UI Voices--------------------------------------
-------------------------------------------------

local voicesTable = {}
local listUIVoicesTable = {}

function getVoiceFromUI()
  --add to subtable
  local voiceTable = {}

  voiceTable.voicesSentence = valuesTable.voicesSentence:getText()
  voiceTable.voicesYell = valuesTable.voicesYell:isChecked()

  return voiceTable
end

function generateXMLvoice(table, indentation, firstIndentation)
  indentation = indentation or '  '
  firstIndentation = firstIndentation or ''

  local voice = ''
  voice = voice..firstIndentation..'<voice sentence="'..table.voicesSentence..'"'
  if table.voicesYell then
    voice = voice..' yell="1"/>'
  else
    voice = voice..'/>'
  end

  return voice
end

local voicesUINr = 1

function getVoiceNumberUI()
  local returnNr = voicesUINr
  voicesUINr = voicesUINr + 1
  return returnNr
end

function addVoiceToUIAndTable(voiceUITable)
  voiceUITable = voiceUITable or getVoiceFromUI()
  local id = getVoiceNumberUI()
  voicesTable[id] = voiceUITable

  local _, newLine = string.gsub(generateXMLvoice(voiceUITable), '\n', '\n')

  listUIVoicesTable[id] = g_ui.createWidget('ChoiceListLabel', valuesTable.voicesList)
  listUIVoicesTable[id]:setText(generateXMLvoice(voiceUITable))
  listUIVoicesTable[id]:setId(id)
  listUIVoicesTable[id]:setHeight(14*(1 + newLine))
end

function showVoiceFromTable()
  if valuesTable.voicesList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.voicesList:getFocusedChild():getId())

  if voicesTable[selectedRow].voicesSentence ~= nil then
    valuesTable.voicesSentence:setText(voicesTable[selectedRow].voicesSentence)
    if voicesTable[selectedRow].voicesYell then
      valuesTable.voicesYell:setChecked(true)
    else
      valuesTable.voicesYell:setChecked(false)
    end
  end
end

function editVoiceFromTable()
  if valuesTable.voicesList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.voicesList:getFocusedChild():getId())

  voicesTable[selectedRow] = getVoiceFromUI()

  local _, newLine = string.gsub(generateXMLvoice(getVoiceFromUI()), '\n', '\n')

  listUIVoicesTable[selectedRow]:setText(generateXMLvoice(getVoiceFromUI()))
  listUIVoicesTable[selectedRow]:setHeight(14*(1 + newLine))
end

function deleteVoiceFromTable()
  if valuesTable.voicesList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.voicesList:getFocusedChild():getId())

  voicesTable[selectedRow] = nil
  listUIVoicesTable[selectedRow]:destroy()
  listUIVoicesTable[selectedRow] = nil
end

function deleteAllVoiceFromTable()
  for _,child in pairs(valuesTable.voicesList:getChildren()) do
    voicesTable[tonumber(child:getId())] = nil
    listUIVoicesTable[tonumber(child:getId())]:destroy()
    listUIVoicesTable[tonumber(child:getId())] = nil
  end
end

-------------------------------------------------
--UI Loot----------------------------------------
-------------------------------------------------

local lootSubtype = {}
lootSubtype['water'] = 1
lootSubtype['blood'] = 2
lootSubtype['beer'] = 3
lootSubtype['slime'] = 4
lootSubtype['lemonade'] = 5
lootSubtype['milk'] = 6
lootSubtype['manafluid'] = 7
lootSubtype['lifefluid'] = 10
lootSubtype['oil'] = 11
lootSubtype['urine'] = 13
lootSubtype['coconut milk'] = 14
lootSubtype['wine'] = 15
lootSubtype['mud'] = 19
lootSubtype['fruit juice'] = 21
lootSubtype['lava'] = 26
lootSubtype['rum'] = 27
lootSubtype['swamp'] = 28
lootSubtype['tea'] = 35
lootSubtype['mead'] = 43

local lootSubtypeId = {}
lootSubtypeId[1] = 'water'
lootSubtypeId[2] = 'blood'
lootSubtypeId[3] = 'beer'
lootSubtypeId[4] = 'slime'
lootSubtypeId[5] = 'lemonade'
lootSubtypeId[6] = 'milk'
lootSubtypeId[7] = 'manafluid'
lootSubtypeId[10] = 'lifefluid'
lootSubtypeId[11] = 'oil'
lootSubtypeId[13] = 'urine'
lootSubtypeId[14] = 'coconut milk'
lootSubtypeId[15] = 'wine'
lootSubtypeId[19] = 'mud'
lootSubtypeId[21] = 'fruit juice'
lootSubtypeId[26] = 'lava'
lootSubtypeId[27] = 'rum'
lootSubtypeId[28] = 'swamp'
lootSubtypeId[35] = 'tea'
lootSubtypeId[43] = 'mead'

function translateLootSubtype(subType)
  if lootSubtype[subType] ~= nil then
    return lootSubtype[subType]
  else
    return ''
  end
end

function translateLootSubtypeIdToText(subType)
  if lootSubtypeId[subType] ~= nil then
    return lootSubtypeId[subType]
  else
    return ''
  end
end

local lootTable = {}
local listUILootTable = {}

function getLootFromUI()
  --add to subtable
  local myLootTable = {}

  if not valuesTable.lootNameCheckbox:isChecked() then
    myLootTable.id = tonumber(valuesTable.lootId:getText())
  else
    myLootTable.name = valuesTable.lootName:getText()
  end
  myLootTable.chance = tonumber(valuesTable.lootChance:getText())
  if valuesTable.lootCountmaxCheckBox:isChecked() then
    myLootTable.countmax = tonumber(valuesTable.lootCountmax:getText())
  end
  if valuesTable.lootSubtypeCheckBox:isChecked() then
    myLootTable.subtype = valuesTable.lootSubtype:getText()
  end
  if valuesTable.lootActionidCheckBox:isChecked() then
    myLootTable.actionid = tonumber(valuesTable.lootActionid:getText())
  end
  if valuesTable.lootUniqueidCheckBox:isChecked() then
    myLootTable.uniqueid = tonumber(valuesTable.lootUniqueid:getText())
  end
  if valuesTable.lootTextCheckBox:isChecked() then
    myLootTable.text = valuesTable.lootText:getText()
  end
  if valuesTable.lootCommentCheckBox:isChecked() then
    myLootTable.comment = valuesTable.lootComment:getText()
  end

  return myLootTable
end

function generateXMLloot(table, indentation, firstIndentation)
  indentation = indentation or '  '
  firstIndentation = firstIndentation or ''

  local loot = ''
  if table.id ~= nil then
    loot = loot..firstIndentation..'<item id="'..table.id..'"'
  elseif table.name ~= nil then
    loot = loot..firstIndentation..'<item name="'..table.name..'"'
  end
  if table.countmax ~= nil then
    loot = loot..' countmax="'..table.countmax..'"'
  end
  if table.subtype ~= nil then
    loot = loot..' subtype="'..translateLootSubtype(table.subtype)..'"'
  end
  if table.actionid ~= nil then
    loot = loot..' actionId="'..table.actionid..'"'
  end
  if table.uniqueid ~= nil then
    loot = loot..' uniqueId="'..table.uniqueid..'"'
  end
  if table.text ~= nil then
    loot = loot..' text="'..table.text..'"'
  end
  loot = loot..' chance="'..table.chance..'"'..'/>'
  if table.comment ~= nil then
    loot = loot..' <!--'..table.comment..'-->'
  end

  return loot
end

local lootUINr = 1

function getLootNumberUI()
  local returnNr = lootUINr
  lootUINr = lootUINr + 1
  return returnNr
end

function addLootToUIAndTable(lootUITable)
  lootUITable = lootUITable or getLootFromUI()
  local id = getLootNumberUI()
  lootTable[id] = lootUITable

  local _, newLine = string.gsub(generateXMLloot(lootUITable), '\n', '\n')

  listUILootTable[id] = g_ui.createWidget('ChoiceListLabel', valuesTable.lootList)
  listUILootTable[id]:setText(generateXMLloot(lootUITable))
  listUILootTable[id]:setId(id)
  listUILootTable[id]:setHeight(14*(1 + newLine))
end

function showLootFromTable()
  if valuesTable.lootList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.lootList:getFocusedChild():getId())

  if lootTable[selectedRow].id ~= nil then
    valuesTable.lootNameCheckbox:setChecked(false)
    valuesTable.lootId:setText(lootTable[selectedRow].id)
  elseif lootTable[selectedRow].name ~= nil then
    valuesTable.lootNameCheckbox:setChecked(true)
    valuesTable.lootName:setText(lootTable[selectedRow].name)
  end
  valuesTable.lootChance:setText(lootTable[selectedRow].chance)
  if lootTable[selectedRow].countmax ~= nil then
    valuesTable.lootCountmax:setText(lootTable[selectedRow].countmax)
    valuesTable.lootCountmaxCheckBox:setChecked(true)
  else
    valuesTable.lootCountmaxCheckBox:setChecked(false)
  end
  if lootTable[selectedRow].subtype ~= nil then
    valuesTable.lootSubtype:setOption(lootTable[selectedRow].subtype)
    valuesTable.lootSubtypeCheckBox:setChecked(true)
  else
    valuesTable.lootSubtypeCheckBox:setChecked(false)
  end
  if lootTable[selectedRow].actionid ~= nil then
    valuesTable.lootActionid:setText(lootTable[selectedRow].actionid)
    valuesTable.lootActionidCheckBox:setChecked(true)
  else
    valuesTable.lootActionidCheckBox:setChecked(false)
  end
  if lootTable[selectedRow].uniqueid ~= nil then
    valuesTable.lootUniqueid:setText(lootTable[selectedRow].uniqueid)
    valuesTable.lootUniqueidCheckBox:setChecked(true)
  else
    valuesTable.lootUniqueidCheckBox:setChecked(false)
  end
  if lootTable[selectedRow].text ~= nil then
    valuesTable.lootText:setText(lootTable[selectedRow].text)
    valuesTable.lootTextCheckBox:setChecked(true)
  else
    valuesTable.lootTextCheckBox:setChecked(false)
  end
  if lootTable[selectedRow].comment ~= nil then
    valuesTable.lootComment:setText(lootTable[selectedRow].comment)
    valuesTable.lootCommentCheckBox:setChecked(true)
  else
    valuesTable.lootCommentCheckBox:setChecked(false)
  end
end

function editLootFromTable()
  if valuesTable.lootList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.lootList:getFocusedChild():getId())

  lootTable[selectedRow] = getLootFromUI()

  local _, newLine = string.gsub(generateXMLloot(getLootFromUI()), '\n', '\n')

  listUILootTable[selectedRow]:setText(generateXMLloot(getLootFromUI()))
  listUILootTable[selectedRow]:setHeight(14*(1 + newLine))
end

function deleteLootFromTable()
  if valuesTable.lootList:getFocusedChild() == nil then
    return
  end

  local selectedRow = tonumber(valuesTable.lootList:getFocusedChild():getId())

  lootTable[selectedRow] = nil
  listUILootTable[selectedRow]:destroy()
  listUILootTable[selectedRow] = nil
end

function deleteAllLootFromTable()
  for _,child in pairs(valuesTable.lootList:getChildren()) do
    lootTable[tonumber(child:getId())] = nil
    listUILootTable[tonumber(child:getId())]:destroy()
    listUILootTable[tonumber(child:getId())] = nil
  end
end

-------------------------------------------------
--Generate full XML file-------------------------
-------------------------------------------------

function generateXMLFile(indentation)
  indentation = indentation or '\t'
  local fileXMLString = ''

  fileXMLString = fileXMLString..'<!-- Generated with OTClient monstermaker [0.9.0] -->'..'\n'
  fileXMLString = fileXMLString..'<?xml version="1.0" encoding="UTF-8"?>'

  --Monster  
  fileXMLString = fileXMLString..'\n'..'<monster name="'..valuesTable.name:getText()..'" nameDescription="'..valuesTable.nameDescription:getText()..
  '" race="'..valuesTable.race:getText()..'" experience="'..valuesTable.experience:getText()..'" skull="'..valuesTable.skull:getText()..
  '" speed="'..valuesTable.speed:getText()..'" manacost="'..valuesTable.manacost:getText()..'">'
  
  fileXMLString = fileXMLString..'\n'..indentation..'<health now="'..valuesTable.healthnow:getText()..'" max="'..valuesTable.healthmax:getText()..'"/>'
  
  local lookTypeFormat = nil
  if valuesTable.looktypeOption:getSelectedWidget():getText() == 'Look Type' then
    lookTypeFormat = 'type'
  elseif valuesTable.looktypeOption:getSelectedWidget():getText() == 'Look TypeEx' then
    lookTypeFormat = 'typeEx'
  end
  
  fileXMLString = fileXMLString..'\n'..indentation..'<look '..lookTypeFormat..'="'..valuesTable.looktype:getText()..'" head="'..valuesTable.head:getText()..
  '" body="'..valuesTable.body:getText()..'" legs="'..valuesTable.legs:getText()..'" feet="'..valuesTable.feet:getText()..'" addons="'..
  valuesTable.addons:getText()..'" mount="'..valuesTable.mount:getText()..'" corpse="'..valuesTable.corpse:getText()..'"/>'
  
  fileXMLString = fileXMLString..'\n'..indentation..'<targetchange interval="'..valuesTable.interval:getText()..'" chance="'..valuesTable.chance:getText()..'"/>'
  
  if valuesTable.strategyCheck:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..'<strategy attack="'..valuesTable.strategy:getValue()..'" defense="'..(100 - valuesTable.strategy:getValue())..'"/>'
  end

  --Flags
  fileXMLString = fileXMLString..'\n'..indentation..'<flags>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag summonable="'..booleantonumber(valuesTable.flagsSummonable:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag attackable="'..booleantonumber(valuesTable.flagsAttackable:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag hostile="'..booleantonumber(valuesTable.flagsHostile:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag illusionable="'..booleantonumber(valuesTable.flagsIllusionable:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag convinceable="'..booleantonumber(valuesTable.flagsConvinceable:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag pushable="'..booleantonumber(valuesTable.flagsPushable:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag canpushitems="'..booleantonumber(valuesTable.flagsCanpushitems:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag canpushcreatures="'..booleantonumber(valuesTable.flagsCanpushcreatures:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag targetdistance="'..valuesTable.flagsTargetdistance:getText()..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag staticattack="'..valuesTable.flagsStaticattack:getValue()..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag hidehealth="'..booleantonumber(valuesTable.flagsHidehealth:isChecked())..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag lightcolor="'..valuesTable.flagsLightcolor:getText()..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag lightlevel="'..valuesTable.flagsLightlevel:getText()..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<flag runonhealth="'..valuesTable.flagsRunonhealth:getValue()..'"/>'
  fileXMLString = fileXMLString..'\n'..indentation..'</flags>'

  --Script
  if valuesTable.scriptOnscript:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..'<script>'
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<event name="'..valuesTable.scriptAddscript:getText()..'"/>'
    fileXMLString = fileXMLString..'\n'..indentation..'</script>'
  end

  --Attacks
  if not table.empty(attacksTable) then
    fileXMLString = fileXMLString..'\n'..indentation..'<attacks>'
    for a,b in pairs(attacksTable) do
      fileXMLString = fileXMLString..'\n'..generateXMLattack(b, indentation, indentation..indentation)
    end
    fileXMLString = fileXMLString..'\n'..indentation..'</attacks>'
  end

  --Defenses
  if not table.empty(defensesTable) then
    fileXMLString = fileXMLString..'\n'..indentation..'<defenses armor="'..valuesTable.defensesArmor:getText()..'" defense="'..valuesTable.defensesDefense:getText()..'">'
    
    for a,b in pairs(defensesTable) do
      fileXMLString = fileXMLString..'\n'..generateXMLdefense(b, indentation, indentation..indentation)
    end

    fileXMLString = fileXMLString..'\n'..indentation..'</defenses>'
  else
    fileXMLString = fileXMLString..'\n'..indentation..'<defenses armor="'..valuesTable.defensesArmor:getText()..'" defense="'..valuesTable.defensesDefense:getText()..'"/>'
  end

  --Elements
  fileXMLString = fileXMLString..'\n'..indentation..'<elements>'
  if valuesTable.elementsHolyText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element holyPercent="'..valuesTable.elementsHolyText:getValue()..'"/>'
  end
  if valuesTable.elementsDeathText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element deathPercent="'..valuesTable.elementsDeathText:getValue()..'"/>'
  end
  if valuesTable.elementsIceText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element icePercent="'..valuesTable.elementsIceText:getValue()..'"/>'
  end
  if valuesTable.elementsFireText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element firePercent="'..valuesTable.elementsFireText:getValue()..'"/>'
  end
  if valuesTable.elementsEarthText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element earthPercent="'..valuesTable.elementsEarthText:getValue()..'"/>'
  end
  if valuesTable.elementsEnergyText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element energyPercent="'..valuesTable.elementsEnergyText:getValue()..'"/>'
  end
  if valuesTable.elementsPhysicalText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element physicalPercent="'..valuesTable.elementsPhysicalText:getValue()..'"/>'
  end
  if valuesTable.elementsLifedrainText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element lifedrainPercent="'..valuesTable.elementsLifedrainText:getValue()..'"/>'
  end
  if valuesTable.elementsDrownText:getValue() ~= 0 then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<element drownPercent="'..valuesTable.elementsDrownText:getValue()..'"/>'
  end
  fileXMLString = fileXMLString..'\n'..indentation..'</elements>'

  --Immunities
  fileXMLString = fileXMLString..'\n'..indentation..'<immunities>'
  if valuesTable.immunitiesHoly:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity holy="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity holy="0"/>'
  end
  if valuesTable.immunitiesDeath:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity death="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity death="0"/>'
  end
  if valuesTable.immunitiesIce:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity ice="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity ice="0"/>'
  end
  if valuesTable.immunitiesFire:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity fire="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity fire="0"/>'
  end
  if valuesTable.immunitiesEarth:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity earth="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity earth="0"/>'
  end
  if valuesTable.immunitiesEnergy:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity energy="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity energy="0"/>'
  end
  if valuesTable.immunitiesPhysical:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity physical="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity physical="0"/>'
  end
  if valuesTable.immunitiesLifedrain:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity lifedrain="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity lifedrain="0"/>'
  end
  if valuesTable.immunitiesDrown:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity drown="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity drown="0"/>'
  end
  if valuesTable.immunitiesParalyze:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity paralyze="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity paralyze="0"/>'
  end
  if valuesTable.immunitiesDrunk:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity drunk="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity drunk="0"/>'
  end
  if valuesTable.immunitiesInvisible:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity invisible="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity invisible="0"/>'
  end
  if valuesTable.immunitiesOutfit:isChecked() then
    fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity outfit="1"/>'
  --else
  --  fileXMLString = fileXMLString..'\n'..indentation..indentation..'<immunity outfit="0"/>'
  end
  fileXMLString = fileXMLString..'\n'..indentation..'</immunities>'

  --Summons
  if not table.empty(summonsTable) then
    fileXMLString = fileXMLString..'\n'..indentation..'<summons maxSummons="'..valuesTable.summonsMaxSummons:getText()..'">'
    for a,b in pairs(summonsTable) do
      fileXMLString = fileXMLString..'\n'..generateXMLsummon(b, indentation, indentation..indentation)
    end
    fileXMLString = fileXMLString..'\n'..indentation..'</summons>'
  end

  --Voices
  if not table.empty(voicesTable) then
    fileXMLString = fileXMLString..'\n'..indentation..'<voices interval="'..valuesTable.voicesInterval:getText()..'" chance="'..valuesTable.voicesChance:getText()..'">'
    for a,b in pairs(voicesTable) do
      fileXMLString = fileXMLString..'\n'..generateXMLvoice(b, indentation, indentation..indentation)
    end
    fileXMLString = fileXMLString..'\n'..indentation..'</voices>'
  end

  --Loot
  if not table.empty(lootTable) then
    fileXMLString = fileXMLString..'\n'..indentation..'<loot>'
    for a,b in pairs(lootTable) do
      fileXMLString = fileXMLString..'\n'..generateXMLloot(b, indentation, indentation..indentation)
    end
    fileXMLString = fileXMLString..'\n'..indentation..'</loot>'
  end

  fileXMLString = fileXMLString..'\n'..'</monster>'

  return fileXMLString
end

function saveToXML()
  local saveName = modules.tool_monstermaker.valuesTable.ioActualname:getText()
  local saveFile = io.open(g_resources.getRealPath()..'tool_monstermaker/creatures/'..saveName, "r")
  local warningWindow = nil

  if saveFile == nil then
    local creatureXML = io.open(g_resources.getRealPath()..'tool_monstermaker/creatures/'..saveName, "w")
    if creatureXML then
      creatureXML:write(generateXMLFile())
      creatureXML:close()
      addCreatureFilesToList()
    end

    local toMonsterXML = io.open(g_resources.getRealPath()..'tool_monstermaker/creatures/'..'monsters_'..saveName, "w")
    if toMonsterXML then
      toMonsterXML:write('<monster name="'..valuesTable.name:getText().." file="..saveName..'" />')
      toMonsterXML:close()
    end
  else
    saveFile:close()

    local yesCallback = function()
      local creatureXML = io.open(g_resources.getRealPath()..'tool_monstermaker/creatures/'..saveName, "w")
      if creatureXML then
        creatureXML:write(generateXMLFile())
        creatureXML:close()
        addCreatureFilesToList()
      end

      local toMonsterXML = io.open(g_resources.getRealPath()..'tool_monstermaker/creatures/'..'monsters_'..saveName, "w")
      if toMonsterXML then
        toMonsterXML:write('<monster name="'..valuesTable.name:getText().." file="..saveName..'" />')
        toMonsterXML:close()
      end

      warningWindow:destroy()
      warningWindow = nil
    end

    local noCallback = function()
      warningWindow:destroy()
      warningWindow = nil
    end

    if not warningWindow then
      warningWindow = displayGeneralBox(tr('Overwrite file'), tr('Do you want overwrite '..saveName..' file?\nIf you choose "yes", you will lost previous file!'), {
        { text=tr('Yes'), callback = yesCallback},
        { text=tr('No'), callback = noCallback},
      anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
    end
  end
end

local creatureFilesLoadList = {}

function addCreatureFilesToList()
  local creatureFiles = g_resources.listDirectoryFiles('/tool_monstermaker/creatures')

  for c,d in pairs(creatureFiles) do
    if string.find(d, 'monsters_', 0) then
      creatureFiles[c] = nil
    end
  end

  for a,b in pairs(creatureFilesLoadList) do
    creatureFilesLoadList[a]:destroy()
    creatureFilesLoadList[a] = nil
  end

  for k,v in pairs(creatureFiles) do
    creatureFilesLoadList[k] = g_ui.createWidget('ChoiceListLabel', valuesTable.ioList)
    creatureFilesLoadList[k]:setText(v)
    creatureFilesLoadList[k]:setId(v)
  end
end

function clearAllOptions()
  --Monster
  valuesTable.name:setText('')
  valuesTable.nameDescription:setText('')
  valuesTable.race:setOption('blood')
  valuesTable.experience:setText(1000)
  valuesTable.skull:setOption('none')
  valuesTable.speed:setText(100)
  valuesTable.manacost:setText(0)
  valuesTable.healthnow:setText(500)
  valuesTable.healthmax:setText(500)
  valuesTable.looktypeOption:selectWidget(valuesTable.looktypeCheckBox)
  valuesTable.looktype:setText(1)
  valuesTable.head:setText(0)
  valuesTable.body:setText(0)
  valuesTable.legs:setText(0)
  valuesTable.feet:setText(0)
  valuesTable.addons:setText(0)
  valuesTable.mount:setText(0)
  valuesTable.corpse:setText(1)
  valuesTable.interval:setText(2000)
  valuesTable.chance:setText(5)
  valuesTable.strategyCheck:setChecked(false)
  valuesTable.strategy:setValue(50)

  --Flags
  valuesTable.flagsSummonable:setChecked(false)
  valuesTable.flagsAttackable:setChecked(false)
  valuesTable.flagsHostile:setChecked(false)
  valuesTable.flagsIllusionable:setChecked(false)
  valuesTable.flagsConvinceable:setChecked(false)
  valuesTable.flagsPushable:setChecked(false)
  valuesTable.flagsCanpushitems:setChecked(false)
  valuesTable.flagsCanpushcreatures:setChecked(false)
  valuesTable.flagsTargetdistance:setText(1)
  valuesTable.flagsStaticattack:setValue(90)
  valuesTable.flagsHidehealth:setChecked(false)
  valuesTable.flagsLightcolor:setText(0)
  valuesTable.flagsLightlevel:setText(1)
  valuesTable.flagsRunonhealth:setValue(5)

  --Script
  valuesTable.scriptOnscript:setChecked(false)
  valuesTable.scriptAddscript:setText('')

  --Attacks
  deleteAllAttackFromTable()
  valuesTable.attacksNametype:setOption('melee')
  valuesTable.attacksNameelemental:setOption('physical')
  valuesTable.attacksNameconditions:setOption('physicalcondition')
  valuesTable.attacksNamefields:setOption('firefield')
  valuesTable.attacksNamerunes:setOption('sudden death')
  valuesTable.attacksNamespells:setOption('great energy beam')
  valuesTable.attacksNameother:setText('')
  valuesTable.attacksMin:setText(-5)
  valuesTable.attacksMax:setText(-10)
  valuesTable.attacksSkillCheckBox:setChecked(false)
  valuesTable.attacksSkillText:setText(1)
  valuesTable.attacksAttackText:setText(1)
  valuesTable.attacksInterval:setText(1000)
  valuesTable.attacksChance:setText(1)
  valuesTable.attacksLengthCheckBox:setChecked(false)
  valuesTable.attacksLength:setText(0)
  valuesTable.attacksSpreadCheckBox:setChecked(false)
  valuesTable.attacksSpread:setText(1)
  valuesTable.attacksRadiusCheckBox:setChecked(false)
  valuesTable.attacksRadius:setText(1)
  valuesTable.attacksPoisonCheckBox:setChecked(false)
  valuesTable.attacksPoison:setText(1)
  valuesTable.attacksTargetCheckBox:setChecked(false)
  valuesTable.attacksRange:setText(1)
  valuesTable.attacksAreaEffectCheckBox:setChecked(false)
  valuesTable.attacksAreaEffectComboBox:setOption('redspark')
  valuesTable.attacksShootEffectCheckBox:setChecked(false)
  valuesTable.attacksShootEffectComboBox:setOption('spear')

  --Defences
  deleteAllDefenseFromTable()
  valuesTable.defensesArmor:setText(1)
  valuesTable.defensesDefense:setText(1)
  valuesTable.defensesName:setOption('healing')
  valuesTable.defensesInterval:setText(1000)
  valuesTable.defensesChance:setText(1)
  valuesTable.defensesMin:setText(1)
  valuesTable.defensesMax:setText(1)
  valuesTable.defensesIsRadius:setChecked(false)
  valuesTable.defensesRadius:setText(1)
  valuesTable.defensesAreaEffect:setOption('redspark')
  valuesTable.defensesDuration:setText(4000)
  valuesTable.defensesSpeedchange:setText(300)

  --Elements
  valuesTable.elementsHolyText:setText(0)
  valuesTable.elementsHolyScrollbar:setValue(0)
  valuesTable.elementsDeathText:setText(0)
  valuesTable.elementsDeathScrollbar:setValue(0)
  valuesTable.elementsIceText:setText(0)
  valuesTable.elementsIceScrollbar:setValue(0)
  valuesTable.elementsFireText:setText(0)
  valuesTable.elementsFireScrollbar:setValue(0)
  valuesTable.elementsEarthText:setText(0)
  valuesTable.elementsEarthScrollbar:setValue(0)
  valuesTable.elementsEnergyText:setText(0)
  valuesTable.elementsEnergyScrollbar:setValue(0)
  valuesTable.elementsPhysicalText:setText(0)
  valuesTable.elementsPhysicalScrollbar:setValue(0)
  valuesTable.elementsLifedrainText:setText(0)
  valuesTable.elementsLifedrainScrollbar:setValue(0)
  valuesTable.elementsDrownText:setText(0)
  valuesTable.elementsDrownScrollbar:setValue(0)

  --Immunities
  valuesTable.immunitiesHoly:setChecked(false)
  valuesTable.immunitiesDeath:setChecked(false)
  valuesTable.immunitiesIce:setChecked(false)
  valuesTable.immunitiesFire:setChecked(false)
  valuesTable.immunitiesEarth:setChecked(false)
  valuesTable.immunitiesEnergy:setChecked(false)
  valuesTable.immunitiesPhysical:setChecked(false)
  valuesTable.immunitiesLifedrain:setChecked(false)
  valuesTable.immunitiesDrown:setChecked(false)
  valuesTable.immunitiesParalyze:setChecked(false)
  valuesTable.immunitiesDrunk:setChecked(false)
  valuesTable.immunitiesInvisible:setChecked(false)
  valuesTable.immunitiesOutfit:setChecked(false)

  --Summons
  deleteAllSummonFromTable()
  valuesTable.summonsMaxSummons:setText(1)
  valuesTable.summonsName:setText('')
  valuesTable.summonsInterval:setText(1000)
  valuesTable.summonsChance:setText(1)
  valuesTable.summonsMax:setText(1)

  --Voices
  deleteAllVoiceFromTable()
  valuesTable.voicesInterval:setText(1000)
  valuesTable.voicesChance:setText(1)
  valuesTable.voicesSentence:setText('')
  valuesTable.voicesYell:setChecked(false)

  --Loot
  deleteAllLootFromTable()
  valuesTable.lootId:setText(1)
  valuesTable.lootNameCheckbox:setChecked(false)
  valuesTable.lootName:setText('')
  valuesTable.lootChance:setText(1)
  valuesTable.lootCountmaxCheckBox:setChecked(false)
  valuesTable.lootCountmax:setText(1)
  valuesTable.lootSubtypeCheckBox:setChecked(false)
  valuesTable.lootSubtype:setOption('water')
  valuesTable.lootActionidCheckBox:setChecked(false)
  valuesTable.lootActionid:setText(1)
  valuesTable.lootUniqueidCheckBox:setChecked(false)
  valuesTable.lootUniqueid:setText(1)
  valuesTable.lootTextCheckBox:setChecked(false)
  valuesTable.lootText:setText('')
  valuesTable.lootCommentCheckBox:setChecked(false)
  valuesTable.lootComment:setText('')

  --I/O
  valuesTable.ioFilename:setText('')
  valuesTable.ioOwnNameCheckBox:setChecked(false)
end

local tableWithLoadingData = {}

function getTableWithLoadingData()
  return tableWithLoadingData
end

function clearTableWithLoadingData()
  tableWithLoadingData = {}
end

function loadDataFromXMLToTable(sector, variableName, variableValue)
  if sector == 'monster' then
    if variableName == 'name' then
      valuesTable.name:setText(variableValue)
    elseif variableName == 'nameDescription' then
      valuesTable.nameDescription:setText(variableValue)
    elseif variableName == 'race' then
      valuesTable.race:setOption(variableValue)
    elseif variableName == 'experience' then
      valuesTable.experience:setText(variableValue)
    elseif variableName == 'skull' then
      valuesTable.skull:setOption(variableValue)
    elseif variableName == 'speed' then
      valuesTable.speed:setText(variableValue)
    elseif variableName == 'manacost' then
      valuesTable.manacost:setText(variableValue)
    end
  elseif sector == 'health' then
    if variableName == 'now' then
      valuesTable.healthnow:setText(variableValue)
    elseif variableName == 'max' then
      valuesTable.healthmax:setText(variableValue)
    end
  elseif sector == 'look' then
    if variableName == 'type' then
      valuesTable.looktypeOption:selectWidget(valuesTable.looktypeCheckBox)
      valuesTable.looktype:setText(variableValue)
    elseif variableName == 'typeEx' then
      valuesTable.looktypeOption:selectWidget(valuesTable.looktypeExCheckBox)
      valuesTable.looktype:setText(variableValue)
    elseif variableName == 'head' then
      valuesTable.head:setText(variableValue)
    elseif variableName == 'body' then
      valuesTable.body:setText(variableValue)
    elseif variableName == 'legs' then
      valuesTable.legs:setText(variableValue)
    elseif variableName == 'feet' then
      valuesTable.feet:setText(variableValue)
    elseif variableName == 'addons' then
      valuesTable.addons:setText(variableValue)
    elseif variableName == 'mount' then
      valuesTable.mount:setText(variableValue)
    elseif variableName == 'corpse' then
      valuesTable.corpse:setText(variableValue)
    end
  elseif sector == 'targetchange' then
    if variableName == 'interval' then
      valuesTable.interval:setText(variableValue)
    elseif variableName == 'chance' then
      valuesTable.chance:setText(variableValue)
    end
  elseif sector == 'strategy' then
    valuesTable.strategyCheck:setChecked(true)
    if variableName == 'attack' then
      valuesTable.strategy:setValue(tonumber(variableValue))
    --elseif variableName == 'defense' then
    --  Ignore
    --  valuesTable.strategy:setValue(100 - tonumber(variableValue))
    end
  elseif sector == 'flag' then
    if variableName == 'summonable' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsSummonable:setChecked(true)
      else
        valuesTable.flagsSummonable:setChecked(false)
      end
    elseif variableName == 'attackable' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsAttackable:setChecked(true)
      else
        valuesTable.flagsAttackable:setChecked(false)
      end
    elseif variableName == 'hostile' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsHostile:setChecked(true)
      else
        valuesTable.flagsHostile:setChecked(false)
      end
    elseif variableName == 'illusionable' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsIllusionable:setChecked(true)
      else
        valuesTable.flagsIllusionable:setChecked(false)
      end
    elseif variableName == 'convinceable' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsConvinceable:setChecked(true)
      else
        valuesTable.flagsConvinceable:setChecked(false)
      end
    elseif variableName == 'pushable' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsPushable:setChecked(true)
      else
        valuesTable.flagsPushable:setChecked(false)
      end
    elseif variableName == 'canpushitems' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsCanpushitems:setChecked(true)
      else
        valuesTable.flagsCanpushitems:setChecked(false)
      end
    elseif variableName == 'canpushcreatures' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsCanpushcreatures:setChecked(true)
      else
        valuesTable.flagsCanpushcreatures:setChecked(false)
      end
    elseif variableName == 'targetdistance' then
      valuesTable.flagsTargetdistance:setText(variableValue)
    elseif variableName == 'staticattack' then
      valuesTable.flagsStaticattack:setValue(tonumber(variableValue))
    elseif variableName == 'hidehealth' then
      if numbertoboolean(tonumber(variableValue)) then
        valuesTable.flagsHidehealth:setChecked(true)
      else
        valuesTable.flagsHidehealth:setChecked(false)
      end
    elseif variableName == 'lightcolor' then
      valuesTable.flagsLightcolor:setText(variableValue)
    elseif variableName == 'lightlevel' then
      valuesTable.flagsLightlevel:setText(variableValue)
    elseif variableName == 'runonhealth' then
      valuesTable.flagsRunonhealth:setValue(tonumber(variableValue))
    end
  elseif sector == 'event' then
    if variableName == 'name' then
      valuesTable.scriptOnscript:setChecked(true)
      valuesTable.scriptAddscript:setText(variableValue)
    end
  elseif sector == 'attack' then
    if variableName == 'name' then
      tableWithLoadingData.name = variableValue
    elseif variableName == 'min' then
      tableWithLoadingData.min = tonumber(variableValue)
    elseif variableName == 'max' then
      tableWithLoadingData.max = tonumber(variableValue)
    elseif variableName == 'skill' then
      tableWithLoadingData.skill = tonumber(variableValue)
    elseif variableName == 'attack' then
      tableWithLoadingData.attack = tonumber(variableValue)
    elseif variableName == 'interval' then
      tableWithLoadingData.interval = tonumber(variableValue)
    elseif variableName == 'chance' then
      tableWithLoadingData.chance = tonumber(variableValue)
    elseif variableName == 'length' then
      tableWithLoadingData.length = tonumber(variableValue)
    elseif variableName == 'spread' then
      tableWithLoadingData.spread = tonumber(variableValue)
    elseif variableName == 'radius' then
      tableWithLoadingData.radius = tonumber(variableValue)
    elseif variableName == 'poison' then
      tableWithLoadingData.poison = tonumber(variableValue)
    elseif variableName == 'target' then
      tableWithLoadingData.target = tonumber(variableValue)
    elseif variableName == 'range' then
      tableWithLoadingData.range = tonumber(variableValue)
    end
  elseif sector == 'defenses' then
    if variableName == 'armor' then
      valuesTable.defensesArmor:setText(variableValue)
    elseif variableName == 'defense' then
      valuesTable.defensesDefense:setText(variableValue)
    end
  elseif sector == 'defense' then
    if variableName == 'name' then
      tableWithLoadingData.name = variableValue
    elseif variableName == 'interval' then
      tableWithLoadingData.interval = tonumber(variableValue)
    elseif variableName == 'chance' then
      tableWithLoadingData.chance = tonumber(variableValue)
    elseif variableName == 'min' then
      tableWithLoadingData.min = tonumber(variableValue)
    elseif variableName == 'max' then
      tableWithLoadingData.max = tonumber(variableValue)
    elseif variableName == 'radius' then
      tableWithLoadingData.radius = tonumber(variableValue)
    elseif variableName == 'duration' then
      tableWithLoadingData.duration = tonumber(variableValue)
    elseif variableName == 'speedchange' then
      tableWithLoadingData.speedChange = tonumber(variableValue)
    end
  elseif sector == 'element' then
    if variableName == 'holyPercent' then
      valuesTable.elementsHolyScrollbar:setValue(tonumber(variableValue))
    elseif variableName == 'deathPercent' then
      valuesTable.elementsDeathScrollbar:setValue(tonumber(variableValue))
    elseif variableName == 'icePercent' then
      valuesTable.elementsIceScrollbar:setValue(tonumber(variableValue))
    elseif variableName == 'firePercent' then
      valuesTable.elementsFireScrollbar:setValue(tonumber(variableValue))
    elseif variableName == 'earthPercent' then
      valuesTable.elementsEarthScrollbar:setValue(tonumber(variableValue))
    elseif variableName == 'energyPercent' then
      valuesTable.elementsEnergyScrollbar:setValue(tonumber(variableValue))
    elseif variableName == 'physicalPercent' then
      valuesTable.elementsPhysicalScrollbar:setValue(tonumber(variableValue))
    elseif variableName == 'lifedrainPercent' then
      valuesTable.elementsLifedrainScrollbar:setValue(tonumber(variableValue))
    elseif variableName == 'drownPercent' then
      valuesTable.elementsDrownScrollbar:setValue(tonumber(variableValue))
    end
  elseif sector == 'immunity' then
    if variableName == 'holy' then
      valuesTable.immunitiesHoly:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'death' then
      valuesTable.immunitiesDeath:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'ice' then
      valuesTable.immunitiesIce:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'fire' then
      valuesTable.immunitiesFire:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'earth' then
      valuesTable.immunitiesEarth:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'energy' then
      valuesTable.immunitiesEnergy:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'physical' then
      valuesTable.immunitiesPhysical:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'lifedrain' then
      valuesTable.immunitiesLifedrain:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'drown' then
      valuesTable.immunitiesDrown:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'paralyze' then
      valuesTable.immunitiesParalyze:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'drunk' then
      valuesTable.immunitiesDrunk:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'invisible' then
      valuesTable.immunitiesInvisible:setChecked(numbertoboolean(tonumber(variableValue)))
    elseif variableName == 'outfit' then
      valuesTable.immunitiesOutfit:setChecked(numbertoboolean(tonumber(variableValue)))
    end
  elseif sector == 'summons' then
    if variableName == 'maxSummons' then
      valuesTable.summonsMaxSummons:setText(variableValue)
    end
  elseif sector == 'summon' then
    if variableName == 'name' then
      tableWithLoadingData.name = variableValue
    elseif variableName == 'interval' then
      tableWithLoadingData.interval = tonumber(variableValue)
    elseif variableName == 'chance' then
      tableWithLoadingData.chance = tonumber(variableValue)
    elseif variableName == 'max' then
      tableWithLoadingData.max = tonumber(variableValue)
    end
  elseif sector == 'voices' then
    if variableName == 'interval' then
      valuesTable.voicesInterval:setText(variableValue)
    elseif variableName == 'chance' then
      valuesTable.voicesChance:setText(variableValue)
    end
  elseif sector == 'voice' then
    if variableName == 'sentence' then
      tableWithLoadingData.voicesSentence = variableValue
    elseif variableName == 'yell' then
      tableWithLoadingData.voicesYell = numbertoboolean(tonumber(variableValue))
    end
  elseif sector == 'item' then
    if variableName == 'id' then
      tableWithLoadingData.id = tonumber(variableValue)
    elseif variableName == 'name' then
      tableWithLoadingData.name = variableValue
    elseif variableName == 'countmax' then
      tableWithLoadingData.countmax = tonumber(variableValue)
    elseif variableName == 'subtype' then
      tableWithLoadingData.subtype = translateLootSubtypeIdToText(tonumber(variableValue))
    elseif variableName == 'actionId' then
      tableWithLoadingData.actionid = tonumber(variableValue)
    elseif variableName == 'uniqueId' then
      tableWithLoadingData.uniqueid = tonumber(variableValue)
    elseif variableName == 'text' then
      tableWithLoadingData.text = variableValue
    elseif variableName == 'chance' then
      tableWithLoadingData.chance = tonumber(variableValue)
    end
  elseif sector == 'attribute' then
    if variableName == 'key' then
      if variableValue == 'areaEffect' then
        tableWithLoadingData.areaEffect = ' '
      elseif variableValue == 'shootEffect' then
        tableWithLoadingData.shootEffect = ' '
      end
    elseif variableName == 'value' then
      if tableWithLoadingData.areaEffect == ' ' then
        tableWithLoadingData.areaEffect = variableValue
      elseif tableWithLoadingData.shootEffect == ' ' then
        tableWithLoadingData.shootEffect = variableValue
      end
    end
  end
end

function loadFromXML()
  if valuesTable.ioList:getFocusedChild() == nil then
    return
  end

  --clear all changes in editor
  clearAllOptions()

  local selectedRow = valuesTable.ioList:getFocusedChild():getId()

  local xml = io.open(g_resources.getRealPath()..'tool_monstermaker/creatures/'..selectedRow, "rb")
  local itemsXMLString = {}

  for line in xml:lines() do
    itemsXMLString[#itemsXMLString + 1] = string.gsub(line, '\t', '')
  end

  xml:close()

  local parseSectors = {}
  for a,b in ipairs(itemsXMLString) do
    local startSign = string.find(b, '<')
    if startSign then
      if string.sub(b, startSign + 1, startSign + 1) == '/' then
        local endSign = string.find(b, '>', startSign + 1)
        if endSign then
          if parseSectors[#parseSectors] == string.sub(b, startSign + 2, endSign - 1) then
            if parseSectors[#parseSectors] == 'attack' then
              addToUIAndTable(getTableWithLoadingData())
              clearTableWithLoadingData()
            elseif parseSectors[#parseSectors] == 'defense' then
              addDefenseToUIAndTable(getTableWithLoadingData())
              clearTableWithLoadingData()
            elseif parseSectors[#parseSectors] == 'summon' then
              addSummonToUIAndTable(getTableWithLoadingData())
              clearTableWithLoadingData()
            elseif parseSectors[#parseSectors] == 'voice' then
              addVoiceToUIAndTable(getTableWithLoadingData())
              clearTableWithLoadingData()
            elseif parseSectors[#parseSectors] == 'item' then
              addLootToUIAndTable(getTableWithLoadingData())
              clearTableWithLoadingData()
            end
            parseSectors[#parseSectors] = nil
          end
        end
      elseif string.sub(b, startSign + 1, startSign + 1) == '?' then
        --ignore
      elseif string.sub(b, startSign + 1, startSign + 1) == '!' then
        --ignore
      else
        local nextSign = string.find(b, ' ', startSign + 1)
        local endSign = string.find(b, '>', startSign + 1)
        if nextSign and nextSign < endSign then
          parseSectors[#parseSectors + 1] = string.sub(b, startSign + 1, string.find(b, ' ', startSign) - 1)
          local isStartComment = string.find(b, '%<%!%-%-')
          local isEndComment = string.find(b, '%-%-%>')
          local commentText = ''
          local prePreparedText = ''
          if isStartComment and parseSectors[#parseSectors] == 'item' then
            prePreparedText = string.sub(b, string.find(b, ' ', startSign), isStartComment-1)
            tableWithLoadingData.comment = string.sub(b, isStartComment + 4, isEndComment - 1)
          else
            prePreparedText = string.sub(b, string.find(b, ' ', startSign), string.len(b))
          end
          local preparedText = ''
          local startNewString = false
          for i=1, #prePreparedText do
            if prePreparedText:sub(i,i) == '"' then
              if not startNewString then
                startNewString = true
                preparedText = preparedText..prePreparedText:sub(i,i)
              else
                startNewString = false
                preparedText = preparedText..prePreparedText:sub(i,i)
              end
            elseif prePreparedText:sub(i,i) == ' ' and not startNewString then
              --ignore
            else
              preparedText = preparedText..prePreparedText:sub(i,i)
            end
          end
          while preparedText ~= '' do
            local findNextValue = string.find(preparedText, '=')
            if findNextValue then
              local variableName = string.sub(preparedText, 0, findNextValue - 1)
              local firstQuote = string.find(preparedText, '"')
              local secondQuote = string.find(preparedText, '"', firstQuote + 1)
              local variableValue = string.sub(preparedText, firstQuote + 1, secondQuote - 1)

              loadDataFromXMLToTable(parseSectors[#parseSectors], variableName, variableValue)

              preparedText = string.sub(preparedText, secondQuote + 1, string.len(preparedText))
            elseif string.find(preparedText, '/>') then
              if parseSectors[#parseSectors] == 'attack' then
                addToUIAndTable(getTableWithLoadingData())
                clearTableWithLoadingData()
              elseif parseSectors[#parseSectors] == 'defense' then
                addDefenseToUIAndTable(getTableWithLoadingData())
                clearTableWithLoadingData()
              elseif parseSectors[#parseSectors] == 'summon' then
                addSummonToUIAndTable(getTableWithLoadingData())
                clearTableWithLoadingData()
              elseif parseSectors[#parseSectors] == 'voice' then
                addVoiceToUIAndTable(getTableWithLoadingData())
                clearTableWithLoadingData()
              elseif parseSectors[#parseSectors] == 'item' then
                addLootToUIAndTable(getTableWithLoadingData())
                clearTableWithLoadingData()
              end
              parseSectors[#parseSectors] = nil
              break
            elseif string.find(preparedText, '>') then
              break
            else
              break
            end
          end
        else
          if endSign then
            parseSectors[#parseSectors + 1] = string.sub(b, startSign + 1, endSign - 1)
          end
        end
      end
    end
  end
end

function clearAllOptionsButton()
  local warningWindow = nil

  local yesCallback = function()
    clearAllOptions()

    warningWindow:destroy()
    warningWindow = nil
  end

  local noCallback = function()
    warningWindow:destroy()
    warningWindow = nil
  end

  if not warningWindow then
    warningWindow = displayGeneralBox(tr('Clear All'), tr('Do you want clear all changes?\nIf you choose "yes", you will lost all changes!'), {
      { text=tr('Yes'), callback = yesCallback},
      { text=tr('No'), callback = noCallback},
    anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
  end
end

function deleteFileXML()
  if valuesTable.ioList:getFocusedChild() == nil then
    return
  end
  local warningWindow = nil

  local deleteFileName = valuesTable.ioList:getFocusedChild():getText()

  local yesCallback = function()
    if g_resources.fileExists('/tool_monstermaker/creatures/'..deleteFileName) then
      os.remove(g_resources.getRealPath()..'tool_monstermaker/creatures/'..deleteFileName)
    end
    if g_resources.fileExists('/tool_monstermaker/creatures/'..'monsters_'..deleteFileName) then
      os.remove(g_resources.getRealPath()..'tool_monstermaker/creatures/'..'monsters_'..deleteFileName)
    end

    addCreatureFilesToList()

    warningWindow:destroy()
    warningWindow = nil
  end

  local noCallback = function()
    warningWindow:destroy()
    warningWindow = nil
  end

  if not warningWindow then
    warningWindow = displayGeneralBox(tr('Delete file'), tr('Do you want to delete '..' file?\nIf you choose "yes", you will lost this file!'), {
      { text=tr('Yes'), callback = yesCallback},
      { text=tr('No'), callback = noCallback},
    anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
  end
end