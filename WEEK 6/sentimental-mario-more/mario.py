height = int(input("Height: "))  # asking for height

while ((height > 8) | (height < 1)):  # conditions for height
    height = int(input("Height: "))

row = 1   # row counter
while (row <= height):
    for _ in range(height - row):  # Space printing before each row's hashes
        print(" ", end="")
    for _ in range(row):  # hash printing for first pyramid
        print("#", end="")
    print("  ", end="")  # constant double space between two pyramids
    for _ in range(row):  # Printing second pyramid
        print("#", end="")
    print()  # Ending the row
    row += 1  # updating row counter
