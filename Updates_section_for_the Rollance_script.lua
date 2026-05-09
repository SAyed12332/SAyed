-- في ملف التحديثات الأونلاين
local choice = gg.choice({
    "🌐 تجربة قسم اللغة",
    "⁉️ تجربة نظام الإبلاغ",
    "🆕 ميزة جديدة تجريبية",
    "🔙 رجوع"
}, nil, "🧪 تجربة مميزات جديدة")

if choice == 1 then
    showAvailableLanguages()
elseif choice == 2 then
    report()
elseif choice == 3 then
    -- كود جديد تماماً بتجربه قبل ما تضيفه للسكربت
    gg.alert("هذه ميزة تجريبية!")
elseif choice == 4 then
    homeSc()
end