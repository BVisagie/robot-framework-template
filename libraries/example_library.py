"""Small Python extensions with **Markdown** documentation and typed arguments.

Use Robot resource keywords for ordinary orchestration. This module demonstrates
Python type aliases and the boundary at which a `Secret` can safely be consumed.
"""

import hmac

from robot.api.deco import keyword
from robot.api.types import Secret

ROBOT_AUTO_KEYWORDS = False
ROBOT_LIBRARY_DOC_FORMAT = "MARKDOWN"

type Quantity = int


@keyword("Calculate stock quantity")
def calculate_stock_quantity(quantity: Quantity, shipment: Quantity = 0) -> Quantity:
    """Add a shipment to the current stock quantity.

    Robot Framework 7.5 converts string arguments using the Python `type` alias
    and shows the alias in generated library documentation.

    Args:
        quantity: Current non-negative item count.
        shipment: Non-negative number of arriving items.

    Returns:
        The combined item count.

    Raises:
        ValueError: If either quantity is negative.
    """
    if quantity < 0 or shipment < 0:
        raise ValueError("Quantity must be non-negative.")
    return quantity + shipment


@keyword("Verify demo token")
def verify_demo_token(token: Secret) -> None:
    """Validate a **dummy** token without returning or logging its value.

    The value is consumed only inside Python. A real integration would pass it
    to a client that does not log credentials. Secrets mask Robot values; they
    do not encrypt data or prevent an external client from logging it.

    Args:
        token: A Robot Framework Secret containing the built-in demo token.

    Raises:
        ValueError: If the dummy token is incorrect. The error omits its value.
    """
    if not hmac.compare_digest(token.value.encode("utf-8"), b"template-demo-token"):
        raise ValueError("Demo token rejected.")
