#import "lib.typ" as hy

#{
  assert(hy.exists("fr"))
  assert(not hy.exists("xz"))
}

#{
  assert(hy.syllables("hyphenation") == ("hy", "phen", "ation"))
  assert(hy.syllables("hydrogen") == ("hy", "dro", "gen"))
  assert(hy.syllables("hydrogène", lang: "fr") == ("hy", "dro", "gène"))
}

#{
  hy.syllables("hyphenation", lang: "xz", fallback: "en")
}
