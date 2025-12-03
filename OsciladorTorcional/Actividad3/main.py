import matplotlib.pyplot as plt
import numpy as np

kg = float

masa_de_1: kg = 0.2120

x = np.array([4, 2])
y = np.array([1.44, 1.31])**2

m, b = np.polyfit(x, y, 1)

def kappa(n_masas, pendiente, r1=8.890e-2, r2=4.00e-2):
    dividendo = np.pi**2 * (masa_de_1 * n_masas) * (r1**2 + r2**2)
    divisor = 2 * pendiente
    return dividendo/divisor

def momento(intercepto, kappa):
    return (intercepto * kappa)/(4 * np.pi**2)

def mean(val1, val2):
    return (val1 + val2) / 2

kappa_2 = kappa(2, m)
kappa_4 = kappa(4, m)

momento_2 = momento(b, kappa_2)
momento_4 = momento(b, kappa_4)

print(kappa_2, momento_4)

print(kappa_4, momento_4)

print(mean(kappa_2, kappa_4), mean(momento_2, momento_4))

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
    
    plt.title("")
    plt.xlabel(r"$N$ de Masas")
    plt.ylabel(r"$T^2 (S^2)$")
    plt.grid(alpha=0.3)
    
    plt.tight_layout()
    plt.savefig("./actividad_3.png", dpi=300)

vals(x, y)
