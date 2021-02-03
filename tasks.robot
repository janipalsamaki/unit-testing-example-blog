*** Settings ***
Documentation     Do accounting operations.
Library           accounting.py

*** Tasks ***
Calculate and save net income to the accounting application
    ${net_income}=    Net Income    1256.25    930.33
    Log To Console    ${net_income}
    # Insert the net income to the accounting application.
    # ...
