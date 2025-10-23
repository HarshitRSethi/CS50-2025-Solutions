import sys


def main():
    number = str(input("Number: "))    # Taking input

    length = len(number)    # Get length of number to then check for different credit card company's
    if (length == 13):
        if (int(number[0]) == 4):   # It can be visa card
            name = "VISA"
        else:   # Doesn't qualify for being a card
            print("INVALID")
            sys.exit(1)
    elif (length == 15):
        if ((int(number[0]) == 3) and (int(number[1]) in [4, 7])):  # It can be Amex card
            name = "AMEX"
        else:   # Doesn't qualify for being a card
            print("INVALID")
            sys.exit(2)
    elif (length == 16):
        if (int(number[0]) == 4):    # It can be visa card
            name = "VISA"
        elif ((int(number[0]) == 5) and (int(number[1]) in [1, 2, 3, 4, 5])):     # It can be Master card
            name = "MASTERCARD"
        else:   # Doesn't qualify for being a card
            print("INVALID")
            sys.exit(3)
    else:   # Doesn't qualify for being a card
        print("INVALID")
        sys.exit(4)
    if (luhnAlgorithm(length, number)):     # Check if it satisy luhnAlgorithm
        print(name)  # If it does print name
    else:
        print("INVALID")


def luhnAlgorithm(length, number):   # Luhn's Algorithm is implemented here
    i = 2
    sum = 0
    while (i <= length):  # Summing of all even places from right
        product = (int(number[length - i])) * 2
        if (len(str(product)) > 1):  # If contain ten's digit in product, then adding them seperately
            sum += int((str(product))[0])
            sum += int((str(product))[1])
        else:
            sum += product  # Else normal addition
        i += 2
    i = 1
    while (i <= length):  # Adding All odd places as well
        sum += int(number[length - i])
        i += 2
    if (sum % 10 == 0):  # If divisible by 10 then true
        return True
    else:   # else false
        return False


main()
