# Tweaks just for the Toothbleach theme

# No underline on titles
.styles |= with_entries(if (.key | test("^title[1-9]$")) and (.value | has("underlineStyle")) then .value |= del(.underlineStyle) else . end)
