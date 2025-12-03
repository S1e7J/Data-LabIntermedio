import numpy as np
import matplotlib.pyplot as plt

# Datos de tiempo y amplitud (asumiendo tiempos consecutivos basados en el período promedio)
# Los tiempos se calculan asumiendo que el primer punto está en t=0 y el segundo en t=T_d (período amortiguado promedio)
A = np.array([27.4, 20.8])  # Amplitudes: ordenadas de mayor a menor en el tiempo
T_d = np.mean([1.17, 1.16])  # Período amortiguado promedio en segundos
t = np.array([0, T_d])        # Tiempos correspondientes a las amplitudes

# Calcular el logaritmo natural de las amplitudes
ln_A = np.log(A)

# Realizar regresión lineal de ln(A) vs. t
coefficients = np.polyfit(t, ln_A, 1)
m = coefficients[0]  # Pendiente de la regresión
b = coefficients[1]  # Intercepto

# La tasa de amortiguamiento alpha es el negativo de la pendiente
alpha = -m

# Frecuencia angular amortiguada
omega_d = 2 * np.pi / T_d

# Frecuencia natural no amortiguada
omega_0 = np.sqrt(omega_d**2 + alpha**2)

# Factor de calidad
Q = omega_0 / (2 * alpha)

# Resultados
print("Resultados del cálculo del factor de calidad Q:")
print(f"Pendiente de la regresión (m): {m:.4f}")
print(f"Tasa de amortiguamiento (alpha): {alpha:.4f} s⁻¹")
print(f"Período amortiguado promedio (T_d): {T_d:.4f} s")
print(f"Frecuencia angular amortiguada (omega_d): {omega_d:.4f} rad/s")
print(f"Frecuencia natural (omega_0): {omega_0:.4f} rad/s")
print(f"Factor de calidad (Q): {Q:.4f}")

def vals(x, y):
    pendiente, intercepto = np.polyfit(x, y, 1)
    
    # Calcular incertidumbres
    n = len(x)  # Número de puntos de datos
    y_pred = pendiente * x + intercepto  # Valores predichos
    residuos = y - y_pred  # Residuos
    
    # Desviación estándar de los residuos
    s_res = np.sqrt(np.sum(residuos**2) / (n - 2))
    
    # Suma de cuadrados de x
    s_xx = np.sum((x - np.mean(x))**2)
    
    # Incertidumbre de la pendiente
    u_pendiente = s_res / np.sqrt(s_xx)
    
    # Incertidumbre del intercepto
    u_intercepto = s_res * np.sqrt(1/n + np.mean(x)**2 / s_xx)
    
    # Crear gráfica
    plt.figure(figsize=(10, 6))
    
    # Graficar puntos de datos
    plt.scatter(x, y, color="#fb4934", label="Datos experimentales")
    
    # Graficar línea de regresión
    x_line = np.linspace(min(x), max(x), 100)
    y_line = pendiente * x_line + intercepto
    plt.plot(x_line, y_line, color="#d3869b", linewidth=2, 
             label=f"Regresión: y = ({pendiente:.4f} ± {u_pendiente:.4f})x + ({intercepto:.4f} ± {u_intercepto:.4f})")
    
    plt.title("Calculo del factor de calidad")
    plt.xlabel(r"$T (S)$")
    plt.ylabel(r"$\ln (A)$")
    plt.grid(alpha=0.3)
    
    plt.tight_layout()
    plt.savefig("./actividad_5.png", dpi=300)

vals(t, ln_A)
