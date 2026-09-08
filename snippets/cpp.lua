local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function get_date()
  return os.date("%Y-%m-%d")
end

ls.add_snippets("cpp", {
  ls.s("st", fmt([[
/*
 * >_<
 * Powered by GhostFace@ShengFlow.
 * {}
 * Copyright (c) {} ShengFlow. All Rights Reserved.
 */
#include <iostream>
using namespace std;

int main() {{
	$1
	return 0;
}}
  ]], {
    ls.function_node(get_date),
    ls.function_node(function() return os.date("%Y") end),
  })),
})