# Cargar librerías necesarias
library(dplyr)
library(ggplot2)

data_temperatura <- read.csv("./general.csv")

# Función para encontrar la región más lineal y calcular pendiente
calcular_pendiente_lineal <- function(x, y, ventana = 5) {
  # Calcular pendientes para todas las ventanas posibles
  pendientes <- numeric(length(x) - ventana + 1)
  correlaciones <- numeric(length(x) - ventana + 1)
  
  for(i in 1:(length(x) - ventana + 1)) {
    idx <- i:(i + ventana - 1)
    modelo <- lm(y[idx] ~ x[idx])
    pendientes[i] <- coef(modelo)[2]
    correlaciones[i] <- cor(x[idx], y[idx])
  }
  
  # Encontrar la ventana con mejor correlación lineal
  mejor_idx <- which.max(abs(correlaciones))
  idx_final <- mejor_idx:(mejor_idx + ventana - 1)
  
  # Ajustar modelo final en la mejor ventana
  modelo_final <- lm(y[idx_final] ~ x[idx_final])
  
  return(list(
    pendiente = coef(modelo_final)[2],
    intercepto = coef(modelo_final)[1],
    r_cuadrado = summary(modelo_final)$r.squared,
    indices = idx_final
  ))
}

# Separar datos por tipo
germanio_n <- data_temperatura %>% filter(Tipo == "Germanio n")
germanio_p <- data_temperatura %>% filter(Tipo == "Germanio p")

# Calcular pendientes para Voltaje_Hall vs Temperatura
pendiente_hall_n <- calcular_pendiente_lineal(germanio_n$Temperatur, germanio_n$Voltaje_Hall)
pendiente_hall_p <- calcular_pendiente_lineal(germanio_p$Temperatur, germanio_p$Voltaje_Hall)

# Calcular pendientes para Voltaje_Longitudinal vs Temperatura
pendiente_long_n <- calcular_pendiente_lineal(germanio_n$Temperatur, germanio_n$Voltaje_Longitudinal)
pendiente_long_p <- calcular_pendiente_lineal(germanio_p$Temperatur, germanio_p$Voltaje_Longitudinal)

# Mostrar resultados
cat("=== PENDIENTES VOLTAJE HALL vs TEMPERATURA ===\n")
cat("Germanio n:", round(pendiente_hall_n$pendiente, 6), "(R² =", round(pendiente_hall_n$r_cuadrado, 4), ")\n")
cat("Germanio p:", round(pendiente_hall_p$pendiente, 6), "(R² =", round(pendiente_hall_p$r_cuadrado, 4), ")\n\n")

cat("=== PENDIENTES VOLTAJE LONGITUDINAL vs TEMPERATURA ===\n")
cat("Germanio n:", round(pendiente_long_n$pendiente, 6), "(R² =", round(pendiente_long_n$r_cuadrado, 4), ")\n")
cat("Germanio p:", round(pendiente_long_p$pendiente, 6), "(R² =", round(pendiente_long_p$r_cuadrado, 4), ")\n")

# Visualizar las regiones lineales encontradas
par(mfrow = c(2, 2))

# Germanio n - Voltaje Hall
plot(germanio_n$Temperatur, germanio_n$Voltaje_Hall, main = "Germanio n - Voltaje Hall",
     xlab = "Temperatura", ylab = "Voltaje Hall", pch = 16)
points(germanio_n$Temperatur[pendiente_hall_n$indices], 
       germanio_n$Voltaje_Hall[pendiente_hall_n$indices], 
       col = "red", pch = 16, cex = 1.5)
abline(pendiente_hall_n$intercepto, pendiente_hall_n$pendiente, col = "red", lwd = 2)

# Germanio p - Voltaje Hall
plot(germanio_p$Temperatur, germanio_p$Voltaje_Hall, main = "Germanio p - Voltaje Hall",
     xlab = "Temperatura", ylab = "Voltaje Hall", pch = 16)
points(germanio_p$Temperatur[pendiente_hall_p$indices], 
       germanio_p$Voltaje_Hall[pendiente_hall_p$indices], 
       col = "red", pch = 16, cex = 1.5)
abline(pendiente_hall_p$intercepto, pendiente_hall_p$pendiente, col = "red", lwd = 2)

# Germanio n - Voltaje Longitudinal
plot(germanio_n$Temperatur, germanio_n$Voltaje_Longitudinal, main = "Germanio n - Voltaje Longitudinal",
     xlab = "Temperatura", ylab = "Voltaje Longitudinal", pch = 16)
points(germanio_n$Temperatur[pendiente_long_n$indices], 
       germanio_n$Voltaje_Longitudinal[pendiente_long_n$indices], 
       col = "red", pch = 16, cex = 1.5)
abline(pendiente_long_n$intercepto, pendiente_long_n$pendiente, col = "red", lwd = 2)

# Germanio p - Voltaje Longitudinal
plot(germanio_p$Temperatur, germanio_p$Voltaje_Longitudinal, main = "Germanio p - Voltaje Longitudinal",
     xlab = "Temperatura", ylab = "Voltaje Longitudinal", pch = 16)
points(germanio_p$Temperatur[pendiente_long_p$indices], 
       germanio_p$Voltaje_Longitudinal[pendiente_long_p$indices], 
       col = "red", pch = 16, cex = 1.5)
abline(pendiente_long_p$intercepto, pendiente_long_p$pendiente, col = "red", lwd = 2)
