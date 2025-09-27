library(tidyverse)
data <- read.csv("./general.csv")
#
# Función para evaluación rápida
evaluar_modelo <- function(modelo, datos) {
  residuales <- residuals(modelo)
  r2 <- summary(modelo)$r.squared
  rmse <- sqrt(mean(residuales^2))
  
  cat("R²:", round(r2, 4), "\n")
  cat("RMSE:", round(rmse, 6), "\n")
  cat("MAE:", round(mean(abs(residuales)), 6), "\n")
  cat("¿Modelo significativo? (p < 0.05):", anova(modelo)$'Pr(>F)'[1] < 0.05, "\n")
}

# Aplicar a cada grupo
data %>%
  group_by(Tipo, Corriente_Ip) %>%
  group_map(~ {
    cat("\n=== Modelo:", .y$Tipo, "-", .y$Corriente_Ip, "===\n")
    modelo <- lm(Voltaje_Hall ~ Corriente, data = .x)
    evaluar_modelo(modelo, .x)
  })
