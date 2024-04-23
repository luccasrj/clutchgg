-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("characters/allChars","SELECT * FROM characters")
vRP.prepare("characters/getUsers","SELECT * FROM characters WHERE id = @id")
vRP.prepare("characters/updatePort","UPDATE characters SET port = @port WHERE id = @id")
vRP.prepare("characters/getCharacters","SELECT * FROM characters WHERE steam = @steam")
vRP.prepare("characters/updateName","UPDATE characters SET name = @name, name2 = @name2 WHERE id = @user_id")
vRP.prepare("characters/updateSurname","UPDATE characters SET surname = @surname WHERE id = @user_id")
vRP.prepare("characters/lastCharacters","SELECT id FROM characters WHERE steam = @steam ORDER BY id DESC LIMIT 1")
vRP.prepare("characters/countPersons","SELECT COUNT(steam) as qtd FROM characters WHERE steam = @steam")
vRP.prepare("characters/createCharacters","INSERT INTO characters(steam,name,name2) VALUES(@steam,@name,@name2)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("accounts/getInfos","SELECT * FROM accounts WHERE steam = @steam")
vRP.prepare("accounts/infosUnwhitelist","UPDATE accounts SET whitelist = 0 WHERE steam = @steam")
vRP.prepare("accounts/infosWhitelist","UPDATE accounts SET whitelist = @whitelist WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("playerdata/getUserdata","SELECT dvalue FROM characters_data WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("playerdata/setUserdata","REPLACE INTO characters_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNEDS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("banneds/getBanned","SELECT * FROM accounts_bans WHERE steam = @steam")
vRP.prepare("banneds/removeBanned","DELETE FROM accounts_bans WHERE steam = @steam")
vRP.prepare("banneds/insertBanned","INSERT INTO accounts_bans(steam,days) VALUES(@steam,@days)")
vRP.prepare("banneds/getTimeBanned","SELECT * FROM accounts_bans WHERE steam = @steam AND (DATEDIFF(CURRENT_DATE,time) >= days)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("chests/getChests","SELECT * FROM chests WHERE name = @name")
vRP.prepare("chests/upgradeChests","UPDATE chests SET weight = weight + 25 WHERE name = @name")