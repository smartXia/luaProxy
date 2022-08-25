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





如有任何问题 issue联系  此 项目 lua 主要用来充当注册中心作用（不同项目之间互相调用，极大的利用了docker 多个镜像同时开启多个内部网络端口）