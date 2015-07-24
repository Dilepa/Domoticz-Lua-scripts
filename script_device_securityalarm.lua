--[[Intention of this script is to turn alarm siren and fire alarm on if one the door sensors changes it’s state to “Open” 
	when state of the security panel is Arm Away or Arm Home. If script is triggered, email and notification are sent.
	Note: fire alarm stays on 5s and alarm siren 150s when triggered!
	Own variable fireAlarmActivationType (type: Int) is used to determine if fire alarm device is activated by the security alarm script or not. If yes, then value is 1 else 0 (real fire alarm)]]

--------------------------------
------ Variables to edit ------
--------------------------------
frontDoor = "Etuovi" --Name of the device
backDoor = "Takaovi" --Name of the device
sideDoor = "Sivuovi" --Name of the device
garageDoor = "Autotallin ovi" --Name of the device
warehouseDoor = "Varaston ovi" --Name of the device
fireAlarmDevice = "Palohälytin" --Name of the fire alarm device
alarmSiren = "Sireeni" --Name of the alarm siren device
alarmActivationType = "fireAlarmActivationType" --Variable which is used to determine has fire alarm been activated by security alarm (1) or by fire alarm (0)
debug = false
--------------------------------
-- End of variables to edit --
--------------------------------

commandArray = {}

if (globalvariables["Security"] ~= "Disarmed" and (devicechanged[frontDoor] == "Open" or devicechanged[backDoor] == "Open" or devicechanged[sideDoor] == "Open" or devicechanged[garageDoor] == "Open" or devicechanged[warehouseDoor] == "Open")) then
	print("Security alarm script running...")
	
	--Variables are initialized
	activationType = uservariables[alarmActivationType] --Fire alarm been activated by security alarm (1) or by fire alarm (0)
	
	if (debug) then
		print("Following values are coming in with device changed table: ")
		for i, v in pairs(devicechanged) do print(i, v) end
		
		print(activationType)
	end
	
	commandArray["Variable:"..alarmActivationType] = tostring(1) ----Fire alarm device activation type is set to 1 which means it's activated by security alarm script
	
	for i, v in pairs(devicechanged) do changedDevice = i end --Store name of the device changed to changedDevice variable
	
	print("Turning alarm siren and fire alarm on...")
	commandArray[fireAlarmDevice] = "On" --Turn fire alarm device on
	commandArray[alarmSiren] = "Panic" --Turn alarm device on
	
	bodytext = "Burglar alarm has been activated! Reason for the activation is: "..changedDevice --Text which is sent via notification and email is created
	print(bodytext)
	
	commandArray[1]={["SendEmail"]="Domoticz - Burglar alarm!#"..bodytext.."#EMAIL_ADDRESS1"} --ADD EMAIL ADDRESS
	commandArray[2]={["SendEmail"]="Domoticz - Burglar alarm!#"..bodytext.."#EMAIL_ADDRESS2"} --ADD 2ND EMAIL ADDRESS IF NEEDED
	commandArray['SendNotification']="Domoticz - Burglar alarm!#"..bodytext.."#0"
	
end
	
return commandArray