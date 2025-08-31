# Tweaks just for the default (Orange) theme

# Orange titles
.styles |= with_entries(
  if (.key | test("^title[1-9]$")) and (.value | has("color")) then
    .value.color = "#F08000"
  else
    .
  end
)
