import random

from robot.api.deco import keyword


# Example of exposing a Python helper as a Robot Framework keyword via @keyword.
@keyword
def get_random_int(min_value: int, max_value: int) -> int:
    """
    Return a random integer between min_value and max_value inclusive.

    This keyword generates and returns a random integer between the specified minimum
    and maximum values, inclusive of both bounds.

    :param min_value: The minimum integer value.
    :param max_value: The maximum integer value.
    :return: A random integer between min_value and max_value.
    """
    return random.randint(min_value, max_value)
