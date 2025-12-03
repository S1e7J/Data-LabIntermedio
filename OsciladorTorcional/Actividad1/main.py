import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats

def main():
    data = pd.read_csv("./data.csv")

    x, y = data["rad"], data["vpp"]
    
    # Calcular regresión lineal
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
    
    # Coeficiente de determinación R²
    r2 = 1 - np.sum(residuos**2) / np.sum((y - np.mean(y))**2)
    
    # Intervalo de confianza (95%)
    t_valor = stats.t.ppf(0.975, n - 2)  # Valor t para 95% de confianza
    
    print(f"Pendiente: {pendiente:.4f} ± {u_pendiente:.4f}")
    print(f"Intercepto: {intercepto:.4f} ± {u_intercepto:.4f}")
    print(f"R²: {r2:.4f}")
    print(f"Intervalo de confianza al 95%")
    print(f"Pendiente: [{pendiente - t_valor * u_pendiente:.4f}, {pendiente + t_valor * u_pendiente:.4f}]")
    print(f"Intercepto: [{intercepto - t_valor * u_intercepto:.4f}, {intercepto + t_valor * u_intercepto:.4f}]")
    
    # Crear gráfica
    plt.figure(figsize=(10, 6))
    
    # Graficar puntos de datos
    plt.scatter(x, y, color="#fb4934", label="Datos experimentales")
    
    # Graficar línea de regresión
    x_line = np.linspace(min(x), max(x), 100)
    y_line = pendiente * x_line + intercepto
    plt.plot(x_line, y_line, color="#d3869b", linewidth=2, 
             label=f"Regresión: y = ({pendiente:.4f} ± {u_pendiente:.4f})x + ({intercepto:.4f} ± {u_intercepto:.4f})")
    
    # Graficar banda de incertidumbre
    y_upper = (pendiente + t_valor * u_pendiente) * x_line + (intercepto + t_valor * u_intercepto)
    y_lower = (pendiente - t_valor * u_pendiente) * x_line + (intercepto - t_valor * u_intercepto)
    plt.fill_between(x_line, y_lower, y_upper, color="#d3869b", alpha=0.2, 
                     label="Intervalo de confianza al 95%")
    
    # Graficar barras de error si están disponibles en los datos
    if "error_vpp" in data.columns:
        plt.errorbar(x, y, yerr=data["error_vpp"], fmt='o', color="#fb4934", 
                     alpha=0.7, capsize=3, label="Incertidumbre experimental")
    
    # Personalizar gráfica
    plt.title("Calibración del Rotor")
    plt.xlabel(r"$\theta$ (Rad)")
    plt.ylabel(r"$V_{pp}$ mV")
    plt.grid(alpha=0.3)
    
    # Añadir texto con resultados
    textstr = f'Pendiente: {pendiente:.1f} ± {u_pendiente:.1f}\nIntercepto: {intercepto:.1f} ± {u_intercepto:.1f} mV\nR²: {r2:.1f}'
    props = dict(boxstyle='round', facecolor='wheat', alpha=0.8)
    plt.text(0.05, 0.95, textstr, transform=plt.gca().transAxes, fontsize=10,
             verticalalignment='top', bbox=props)
    
    plt.tight_layout()
    plt.savefig("./actividad_1.png", dpi=300)
    
    # # Gráfica adicional de residuos
    # plt.figure(figsize=(10, 4))
    # plt.scatter(x, residuos, color="#458588")
    # plt.axhline(y=0, color="#d3869b", linestyle='--')
    # plt.xlabel(r"$\theta$ (Rad)")
    # plt.ylabel("Residuos")
    # plt.title("Análisis de Residuos")
    # plt.grid(alpha=0.3)
    # plt.tight_layout()
    # plt.savefig("./residuos.png", dpi=300)
    # plt.show()

if __name__ == "__main__":
    main()
