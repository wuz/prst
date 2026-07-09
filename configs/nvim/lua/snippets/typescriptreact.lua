local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
  s(
    { trig = "RCC", name = "React Client Component", desc = "Scaffold for a React Client Component" },
    fmta([[
type <ComponentName>Props = {};
const <ComponentName> = (<Props>: <ComponentName>Props) =>> {
  return <Return>
}

export default <ComponentName>;
    ]], {
      ComponentName = i(1, "ComponentName", { desc = "Component Name" }),
      Props = i(2, "{}", { desc = "Component props" }),
      Return = i(3, "<div />", { desc = "The component return" }),
    }, { repeat_duplicates = true })
  ),
}
