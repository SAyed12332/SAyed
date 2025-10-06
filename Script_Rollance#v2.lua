#!/dev SAyed




local base = gg.EXT_STORAGE .. "/Script_Rollance#v2"

-- 🧩 تحقق أولاً إن المجلد موجود فعلاً
local function folderExists(path)
    local f = io.open(path .. "/.check", "w")
    if f then
        f:close()
        os.remove(path .. "/.check")
        return true
    else
        return false
    end
end

-- 🗂️ إنشاء المجلد فقط لو مش موجود
if not folderExists(base) then
    local create_start, create_end
    for i, v in pairs(gg.getRangesList()) do
        if v["end"] - v.start < 10240 and not string.find(v.name or "", "deleted") then
            create_start = v.start
            create_end = v["end"]
            break
        end
    end

    if create_start and create_end then
      
        gg.dumpMemory(create_start, create_end, base .. "/", gg.DUMP_SKIP_SYSTEM_LIBS)
    
    else
      
    end
else

end

local function fnv1a32(str)
 local h = 0x811c9dc5
  for i=1,#str do h = ((h ~ string.byte(str,i)) * 0x01000193) & 0xFFFFFFFF end
  return string.format("%08x", h)
end

local info_file = "/sdcard/Script_Rollance#v2/sv0.txt"
local alert_state_file = "/sdcard/Script_Rollance#v2/alert_state.dat"
local frozen = false

function centerText(text, width)
  text = tostring(text or "")
  width = tonumber(width) or 30
  local len = #text
  if len >= width then return text end
  local padding = math.floor((width - len) / 2)
  return string.rep(" ", padding) .. text
end

function save_info(username, contact_info, anonymous)
  local ok, err = pcall(function()
    local f = assert(io.open(info_file, "w"))
    username = tostring(username or "")
    contact_info = tostring(contact_info or "")
    anonymous = anonymous and "true" or "false"
    f:write(username, "\n", contact_info, "\n", anonymous)
    f:close()
  end)
  return ok
end
function load_info()
  local username, contact_info, anonymous = "", "", false
  local ok, err = pcall(function()
    local f = assert(io.open(info_file, "r"))
    username = f:read("*l") or ""
    contact_info = f:read("*l") or ""
    local anonymous_line = f:read("*l")
    f:close()
    anonymous = (anonymous_line == "true")
  end)
  if not ok then
  
    return nil, nil, false
  end
  return username, contact_info, anonymous
end





function isAlertShown()
  local state = "0"
  local ok = pcall(function()
    local f = io.open(alert_state_file, "r")
    if f then
      state = f:read("*l") or "0"
      f:close()
    end
  end)
  return (state == "1")
end

function saveAlertState()
  pcall(function()
    local f = io.open(alert_state_file, "w")
    if f then
      f:write("1")
      f:close()
    end
  end)
end

function getNameFromFile()
  local username = ""
  pcall(function()
    local f = io.open(info_file, "r")
    if f then
      username = f:read("*l") or ""
      f:close()
    end
  end)
  return username
end

if not isAlertShown() then
    gg.setVisible(false)

    local profilhcek = 0

    repeat
