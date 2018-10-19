local fs = require "nixio.fs"
local custom_forward_file = "/etc/dnsmasq.ssr/custom_forward.conf"

m = SimpleForm("custom", translate("GFW Custom List"))

s = m:field(TextValue, "conf")
s.rmempty = true
s.rows = 25
function s.cfgvalue()
	return fs.readfile(custom_forward_file) or ""
end

function m.handle(self, state, data)
	if state == FORM_VALID then
		if data.conf then
			fs.writefile(custom_forward_file, data.conf:gsub("\r\n", "\n"))
			luci.sys.call("/etc/init.d/dnsmasq restart && ipset flush gfwlist")
		end
	end
	return true
end

return m