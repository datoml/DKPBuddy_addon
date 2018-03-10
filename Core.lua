-- Author      : Derpsn
-- Create Date : 3/9/2018 1:32:41 PM
SLASH_TEST1 = "/dkpbuddy"

SlashCmdList["TEST"] = function(msg)
	DKPBuddyMainFrame:Show();
	DKPBuddyEditBox:SetText('');

	local day = date("%d");

	DKPBuddyCalendarDay:SetText(day);
	DKPBuddyCalendarMonth:SetText("0");
end 

function Loaded()
	print('DKP Buddy loaded!');	
end

function Close()
	DKPBuddyMainFrame:Hide();
end

function GetCalendarEventInformations()
	local weekday, month, day, year = CalendarGetDate();
	local usedDay = DKPBuddyCalendarDay:GetText();
	local monthOffset = tonumber(DKPBuddyCalendarMonth:GetText());
	local numEvents = CalendarGetNumDayEvents(0, day);

	local items = '[\n';

	for i = 1, numEvents, 1 do
		--CALENDAR_EVENTTYPE_RAID    = 1
		--CALENDAR_EVENTTYPE_DUNGEON = 2
		--CALENDAR_EVENTTYPE_PVP     = 3
		--CALENDAR_EVENTTYPE_MEETING = 4
		--CALENDAR_EVENTTYPE_OTHER   = 5

		local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType, sequenceIndex, numSequenceDayss = CalendarGetDayEvent(monthOffset, usedDay, i);
		if eventType == 1 then
			CalendarOpenEvent(0, day, i);
			inviteCount = CalendarEventGetNumInvites()

			for invitee = 1, inviteCount, 1 do
				--CALENDAR_INVITESTATUS_INVITED      = 1
				--CALENDAR_INVITESTATUS_ACCEPTED     = 2
				--CALENDAR_INVITESTATUS_DECLINED     = 3
				--CALENDAR_INVITESTATUS_CONFIRMED    = 4
				--CALENDAR_INVITESTATUS_OUT          = 5
				--CALENDAR_INVITESTATUS_STANDBY      = 6
				--CALENDAR_INVITESTATUS_SIGNEDUP     = 7
				--CALENDAR_INVITESTATUS_NOT_SIGNEDUP = 8
				--CALENDAR_INVITESTATUS_TENTATIVE    = 9

				items = items .. '        {\n';

				local name, level, className, classFilename, inviteStatus, modStatus = CalendarEventGetInvite(invitee);
				local weekday, month, day, year, hour, minute = CalendarEventGetInviteResponseTime(invitee);

				--2012-04-23T18:25:43
				local responseTime = year .. '-' .. string.format("%02d", month) .. '-' .. string.format("%02d", day) .. 'T' .. string.format("%02d", hour) .. ':' .. string.format("%02d", minute) .. ':00';

				items = items .. '            "name": "' .. name .. '",\n';
				items = items .. '            "inviteStatus": ' .. inviteStatus .. ',\n';
				if year ~= 0 then
					items = items .. '            "responseTime": "' .. responseTime .. '",\n';				
					items = items .. '            "isCreator": false\n';
				elseif modStatus == 'CREATOR' then
					items = items .. '            "responseTime": null,\n';
					items = items .. '            "isCreator": true\n';
				else 
					items = items .. '            "responseTime": null,\n';
					items = items .. '            "isCreator": false\n';
				end
				
				if invitee == inviteCount then
					items = items .. '        }\n';
				else
					items = items .. '        },\n';
				end
			end
		end
	end

	items = items .. '    ]';

	return items;
end

function GetGroupMembers()
	local numMembers = GetNumGroupMembers();	
	local items = '[\n';

	for i = 1, numMembers, 1 do
		name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);		
		items = items .. '        {\n';
		items = items .. '            "name": "' .. name .. '",\n';
		items = items .. '            "class": "' .. class .. '"\n';
		
		if i == numMembers then
			items = items.. '        }\n';
		else
			items = items.. '        },\n';
		end
	end

	items = items .. '    ]';

	return items;
end

function OutputCalenderEventForDay()
	local calendarItems = GetCalendarEventInformations();

	local result = '{\n';
	result = result .. '    "calendar": ' .. calendarItems .. '\n';
	result = result .. '}';

	DKPBuddyMainFrame:Show();
	DKPBuddyEditBox:SetText(result);
	DKPBuddyEditBox:HighlightText();
	DKPBuddyEditBox:SetScript("OnEscapePressed", function (self)
		DKPBuddyMainFrame:Hide();
	end)
end

function OutputCurrentGroupMembers()
	local groupMembers = GetGroupMembers();

	local result = '{\n';
	result = result .. '    "groupMembers": ' .. groupMembers .. '\n';
	result = result .. '}';

	DKPBuddyMainFrame:Show();
	DKPBuddyEditBox:SetText(result);
	DKPBuddyEditBox:HighlightText();
	DKPBuddyEditBox:SetScript("OnEscapePressed", function (self)
		DKPBuddyMainFrame:Hide();
	end)
end

function OutputCurrentRaidStatus()
	local calendarItems = GetCalendarEventInformations();
	local groupMembers = GetGroupMembers();

	local result = '{\n';
	result = result .. '    "calendar": ' .. calendarItems .. ',\n';
	result = result .. '    "groupMembers": ' .. groupMembers .. '\n';
	result = result .. '}';

	DKPBuddyMainFrame:Show();
	DKPBuddyEditBox:SetText(result);
	DKPBuddyEditBox:HighlightText();
	DKPBuddyEditBox:SetScript("OnEscapePressed", function (self)
		DKPBuddyMainFrame:Hide();
	end)
end