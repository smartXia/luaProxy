-- 注意 lua 文件引用需要在nginx的配置文件配置lua 的路径
-- 在 lua_package_path "/usr/local/openresty/nginx/lua_file/?.lua;;";

local _Mo = {}

-- key appid value 对应的端口号和请求path 如果只有端口号直接 描述
-- appids["register_center"] = ":9090"
-- 暂不支持 直接请求跨sdk访问
-- 8083 注册中心端口号如没必要默认不开启

-- appids["doatnnuotjlwbh6r83jed1m7yvwrps5q"] = ":80/account/webroot"
-- appids["sihpkp4z3rg7wvsozr5lkta9nxxiocqj"] = ":80/ucenter/webroot"
-- appids["dwvzflvcgqgkmtqumindtwrylbakozn3"] = ":80/acl/webroot"
function _Mo.GetAppidsInfo()
        local appids = {}
        appids["register_center"] = ":8083/"
        appids["doatnnuotjlwbh6r83jed1m7yvwrps5q"] = ":8081"
        return appids
end

return _Mo
