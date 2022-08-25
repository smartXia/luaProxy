--1.获取header头
--2.解析jwt 获取requeststack
--3.获取第第二层的appid 判断此appid=ucenter
--4.路由到本地的ucenter目录
-- require Authorization request header
local jwt = require "resty.jwt"
local cjson = require "cjson"
local secret = "lua-resty-jwt"
local token = ngx.var.http_Authorization
local app = require "config"

appids = app.GetAppidsInfo()

function implode(split, t)
    local tab = {}
    for _, v in pairs(t) do
        table.insert(tab, v)
    end
    return table.concat(tab, split);
end

function explode(split, str)
    local str_split_tab = {}
    while true do
        local idx = string.find(str, split, 1, true);
        if nil ~= idx then
            local insert_str = '';
            if 1 == idx then
                insert_str = string.sub(str, 1, idx + #split - 1);
            else
                insert_str = string.sub(str, 1, idx - 1);
            end

            if (insert_str ~= split) and (nil ~= insert_str or '' ~= insert_str) then
                table.insert(str_split_tab, insert_str);
            end
            str = string.sub(str, idx + #split, -1);
        else
            if nil ~= str or '' ~= str then
                table.insert(str_split_tab, str);
            end
            break;
        end
    end
    return str_split_tab;
end

function quote(str)
    return "\"" .. str .. "\""
end

function length(t)
    local res = 0
    for k, v in pairs(t) do
        res = res + 1
    end
    return res
end

if token == nil then
    ngx.say("No Authorization header", "</br>")
    ngx.say("No Authorization header", "</br>")
    ngx.log(ngx.WARN, "No Authorization header")
    ngx.say("No Authorization header", "</br>")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- require Authorization request header
local auth_header = ngx.var.http_Authorization

if auth_header == nil then
    ngx.log(ngx.WARN, "No Authorization header")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
-- require Bearer token
local _, _, token = string.find(auth_header, "Bearer%s+(.+)")
if token == nil then
    ngx.log(ngx.ERR, "Missing token")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
    ngx.say("Missing token")
end


local jwt_obj = jwt:verify(secret, token)

local reqstackLength = length(jwt_obj.payload.call_stack)

if (reqstackLength < 2) then
    ngx.say("token 解析callsatack 长度小于2,无法调用下层服务 stack:",
        cjson.encode(jwt_obj.payload.call_stack))
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

local lastAppid = cjson.encode(jwt_obj.payload.call_stack[reqstackLength].appid)

--  配置文件读取app对应的信息
-- appids = GetAppidsInfo()
lastAppid = string.gsub(lastAppid, "\"", "")

if appids[lastAppid] then
    local path = appids[lastAppid]
    --   ngx.say("重定服务lastAppid:", target_appid, "</br>", "url:",path, "</br>")
    local uri = ngx.var.request_uri
    tem = explode("/", uri)
    ngx.var.md5 = tem[1]
    table.remove(tem, 1)
    trueUrl        = "/" .. implode("/", tem)
    local truePath = path .. trueUrl
    ngx.req.set_header("X-APPKEY", "appkey")
    ngx.req.set_header("X-CHANNEL", "2")
    ngx.req.set_header("X-APPID", "appid")
    ngx.header["X-APPID"]   = "appid"
    ngx.header["X-APPKEY"]  = "appkey"
    ngx.header["X-CHANNEL"] = "2"
    finUrl                  = ngx.var.scheme .. "://" .. ngx.var.host .. truePath
    ngx.var.target_url      = finUrl

    return
else
    ngx.say("匹配失败 无此服务", lastAppid)
end

-- 去掉双引号 appid  原来是“appid” 后面在table 为 appid 才能匹配到
-- doAppFunc(lastAppid)
