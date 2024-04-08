-- 在状态栏中显示文件的用户/组
Status = {
	area = ui.Rect.default,
}

function Status.style()
	if cx.active.mode.is_select then
		return THEME.status.mode_select
	elseif cx.active.mode.is_unset then
		return THEME.status.mode_unset
	else
		return THEME.status.mode_normal
	end
end

function Status:mode()
	local mode = tostring(cx.active.mode):upper()
	if mode == "UNSET" then
		mode = "UN-SET"
	end

	local style = self.style()
	return ui.Line({
		ui.Span(THEME.status.separator_open):fg(style.bg),
		ui.Span(" " .. mode .. " "):style(style),
	})
end

function Status:size()
	local h = cx.active.current.hovered
	if not h then
		return ui.Line({})
	end

	local style = self.style()
	return ui.Line({
		ui.Span(" " .. ya.readable_size(h:size() or h.cha.length) .. " ")
			:fg(style.bg)
			:bg(THEME.status.separator_style.bg),
		ui.Span(THEME.status.separator_close):fg(THEME.status.separator_style.fg),
	})
end

function Status:name()
	local h = cx.active.current.hovered
	if not h then
		return ui.Span("")
	end

	return ui.Span(" " .. h.name)
end

function Status:permissions()
	local h = cx.active.current.hovered
	if not h then
		return ui.Line({})
	end

	local perm = h.cha:permissions()
	if not perm then
		return ui.Line({})
	end

	local spans = {}
	for i = 1, #perm do
		local c = perm:sub(i, i)
		local style = THEME.status.permissions_t
		if c == "-" then
			style = THEME.status.permissions_s
		elseif c == "r" then
			style = THEME.status.permissions_r
		elseif c == "w" then
			style = THEME.status.permissions_w
		elseif c == "x" or c == "s" or c == "S" or c == "t" or c == "T" then
			style = THEME.status.permissions_x
		end
		spans[i] = ui.Span(c):style(style)
	end
	return ui.Line(spans)
end

function Status:percentage()
	local percent = 0
	local cursor = cx.active.current.cursor
	local length = #cx.active.current.files
	if cursor ~= 0 and length ~= 0 then
		percent = math.floor((cursor + 1) * 100 / length)
	end

	if percent == 0 then
		percent = "  Top "
	else
		percent = string.format(" %3d%% ", percent)
	end

	local style = self.style()
	return ui.Line({
		ui.Span(" " .. THEME.status.separator_open):fg(THEME.status.separator_style.fg),
		ui.Span(percent):fg(style.bg):bg(THEME.status.separator_style.bg),
	})
end

function Status:position()
	local cursor = cx.active.current.cursor
	local length = #cx.active.current.files

	local style = self.style()
	return ui.Line({
		ui.Span(string.format(" %2d/%-2d ", cursor + 1, length)):style(style),
		ui.Span(THEME.status.separator_close):fg(style.bg),
	})
end

function Status:owner()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	})
end

function Status:render(area)
	self.area = area

	local left = ui.Line({ self:mode(), self:size(), self:name() })
	local right = ui.Line({ self:owner(), self:permissions(), self:percentage(), self:position() })
	return {
		ui.Paragraph(area, { left }),
		ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
		table.unpack(Progress:render(area, right:width())),
	}
end

-- 在标题中显示用户名和主机名
Header = {
	area = ui.Rect.default,
}

function Header:cwd(max)
	local cwd = cx.active.current.cwd
	local readable = ya.readable_path(tostring(cwd))

	local text = cwd.is_search and string.format("%s (search: %s)", readable, cwd:frag()) or readable
	return ui.Span(ya.truncate(text, { max = max, rtl = true })):style(THEME.manager.cwd)
end

function Header:count()
	local yanked = #cx.yanked

	local count, style
	if yanked == 0 then
		count = #cx.active.selected
		style = THEME.manager.count_selected
	elseif cx.yanked.is_cut then
		count = yanked
		style = THEME.manager.count_cut
	else
		count = yanked
		style = THEME.manager.count_copied
	end

	if count == 0 then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(string.format(" %d ", count)):style(style),
		ui.Span(" "),
	})
end

function Header:tabs()
	local tabs = #cx.tabs
	if tabs == 1 then
		return ui.Line({})
	end

	local spans = {}
	for i = 1, tabs do
		local text = i
		if THEME.manager.tab_width > 2 then
			text = ya.truncate(text .. " " .. cx.tabs[i]:name(), { max = THEME.manager.tab_width })
		end
		if i == cx.tabs.idx then
			spans[#spans + 1] = ui.Span(" " .. text .. " "):style(THEME.manager.tab_active)
		else
			spans[#spans + 1] = ui.Span(" " .. text .. " "):style(THEME.manager.tab_inactive)
		end
	end
	return ui.Line(spans)
end

-- TODO: remove this function after v0.2.5 release
function Header:layout(area)
	if not ya.deprecated_header_layout then
		ya.deprecated_header_layout = true
		ya.notify({
			title = "Deprecated API",
			content = "`Header:layout()` is deprecated, please apply the latest `Header:render()` in your `init.lua`",
			timeout = 5,
			level = "warn",
		})
	end

	self.area = area

	return ui.Layout()
		:direction(ui.Layout.HORIZONTAL)
		:constraints({ ui.Constraint.Percentage(50), ui.Constraint.Percentage(50) })
		:split(area)
end

function Header:host()
	if ya.target_family() ~= "unix" then
		return ui.Line({})
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end

function Header:render(area)
	self.area = area

	local right = ui.Line({ self:count(), self:tabs() })
	local left = ui.Line({ self:host(), self:cwd(math.max(0, area.w - right:width())) })
	return {
		ui.Paragraph(area, { left }),
		ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
	}
end
