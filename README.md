# GmodStalkerInventory

## Stamina
Inventory has its own realization of endurance depending on the weight of inventory items
> Config file: `stamina\sh_stamina.lua`

## Content addons
* [Stalker Inventory icons/materials](https://steamcommunity.com/sharedfiles/filedetails/?id=1783179338 "Default icons from Stalker")
* [NGNL | S.T.A.L.K.E.R. | Weapons Icons](https://steamcommunity.com/sharedfiles/filedetails/?id=2138131080 "Icons for TFA weapons")

## TFA Compatibility
In order for the reloading of weapons using ammunition from the inventory to work, you need to add a hook `TFA_PostCompleteReload` into -> `lua\weapons\tfa_gun_base\shared.lua`
```lua
function SWEP:CompleteReload()
	if hook.Run("TFA_CompleteReload", self) then return end

	local maxclip = self:GetPrimaryClipSizeForReload(true)
	local curclip = self:Clip1()
	local amounttoreplace = math.min(maxclip - curclip, self:Ammo1())
	self:TakePrimaryAmmo(amounttoreplace * -1)
	self:TakePrimaryAmmo(amounttoreplace, true)
	self:SetJammed(false)

	hook.Run("TFA_PostCompleteReload", self)
end
```

## Available hooks
> Note: All hooks are called only on the server side

| Name | Arguments | Description |
| ------ | ------ | ------ |
| OnItemSpawned | (self) | Called at any spawn of the item (QMenu, drop, etc.) |
| Inventory:PrePlayerGiveItem |  (ply, itemId, amount, data, fromSlot) | Before adding an item to the player's inventory, return true to prevent |
| Inventory:PostPlayerGiveItem |  (ply, itemId, amount, data, fromSlot) | After adding an item to the player's inventory |
| Inventory:PrePlayerRemoveItem |  (ply, itemId, amount) | Before removing an item from a player's inventory, return true to prevent |
| Inventory:PostPlayerRemoveItem |  (ply, itemId, amount) | After removing an item from a player's inventory |
| Inventory:PreInventoryRemoveItem |  (ent, itemId, amount, data) | Before removing an item from the inventory of containers, return true to prevent |
| Inventory:PostInventoryRemoveItem |  (ent, itemId, amount, data) | After removing an item from the inventory of containers |
| Inventory:PreInventoryAddItem |  (ent, itemId, amount, data) | Before adding an item from the inventory of containers, return true to prevent |
| Inventory:PostInventoryAddItem |  (ent, itemId, amount, data) | After adding an item from the inventory of containers |
| Inventory:PostPlayerEquipAmmunation |  (ply, itemId, data, slot) | When the player equips armor or weapons |
| Inventory:PostPlayerEquipQuickSlot |  (ply, itemId, amount, slot) | When a player puts something in a quick slot |
| Inventory:PostPlayerEquipArtSlot |  (ply, itemId, data, slot) | When the player equips an artifact |
| Inventory:PostPlayerUnEquipAmmunation |  (ply, itemId, data, slot) | When the player removes armor or weapons from the slot |
| Inventory:PostPlayerUnEquipQuickSlot |  (ply, itemId, amount, slot) | When a player removes something from a quick slot |
| Inventory:PostPlayerUnEquipArtSlot |  (ply, itemId, data, slot) | When a player removes an artifact from the slot |
| Inventory:PostPlayerEquipWeapon |  (ply, itemId, data, slot) | When a player equips a weapon |
| Inventory:PostPlayerEquipHelmet |  (ply, itemId, data, slot) | When a player equips a helmet |
| Inventory:PostPlayerEquipArmor |  (ply, itemId, data, slot) | When a player equips a armor |
| Inventory:PostPlayerEquipDevice |  (ply, itemId, data, slot) | When a player puts something in the device slot |
| Inventory:PostPlayerUnEquipWeapon |  (ply, itemId, data, slot) | When a player removes a weapon from slot |
| Inventory:PostPlayerUnEquipHelmet |  (ply, itemId, data, slot) | When a player removes a helmet from slot |
| Inventory:PostPlayerUnEquipArmor |  (ply, itemId, data, slot) | When a player removes a armor from slot |
| Inventory:PostPlayerUnEquipDevice |  (ply, itemId, data, slot) | When a player removes a device from slot |

## Items config
Function for registering new items
* id - unique item id
* itemTable - table with item characteristics
```
function Inventory:RegisterItem(id, itemTable)
```
| Key | Type | Description | Default |
| ------ | ------ | ------ | ------ |
| Name | String | Item title | 	id	
| Desc | String | Item description | 			
| Model | String | Item world model | 		
| Skin | Int | Item world model skin | 0			
| Weight | Int | Item weight in inventory | 0.1	
| DefaultAmount | Int | Standard number of items in a stack when spawning (Mainly used for spawning with ammopacks) | 1
| Category | String | The category to which the subject belongs, categories are created in the config |	Other	
| SizeX | Int | The size of the item in the inventory by X is a multiple of the grid value in the config (May not be a multiple) | 1			
| SizeY | Int | The size of the item in the inventory by Y is a multiple of the grid value in the config (May not be a multiple) | 1			
| IconMat | String | Item icon in inventory | icons/items/error.png	
| IconColor | Color | The color of the icon in the inventory (Most likely it does not need to be used) | nil		
| EffectsDesc | Table | Item effects description [table](#EffectsDesc) | nil
| Usable | Bool | Can the item be used as a consumable | nil			
| DeleteOnUse | Bool | Should the item be removed after use | true	
| Droppable | Bool | Can an item be dropped by a player | true		
| CanStuck | Bool | Can an item stack up | nil	
| IsWeapon | Bool | Is the item a weapon | nil		
| IsArtifact | Bool | Is the item a artifact | nil	
| IsQuest | Bool | Is the item a quest (not used) | nil		
| IsMutant | Bool | Is the item a mutant part (not used) | nil		
| IsDevice | Bool | Is the item a device | nil		
| IsArmor | Bool | Is the item a armor | nil		
| IsHelmet | Bool | Is the item a helmet | nil		
| IsAmmo | Bool | Is the item a ammo | nil			
| Weapon | String | The class of the weapon used (if the item is weapon) | nil			
| ArmorModel | String | Armor model (if the item is armor) | nil		
| Art | String |  The class of the artifact used (if the item is a artifact) (not used) | nil
| ArmorTable | Table | Table of armor resistances [table](#ArmorTable) | nil		
| HelmetTable | Table | Table of helmet resistances [table](#HelmetTable) | nil	
| Ammo | String | Type of ammo (if the item is ammo) | nil			
| BasePrice | Int | The base price of the item on the basis of which the price is calculated taking into account the margins of merchants | 1 
| OnPlayerUse | Function | (ply) | nil		
| OnPlayerGive | Function | (ply) | nil		
| OnArtifactEquip | Function | (ply) | nil	
| OnArtifactUnEquip | Function | (ply) | nil	
| OnArmorEquip | Function | (ply) | nil		
| OnArmorUnEquip | Function | (ply) | nil		
| OnHelmetEquip | Function | (ply) | nil		
| OnHelmetUnEquip | Function | (ply) | nil	
| OnQuickSlotEquip | Function | (ply) | nil	
| OnQuickSlotUnEquip | Function | (ply) | nil
| OnPlayerDeath | Function | (victim, inflictor, attacker) | nil		
| OnRemoved | Function | (ent) | nil

### EffectsDesc
* title - Effect title
* value - any string valu
* unit - like % or kg etc
* state:  
    * 1 - positive effect
    * 2 - neutral effect
    * 3 - negative effect

Example table: 
```lua
EffectsDesc  = {
      [1] = {title = "???????????????????????? ????????????", value = "40", unit = "%", state = 1},
      [2] = {title = "???????????????????? ????????????", value = "40", unit = "%", state = 1},
      [3] = {title = "?????????????? ????????????", value = "40", unit = "%", state = 1},
      [4] = {title = "?????????????????????? ????????????", value = "40", unit = "%", state = 1},
      [5] = {title = "?????? ????????????", value = "0", unit = "%", state = 2},
      [6] = {title = "???????????? ???? ??????????", value = "55", unit = "%", state = 1},
      [7] = {title = "???????????? ???? ????????????", value = "50", unit = "%", state = 1},
      [8] = {title = "??????????????????????????", value = "65", unit = "%", state = 1},
      [9] = {title = "????????. ?????????????????????? ??????", value = "20", unit = "????", state = 3},
   }
```

### ArmorTable
Example table:
```lua
ArmorTable      = {
      Effects = {
         RadiationDef = 40, --???????????????????????? ????????????
         ChemicalDef = 40, --???????????????????? ????????????
         ElectricalDef = 40, --?????????????? ????????????
         ThermalDef = 40, --?????????????????????? ????????????
         PsyDef = 0, --?????? ????????????
         ImpactDef = 55, --???????????? ???? ??????????
         BlastDef = 50, --???????????? ???? ????????????
         BulletDef = 65, --??????????????????????????
      },
      Stamina = 0, --???????????????????????????? ????????????????????????
      MaxWeight = 20, --????????. ?????????????????????? ??????
      Containters = 1, --??????-???? ??????????????????????
      Helmet = true, --???????????????????? ?????????????????? ????????
   },
```
### HelmetTable
Example table:
```lua
HelmetTable  = {
      Effects = {
         RadiationDef = 2, --???????????????????????? ????????????
         ChemicalDef = 3, --???????????????????? ????????????
         PsyDef = 14, --?????? ????????????
         BulletDef = 21, --??????????????????????????
      },
      NVD = 1, --?????????????? ?????? (not used)
   }
```