profilhcek = gg.alert(


  [[مرحبا 👋
  
نحتاج لملء بعض البيانات منك مثل اسمك ووسيلة تواصل معك سيحتاجها السكربت في بعض الاعدادات

يمكنك إدخال اسمك فقط ووسيلة التواصل اختيارية

لن يتم حفظ أي شيء إلا إذا ضغطت (ادخال) وأكملت النموذج.]],
  "ادخال",
  "عدم الادخال"
)
     
        if profilhcek ~= 1 and profilhcek ~= 2 then
          
        end
    until profilhcek == 1 or profilhcek == 2
    

  
  if profilhcek == 1 then
    local user_input = gg.prompt(
      {"👤 اكتب اسمك:", "📎 إضافة وسيلة تواصل؟", "🕵️‍♂️ أرسل كمجهول"},
      {"", false, false},
      {"text", "checkbox", "checkbox"}
    )

    if user_input then
      local username = user_input[1] or ""
      local add_contact = user_input[2]
      local anonymous = user_input[3]

      if anonymous then username = "🕵️‍♂️ مجهول" end

      local contact_info = ""
      if add_contact then
        local input = gg.prompt({"📎 اكتب وسيلة التواصل (يوزر/رقم/رابط):"}, {""}, {"text"})
        if input and input[1] ~= "" then
          contact_info = input[1]
        end
      end

      if username ~= "" or contact_info ~= "" then
        save_info(username, contact_info, anonymous)
      end
    end

    saveAlertState() 
  elseif profilhcek == 2 then
    local sayed31 = gg.alert("\nباختيارك عدم الإدخال سيتم تسجيلك كمجهول ولن يتم حفظ أي بيانات.", "حسنا", "ادخال البيانات")
    if sayed31 == 1 then
      saveAlertState()
    elseif sayed31 == 2 then
      -- يرجع للنموذج تاني
      local user_input = gg.prompt(
        {"👤 اكتب اسمك:", "📎 إضافة وسيلة تواصل؟", "🕵️‍♂️ أرسل كمجهول"},
        {"", false, false},
        {"text", "checkbox", "checkbox"}
      )

      if user_input then
        local username = user_input[1] or ""
        local add_contact = user_input[2]
        local anonymous = user_input[3]

        if anonymous then username = "🕵️‍♂️ مجهول" end

        local contact_info = ""
        if add_contact then
          local input = gg.prompt({"📎 اكتب وسيلة التواصل (يوزر/رقم/رابط):"}, {""}, {"text"})
          if input and input[1] ~= "" then
            contact_info = input[1]
          end
        end

        if username ~= "" or contact_info ~= "" then
          save_info(username, contact_info, anonymous)
        end
      end
      saveAlertState() 
    end
  end
end





if not _G.start_time then _G.start_time = os.time() end  function sayedlip1() gg.clearResults() gg.setRanges(gg.REGION_ANONYMOUS) 

gg.searchNumber("5;5;5;256;104", gg.TYPE_DWORD)

  count = gg.getResultsCount() if count > 0 then gg.refineNumber("5", gg.TYPE_DWORD)  results = gg.getResults(500) for i = 1, #results - 2 do  a1, a2, a3 = results[i].address, results[i+1].address, results[i+2].address if results[i].value == 5 and results[i+1].value == 5 and results[i+2].value == 5 then if a2 == a1 + 4 and a3 == a2 + 4 then  nextAddr = a3 + 4  item = {address = nextAddr,flags = gg.TYPE_DWORD,value = 50,freeze = true,freezeType = gg.FREEZE_NORMAL} gg.addListItems({item}) gg.toast("تم تعديل "..string.format("0x%X", nextAddr).." إلى 50") end end end else


choice = gg.alert("لا يوجد نتائج", "إعادة البحث", "إلغاء", "إبلاغ عن مشكله⁉️")

if choice == 1 then

  sayedlip1()

elseif choice == 2 then
  
  frozen = false
  return homeSc()

elseif choice == 3 then
  
frozen = false
  if type(report) == "function" then
    report()
  end
  frozen = false
  return homeSc()

else
  
  frozen = false
  return homeSc()
end
end 
end



function homeSc()  name = getNameFromFile()  width = 24

  titleText = (name ~= "" and ("\t\t\t\t\tاهلا بك يا " .. name .. " في القائمه الرئيسيه")) or "\t\t\t\t\t\t\t اهلا بك في القائمه الرئيسيه"
 
  titleLine = string.rep("━", width)  header = titleLine .. "\n" .. centerText(titleText, width) .. "\n" .. titleLine   status = frozen and "✔️" or "❌"

 menu = {"🏐  تجميد الكرات  [ " .. status .. " ]","⭐  تقييم السكربت","⁉️ ابلاغ عن مشكله","🔻  خروج"}

 choice = gg.choice(menu, nil, header) if choice == nil then return end if choice == 1 then frozen = not frozen  if frozen then sayedlip1() gg.toast("التجميد مفعل") else  ok, items = pcall(gg.getListItems) if ok and items and #items > 0 then pcall(gg.removeListItems, items) end gg.toast(" التجميد غير مفعل") end
return elseif choice == 2 then if type(conecttelegram) == "function" then conecttelegram() else end elseif choice == 3 then report() elseif choice == 4 then os.exit()  end end
function conecttelegram()



local function padText(text, spaces, side)
  local pad = string.rep(" ", spaces or 0)
  if side == "left" then
    return pad .. text
  elseif side == "right" then
    return text .. pad
  else
    return text
  end
