#### Exercise Answers ####

#### Day 3 ####

# 1-
data(meuse)
meuse %>%
  ggplot(aes(x, y)) +
  geom_point(aes(size=zinc), color="blue", alpha=3/4) +
  ggtitle("Zinc Concentration (ppm)") +
  labs(x = NULL, y = NULL) +
  coord_equal() + # so it balances the coordinates
  theme_minimal()

coordinates(meuse) <- ~ x + y
class(meuse)

# 2- Fit a variogram
# TIP: Formula log(zinc)~1
# model for fit vgm(1, "Sph", 900, 1)

zinc_f <- as.formula(log(zinc)~1)

zinc_var <- variogram(zinc_f, meuse) # calculates sample variogram values

zinc_fit <- fit.variogram(zinc_var, model=vgm(1, "Sph", 900, 1)) # fit model

# 3- Plot to assess fit
plot(zinc_var, zinc_fit)

# 4- Load grid data
data("meuse.grid")

# 5- Plot meuse and meuse.grid with ggplot2
# It can be individually or together in the same plot
#

meuse %>%
  as_tibble() %>%
  ggplot(aes(x, y)) +
  geom_point(size=1) +
  coord_equal() +
  ggtitle("Points with measurements")

meuse.grid %>%
  ggplot(aes(x, y)) +
  geom_point(size=.1) +
  coord_equal() +
  ggtitle("Points at which to estimate")


# 6- Compute Kriging
coordinates(meuse.grid) <- ~ x + y
zinc_krg <- krige(zinc_f, meuse, meuse.grid, model=zinc_fit)

# 7- Plot the results
zinc_krg %>%
  as_tibble() %>%
  ggplot(aes(x, y)) +
  geom_tile(aes(fill=var1.pred)) +
  coord_equal() +
  scale_fill_gradient(low = "yellow", high="red") +
  theme_minimal()
