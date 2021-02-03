# How to test your Python libraries - a practical guide

## The problem

You are implementing a robot for automating manual accounting tasks. One of the tasks is calculating the net income and inserting that into the accounting system.

Currently, the net income calculation is done manually. There are several issues with this approach:

- It's slow.
- It's error-prone.
- The errors are caught much later, causing a lot of pain and backtracking.

## The solution

You decide to code a Python library for doing the calculation. Implementing it does not take too long:

`accounting.py`

```py
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

```

Next, you implement the accounting robot. The robot imports your accounting library to do the heavy number crunching:

`tasks.robot`:

```robot
*** Settings ***
Documentation     Do accounting operations.
Library           accounting.py

*** Tasks ***
Calculate and save net income to the accounting application
    ${net_income}=    Net Income    1256.25    930.33
    Log To Console    ${net_income}
    # Insert the net income to the accounting application.
    # ...

```

## Proving the solution works: The manual way

How do you prove the calculation you implemented works correctly right now? How about later? It would suck majorly if the calculation were incorrect.

Sure, you can manually test the calculation logic, but all those manual tests need to be completed again if the implementation needs to be modified later. There are several issues with this approach, too:

- It's slow.
- It's error-prone.
- The errors are caught much later, causing a lot of pain and backtracking.

## You talk the talk, but do you walk the walk?

There's much talk about the importance of testing. Unfortunately, sometimes we talk the talk but don't actually walk the walk. Talking is easier than walking, I guess.

Since you are a proud professional, you roll up your sleeves and decide to implement real tests! First, you need a testing framework...

Luckily your chosen stack already includes one of the most proven testing solutions out there: Robot Framework!

You create a new robot file for the test cases:

`tests.robot`:

```robot
*** Settings ***
Documentation     Test accounting operations.
Library           accounting.py

*** Test Cases ***
The net income should equal revenues minus expenses
    [Template]    Revenues of ${revenues} and expenses of ${expenses} should equal ${expected} net income
    1256.25    930.33    325.92
    3.0    2.0    1.0
    100.20    462.12    -361.92
    200.0    200.0    0

*** Keywords ***
Revenues of ${revenues} and expenses of ${expenses} should equal ${expected} net income
    ${net_income}=    Net Income    ${revenues}    ${expenses}
    Should Be Equal As Numbers    ${net_income}    ${expected}

```

You decide to keep the test-related stuff separate from the production implementation. You create the following `test_robot.yaml`:

```yaml
tasks:
  Default:
    command:
      - python
      - -m
      - robot
      - --report
      - NONE
      - --outputdir
      - output
      - --logtitle
      - Task log
      - tests.robot

condaConfigFile: conda.yaml
artifactsDir: output
PATH:
  - .
PYTHONPATH:
  - .
ignoreFiles:
  - .gitignore
```

> This configuration file is exactly the same as the production `robot.yaml`, but instead of calling `tasks.robot`, you call `tests.robot`!

You open your terminal and tell RCC to execute the test tasks:

```bash
rcc run --robot test_robot.yaml
```

Great success!:

```bash
==============================================================================
Tests :: Test accounting operations.
==============================================================================
The net income should equal revenues minus expenses                   | PASS |
------------------------------------------------------------------------------
Tests :: Test accounting operations.                                  | PASS |
1 critical test, 1 passed, 0 failed
1 test total, 1 passed, 0 failed
==============================================================================
```

You open the log file and see human-readable assertions:

```bash
Revenues of 1256.25 and expenses of 930.33 should equal 325.92 net income
Revenues of 3.0 and expenses of 2.0 should equal 1.0 net income
Revenues of 100.20 and expenses of 462.12 should equal -361.92 net income
Revenues of 200.0 and expenses of 200.0 should equal 0 net income
```

The calculations work! And now you have a way to prove it. The tests assure that you can do modifications to the logic with the knowledge that the tests will warn you if you accidentally broke something! Such a piece of mind.

You pat yourself on the back, close the lid of your laptop, pour a cup of your favorite beverage, and start surfing Reddit! It's great being an automation professional!
