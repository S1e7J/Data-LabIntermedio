import pandas as pd

def main():
    data = pd.read_csv("./muon.data")
    print(data)
    print("Hello from muones!")


if __name__ == "__main__":
    main()