end

local function getScriptNameOnly()
  local info = debug.getinfo(2, "S") or debug.getinfo(1, "S")
  local src = info and info.source or ""
  if src:sub(1,1) == "@" then
    local fullpath = src:sub(2)
    local namefile = fullpath:match("([^/\\]+)$") or fullpath
    return namefile, fullpath
  end
  return "unknown", ""
end


local function to_json(val)
    local t = type(val)
    if t == "string" then
        return '"'..val:gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n','\\n')..'"'
    elseif t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "table" then
        local isArray = (#val > 0)
        local parts = {}
        if isArray then
            for i=1,#val do
                table.insert(parts, to_json(val[i]))
            end
            return "["..table.concat(parts, ",").."]"
        else
            for k,v in pairs(val) do
                table.insert(parts, '"'..k..'":'..to_json(v))
            end
            return "{"..table.concat(parts, ",").."}"
        end
    else
        return "null"
    end
end


local function make_contact_url(contact)
    if contact and contact ~= "" then
        return contact
    else
        return nil
    end
end


    local token = "7486988946:AAGmsDArkctGTXgeZnPeKGktuQ_ylt1lzV4"
    local chat_id = "6108279690"























local info_file = "/sdcard/Script_Rollance#v2/sv0.txt"

local function save_info(username, contact_info, anonymous)
    local tmp = info_file .. ".tmp"
    local f = io.open(tmp, "w")
    if not f then return false end
    f:write(tostring(username or "").."\n"..tostring(contact_info or "").."\n"..tostring(anonymous and "true" or "false"))
    f:close()
    os.remove(info_file)
    os.rename(tmp, info_file)
    return true
end

local function load_info()
    local f = io.open(info_file, "r")
    if not f then return nil, nil, false end

    local lines = {}
    for line in f:lines() do
        line = tostring(line):gsub("^%s+", ""):gsub("%s+$", "")
        if line ~= "" then table.insert(lines, line) end
    end
    f:close()

    local username = lines[1] or ""
    local contact_info = lines[2] or ""
    local anon_text = (lines[3] or ""):lower()
    local anonymous = (anon_text == "true" or anon_text == "1" or anon_text == "yes")

    return username, contact_info, anonymous
end
local username, contact_info, anonymous = load_info()

if not username then
    local user_input = gg.prompt(
        {"👤 اكتب اسمك:", "📎 إضافة وسيلة تواصل؟", "🕵️‍♂️ إرسال كمجهول"},
        {"", false, false},
        {"text", "checkbox", "checkbox"}
    )
    if not user_input then
        gg.alert("❌ تم الإلغاء")
        return
    end

    username = user_input[1]
    local add_contact = user_input[2]
    anonymous = user_input[3]

    if anonymous then
        username = "🕵️‍♂️ مجهول"
    elseif username == "" then
        gg.alert("⚠️ الاسم فارغ من فضلك تحقق")
        return
    end

    contact_info = "غير مضاف"
    if add_contact then
        local input = gg.prompt({"📎 اكتب وسيلة التواصل (يوزر/رقم/رابط):"}, {""}, {"text"})
        if input and input[1] ~= "" then
            contact_info = input[1]
        end
    end

 
    save_info(username, contact_info, anonymous)
end




local rate_input = gg.prompt(
    {"🌟 اختر التقييم [0; 5]", "📝 إضافة وصف مشكلة / ملاحظات"},
    {3, false},
    {"number", "checkbox"}
)

if not rate_input then
    gg.alert("❌ لم يتم إدخال تقييم")
    return
end

local stars = math.max(0, math.min(5, tonumber(rate_input[1]) or 3))
local add_notes = rate_input[2]

local status_map = {
    [0] = "❌ غير راضٍ",
    [1] = "😕 راضٍ قليلًا",
    [2] = "🙂 مقبول",
    [3] = "😃 جيد",
    [4] = "🥰 جميل",
    [5] = "🤩 ممتاز"
}
local status = status_map[stars] or "❓ غير معروف"
local desc = "لا يوجد"
local desc = nil
if stars == 0 then
    while true do
        local input = gg.prompt(
            {"✍️ بناءً على اختيارك 0 نجوم، يجب وصف مشكلتك لتحسين السكربت:", "رجوع"},
            {"", false},
            {"text", "checkbox"}
        )

     
        if not input then
            gg.alert("⚠️ لا يمكن إرسال تقييم 0 نجوم بدون وصف أو اختيار العودة!")
        else
            local text = input[1]
            local back = input[2]

          
            if back then
            
                return
            end
            
         
            if text and text ~= "" then
                desc = text
                break
            else
                gg.alert("⚠️ لا يمكن ترك خانة الوصف فارغة!")
            end
        end
    end


   

elseif add_notes then
    local input = gg.prompt({"✍️ صف مشكلتك أو ملاحظاتك:"}, {""}, {"text"})
    if input and input[1] ~= "" then
        desc = input[1]
    end
end


local percent_table = {
    [0] = 0,
    [1] = 20,
    [2] = 40,
    [3] = 60,
    [4] = 80,
    [5] = 100
}


local percent = percent_table[stars] or 0
local stars_line = string.rep("⭐", stars) .. " (" .. percent .. "%)"


desc = desc or ""
if desc == "" then desc = "لا يوجد" end


desc = desc:gsub("([^\n]+)", "     %1")



local deco  = "╭━─━─━──━─≪✠≫─━─━─━─━╮\n\n"
local deco2 = "\n\n╰━─━─━──━─≪✠≫─━─━─━─━╯"
local boxed_desc = deco .. desc .. deco2


local datetime = os.date("%d-%m-%Y %H:%M:%S")
local uptime   = os.clock()
local uptime_s = string.format("%.2f ثانية", uptime)

local contact_url = make_contact_url(contact_info)
local username_line = contact_url and ("["..username.."]("..contact_url..")") or username
local contact_line  = contact_url and ("[اضغط للدخول لوسيله التواصل]("..contact_url..")") or contact

local md = ""
md = md .. "*▭▬▭▬▭ ✦ تقييم جديد ✦ ▭▬▭▬▭*\n\n"
md = md .. "*👤 معلومات المستخدم:*\n\n"
md = md .. "📝 • الاسم: ◗" .. username_line .. "◖\n"
md = md .. "📎 • تواصل: " .. (contact_line ~= "" and contact_line or "غير مضاف") .. "\n\n"

local heading_eval_info = padText("*🌟 محتوي التقييم:*", 15, "left")
local texto = padText("──────────", 16, "left")
md = md .. heading_eval_info .. "\n\n"
md = md .. "🌟 • التقييم: " .. stars_line .. "\n"
md = md .. texto .. "\n"
md = md .. " • حاله التقييم: " .. status .. "\n\n"
local text1 = padText("⊱━━━━⊰✾⊱━━━━⊰", 16, "left")
local description1 = padText("🖊️ • الوصف:",19,"left")

md = md .. description1 .."\n\n" .. boxed_desc .. "\n\n"
md = md .. "" .. text1 .. "\n\n"
local heading_script_info = padText("*⚙️ بيانات إضافية:*", 15, "left")
md = md .. heading_script_info .. "\n\n"
md = md .. "🕒 • وقت الإرسال: `" .. datetime .. "`\n"
md = md .. "⏱️ • مدة التشغيل: `" .. uptime_s .. "`\n\n"
md = md .. "┄┄┄┈┈┈──────⍟─────┈┈┈┄┄"
local namefile = getScriptNameOnly()
md = md .. "`" .. namefile .. "`\n"
md = md .. "┄┄┄┈┈┈──────⍟─────┈┈┈┄┄"

local reply_markup = nil
if contact_url then
    reply_markup = {
        inline_keyboard = {
            {
                { text = " 📎 رابط التواصل ", url = contact_url }
            }
        }
    }
end


local payload = {
    chat_id = chat_id,
    parse_mode = "Markdown",
    text = md
}
if reply_markup then payload.reply_markup = reply_markup end


local body = to_json(payload)

gg.alert(md)

local url = "https://api.telegram.org/bot"..token.."/sendMessage"
local headers = { ["Content-Type"] = "application/json" }
local res = gg.makeRequest(url, headers, body)

if res and res.code == 200 then
    gg.alert("\nوصل تقييمك بنجاح للمطور 📨\n\nشكرا علي وقتك ♥️","")
else
    gg.alert("❌ فشل: "..tostring((res and res.content) or res))
end




  end 






local function urlencode(s)
    if not s then return "" end
    s = tostring(s)
    s = s:gsub("\n","%%0A")
    s = s:gsub("([^%w _%%%-%.~])", function(c) return string.format("%%%02X", string.byte(c)) end)
    s = s:gsub(" ","%%20")
    return s
end
local function detectAndroidVersion()
    local v = ""
    local ok,pipe = pcall(io.popen, "getprop ro.build.version.release 2>/dev/null")
    if ok and pipe then
        local out = pipe:read("*l") or ""
        pipe:close()
        out = tostring(out):gsub("^%s+",""):gsub("%s+$","")
        if out ~= "" then v = out end
    end
    return v
end

local function try_getprop(key)
  local ok, pipe = pcall(io.popen, "getprop "..key.." 2>/dev/null")
  if not ok or not pipe then return "" end
  local out = pipe:read("*a") or ""
  pipe:close()
  out = tostring(out):gsub("^%s+",""):gsub("%s+$","")
  return out
end

local function fnv1a32_hex(str)
  local fnv = 0x811c9dc5
  for i=1,#str do
    fnv = (fnv ~ string.byte(str, i)) * 0x01000193
    fnv = fnv % 0x100000000
  end
  return string.format("%08x", fnv)
end

local function get_process_fields()
  local arch="unknown"; local pkg="unknown"; local ver="unknown"
  local ok, info = pcall(gg.getTargetInfo)
  if ok and info then
    pkg = info.packageName or pkg
    ver = tostring(info.versionName or info.versionCode or ver)
    if info.x64~=nil then arch = info.x64 and "64" or "32"
    elseif info.is64~=nil then arch = info.is64 and "64" or "32"
    elseif type(info.arch)=="string" then arch = info.arch end
  end
  return pkg, ver, arch
end

local function detectAndroidVersion()
  local v = try_getprop("ro.build.version.release")
  if v == "" then v = try_getprop("ro.build.version.sdk") end
  return v or ""
end

local function try_serial()
  local s = try_getprop("ro.serialno")
  if s == "" then s = try_getprop("ro.boot.serialno") end
  if s == "" then
    local ok, p = pcall(io.popen, "settings get secure android_id 2>/dev/null")
    if ok and p then s = (p:read("*a") or "") p:close() s = tostring(s):gsub("^%s+",""):gsub("%s+$","") end
  end
  return s or ""
end



local function getProcessInfo()
    local arch="غير معروف"; local pkg="غير متاح"; local ver="غير متاح"
    local ok,info = pcall(gg.getTargetInfo)
    if ok and info then
        pkg = info.packageName or pkg
        ver = info.versionName or info.versionCode or ver
        if info.x64~=nil then arch = info.x64 and "64 بت" or "32 بت"
        elseif info.is64~=nil then arch = info.is64 and "64 بت" or "32 بت"
        elseif type(info.arch)=="string" then
            local a = info.arch:lower()
            if a:find("64") or a:find("aarch64") then arch = "64 بت" else arch = "32 بت" end
        elseif type(info.abi)=="string" then
            local a = info.abi:lower()
            if a:find("64") then arch="64 بت" else arch="32 بت" end
        else
            pcall(function()
                gg.setRanges(gg.REGION_ANONYMOUS)
                gg.searchNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
                local r = gg.getResults(1)
                if r and r[1] and r[1].address then
local addr = tonumber(r[1].address) or 0
if addr > 0xFFFFFFFF then arch = "64 بت" else arch = "32 بت" end
                   
                end
                gg.clearResults()
            end)
        end
    end
    return arch, pkg, tostring(ver)
end
local info_file = "/sdcard/Script_Rollance#v2/sv0.txt"
local function load_info()
    local f = io.open(info_file,"r")
    if f then
        local name = f:read("*l") or ""
        local contact = f:read("*l") or ""
        local anon = f:read("*l")=="true"
        f:close()
        return name, contact, anon
    end
    return "", "", false
end
if not _G.start_time then _G.start_time = os.time() end
local function getUptime()
    local t = os.time() - _G.start_time
    local h = math.floor(t/3600); local m = math.floor((t%3600)/60); local s = t%60
    return string.format("%02d:%02d:%02d", h, m, s)
end
local function make_contact_url(c)
    if not c or c=="" then return nil end
    c = tostring(c):gsub("^%s+",""):gsub("%s+$","")
    if c:match("^@") then return "https://t.me/"..c:sub(2) end
    if c:match("^https?://") then return c end
    if c:match("^t%.me") then return "https://"..c end
    if c:match("^telegram%.me") then return "https://"..c end
    return nil
end
local function random_id(len)
  local cs="abcdefghijklmnopqrstuvwxyz0123456789"
  local t={}
  math.randomseed(os.time() + (os.clock()*1000000))
  for i=1,len do t[i]=cs:sub(math.random(1,#cs),math.random(1,#cs)) end
  return table.concat(t)
end


local function choose_dir()
  local candidates = {
    "/data/data/com.termux/files",
    "/Script_Rollance#v2/sdcard"
  }
  end
local function get_reporter_file_path()
  local dir = choose_dir()
  if not dir then return nil end
  return dir .. "/$.dat"
end

local function read_file(path)
  local f = io.open(path,"r")
  if not f then return nil end
  local s = f:read("*l")
  f:close()
  if s and s~="" then return s end
  return nil
end

local function write_file(path, content)
  local f = io.open(path,"w")
  if not f then return false end
  f:write(content.."\n")
  f:close()
  return true
end

function get_or_create_reporter_id()
  local path = get_reporter_file_path()
  if path then
    local existing = read_file(path)
    if existing then return existing, path end
    local id = random_id(12)
    local ok = write_file(path, id)
    if ok then return id, path end
  end

  local sd = "/sdcard/Script_Rollance#v2/$.dat"
  local ex = read_file(sd)
  if ex then return ex, sd end
  local newid = random_id(12)
  write_file(sd, newid)
  return newid, sd
end


function report()
local reporter_id, reporter_path = get_or_create_reporter_id()
    local token = "7486988946:AAGmsDArkctGTXgeZnPeKGktuQ_ylt1lzV4"
    local chat_id = "6108279690"
    local name, contact, anon = load_info()
    if anon then name = "🕵️‍♂️ مجهول" end
    if name=="" then name="غير معروف" end
    if contact=="" then contact="غير مضاف" end
    local detected_arch, detected_pkg, detected_app_ver = getProcessInfo()
    if not detected_arch or detected_arch=="" then detected_arch="غير معروف" end
    if not detected_pkg or detected_pkg=="" then detected_pkg="غير متاح" end
    if not detected_app_ver or detected_app_ver=="" then detected_app_ver="غير متاح" end
    local detected_android = detectAndroidVersion()
    if not detected_android or detected_android=="" then detected_android = "غير محدد" end
    local choice = gg.choice({"1. مشكلة في كود البحث (Search)","2. مشكلة في الكود عامة (General)","3. مشكلة أخرى"},nil,"اختر نوع المشكلة:")
    if not choice then gg.toast("تم الإلغاء") return end
    local type_label = (choice==1) and "مشكلة في كود البحث" or (choice==2) and "مشكلة في الكود عامة" or "مشكلة أخرى"
    local initial_arch = detected_arch.." (من البحث)"
    local initial_android = detected_android ~= "غير محدد" and (detected_android.." (من البحث)") or "غير محدد"
    local initial_app = detected_app_ver.." (من البحث)"
    local archField = initial_arch; local androidField = initial_android; local appField = initial_app
    while true do
        local pr = gg.prompt({"📟 نوع البت:  64 أو 32  ","📱 إصدار أندرويد:","🎮 إصدار اللعبه:","الفحص التلقائي"},{archField,androidField,appField,false},{"text","text","text","checkbox"})
        if not pr then gg.toast("تم الإلغاء") return end
        local raw_arch = tostring(pr[1] or ""):gsub("%s+$","")
        local raw_android = tostring(pr[2] or ""):gsub("%s+$","")
        local raw_app = tostring(pr[3] or ""):gsub("%s+$","")
        local do_auto = pr[4]
        if do_auto then
            raw_arch = initial_arch; raw_android = initial_android; raw_app = initial_app
            local conf = gg.prompt({"🔎 نوع البت:  64 أو 32  ","🔎 إصدار اندرويد:","🔎 اصدار اللعبه:"},{raw_arch,raw_android,raw_app},{"text","text","text"})
            if not conf then gg.toast("تم الإلغاء") return end
            raw_arch = tostring(conf[1] or ""):gsub("%s+$","")
            raw_android = tostring(conf[2] or ""):gsub("%s+$","")
            raw_app = tostring(conf[3] or ""):gsub("%s+$","")
        end
        local function strip(s) return tostring(s):gsub("%s*%(%s*من البحث%s*%)%s*$","") end
        local v_arch = strip(raw_arch)
        local v_android = strip(raw_android)
        local v_app = strip(raw_app)
        if v_android==nil or v_android=="" or v_android=="غير محدد" or not v_android:match("^%d+$") then
            archField = raw_arch; androidField = raw_android; appField = raw_app
            gg.alert("إصدار اندرويد غير صحيح من فضلك قم بفحص اصدار اندرويد الخاص بك وكتابته لتحديد المشكله بشكل دقيق")
        else
            local edited_arch = (raw_arch ~= initial_arch)
            local edited_android = (raw_android ~= initial_android)
            local edited_app = (raw_app ~= initial_app)
            local tag_arch = (not edited_arch and detected_arch~="غير معروف") and " (من البحث)" or ""
            local tag_android = (not edited_android and detected_android~="غير محدد") and " (من البحث)" or ""
            local tag_app = (not edited_app and detected_app_ver~="غير متاح") and " (من البحث)" or ""
            local final_pkg = detected_pkg
            pcall(function() local info=gg.getTargetInfo() if info and info.packageName then final_pkg=info.packageName end end)
            
            
            
            
local function to_json(tbl)
    local function esc(str)
        return '"'..tostring(str):gsub('"','\\"')..'"'
    end
    local parts = {}
    for k,v in pairs(tbl) do
        local key = esc(k)
        local value
        if type(v) == "table" then
            value = to_json(v)
        else
            value = esc(v)
        end
        table.insert(parts, key..":"..value)
    end
    return "{"..table.concat(parts, ",").."}"
end
            
            
           
function padText(text, spaces, side)
  local pad = string.rep(" ", spaces)
  if side == "left" then
    return pad .. text
  elseif side == "right" then
    return text .. pad
  else
    return text 
  end
end



            
local contact_url = make_contact_url(contact)
local username_line = ""
if contact_url then
    username_line = "["..name.."]("..contact_url..")"
else
    username_line = name
end

local contact_line = contact_url and ("[اضغط للدخول لوسيله التواصل]("..contact_url..")") or contact
local datetime = os.date("%d-%m-%Y %H:%M:%S")
local uptime = getUptime()
local last_search = (_G.search_log and #_G.search_log>0) and _G.search_log[#_G.search_log] or "لا يوجد"
local function padText(text, spaces, side)
  local pad = string.rep(" ", spaces or 0)
  if side == "left" then
    return pad .. text
  elseif side == "right" then
    return text .. pad
  else
    return text
  end
end


local results = gg.getResultsCount()
local memory = collectgarbage("count") / 1024
local system_status = "💾 • ذاكرة: " .. string.format("%.2f MB", memory)
local system_status2 = "📊 • نتائج GG: " .. results ..""


local md = ""
md = md .. "▭▬▭▬▭ ✦ *بلاغ جديد* ✦ ▭▬▭▬▭\n\n"
md = md .. "*👤 معلومات المبلّغ:*\n\n"
md = md .. "📝 • الاسم: ◗" .. username_line .. "◖\n"
md = md .. "📎 • تواصل: " .. (contact_url and contact_line or contact) .. "\n\n"

local heading_game_info   = padText("*📱 معلومات اللعبه:*", 15, "left")
local heading_report_info = padText("*⚠️ تفاصيل البلاغ:*", 15, "left")
local heading_script_info = padText("*⚙️ معلومات السكربت:*", 15, "left")

md = md .. heading_game_info .. "\n\n"
md = md .. "📦 • اسم الحزمة: `" .. (final_pkg or "غير متاح") .. "`\n"
md = md .. "🔖 • إصدار اللعبه : `" .. (v_app~="" and v_app or detected_app_ver) .. "`" .. tag_app .. "\n"
md = md .. "🏗️ • معدل بت البرنامج: `" .. (v_arch~="" and v_arch or detected_arch) .. "`" .. tag_arch .. "\n"
md = md .. "🤖 • إصدار أندرويد: `" .. (v_android~="" and v_android or detected_android) .. "`" .. tag_android .. "\n\n"
md = md .. heading_report_info .. "\n\n"
md = md .. "📂 • نوع المشكله: " .. type_label .. "\n"
md = md .. "─────────────────\n\n"
local desc = gg.prompt({"📝 اكتب وصف المشكلة:"},{""},{"text"})
if not desc or not desc[1] or desc[1]:match("^%s*$") then
  gg.alert("الوصف مطلوب")
  return
end

local description = desc[1] or "مفيش وصف"  

description = description:gsub("([^\n]+)", "     %1")
local label = padText("🖊️ • الوصف:", 15, "left")
local text1 = padText("⊱━━━━⊰✾⊱━━━━⊰", 16, "left")
local deco = "╭━─━─━──━─≪✠≫─━─━─━─━╮\n"
local deco2 = "\n╰━─━─━──━─≪✠≫─━─━─━─━╯"

local boxed_desc = deco .. "\n" .. description .. "\n" .. deco2

md = md .. "*" .. label .. "*\n\n" .. boxed_desc .. "\n\n"

md = md .. "" .. text1 .. "\n\n"

md = md .. heading_script_info .. "\n\n"
md = md .. "• معرف المبلغ: `" .. (reporter_id or "غير متاح") .. "`\n\n"
md = md .. "⏱️ • مدة تشغيل السكربت: `" .. uptime .. "`\n"
md = md .. system_status .. "\n"
md = md .. "🔎 • آخر بحث: `" .. last_search .. "`\n"
md = md .. system_status2 .. "\n"
md = md .. "🕒 • وقت الإرسال: `" .. datetime .. "`\n\n"
md = md .. "┄┄┄┈┈┈──────⍟─────┈┈┈┄┄"
local namefile = getScriptNameOnly()
md = md .. "`" .. namefile .. "`\n"
md = md .. "┄┄┄┈┈┈──────⍟─────┈┈┈┄┄"


local function to_json(val)
    local t = type(val)
    if t == "string" then
        return '"'..val:gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n','\\n')..'"'
    elseif t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "table" then
        local isArray = (#val > 0)
        local parts = {}
        if isArray then
            for i=1,#val do
                table.insert(parts, to_json(val[i]))
            end
            return "["..table.concat(parts, ",").."]"
        else
            for k,v in pairs(val) do
                table.insert(parts, '"'..k..'":'..to_json(v))
            end
            return "{"..table.concat(parts, ",").."}"
        end
    else
        return "null"
    end
end


local function to_json(val)
    local t = type(val)
    if t == "string" then
        return '"'..val:gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n','\\n')..'"'
    elseif t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "table" then
        local isArray = (#val > 0)
        local parts = {}
        if isArray then
            for i=1,#val do
                table.insert(parts, to_json(val[i]))
            end
            return "["..table.concat(parts, ",").."]"
        else
            for k,v in pairs(val) do
                table.insert(parts, '"'..k..'":'..to_json(v))
            end
            return "{"..table.concat(parts, ",").."}"
        end
    else
        return "null"
    end
end






local function make_contact_url(contact)
    if contact and contact ~= "" then
        return contact
    else
        return nil
    end
end


local contact_url = make_contact_url(contact)

local reply_markup = nil
if contact_url then
    reply_markup = {
        inline_keyboard = {
            {
                { text = " 📎 رابط التواصل ", url = contact_url }
            }
        }
    }
end


local payload = {
    chat_id = chat_id,
    parse_mode = "Markdown",
    text = md
}


if reply_markup then
    payload.reply_markup = reply_markup
end

local body = to_json(payload)

gg.alert(md)
local url = "https://api.telegram.org/bot"..token.."/sendMessage"
local headers = { ["Content-Type"] = "application/json" }

local res = gg.makeRequest(url, headers, body)

if res and res.code == 200 then
    gg.alert("✅ تم إرسال البلاغ مع الزر")
    return homeSc()
else
    gg.alert("❌ فشل: "..tostring((res and res.content) or res))
end     
break
        end
    end
end








while true do
  if gg.isVisible(true) then
    gg.setVisible(false)
    homeSc()
  end
  gg.sleep(100)
end