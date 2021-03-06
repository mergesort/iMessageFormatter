#This is a script that emulates the iPhone style of autocapitalizing of the first character in an iMessage.
#It also automatically appends a period if there isn't punctuation at the end of a sentence.
#If you don't want the formatting to apply to a certain message, start the message with "\", and it will be stripped out automatically.
#The string library that is appended to the bottom of the file can be found at http://applescript.bratis-lover.net/library/string/
#I do not AppleScript much, mostly because it's an awful and terrible in my experience, which is why I found it really handy, and wanted to send a shout out to Aurelio!

property specialCharacters : "!.,?()-+=@#$%^&*[]{}:;\"\\|'/><~`"
property spaceCharacter : " "
property lowercaseCharacters : "abcdefghijklmnopqrstuvwxyz"
property numericalCharacters : "1234567890"
property uppercaseCharacters : "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
property escapeCharacters : "\\"
property tlds : {".ac", ".ad", ".aes", ".af", ".ag", ".ai", ".al", ".am", ".ans", ".ao", ".aq", ".ar", ".as", ".at", ".au", ".aw", ".ax", ".az", ".ba", ".bb", ".bd", ".be", ".bf", ".bg", ".bh", ".bi", ".bj", ".bm", ".bn", ".bo", ".br", ".bs", ".bt", ".bv", ".bw", ".by", ".bz", ".ca", ".cc", ".cd", ".cf", ".cg", ".ch", ".ci", ".ck", ".cl", ".cm", ".cn", ".co", ".cr", ".cu", ".cv", ".cx", ".cy", ".cz", ".de", ".dj", ".dk", ".dm", ".do", ".dz", ".ec", ".ee", ".eg", ".eh", ".er", ".es", ".et", ".eu", ".fi", ".fj", ".fk", ".fm", ".fo", ".fr", ".ga", ".gd", ".ge", ".gf", ".gg", ".gh", ".gi", ".gl", ".gm", ".gn", ".gp", ".gq", ".gr", ".gs", ".gt", ".gu", ".gw", ".gy", ".hk", ".hm", ".hn", ".hr", ".ht", ".hu", ".id", ".ie", ".il", ".im", ".in", ".io", ".iq", ".ir", ".is", ".it", ".je", ".jm", ".jo", ".jp", ".ke", ".kg", ".kh", ".ki", ".km", ".kn", ".kp", ".kr", ".kw", ".ky", ".kz", ".la", ".lb", ".lc", ".li", ".lk", ".lr", ".ls", ".lt", ".lu", ".lv", ".ly", ".ma", ".mc", ".md", ".me", ".mg", ".mh", ".mk", ".ml", ".mm", ".mn", ".mo", ".mp", ".mq", ".mr", ".ms", ".mt", ".mu", ".mv", ".mw", ".mx", ".my", ".mz", ".na", ".nc", ".ne", ".nf", ".ng", ".ni", ".nl", ".no", ".np", ".nr", ".nu", ".nz", ".om", ".pa", ".pe", ".pf", ".pg", ".ph", ".pk", ".pl", ".pm", ".pn", ".pr", ".ps", ".pt", ".pw", ".py", ".qa", ".re", ".ro", ".rs", ".ru", ".rw", ".sa", ".sb", ".sc", ".sd", ".se", ".sg", ".sh", ".si", ".sj", ".sk", ".sl", ".sm", ".sn", ".so", ".sr", ".st", ".su", ".sv", ".sy", ".sz", ".tc", ".td", ".tf", ".tg", ".th", ".tj", ".tk", ".tm", ".tn", ".to", ".tp", ".tr", ".tt", ".tv", ".tw", ".tz", ".ua", ".ug", ".uk", ".um", ".us", ".uy", ".uz", ".va", ".vc", ".ve", ".vg", ".vi", ".vn", ".vu", ".wf", ".ws", ".ye", ".yt", ".yu", ".za", ".zm", ".zw", ".com", ".edu", ".gov", ".int", ".mil", ".net", ".org", ".arpa", ".nato", ".biz", ".cat", ".pro", ".tel", ".aero", ".asia", ".coop", ".info", ".jobs", ".mobi", ".name", ".museum", ".travel"}
property fileExtensions : {".pdf", ".mp3", ".jpg", ".rar", ".exe", ".wmv", ".doc", ".avi", ".ppt", ".mpg", ".tif", ".wav", ".mov", ".psd", ".wma", ".sitx", ".sit", ".eps", ".cdr", ".ai", ".xls", ".mp4", ".txt", ".m4a", ".rmvb", ".bmp", ".pps", ".aif", ".pub", ".dwg", ".gif", ".qbb", ".mpeg", ".indd", ".swf", ".asf", ".png", ".dat", ".rm", ".mdb", ".chm", ".jar", ".htm", ".dvf", ".dss", ".dmg", ".iso", ".flv", ".wpd", ".cda", ".m4b", ".7z", ".gz", ".fla", ".qxd", ".rtf", ".aiff", ".msi", ".jpeg", ".3gp", ".cdl", ".vob", ".ace", ".m4p", ".divx", ".html", ".pst", ".cab", ".ttf", ".xtm", ".hqx", ".qbw", ".sea", ".ptb", ".bin", ".mswmm", ".ifo", ".tgz", ".log", ".dll", ".mcd", ".ss", ".m4v", ".eml", ".mid", ".ogg", ".ram", ".lnk", ".torrent", ".ses", ".mp2", ".vcd", ".bat", ".asx", ".ps", ".bup", ".cbr", ".amr", ".wps", ".sql"}
property ignoredPrefixes : {"http", "www.", "ftp://", "ftp."}
property emoji : {"😄", "😃", "😀", "😊", "☺", "😉", "😍", "😘", "😚", "😗", "😙", "😜", "😝", "😛", "😳", "😁", "😔", "😌", "😒", "😞", "😣", "😢", "😂", "😭", "😪", "😥", "😰", "😅", "😓", "😩", "😫", "😨", "😱", "😠", "😡", "😤", "😖", "😆", "😋", "😷", "😎", "😴", "😵", "😲", "😟", "😦", "😧", "😈", "👿", "😮", "😬", "😐", "😕", "😯", "😶", "😇", "😏", "😑", "👲", "👳", "👮", "👷", "💂", "👶", "👦", "👧", "👨", "👩", "👴", "👵", "👱", "👼", "👸", "", "😺", "😸", "😻", "😽", "😼", "🙀", "😿", "😹", "😾", "😯", "👹", "👺", "🙈", "🙉", "🙊", "💀", "👽", "💩", "", "🔥", "✨", "🌟", "💫", "💥", "💢", "💦", "💧", "💤", "💨", "👂", "👀", "👃", "👅", "👄", "👍", "👎", "👌", "👊", "✊", "✌", "👋", "✋", "👐", "👆", "👇", "👉", "👈", "🙌", "🙏", "☝", "👏", "💪", "🚶", "🏃", "💃", "👫", "👪", "👬", "👭", "💏", "💑", "👯", "🙆", "🙅", "💁", "🙋", "💆", "💇", "💅", "👰", "🙎", "🙍", "🙇", "", "🎩", "👑", "👒", "👟", "👞", "👡", "👠", "👢", "👕", "👔", "👚", "👗", "🎽", "👖", "👘", "👙", "💼", "👜", "👝", "👛", "👓", "🎀", "🌂", "💄", "", "💛", "💙", "💜", "💚", "❤", "💔", "💗", "💓", "💕", "💖", "💞", "💘", "💌", "💋", "💍", "💎", "👤", "👥", "💬", "👣", "💭", "", "🐶", "🐺", "🐱", "🐭", "🐹", "🐰", "🐸", "🐯", "🐨", "🐻", "🐷", "🐽", "🐮", "🐗", "🐵", "🐒", "🐴", "🐑", "🐘", "🐼", "🐧", "🐦", "🐤", "🐥", "🐣", "🐔", "🐍", "🐢", "🐛", "🐝", "🐜", "🐞", "🐌", "🐙", "🐚", "🐠", "🐟", "🐬", "🐳", "🐋", "🐄", "🐏", "🐀", "🐃", "🐅", "🐇", "🐉", "🐎", "🐐", "🐓", "🐕", "🐖", "🐁", "🐂", "🐲", "🐡", "🐊", "🐫", "🐪", "🐆", "🐈", "🐩", "🐾", "", "💐", "🌸", "🌷", "🍀", "🌹", "🌻", "🌺", "🍁", "🍃", "🍂", "🌿", "🌾", "🍄", "🌵", "🌴", "🌲", "🌳", "🌰", "🌱", "🌼", "", "🌐", "🌞", "🌝", "🌚", "🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘", "🌜", "🌛", "🌙", "🌍", "🌎", "🌏", "🌋", "🌌", "🌠", "⭐", "☀", "⛅", "☁", "⚡", "☔", "❄", "⛄", "🌀", "🌁", "🌈", "🌊", "", "🎍", "💝", "🎎", "🎒", "🎓", "🎏", "🎆", "🎇", "🎐", "🎑", "🎃", "👻", "🎅", "🎄", "🎁", "🎋", "🎉", "🎊", "🎈", "🎌", "🔮", "🎥", "📷", "📹", "📼", "💿", "📀", "💽", "💾", "💻", "📱", "☎", "📞", "📟", "📠", "📡", "📺", "📻", "🔊", "🔉", "🔈", "🔇", "🔔", "🔕", "📢", "📣", "⏳", "⌛", "⏰", "⌚", "🔓", "🔒", "🔏", "🔐", "🔑", "🔎", "💡", "🔦", "🔆", "🔅", "🔌", "🔋", "🔍", "🛁", "🛀", "🚿", "🚽", "🔧", "🔩", "🔨", "🚪", "🚬", "💣", "🔫", "🔪", "💊", "💉", "💰", "💴", "💵", "💷", "💶", "💳", "💸", "📲", "", "📧", "📥", "📤", "✉", "📩", "📨", "📯", "📫", "📪", "📬", "📭", "📮", "📦", "📝", "📄", "📃", "📑", "📊", "📈", "📉", "📜", "📋", "📅", "📆", "📇", "📁", "📂", "✂", "📌", "📎", "✒", "✏", "📏", "📐", "📕", "📗", "📘", "📙", "📓", "📔", "📒", "📚", "📖", "🔖", "📛", "🔬", "🔭", "📰", "", "🎨", "🎬", "🎤", "🎧", "🎼", "🎵", "🎶", "🎹", "🎻", "🎺", "🎷", "🎸", "", "👾", "🎮", "🃏", "🎴", "🀄", "🎲", "🎯", "🏈", "🏀", "⚽", "⚾", "🎾", "🎱", "🏉", "🎳", "⛳", "🚵", "🚴", "🏁", "🏇", "🏆", "🎿", "🏂", "🏊", "🏄", "🎣", "", "☕", "🍵", "🍶", "🍼", "🍺", "🍻", "🍸", "🍹", "🍷", "🍴", "🍕", "🍔", "🍟", "🍗", "🍖", "🍝", "🍛", "🍤", "🍱", "🍣", "🍥", "🍙", "🍘", "🍚", "🍜", "🍲", "🍢", "🍡", "🍳", "🍞", "🍩", "🍮", "🍦", "🍨", "🍧", "🎂", "🍰", "🍪", "🍫", "🍬", "🍭", "🍯", "", "🍎", "🍏", "🍊", "🍋", "🍒", "🍇", "🍉", "🍓", "🍑", "🍈", "🍌", "🍐", "🍍", "🍠", "🍆", "🍅", "🌽", "", "🏠", "🏡", "🏫", "🏢", "🏣", "🏥", "🏦", "🏪", "🏩", "🏨", "💒", "⛪", "🏬", "🏤", "🌇", "🌆", "🏯", "🏰", "⛺", "🏭", "🗼", "🗾", "🗻", "🌄", "🌅", "🌃", "🗽", "🌉", "🎠", "🎡", "⛲", "🎢", "🚢", "", "⛵", "🚤", "🚣", "⚓", "🚀", "✈", "💺", "🚁", "🚂", "🚊", "🚉", "🚞", "🚆", "🚄", "🚅", "🚈", "🚇", "🚝", "🚋", "🚃", "🚎", "🚌", "🚍", "🚙", "🚘", "🚗", "🚕", "🚖", "🚛", "🚚", "🚨", "🚓", "🚔", "🚒", "🚑", "🚐", "🚲", "🚡", "🚟", "🚠", "🚜", "💈", "🚏", "🎫", "🚦", "🚥", "⚠", "🚧", "🔰", "⛽", "🏮", "🎰", "♨", "🗿", "🎪", "🎭", "📍", "🚩", "", "🇯🇵", "🇰🇷", "🇩🇪", "🇨🇳", "🇺🇸", "🇫🇷", "🇪🇸", "🇮🇹", "🇷🇺", "🇬🇧", "", "1⃣", "2⃣", "3⃣", "4⃣", "5⃣", "6⃣", "7⃣", "8⃣", "9⃣", "0⃣", "🔟", "🔢", "#⃣", "🔣", "⬆", "⬇", "⬅", "➡", "🔠", "🔡", "🔤", "↗", "↖", "↘", "↙", "↔", "↕", "🔄", "◀", "▶", "🔼", "🔽", "↩", "↪", "ℹ", "⏪", "⏩", "⏫", "⏬", "⤵", "⤴", "", "🆗", "🔀", "🔁", "🔂", "🆕", "🆙", "🆒", "🆓", "🆖", "📶", "🎦", "🈁", "🈯", "🈳", "🈵", "🈴", "🈲", "🉐", "🈹", "🈺", "🈶", "🈚", "🚻", "🚹", "🚺", "🚼", "🚾", "🚰", "🚮", "🅿", "♿", "🚭", "🈷", "🈸", "🈂", "Ⓜ", "🛂", "🛄", "🛅", "🛃", "🉑", "㊙", "㊗", "🆑", "🆘", "🆔", "🚫", "🔞", "📵", "🚯", "🚱", "🚳", "🚷", "🚸", "⛔", "✳", "❇", "❎", "✅", "✴", "💟", "🆚", "📳", "📴", "🅰", "🅱", "🆎", "🅾", "💠", "➿", "♻", "", "♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓", "⛎", "", "🔯", "🏧", "💹", "💲", "💱", "©", "®", "™", "❌", "‼", "⁉", "❗", "❓", "❕", "❔", "⭕", "🔝", "🔚", "🔙", "🔛", "🔜", "🔃", "🕛", "🕧", "🕐", "🕜", "🕑", "🕝", "🕒", "🕞", "🕓", "🕟", "🕔", "🕠", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚", "🕡", "🕢", "🕣", "🕤", "🕥", "🕦", "✖", "➕", "➖", "➗", "♠", "♥", "♣", "♦", "💮", "💯", "✔", "☑", "🔘", "🔗", "➰", "〰", "〽", "🔱", "◼", "◻", "◾", "◽", "▪", "▫", "🔺", "🔲", "🔳", "⚫", "⚪", "🔴", "🔵", "🔻", "⬜", "⬛", "🔶", "🔷", "🔸", "🔹"}


################################################################################

on uppercaseAndPunctuate(str)
	if length of str is equal to 1 then
		return str
	end if
	
	set firstCharacter to text 1 of str
	
	if (firstCharacter is in escapeCharacters) then
		return text 2 thru end of str
	end if
	
	##Add more patterns below
	set tldTest to checkWordInList(str, true, tlds)
	set numberTest to checkWordInList(str, true, numericalCharacters)
	set emojiTest to checkWordInList(str, true, emoji)
	set fileExtensionText to checkWordInList(str, true, fileExtensions)
	set specialCharactersPrefixText to checkWordInList(str, false, specialCharacters)
	set prefixTest to checkWordInList(str, false, ignoredPrefixes)
	
	set convertedString to convertToSmartQuotes(str)
	set capitalizedString to capitalizedWord(convertedString)
	
	if length of tldTest is not equal to 0 then
		return tldTest
	else if length of numberTest is not equal to 0 then
		return numberTest
	else if length of emojiTest is not equal to 0 and length of str > 1 then
		return capitalizedWord(emojiTest)
	else if length of emojiTest is not equal to 0 and length of str is equal to 1 then
		return str
	else if length of fileExtensionText is not equal to 0 then
		return fileExtensionText
	else if length of prefixTest is not equal to 0 then
		return prefixTest
	else if length of specialCharactersPrefixText is not equal to 0 then
		return specialCharactersPrefixText
	end if
	
	if length of capitalizedString > 0 then
		set trimmed to trimEnd(capitalizedString) as text
		set lastCharacter to text -1 of trimmed
		
		if (lastCharacter is in specialCharacters) then
			return trimmed
		else if (lastCharacter is in lowercaseCharacters or lastCharacter is in uppercaseCharacters or lastCharacter is in spaceCharacter) then
			return trimmed & "." as text
		end if
	else
		return str & "." as text
	end if
end uppercaseAndPunctuate

on convertToSmartQuotes(str)
	set replacedString to replaceString(str, "'", "’")
	return replacedString
end convertToSmartQuotes

on checkWordInList(str, fromEnd, thelist)
	repeat with i from 1 to count of thelist
		if (fromEnd) then
			set testString to rstripString(str, item i of thelist)
		else
			set testString to lstripString(str, item i of thelist)
		end if
		if (length of testString is not equal to length of str) then
			return str
		end if
	end repeat
	return ""
end checkWordInList

on stripWord(str, fromEnd, originalString)
	if (fromEnd) then
		set strippedString to rstripString(str, originalString)
	else
		set strippedString to lstripString(str, originalString)
	end if
	
	return strippedString
end stripWord

on capitalizedWord(str)
	set firstCharacter to text 1 of str
	set capitalizedString to ""
	set characterOffset to character offset of firstCharacter in lowercaseCharacters
	if characterOffset > 0 then
		set capitalizedCharacter to text characterOffset thru characterOffset in uppercaseCharacters
		set capitalizedString to capitalizedCharacter & (text 2 thru end of str)
	else
		set capitalizedString to ""
	end if
	
	return capitalizedString
end capitalizedWord


################################################################################

using terms from application "Messages"
	on message sent theMessage for theChat
		return uppercaseAndPunctuate(theMessage)
	end message sent
	
	on message received theMessage from theBuddy for theChat
		
	end message received
	
	on chat room message received theMessage from theBuddy for theChat
		
	end chat room message received
	
	on active chat message received theMessage
		
	end active chat message received
	
	on addressed chat room message received theMessage from theBuddy for theChat
		
	end addressed chat room message received
	
	on addressed message received theMessage from theBuddy for theChat
		
	end addressed message received
	
	# The following are unused but need to be defined to avoid an error
	
	on received text invitation theText from theBuddy for theChat
		
	end received text invitation
	
	on received audio invitation theText from theBuddy for theChat
		
	end received audio invitation
	
	on received video invitation theText from theBuddy for theChat
		
	end received video invitation
	
	on received remote screen sharing invitation from theBuddy for theChat
		
	end received remote screen sharing invitation
	
	on received local screen sharing invitation from theBuddy for theChat
		
	end received local screen sharing invitation
	
	on received file transfer invitation theFileTransfer
		
	end received file transfer invitation
	
	on buddy authorization requested theRequest
		
	end buddy authorization requested
	
	on av chat started
		
	end av chat started
	
	on av chat ended
		
	end av chat ended
	
	on login finished for theService
		
	end login finished
	
	on logout finished for theService
		
	end logout finished
	
	on buddy became available theBuddy
		
	end buddy became available
	
	on buddy became unavailable theBuddy
		
	end buddy became unavailable
	
	on completed file transfer
		
	end completed file transfer
	
end using terms from

(*
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--c-                                                                                           STRING LIBRARY
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--d-- Last modification date:                                                             02.08.2008


The string library holds a collection of handlers for string manipulation 
such as counting, finding, replacing, splitting etc.


--m-- http://applescript.bratis-lover.net/library/string/

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--c-                                                                                                   COPYRIGHT
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

COPYRIGHT (c) 2003 HAS (http://applemods.sourceforge.net) 
                                [ findFirst, findLast, trimStart, trimEnd, trimBoth, 
                                  capitalizeWords, removeExtraSpaces, multiplyText, chompText ]

COPYRIGHT (c) 2008 ljr (http://applescript.bratis-lover.net) 
                                [ countSubstring, replaceString, RemoveFromString, lstripString, 
                                  rstripString, stripString, lStripStringList, rStripStringList, 
                                  stripStringList, explode, implode, capitalizeSentences, findAll, 
                                  RemoveListFromString, normaliseWhiteSpace, removeExtraTabs, 
                                  removeEmptyLines, translateLineEndings, stringBetween, 
                                  capitalizeWordsWithExceptions, leftString, rightString, 
                                  leftStringFromRight, rightStringFromRight, ]

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

COPYRIGHT (c) 2008 Aurelio (http://aurelio.net/doc/as4pp.html)
                                [ translateChars, lowerString, upperString, capitalizeString ]

Please refer to the authors' websites for copyright information.

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

*)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--c-                                                                                                 PROPERTIES
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


--c--   property myName
--d--   Name that should be used when loading this library.
property myName : "_string"


--c--   property _ucChars_
--d--   Upper case characters.
property _ucChars_ : "AÄÁÀÂÃÅĂĄÆBCÇĆČDĎĐEÉÈÊËĚĘFGHIÍÌÎÏJKLĹĽŁMNÑŃŇ" & ¬
	"OÖÓÒÔÕŐØPQRŔŘSŞŠŚTŤŢUÜÚÙÛŮŰVWXYÝZŽŹŻÞ"


--c--   property _lcChars_
--d--   Lower case characters.
property _lcChars_ : "aäáàâãåăąæbcçćčdďđeéèêëěęfghiíìîïjklĺľłmnñńň" & ¬
	"oöóòôõőøpqrŕřsşšśtťţuüúùûůűvwxyýzžźżþ"

--c--   property _otherChars_
--d--   Miscellaneous other characters.
property _otherChars_ : "ß"


--c--   property _nonCapitalizedWords_en_
--d--   English words usually not capitalized in headlines.
property _nonCapitalizedWords_en_ : {"a", "about", "above", "according", "across", ¬
	"after", "against", "along", "amid", "among", "an", "and", "around", "as", "at", ¬
	"athwart", "be", "before", "behind", "below", "beneath", "beside", "between", ¬
	"beyond", "but", "by", "concerning", "during", "either", "except", "excepting", ¬
	"for", "from", "in", "inside", "into", "is", "it", "like", "neither", "nor", "of", ¬
	"off", "on", "only", "onto", "or", "out", "outside", "over", "past", "pending", ¬
	"regarding", "respecting", "round", "since", "so", "that", "the", "then", "this", ¬
	"though", "through", "throughout", "till", "to", "toward", "under", "underneath", ¬
	"until", "unto", "up", "upon", "when", "where", "whether", "which", "who", ¬
	"whose", "with", "within", "without", "yet"}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--c-                                                                                                    COUNTING
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


--c--   countSubstring(theText, theSubstring)
--d--   Count the number of occurrences of a substring (case-insensitive).
--a--   theText : string -- the string containing the substring
--a--   theSubstring : string -- the string to count
--r--   integer -- number of occurrences of substring
--x--   countSubstring("abc abc abc", "abc") --> 3
--u--   ljr (http://applescript.bratis-lover.net/library/string/), 
--u--   modified from 'Aurelio.net' (http://aurelio.net/doc/as4pp.html)
on countSubstring(theText, theSubstring)
	local ASTID, theText, theSubstring, i
	set ASTID to AppleScript's text item delimiters
	try
		set AppleScript's text item delimiters to theSubstring
		set i to (count theText's text items) - 1
		set AppleScript's text item delimiters to ASTID
		return i
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't countSubstring: " & eMsg number eNum
	end try
end countSubstring



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--c-                                                                                            FIND / REPLACE
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


--c--   findFirst(str, findString)
--d--   Get position of first match found (case-sensitive).
--a--   str : string -- the string to search
--a--   findStr : string -- the string to find
--r--   integer -- the offset, or 0 if not found
--x--   findFirst("abcabc", "bc") --> 2
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on findFirst(str, findString)
	local str, findString, len, oldTIDs
	set oldTIDs to AppleScript's text item delimiters
	try
		set str to str as string
		set AppleScript's text item delimiters to findString
		considering case
			set len to str's first text item's length
		end considering
		set AppleScript's text item delimiters to oldTIDs
		if len is str's length then
			return 0
		else
			return len + 1
		end if
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't findFirst: " & eMsg number eNum
	end try
end findFirst


--c--   findLast(str, findString)
--d--   Get position of last match found (case-sensitive).
--a--   str : string -- the string to search
--a--   findStr : string -- the string to find
--r--   integer -- the offset; negative integer, or 0 if not found
--x--   findLast("abcabc", "b") --> -2
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on findLast(str, findString)
	local str, findString, len, oldTIDs
	set oldTIDs to AppleScript's text item delimiters
	try
		set str to str as string
		set AppleScript's text item delimiters to findString as string
		considering case
			set len to str's last text item's length
		end considering
		set AppleScript's text item delimiters to oldTIDs
		if len is str's length then
			return 0
		else
			return -(findString's length) - len
		end if
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't findLast: " & eMsg number eNum
	end try
end findLast


--c--   findAll(str, findString)
--d--   Get positions of all matches found (case-sensitive).
--a--   str : string -- the string to search
--a--   findStr : string -- the string to find
--r--   list -- list of integers (empty list if not found)
--x--   findAll("abcabc", "b") --> {2, 5}
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on findAll(str, findString)
	local ASTID, str, findString, tmp, len, len2, pos, res
	set ASTID to AppleScript's text item delimiters
	try
		set AppleScript's text item delimiters to findString
		if str does not contain findString then return {}
		considering case
			script k
				property res : {}
				property tmp : str's text items
			end script
		end considering
		set len to count k's tmp
		set len2 to count findString
		set pos to 0
		repeat with i from 1 to len - 1
			set thisPos to (count k's tmp's item i)
			set thisPos to thisPos + pos
			set pos to thisPos + len2
			set end of k's res to (thisPos + 1)
		end repeat
		set AppleScript's text item delimiters to ASTID
		return k's res
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't findAll: " & eMsg number eNum
	end try
end findAll


--c--   replaceString(theText, oldString, newString)
--d--   Case-sensitive find and replace of all occurrences.
--a--   theText : string -- the string to search
--a--   oldString : string -- the find string
--a--   newString : string -- the replacement string
--r--   string
--x--   replaceString("Hello hello", "hello", "Bye") --> "Hello Bye"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on replaceString(theText, oldString, newString)
	local ASTID, theText, oldString, newString, lst
	set ASTID to AppleScript's text item delimiters
	try
		considering case
			set AppleScript's text item delimiters to oldString
			set lst to every text item of theText
			set AppleScript's text item delimiters to newString
			set theText to lst as string
		end considering
		set AppleScript's text item delimiters to ASTID
		return theText
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't replaceString: " & eMsg number eNum
	end try
end replaceString


--c--   RemoveFromString(theText, CharOrString)
--d--   Case-sensitive remove substring from string.
--a--   theText : string -- the string to search
--a--   CharOrString : string -- the string to remove
--r--   string
--x--   RemoveFromString("Hello hello", "hello") --> "Hello "
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on RemoveFromString(theText, CharOrString)
	local ASTID, theText, CharOrString, lst
	set ASTID to AppleScript's text item delimiters
	try
		considering case
			if theText does not contain CharOrString then ¬
				return theText
			set AppleScript's text item delimiters to CharOrString
			set lst to theText's text items
		end considering
		set AppleScript's text item delimiters to ASTID
		return lst as text
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't RemoveFromString: " & eMsg number eNum
	end try
end RemoveFromString


--c--   RemoveListFromString(theText, listOfCharsOrStrings)
--d--   Case-sensitive remove list of substrings from string.
--a--   theText : string -- the string to search
--a--   listOfCharsOrStrings : list -- list of strings (chars or strings)
--r--   string
--x--   RemoveListFromString("Hello hello", {"hello"}) --> "Hello "
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on RemoveListFromString(theText, listOfCharsOrStrings)
	local ASTID, theText, CharOrString, lst
	try
		script k
			property l : listOfCharsOrStrings
		end script
		set len to count k's l
		repeat with i from 1 to len
			set cur_ to k's l's item i
			set theText to my RemoveFromString(theText, cur_)
		end repeat
		return theText
	on error eMsg number eNum
		error "Can't RemoveListFromString: " & eMsg number eNum
	end try
end RemoveListFromString


--c--   normaliseWhiteSpace(str)
--d--   Convert any tabs, linefeeds and returns to spaces.
--a--   str : string -- the text to convert
--r--   string
--x--   normaliseWhiteSpace("1\n2\t3\r4") --> "1 2 3 4"
--q--   replaceString
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on normaliseWhiteSpace(str)
	local str, whiteSpace, i
	try
		set whiteSpace to {character id 10, return, tab, character id 160}
		repeat with i from 1 to 4
			set str to my replaceString(str, whiteSpace's item i, " ")
		end repeat
		return str
	on error eMsg number eNum
		error "Can't normaliseWhiteSpace: " & eMsg number eNum
	end try
end normaliseWhiteSpace


--c--   removeExtraSpaces(str)
--d--   Convert multiple spaces to a single space.
--a--   str : string -- the text to convert
--r--   string
--x--   removeExtraSpaces("1        2     3    4") --> "1 2 3 4"
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on removeExtraSpaces(str)
	local str, oldTIDs, removeStrRef, removeStr, lst
	set oldTIDs to AppleScript's text item delimiters
	try
		repeat with removeStrRef in {"        ", "  "}
			set removeStr to removeStrRef's contents
			repeat
				set AppleScript's text item delimiters to removeStr
				set lst to str's text items
				if (count of lst) is 1 then exit repeat
				set AppleScript's text item delimiters to " "
				set str to lst as string
			end repeat
		end repeat
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't removeExtraSpaces: " & eMsg number eNum
	end try
end removeExtraSpaces


--c--   removeExtraTabs(str)
--d--   Convert multiple tabs to a single tab.
--a--   str : string -- the text to convert
--r--   string
--x--   removeExtraTabs("1\t\t\t\t2\t\t\t3\t\t\t\t\t4") --> "1	2	3	4"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
--u--   based on removeExtraSpaces by HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on removeExtraTabs(str)
	local str, oldTIDs, removeStrRef, removeStr, lst
	set oldTIDs to AppleScript's text item delimiters
	try
		repeat with removeStrRef in {"								", "		"}
			set removeStr to removeStrRef's contents
			repeat
				set AppleScript's text item delimiters to removeStr
				set lst to str's text items
				if (count of lst) is 1 then exit repeat
				set AppleScript's text item delimiters to "	"
				set str to lst as string
			end repeat
		end repeat
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't removeExtraTabs: " & eMsg number eNum
	end try
end removeExtraTabs


--c--   removeEmptyLines(str)
--d--   Remove empty lines from string.
--a--   str : string -- input
--r--   string
--x--   removeEmptyLines("a\n\n\nb") --> "a\rb"
--q--   implode
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on removeEmptyLines(str)
	local i, len, str, cleanLst, lst, p
	try
		script k
			property lst : paragraphs of str
			property cleanLst : {}
		end script
		set len to count k's lst
		repeat with i from 1 to len
			set p to k's lst's item i
			ignoring white space
				if p is not "" then set end of k's cleanLst to p
			end ignoring
		end repeat
		return my implode(return, k's cleanLst)
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't removeEmptyLines: " & eMsg number eNum
	end try
end removeEmptyLines


--c--   translateLineEndings(str, trTo)
--d--   Translate line endings.
--a--   str : string -- input
--a--   trTo : string -- translate to "\r", "\n" or "\r\n"
--r--   string
--x--   translateLineEndings("a\nb\nc", "\r\n") --> "a\r\nb\r\nc"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on translateLineEndings(str, trTo)
	local str, trTo, ASTID
	set ASTID to AppleScript's text item delimiters
	try
		set str to paragraphs of str
		set AppleScript's text item delimiters to trTo
		set str to str as text
		set AppleScript's text item delimiters to ASTID
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't trLineEndings: " & eMsg number eNum
	end try
end translateLineEndings



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--c-                                                                                                 STRIP / TRIM
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


--c--   trimStart(str)
--d--   Trim any white space (space/tab/return/linefeed) from the start of a string.
--a--   str : string
--r--   string
--x--   trimStart("  \t \n \r abc") --> "abc"
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on trimStart(str)
	local str, whiteSpace
	try
		set str to str as string
		set whiteSpace to {character id 10, return, space, tab}
		try
			repeat while str's first character is in whiteSpace
				set str to str's text 2 thru -1
			end repeat
			return str
		on error number -1728
			return ""
		end try
	on error eMsg number eNum
		error "Can't trimStart: " & eMsg number eNum
	end try
end trimStart


--c--   trimEnd(str)
--d--   Trim any white space (space/tab/return/linefeed) from the end of a string.
--a--   str : string
--r--   string
--x--   trimEnd("abc  \t \n \r ") --> "abc"
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on trimEnd(str)
	local str, whiteSpace
	try
		set str to str as string
		set whiteSpace to {character id 10, return, space, tab}
		try
			repeat while str's last character is in whiteSpace
				set str to str's text 1 thru -2
			end repeat
			return str
		on error number -1728
			return ""
		end try
	on error eMsg number eNum
		error "Can't trimEnd: " & eMsg number eNum
	end try
end trimEnd


--c--   trimBoth(str)
--d--   Trim any white space (space/tab/return/linefeed) from both ends of a string.
--a--   str : string
--r--   string
--x--   trimBoth("  \t \n \r  abc  \t \n \r ") --> "abc"
--q--   trimStart, trimEnd
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on trimBoth(str)
	local str
	try
		return my trimStart(my trimEnd(str))
	on error eMsg number eNum
		error "Can't trimBoth: " & eMsg number eNum
	end try
end trimBoth


--c--   lstripString(theText, trimString)
--d--   Trim a string from the text's beginning.
--a--   theText : string -- the text to strip
--a--   trimString : string -- the string to remove
--r--   string
--x--   lstripString("abcd", "ab") --> "cd"
--u--   ljr (http://applescript.bratis-lover.net/library/string/), 
--u--   modified from 'Aurelio.net' (http://aurelio.net/doc/as4pp.html)
on lstripString(theText, trimString)
	local theText, trimString, x
	try
		set x to count trimString
		try
			repeat while theText begins with trimString
				set theText to characters (x + 1) thru -1 of theText as text
			end repeat
			return theText
		on error number -1700
			return ""
		end try
	on error eMsg number eNum
		error "Can't trimBoth: " & eMsg number eNum
	end try
end lstripString


--c--   rstripString(theText, trimString)
--d--   Trim a string from the text's ending.
--a--   theText : string -- the text to strip
--a--   trimString : string -- the string to remove
--r--   string
--x--   rstripString("abcd", "cd") --> "ab"
--u--   ljr (http://applescript.bratis-lover.net/library/string/),
--u--   modified from 'Aurelio.net' (http://aurelio.net/doc/as4pp.html)
on rstripString(theText, trimString)
	local theText, trimString, x
	try
		set x to count trimString
		try
			repeat while theText ends with trimString
				set theText to characters 1 thru -(x + 1) of theText as text
			end repeat
			return theText
		on error number -1700
			return ""
		end try
	on error eMsg number eNum
		error "Can't trimBoth: " & eMsg number eNum
	end try
end rstripString


--c--   stripString(theText, trimString)
--d--   Trim a string from the text's boundaries.
--a--   theText : string -- the text to strip
--a--   trimString : string -- the string to remove
--r--   string
--x--   stripString("abcdab", "ab") --> "cd"
--q--   lstripString, rstripString
--u--   ljr (http://applescript.bratis-lover.net/library/string/),
--u--   modified from 'Aurelio.net' (http://aurelio.net/doc/as4pp.html)
on stripString(theText, trimString)
	local theText, trimString
	try
		set theText to my lstripString(theText, trimString)
		set theText to my rstripString(theText, trimString)
		return theText
	on error eMsg number eNum
		error "Can't stripString: " & eMsg number eNum
	end try
end stripString


--c--   lStripStringList(theString, trimList)
--d--   Trim a list of characters from the text's beginning.
--a--   theText : string -- the text to strip
--a--   trimList :  string or list -- list of chars to remove
--r--   string
--x--   lStripStringList("--> this", "-> ") --> "this"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on lStripStringList(theString, trimList)
	local theString, trimList
	try
		repeat while text 1 of theString is in trimList
			set theString to text 2 thru -1 of theString
		end repeat
		return theString
	on error eMsg number eNum
		if eNum = -1728 or eNum = -1700 then return ""
		error "Can't lStripStringList: " & eMsg number eNum
	end try
end lStripStringList


--c--   rStripStringList(theString, trimList)
--d--   Trim a list of characters from the text's ending.
--a--   theText : string -- the text to strip
--a--   trimList : string or list -- list of chars to remove
--r--   string
--x--   rStripStringList("this <--", "-< ") --> "this"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on rStripStringList(theString, trimList)
	local theString, trimList
	try
		repeat while text -1 of theString is in trimList
			set theString to text 1 thru -2 of theString
		end repeat
		return theString
	on error eMsg number eNum
		if eNum = -1728 or eNum = -1700 then return ""
		error "Can't rStripStringList: " & eMsg number eNum
	end try
end rStripStringList


--c--   stripStringList(theString, trimList)
--d--   Trim a list of characters from the text's boundaries.
--a--   theText : string -- the text to strip
--a--   trimList : string or list -- list of chars to remove
--r--   string
--x--   stripStringList("--> test <--", "<- >") --> "test"
--q--   rStripStringList, lStripStringList
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on stripStringList(theString, trimList)
	local theString, trimList
	try
		set theString to my rStripStringList(theString, trimList)
		set theString to my lStripStringList(theString, trimList)
		return theString
	on error eMsg number eNum
		error "Can't stripStringList: " & eMsg number eNum
	end try
end stripStringList


--c--   chompText(txt)
--d--   Remove last character from string if it's a linefeed or return.
--a--   txt : string
--r--   string
--x--   chompText("Test line\n") --> "Test line"
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on chompText(txt)
	try
		set txt to txt as string
		if txt's length is greater than 0 then
			considering hyphens, punctuation and white space
				if {txt's last character} is in {character id 10, return} then
					if txt's length is 1 then
						return ""
					else
						return txt's text 1 thru -2
					end if
				end if
			end considering
		end if
	on error eMsg number eNum
		error "Can't chompText: " & eMsg number eNum
	end try
end chompText



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--c-                                                                                    CASE MANIPULATION
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


--c--   translateChars(theText, fromChars, toChars)
--d--   Translate characters of a text.
--a--   theText : string -- the string to translate in
--a--   fromChars : string -- string of characters to translate
--a--   toChars : string -- string of characters to translate to
--r--   string 
--x--   translateChars("abc", "b", "X") --> "aXc"
--u--   Aurelio (http://aurelio.net/doc/as4pp.html)
on translateChars(theText, fromChars, toChars)
	local Newtext, fromChars, toChars, char, newChar, theText
	try
		set Newtext to ""
		if (count fromChars) ≠ (count toChars) then
			error "translateChars: From/To strings have different lenght"
		end if
		repeat with char in theText
			set newChar to char
			set x to offset of char in fromChars
			if x is not 0 then set newChar to character x of toChars
			set Newtext to Newtext & newChar
		end repeat
		return Newtext
	on error eMsg number eNum
		error "Can't translateChars: " & eMsg number eNum
	end try
end translateChars


--c--   lowerString(theText)
--d--   Convert a text case to lower characters.
--a--   theText : string -- the string to convert
--r--   string 
--x--   lowerString("HELLO") --> "hello"
--q--   translateChars
--u--   Aurelio (http://aurelio.net/doc/as4pp.html)
on lowerString(theText)
	local upper, lower, theText
	try
		return my translateChars(theText, my _ucChars_, my _lcChars_)
	on error eMsg number eNum
		error "Can't lowerString: " & eMsg number eNum
	end try
end lowerString


--c--   upperString(theText)
--d--   Convert a text case to upper characters.
--a--   theText : string -- the string to convert
--r--   string 
--x--   upperString("hello") --> "HELLO"
--q--   translateChars
--u--   Aurelio (http://aurelio.net/doc/as4pp.html)
on upperString(theText)
	local upper, lower, theText
	try
		return my translateChars(theText, my _lcChars_, my _ucChars_)
	on error eMsg number eNum
		error "Can't upperString: " & eMsg number eNum
	end try
end upperString


--c--   capitalizeString(theText)
--d--   Capitalize a text, returning only the first letter uppercased.
--a--   theText : string -- the string to capitalize
--r--   string 
--x--   capitalizeString("this IS a Test.") --> "This is a test."
--q--   upperString, lowerString
--u--   Aurelio (http://aurelio.net/doc/as4pp.html)
on capitalizeString(theText)
	local theText, firstChar, otherChars
	try
		if theText = "" then return ""
		set firstChar to my upperString(first character of theText)
		try
			set otherChars to my lowerString(characters 2 thru -1 of theText)
		on error number -1728
			set otherChars to ""
		end try
		return firstChar & otherChars
	on error eMsg number eNum
		error "Can't capitalizeString: " & eMsg number eNum
	end try
end capitalizeString


--c--   capitalizeWords(theText)
--d--   Capitalize a text, returning the first letter of every word uppercased.
--a--   str : string -- the string to capitalize
--r--   string 
--x--   capitalizeWords("fInd tHE cAt 8 ß ()7b9 789 7 %$ '# lfkj alsoe ghf § .") --> "Find The Cat."
--q--   lowerString
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on capitalizeWords(str)
	-- modified by ljr to handle non-letter characters at beginning of a word
	local oldTIDs, _lcChars, _ucChars, str, lst, len, max, idx
	set oldTIDs to AppleScript's text item delimiters
	try
		set _lcChars to my _lcChars_
		set _ucChars to my _ucChars_
		set max to count _ucChars
		set str to my lowerString(str)
		set lst to {}
		set len to (str's text 1 thru (word 1)'s length) - (str's word 1's length)
		if len is greater than 0 then
			set lst's end to str's text 1 thru len
			set str to str's text (len + 1) thru -1
		end if
		repeat (count str's words) - 1 times
			set len to (str's text 1 thru (word 2)'s length) - (str's word 2's length)
			set AppleScript's text item delimiters to (get str's character 1)
			set idx to ((_lcChars's text item 1's length) + 1)
			if idx ≤ max then
				set lst's end to (_ucChars's character (idx)) & str's text 2 thru len
			else
				set lst's end to str's text 1 thru len
			end if
			set str to str's text (len + 1) thru -1
		end repeat
		set AppleScript's text item delimiters to (get str's character 1)
		set idx to ((_lcChars's text item 1's length) + 1)
		if idx ≤ max then
			set lst's end to (_ucChars's character ((_lcChars's text item 1's length) + 1))
		else
			set lst's end to (get str's character 1)
		end if
		if str's length > 1 then set lst's end to str's text 2 thru -1
		set AppleScript's text item delimiters to ""
		set str to lst as string
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't capitalizeWords: " & eMsg number eNum
	end try
end capitalizeWords



--c--   capitalizeWordsWithExceptions(theText, exceptionList)
--d--   Capitalize a text, returning the first letter of every word (except exceptionlist) uppercased.
--a--   str : string -- the string to capitalize
--a--   exceptionList : list -- list of words that should not be capitalized
--r--   string 
--x--   capitalizeWordsWithExceptions("there hE found tHE cAt.", {"the"}) --> ""There He Found the Cat."
--q--   lowerString
--u--   ljr (http://applescript.bratis-lover.net/library/string/),
--u--   based on capitalizeWords by HAS (http://applemods.sourceforge.net/mods/Data/String.php) 
on capitalizeWordsWithExceptions(str, exceptionList)
	-- modified by ljr to handle non-letter characters at beginning of a word
	local oldTIDs, _lcChars, _ucChars, str, lst, len, max, idx, x
	set oldTIDs to AppleScript's text item delimiters
	--set noCapList to {"the"}
	try
		set _lcChars to my _lcChars_
		set _ucChars to my _ucChars_
		set max to count _ucChars
		set str to my lowerString(str)
		set lst to {}
		set len to (str's text 1 thru (word 1)'s length) - (str's word 1's length)
		if len is greater than 0 then
			set lst's end to str's text 1 thru len
			set str to str's text (len + 1) thru -1
		end if
		set x to 0 -- ljr: flag for first word (always capitalize)
		repeat (count str's words) - 1 times
			set len to (str's text 1 thru (word 2)'s length) - (str's word 2's length)
			set AppleScript's text item delimiters to (get str's character 1)
			set idx to ((_lcChars's text item 1's length) + 1)
			if idx ≤ max and str's word 1 is not in exceptionList then
				set lst's end to (_ucChars's character (idx)) & str's text 2 thru len
			else if idx ≤ max and str's word 1 is in exceptionList and x = 0 then
				set lst's end to (_ucChars's character (idx)) & str's text 2 thru len
			else
				set lst's end to str's text 1 thru len
			end if
			set str to str's text (len + 1) thru -1
			set x to 1
		end repeat
		set AppleScript's text item delimiters to (get str's character 1)
		set idx to ((_lcChars's text item 1's length) + 1)
		if idx ≤ max and str's word 1 is not in exceptionList then
			set lst's end to (_ucChars's character ((_lcChars's text item 1's length) + 1))
		else
			set lst's end to (get str's character 1)
		end if
		if str's length > 1 then set lst's end to str's text 2 thru -1
		set AppleScript's text item delimiters to ""
		set str to lst as string
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't capitalizeWordsWithExceptions: " & eMsg number eNum
	end try
end capitalizeWordsWithExceptions


--c--   capitalizeSentences(str)
--d--   Capitalize the sentences of a string (string may not contain tabs or linebreaks).
--a--   str : string -- the text to convert
--r--   string
--x--   capitalizeSentences("this is a test. and another one...") --> "This is a test. And another one..."
--q--   capitalizeString, explode, implode
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on capitalizeSentences(str)
	local str
	try
		set str to my explode(". ", str)
		set len to count str
		repeat with i from 1 to len
			set str's item i to my capitalizeString(str's item i)
		end repeat
		set str to my implode(". ", str)
		return str
	on error eMsg number eNum
		error "Can't capitalizeSentences: " & eMsg number eNum
	end try
	
end capitalizeSentences


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--c-                                                                                                  SPLIT / JOIN
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


--c--   explode(delimiter, input)
--d--   Split a string on a specific delimiter.
--a--   separator : string -- the delimiter used to split the string
--a--   input : string -- the string to split
--r--   list
--x--   explode("-", "a-b-c") --> {"a", "b", "c"}
--u--   ljr (http://applescript.bratis-lover.net/library/string/),
--u--   modified from 'Applescript.net' (http://bbs.applescript.net/viewtopic.php?id=18377)
on explode(delimiter, input)
	local delimiter, input, ASTID
	set ASTID to AppleScript's text item delimiters
	try
		set AppleScript's text item delimiters to delimiter
		set input to text items of input
		set AppleScript's text item delimiters to ASTID
		return input --> list
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't explode: " & eMsg number eNum
	end try
end explode


--c--   implode(delimiter, pieces)
--d--   Join a list using a specific delimiter.
--a--   separator : string -- the delimiter used to join the string
--a--   pieces : list -- the list to split
--r--   string
--x--   implode("-", {"a", "b", "c"}) --> "a-b-c"
--u--   ljr (http://applescript.bratis-lover.net/library/string/), 
--u--   modified from 'Applescript.net' (http://bbs.applescript.net/viewtopic.php?pid=65358)
on implode(delimiter, pieces)
	local delimiter, pieces, ASTID
	set ASTID to AppleScript's text item delimiters
	try
		set AppleScript's text item delimiters to delimiter
		set pieces to "" & pieces
		set AppleScript's text item delimiters to ASTID
		return pieces --> text
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't implode: " & eMsg number eNum
	end try
end implode


--c--   stringBetween(str, head, tail)
--d--   Return string betwenn first occurence of head and tail.
--a--   str : string 
--a--   head : string
--a--   tail : string
--r--   string
--q--   explode
--x--   stringBetween("abcdef", "b", "e") --> "cd"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on stringBetween(str, head, tail)
	local str, head, tail
	try
		if str does not contain head then return ""
		if str does not contain tail then return ""
		set str to item 2 of my explode(head, str)
		set str to item 1 of my explode(tail, str)
		return str
	on error eMsg number eNum
		error "Can't stringBetween: " & eMsg number eNum
	end try
end stringBetween


--c--   leftString(str, del)
--d--   Return the text to the left of a delimiter (full string if not found).
--a--   str : string -- the string to search
--a--   del : string -- the delimiter to use
--r--   string
--x--   leftString("ab:ca:bc", ":") --> "ab"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on leftString(str, del)
	local str, del, oldTIDs
	set oldTIDs to AppleScript's text item delimiters
	try
		set str to str as string
		if str does not contain del then return str
		set AppleScript's text item delimiters to del
		set str to str's first text item
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't leftString: " & eMsg number eNum
	end try
end leftString


--c--   rightString(str, del)
--d--   Return the text to the right of a delimiter (full string if not found).
--a--   str : string -- the string to search
--a--   del : string -- the delimiter to use
--r--   string
--x--   rightString("ab:ca:bc", ":") --> "ca:bc"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on rightString(str, del)
	local str, del, oldTIDs
	set oldTIDs to AppleScript's text item delimiters
	try
		set str to str as string
		if str does not contain del then return str
		set AppleScript's text item delimiters to del
		set str to str's text items 2 thru -1 as string
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't rightString: " & eMsg number eNum
	end try
end rightString


--c--   leftStringFromRight(str, del)
--d--   Return the text to the left of a delimiter starting from right (full string if not found).
--a--   str : string -- the string to search
--a--   del : string -- the delimiter to use
--r--   string
--x--   leftStringFromRight("ab:ca:bc", ":") --> "ab:ca"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on leftStringFromRight(str, del)
	local str, del, oldTIDs
	set oldTIDs to AppleScript's text item delimiters
	try
		set str to str as string
		if str does not contain del then return str
		set AppleScript's text item delimiters to del
		set str to str's text items 1 thru -2 as string
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't leftStringFromRight: " & eMsg number eNum
	end try
end leftStringFromRight


--c--   rightStringFromRight(str, del)
--d--   Return the text to the right of a delimiter starting from right (full string if not found).
--a--   str : string -- the string to search
--a--   del : string -- the delimiter to use
--r--   string
--x--   rightStringFromRight("ab:ca:bc", ":") --> "bc"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on rightStringFromRight(str, del)
	local str, del, oldTIDs
	set oldTIDs to AppleScript's text item delimiters
	try
		set str to str as string
		if str does not contain del then return str
		set AppleScript's text item delimiters to del
		set str to str's last text item
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't rightStringFromRight: " & eMsg number eNum
	end try
end rightStringFromRight



--c--   multiplyText(str, n)
--d--   Repeat text.
--a--   str : string 
--a--   n : integer -- number of times to repeat 
--r--   string
--x--   multiplyText("ab", 3) --> "ababab"
--u--   HAS (http://applemods.sourceforge.net/mods/Data/String.php)
on multiplyText(str, n)
	try
		set n to n as integer
		if n < 1 then return {}
		set mk to 1
		set lst to {str as string}
		repeat until mk is greater than or equal to n
			set lst to lst & lst
			set mk to mk * 2
		end repeat
		return implode("", lst's items 1 thru n)
	on error eMsg number eNum
		error "Can't multiplyText: " & eMsg number eNum
	end try
end multiplyText



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--                                                                                                                 EOF
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --