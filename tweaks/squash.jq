# Copyright (c) Daniel Terhorst-North
# Downloaded from https://github.com/tastapod/np-squash on 2025-08-31 at 14:30

# Metadata
.name += " Squashed"

| . += {
    squashedBy: {
        name: "np-squash",
        date: (now | todateiso8601)
    }
}

# Body text (negative spacing brings paragraph blocks closer together)
| .styles.["body", "tabbed"] += {
    paragraphSpacing: 0,
}

# Headings
| .styles.["title-mark1", "title-mark2", "title-mark3", "title-mark4"] += {
    paragraphSpacing: 3
}

# Tasks
| .styles.["checked", "todo", "flagged-1", "flagged-2", "flagged-3"] += {
    paragraphSpacing: 3,
}

# Tags
| .styles.["attag", "hashtag"] += {
    paragraphSpacing: 0
}
