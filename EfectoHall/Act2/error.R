library(dplyr)
library(broom)  # Para análisis de modelos

data <- read.csv("./general.csv")

# 1. Calcular métricas de error detalladas para cada regresión
metricas_error <- data %>%
  group_by(Tipo, Corriente) %>%
  do({
    modelo <- lm(Voltaje_Hall ~ Corriente_Ip, data = .)
    
    # Predicciones y residuales
    predicciones <- predict(modelo)
    residuales <- residuals(modelo)
    n <- nrow(.)
    p <- length(coef(modelo)) - 1  # número de predictores
    
    # Métricas de error
    data.frame(
      # Errores absolutos
      MAE = mean(abs(residuales)),  # Error Absoluto Medio
      MSE = mean(residuales^2),     # Error Cuadrático Medio
      RMSE = sqrt(mean(residuales^2)),  # Raíz del Error Cuadrático Medio
      
      # Errores relativos
      MAPE = mean(abs(residuales/.$Voltaje_Hall)) * 100,  # Error Porcentual Absoluto Medio
      
      # Coeficientes de determinación
      R2 = summary(modelo)$r.squared,
      R2_ajustado = summary(modelo)$adj.r.squared,
      
      # Información del modelo
      AIC = AIC(modelo),
      BIC = BIC(modelo),
      
      # Pruebas de normalidad de residuales
      Shapiro_p = shapiro.test(residuales)$p.value,
      
      # Intervalos de confianza para la pendiente
      Pendiente = coef(modelo)[2],
      Pendiente_SE = summary(modelo)$coefficients[2, 2],
      Pendiente_IC_inf = confint(modelo)[2, 1],
      Pendiente_IC_sup = confint(modelo)[2, 2],
      
      # Número de observaciones
      n_observaciones = n
    )
  })

# Mostrar métricas de error
print(metricas_error)

# 2. Análisis de varianza (ANOVA) para cada modelo
anova_analysis <- data %>%
  group_by(Tipo, Corriente) %>%
  do({
    modelo <- lm(Voltaje_Hall ~ Corriente_Ip, data = .)
    anova_result <- anova(modelo)
    data.frame(
      F_value = anova_result$`F value`[1],
      p_value = anova_result$`Pr(>F)`[1],
      Suma_cuadrados = anova_result$`Sum Sq`[1],
      Media_cuadrados = anova_result$`Mean Sq`[1]
    )
  })

print(anova_analysis)

# 3. Validación cruzada leave-one-out para estimar error real
library(caret)

cv_errors <- data %>%
  group_by(Tipo, Corriente) %>%
  do({
    subdata <- .
    if(nrow(subdata) > 2) {
      # Configurar validación cruzada leave-one-out
      train_control <- trainControl(method = "LOOCV")
      
      # Entrenar modelo con CV
      model_cv <- train(Voltaje_Hall ~ Corriente_Ip, 
                       data = subdata, 
                       method = "lm", 
                       trControl = train_control)
      
      data.frame(
        CV_RMSE = model_cv$results$RMSE,
        CV_R2 = model_cv$results$Rsquared,
        CV_MAE = model_cv$results$MAE
      )
    } else {
      data.frame(
        CV_RMSE = NA,
        CV_R2 = NA,
        CV_MAE = NA
      )
    }
  })

print(cv_errors)

# 4. Gráficos de diagnóstico de residuales
diagnostic_plots <- function(data) {
  par(mfrow = c(2, 2))
  modelo <- lm(Voltaje_Hall ~ Corriente_Ip, data = data)
  plot(modelo)
  par(mfrow = c(1, 1))
}

# Aplicar a cada grupo
data %>%
  group_by(Tipo, Corriente) %>%
  group_walk(~ {
    cat("\nDiagnóstico para:", .y$Tipo, "- Corriente:", .y$Corriente, "\n")
    diagnostic_plots(.x)
  })

# 5. Tabla resumen completa de precisión
resumen_precision <- metricas_error %>%
  left_join(anova_analysis, by = c("Tipo", "Corriente")) %>%
  left_join(cv_errors, by = c("Tipo", "Corriente")) %>%
  mutate(
    # Interpretación de la calidad del modelo
    Calidad_R2 = case_when(
      R2 > 0.9 ~ "Excelente",
      R2 > 0.7 ~ "Buena",
      R2 > 0.5 ~ "Moderada",
      TRUE ~ "Pobre"
    ),
    # Significancia estadística
    Significativo = p_value < 0.05,
    # Normalidad de residuales
    Residuales_normales = Shapiro_p > 0.05
  )

# Mostrar resumen completo
print(resumen_precision)

# 6. Gráfico de comparación de errores entre modelos
ggplot(resumen_precision, aes(x = Corriente, y = RMSE, fill = Calidad_R2)) +
  geom_col() +
  facet_wrap(~ Tipo) +
  labs(title = "Comparación de Error RMSE entre Modelos",
       x = "Corriente (A)",
       y = "RMSE",
       fill = "Calidad del Modelo") +
  theme_minimal()

# 7. Exportar resultados a CSV
write.csv(resumen_precision, "precision_regresiones.csv", row.names = FALSE)
