# Cargar librerías necesarias
library(ggplot2)
library(dplyr)
library(tidyr)

# Crear data frames con los datos proporcionados

# Germanio n
germanio_n <- data.frame(
  I_m = c(0.009, 0.047, 0.096, 0.123, 0.154, 0.195, 0.225, # Ip = 0.010
          0.024, 0.075, 0.104, 0.135, 0.161, 0.194, 0.228, # Ip = -0.010
          0.016, 0.050, 0.076, 0.105, 0.144, 0.179, 0.221), # Ip = -0.025
  R_relativo = c(0.00000, -0.00267, 0.00800, 0.01333, 0.02133, 0.02667, 0.03733,
                 0.00000, 0.00205, 0.00615, 0.01230, 0.01639, 0.02254, 0.02869,
                 0.00000, 0.05458, 0.26090, 0.55230, 0.18410, 0.15450, 0.16840),
  I_p = factor(c(rep("0.010 A", 7), rep("-0.010 A", 7), rep("-0.025 A", 7)))
)

# Germanio p
germanio_p <- data.frame(
  I_m = c(0.035, 0.055, 0.075, 0.099, 0.124, 0.152, 0.177, # Ip = 0.010
          0.015, 0.040, 0.077, 0.098, 0.124, 0.140, 0.172, # Ip = -0.010
          0.017, 0.057, 0.086, 0.105, 0.124, 0.150, 0.185), # Ip = -0.025
  R_relativo = c(0.00000, 0.00291, 0.00581, 0.01744, 0.02616, 0.03488, 0.04360,
                 0.00000, 0.00000, 0.00000, 0.00480, 0.01199, 0.01918, 0.02878,
                 0.00000, 0.00428, 0.01070, 0.01497, 0.02139, 0.02995, 0.04171),
  I_p = factor(c(rep("0.010 A", 7), rep("-0.010 A", 7), rep("-0.025 A", 7)))
)

# Gráfica para Germanio n
ggplot(germanio_n, aes(x = I_m, y = R_relativo, color = I_p, shape = I_p)) +
  geom_point(size = 3) +
  geom_smooth() +
  labs(title = "Efecto Hall - Germanio n (Tipo n)",
       x = "Corriente del imán (A)",
       y = expression(frac(R[m] - R[0], R[0])),
       color = "Corriente Ip",
       shape = "Corriente Ip") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c"))

# Gráfica para Germanio p
ggplot(germanio_p, aes(x = I_m, y = R_relativo, color = I_p, shape = I_p)) +
  geom_point(size = 3) +
  geom_smooth() +
  labs(title = "Efecto Hall - Germanio p (Tipo p)",
       x = "Corriente del imán (A)",
       y = expression(frac(R[m] - R[0], R[0])),
       color = "Corriente Ip",
       shape = "Corriente Ip") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c"))

# Gráficas separadas por Ip para mejor visualización

# Germanio n por Ip separado
ggplot(germanio_n, aes(x = I_m, y = R_relativo)) +
  geom_point(size = 3, aes(color = I_p)) +
  geom_smooth(aes(color = I_p)) +
  facet_wrap(~ I_p, scales = "free") +
  labs(title = "Efecto Hall - Germanio n (Separado por Ip)",
       x = "Corriente del imán (A)",
       y = expression(frac(R[m] - R[0], R[0]))) +
  theme_minimal()
ggsave("R_m_n_I_separado.png")

# Germanio p por Ip separado
ggplot(germanio_p, aes(x = I_m, y = R_relativo)) +
  geom_point(size = 3, aes(color = I_p)) +
  geom_smooth(aes(color = I_p)) +
  facet_wrap(~ I_p, scales = "free") +
  labs(title = "Efecto Hall - Germanio p (Separado por Ip)",
       x = "Corriente del imán (A)",
       y = expression(frac(R[m] - R[0], R[0]))) +
  theme_minimal()
ggsave("R_m_p_I_separado.png")

# Gráfica comparativa ambos materiales (mismo Ip)
# Para Ip = 0.010 A
ip_010 <- rbind(
  cbind(germanio_n[germanio_n$I_p == "0.010 A", ], Material = "Germanio n"),
  cbind(germanio_p[germanio_p$I_p == "0.010 A", ], Material = "Germanio p")
)

ggplot(ip_010, aes(x = I_m, y = R_relativo, color = Material, shape = Material)) +
  geom_point(size = 3) +
  geom_smooth() +
  labs(title = "Comparación Germanio n vs p (Ip = 0.010 A)",
       x = "Corriente del imán (A)",
       y = expression(frac(R[m] - R[0], R[0]))) +
  theme_minimal() +
  scale_color_manual(values = c("#d62728", "#9467bd"))
ggsave("R_m_I_p10.png")
