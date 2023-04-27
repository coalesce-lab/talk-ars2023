# Figures for the presentation



# Dunbar's alters ---------------------------------------------------------

# Dunbar's circles with approximately correct number of alters in each circle.

library(igraph)
library(graphlayouts)
library(ggraph)

circle_names <-   c("support", "sympathy", "affinity", "active", "acquaintances")
alters <- factor(
  rep(circle_names, c(5, 15, 50, 150, 500)),
  levels = circle_names
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
  centrality = match(V(g)$circle, rev(circles), nomatch = 6) |>
    jitter()
) +
  draw_circle(use = "cent") +
  geom_edge_link0(color = "gray90") +
  geom_node_point(aes(fill = circle), color = "white", size = 5, shape = 21) +
  theme_void() +
  scale_fill_discrete(name = "Dunbar's circle")

