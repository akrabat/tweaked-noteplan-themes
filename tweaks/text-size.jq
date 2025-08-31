# Text size tweaks

# set body size if $body_size exists
if $body_size then .styles.body.size = $body_size else . end

# Headings are two points smaller each time from the supplied $title1_size,
# but no smaller than the body size.
# Apply to all titles if body size is set, otherwise apply only to the defined title styles
| .styles.body.size as $min_size
| ([$title1_size - 2, $min_size] | max) as $title2_size
| ([$title1_size - 4, $min_size] | max) as $title3_size
| ([$title1_size - 6, $min_size] | max) as $title4_size
| ([$title1_size - 8, $min_size] | max) as $title5_size
| ([$title1_size - 10, $min_size] | max) as $title6_size

| if (.styles | has("title1")) or $body_size then .styles.title1.size = $title1_size else . end
| if (.styles | has("title-mark1")) or $body_size then .styles.["title-mark1"].size = $title1_size else . end
| if (.styles | has("title2")) or $body_size then .styles.title2.size = $title2_size else . end
| if (.styles | has("title-mark2")) or $body_size then .styles.["title-mark2"].size = $title2_size else . end
| if (.styles | has("title3")) or $body_size then .styles.title3.size = $title3_size else . end
| if (.styles | has("title-mark3")) or $body_size then .styles.["title-mark3"].size = $title3_size else . end
| if (.styles | has("title4")) or $body_size then .styles.title4.size = $title4_size else . end
| if (.styles | has("title-mark4")) or $body_size then .styles.["title-mark4"].size = $title4_size else . end
| if (.styles | has("title5")) or $body_size then .styles.title5.size = $title5_size else . end
| if (.styles | has("title-mark5")) or $body_size then .styles.["title-mark5"].size = $title5_size else . end
| if (.styles | has("title6")) or $body_size then .styles.title6.size = $title6_size else . end
| if (.styles | has("title-mark6")) or $body_size then .styles.["title-mark6"].size = $title6_size else . end
