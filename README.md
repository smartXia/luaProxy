# idg-tpl-empty

-- key appid value 对应的端口号和请求path 如果只有端口号直接 描述 
-- appids["register_center"] = ":9090"
-- 暂不支持 直接请求跨sdk访问

appids["doatnnuotjlwbh6r83jed1m7yvwrps5q"] = ":80/account/webroot"
appids["sihpkp4z3rg7wvsozr5lkta9nxxiocqj"] = ":80/ucenter/webroot"
appids["dwvzflvcgqgkmtqumindtwrylbakozn3"] = ":80/acl/webroot"

function GetAppidsInfo()
    return appids
end