import math


def net_income(revenues: float, expenses: float, decimals=2) -> float:
    # Revenues - Expenses = Net Income
    #
    # Revenues are the sales or other positive cash inflow that comes into
    # your company. Expenses are the costs that are associated with making
    # sales. By subtracting your revenue from your expenses, you can calculate
    # your net income. This is the money #that you have earned at the end of
    # the day. It's possible that this number will be negative when your
    # business is in its nascent stage, so the goal is for your business' net
    # income to become positive, meaning your business is profitable.
    #
    # https://quickbooks.intuit.com/global/resources/bookkeeping/8-accounting-formulas-every-business-should-know/
    multiplier = 10 ** decimals
    net_income = revenues - expenses
    return math.floor(net_income * multiplier + 0.5) / multiplier
