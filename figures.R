# Figures for the presentation



# Dunbar's alters ---------------------------------------------------------

# Dunbar's circles with approximately correct number of alters in each circle.

library(igraph)
library(graphlayouts)
library(ggraph)

circles <- c(
  support = 5,
  sympathy = 15,
  affinity = 50,
  active = 150,
  acquaintances = 500
)

alters <- factor(
  rep(names(circles), circles),
  levels = names(circles)
)
edb <- data.frame(
  ego = 1,
  alter = seq_along(alters) + 1
)

g <- graph_from_data_frame(edb, directed = FALSE)
V(g)$circle <- c(factor("ego"), alters)
V(g)$is_ego <- V(g)$circle == "ego"

# body(layout_with_centrality) |>
#   as.list()

# Set my seed
trace(layout_with_centrality, at = 8, 
      tracer = bquote(
        set.seed(666)
      )
)

ggraph(
  g, 
  layout = "centrality", 
  centrality = match(V(g)$circle, rev(names(circles)), nomatch = 6) |>
    jitter()
) +
  draw_circle(use = "cent") +
  geom_edge_link0(color = "gray90") +
  geom_node_point(aes(fill = circle), color = "white", size = 5, shape = 21) +
  theme_void() +
  scale_fill_discrete(name = "Dunbar's circle")




# Dunbar's circles #2 -----------------------------------------------------

library(tidyverse)

circles |>
  enframe() |>
  arrange(desc(value)) |>
  mutate(
    l = lead(value, default = 0),
    a = value - l,
    r = sqrt(a / pi)
  ) |>
  ggplot(aes(x=factor(1), fill=name)) +
  geom_bar(aes(y=r), width = 1, color = NA, stat = "identity") +
  coord_polar() +
  scale_fill_discrete(name = "Dunbar's circles") +
  theme_void()
