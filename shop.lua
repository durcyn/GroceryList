local items = {
	[74833] = {bag = 87658, count = 20}, -- Raw Tiger Steak	
	[74834] = {bag = 87659, count = 20}, -- Mushan Ribs
	[74837] = {bag = 87660, count = 20}, -- Raw Turtle Meat
	[74838] = {bag = 87661, count = 20}, -- Raw Crab Meat
	[74839] = {bag = 87662, count = 20}, -- Wildfowl Breast
	[74840] = {bag = 87663, count = 100}, -- Green Cabbage
	[74841] = {bag = 87664, count = 100}, -- Juicycrunch Carrot
	[74842] = {bag = 87665, count = 100}, -- Mogu Pumpkin
	[74843] = {bag = 87666, count = 100}, -- Scallions
	[74844] = {bag = 87667, count = 100}, -- Red Blossom Leek
	[74846] = {bag = 87669, count = 100}, -- Witchberries
	[74847] = {bag = 87670, count = 100}, -- Jade Squash
	[74848] = {bag = 87671, count = 100}, -- Striped Melon
	[74849] = {bag = 87672, count = 100}, -- Pink Turnip
	[74850] = {bag = 87673, count = 100}, -- White Turnip
	[74856] = {bag = 87678, count = 20}, -- Jade Lungfish
	[74857] = {bag = 87679, count = 20}, -- Giant Mantis Shrimp
	[74859] = {bag = 87680, count = 20}, -- Emperor Salmon
	[74860] = {bag = 87681, count = 20}, -- Rebelly Mandarin
	[74861] = {bag = 87682, count = 20}, -- Tiger Gourami
	[74863] = {bag = 87683, count = 20}, -- Jewel Danio
	[74864] = {bag = 87684, count = 20}, -- Reef Octopus
	[74865] = {bag = 87685, count = 20}, -- Krasarang Paddlefish
	[74866] = {bag = 87686, count = 60}, -- Golden Carp
	[75014] = {bag = 87687, count = 20}, -- Raw Crocolisk Belly
}

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(frame, event, ...) if f[event] then f[event](frame, event, ...) end end)
f:RegisterEvent("MERCHANT_SHOW")
f:RegisterEvent("MERCHANT_CLOSED")

local btn = CreateFrame("Button", "GroceryListFrame", MerchantFrame, "UIPanelButtonTemplate")
btn:SetText("Buy")
btn:SetSize(35, 19)
btn:SetPoint("TOPRIGHT", MerchantFrameCloseButton, -25, -6)
btn:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:SetText("Buy Empty Grocery Containers for full stacks in your bags.")
	GameTooltip:Show()
end)
btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

btn:SetScript("OnClick", function()
	local groceries = {}
	for bag = 0,4 do 
		local slots = GetContainerNumSlots(bag)
		for slot = 1, slots do
			local id = GetContainerItemID(bag, slot)
			local count = select(2, GetContainerItemInfo(bag, slot))
			if id and items[id] and count then
				groceries[id] = groceries[id] and groceries[id] + count or count
			end
		end
	end
	
	local shopping = {}
	for id, count in pairs(groceries) do
		for grocery, data in pairs(items) do
			if id == grocery and count >= data.count then
				table.insert(shopping, data.bag)
			end
		end
	end

	local merchitems = GetMerchantNumItems()
	for merchitem = 1, merchitems do 
		local link = GetMerchantItemLink(merchitem)
	        local id = tonumber(string.match(link, "item:(%d+):"))
		for _, bag in pairs(shopping) do
			if id == bag then
				BuyMerchantItem(merchitem)
			end
		end
	end
end)

function f:MERCHANT_SHOW()
	local first = select(3, GetMerchantItemInfo(1))
	if first == 13500 then btn:Show() end
end

function f:MERCHANT_CLOSED()
	btn:Hide()
end
