from scipy.constants import mu_0
# from typing import Tuple
# from enum import Enum

# class CurrentType(Enum):
#     AMPERE = "AMPERE"
#
# class LengthType(Enum):
#     CENTIMITER = "CENTIMITER"
#
# def _convert_to_int(value: float | int, divisor: int | None) -> Tuple[int, int]:
#     def _helper(value) -> Tuple[int, int]:
#         if type(value) == int: return value, 0
#         expo = len(str(value).split('.')[-1])
#         return (value * 10**expo, expo)
#     return value, divisor if (type(value) == int and divisor is not None) else _helper(value)
#
# class Length():
#     def __init__(self, length: int | float, divisor: int | None = None, length_type: LengthType = LengthType.CENTIMITER) -> None:
#         self.length, self.divisor = length, divisor if type(length) == int and divisor is not None else 
# class Current():
#     def __init__(self, value: int | float, divisor: int | None = None, current_type: CurrentType = CurrentType.AMPERE) -> None:
#         self.value, self.divisor = value, divisor if type(value) == int else _convert_to_int(value)
#         self.type = current_type


def get_magnetic_field(I: float, N: int = 1000, L: float | int = 7) -> float:
    return mu_0 * I * N * L
